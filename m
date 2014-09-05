Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaIEWWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:22:05 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:41145 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaIEWWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:22:03 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Fri, 5 Sep 2014 23:22:01 +0100 (BST)
From: Anton Altaparmakov <anton@tuxera.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH] Use find_get_page_flags() to mark page accessed as it is no
 longer marked later on
Message-ID: <Pine.LNX.4.64.1409052311510.2647@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman's commit 2457aec63745 ("mm: non-atomically mark page accessed 
during page cache allocation where possible") removed mark_page_accessed() 
calls from NTFS without updating the matching find_lock_page() to 
find_get_page_flags(GFP_LOCK | FGP_ACCESSED) thus causing the page to 
never be marked accessed.

This patch fixes that.

Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
---

Hi Andrew,

Can you please take the below patch and forward it for inclusion to Linus?

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index f5ec1ce..643faa4 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1,7 +1,7 @@
 /*
  * file.c - NTFS kernel file operations.  Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.
+ * Copyright (c) 2001-2014 Anton Altaparmakov and Tuxera Inc.
  *
  * This program/include file is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as published
@@ -410,7 +410,8 @@ static inline int __ntfs_grab_cache_pages(struct address_space *mapping,
 	BUG_ON(!nr_pages);
 	err = nr = 0;
 	do {
-		pages[nr] = find_lock_page(mapping, index);
+		pages[nr] = find_get_page_flags(mapping, index, FGP_LOCK |
+				FGP_ACCESSED);
 		if (!pages[nr]) {
 			if (!*cached_page) {
 				*cached_page = page_cache_alloc(mapping);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 6c3296e..9e1e112 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3208,7 +3208,7 @@ static void __exit exit_ntfs_fs(void)
 }
 
 MODULE_AUTHOR("Anton Altaparmakov <anton@tuxera.com>");
-MODULE_DESCRIPTION("NTFS 1.2/3.x driver - Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.");
+MODULE_DESCRIPTION("NTFS 1.2/3.x driver - Copyright (c) 2001-2014 Anton Altaparmakov and Tuxera Inc.");
 MODULE_VERSION(NTFS_VERSION);
 MODULE_LICENSE("GPL");
 #ifdef DEBUG
