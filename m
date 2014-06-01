Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaFAFif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 01:38:35 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:65265 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaFAFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 01:38:34 -0400
From: Leon Yu <chianglungyu@gmail.com>
To: davem@davemloft.net, ast@plumgrid.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Yu <chianglungyu@gmail.com>
Subject: [PATCH] net: filter: fix possible memory leak in __sk_prepare_filter()
Date: Sun,  1 Jun 2014 05:37:25 +0000
Message-Id: <1401601045-7829-1-git-send-email-chianglungyu@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__sk_prepare_filter() was reworked in commit bd4cf0ed3 (net: filter:
rework/optimize internal BPF interpreter's instruction set) so that it should
have uncharged memory once things went wrong. However that work isn't complete.
Error is handled only in __sk_migrate_filter() while memory can still leak in
the error path right after sk_chk_filter().

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
---
 net/core/filter.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9d79ca0..4aec7b9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1559,8 +1559,13 @@ static struct sk_filter *__sk_prepare_filter(struct sk_filter *fp,
 	fp->jited = 0;
 
 	err = sk_chk_filter(fp->insns, fp->len);
-	if (err)
+	if (err) {
+		if (sk != NULL)
+			sk_filter_uncharge(sk, fp);
+		else
+			kfree(fp);
 		return ERR_PTR(err);
+	}
 
 	/* Probe if we can JIT compile the filter and if so, do
 	 * the compilation of the filter.
-- 
1.9.3

