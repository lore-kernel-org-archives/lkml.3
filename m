Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab3HSKVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:21:09 -0400
Received: from etezian.org ([198.101.225.253]:40101 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3HSKVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:21:07 -0400
From: Andi Shyti <andi@etezian.org>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, andi@etezian.org
Subject: [PATCH] rsxx: core: fix memory leak
Date: Mon, 19 Aug 2013 12:20:31 +0200
Message-Id: <1376907631-13725-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if 'copy_from_user' fails, the 'rsxx_cram_write()' function
returns without freeing the allocated buffer 'buf'.

Free 'buf' before returning.

This issue has been reported by scan.coverity.com

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/block/rsxx/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 6e85e21..1ddb284 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -223,8 +223,10 @@ static ssize_t rsxx_cram_write(struct file *fp, const char __user *ubuf,
 		return -ENOMEM;
 
 	st = copy_from_user(buf, ubuf, cnt);
-	if (st)
+	if (st) {
+		kfree(buf);
 		return st;
+	}
 
 	info->f_pos = (u32)*ppos + info->offset;
 
-- 
1.8.4.rc2

