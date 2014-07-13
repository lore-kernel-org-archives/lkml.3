Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaGMNKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 09:10:09 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:48240 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaGMNJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 09:09:59 -0400
Date: Sun, 13 Jul 2014 10:04:08 -0300
From: Lucas Tanure <tanure@linux.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] NoMoreModuleVmalloc - Try alloc_pages_exact before vmalloc,
 if fails do vmalloc
Message-ID: <20140713130407.GA27344@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert vmalloc() call to alloc_pages_exact(). If alloc_pages_exact() fails,
then fall back to vmalloc(). If the address is a vmalloc address, then
call vfree(), otherwise call free_pages_exact().

Signed-off-by: Lucas Tanure <tanure@linux.com>
---
 kernel/module.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index ae79ce6..50c1e77 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2484,6 +2484,7 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
 				  struct load_info *info)
 {
 	int err;
+	bool alloc_from_vmalloc = false;
 
 	info->len = len;
 	if (info->len < sizeof(*(info->hdr)))
@@ -2494,12 +2495,19 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
 		return err;
 
 	/* Suck in entire file: we'll want most of it. */
-	info->hdr = vmalloc(info->len);
-	if (!info->hdr)
-		return -ENOMEM;
+	info->hdr = alloc_pages_exact(info->len, GFP_KERNEL);
+	if (!info->hdr) {
+		info->hdr = vmalloc(info->len);
+		if (!info->hdr)
+			return -ENOMEM;
+		alloc_from_vmalloc = true;
+	}
 
 	if (copy_from_user(info->hdr, umod, info->len) != 0) {
-		vfree(info->hdr);
+		if(alloc_from_vmalloc)
+			vfree(info->hdr);
+		else
+			free_pages_exact(info->hdr,info->len);
 		return -EFAULT;
 	}
 
-- 
2.0.1

