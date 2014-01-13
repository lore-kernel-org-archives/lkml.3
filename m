Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaAMJfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:35:21 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60318 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaAMJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:35:18 -0500
Message-ID: <52D3B0DE.3@linux.vnet.ibm.com>
Date: Mon, 13 Jan 2014 17:24:46 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] splice: fix unexpected size truncation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011309-7014-0000-0000-0000042D1DC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@splice_desc.total_len is 32 bit(unsigned int) which is used to store the
size passed from userspace which is 64 bit(size_t) so that the size is
unexpectedly truncated

That causes vmsplice can not work if the size passed from userspace is >= 4G,
for example, we noticed in vmsplice, splice-reader does not do anything and
splice-writer is waiting for available buffer forever if the size is 4G

Fix it by extending @splice_desc.total_len to 64 bits as well

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/splice.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/splice.h b/include/linux/splice.h
index 74575cb..1e85396 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -24,7 +24,8 @@
  * Passed to the actors
  */
 struct splice_desc {
-	unsigned int len, total_len;	/* current and remaining length */
+	size_t total_len;		/* remaining length */
+	unsigned int len;		/* current length */
 	unsigned int flags;		/* splice flags */
 	/*
 	 * actor() private data
-- 
1.8.1.4

