Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967073AbaFTUYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:24:02 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:40429 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966819AbaFTUX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:23:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwHACWYpFNXQzOZ/2dsb2JhbABZgw1SqnUFAQEBAQEBBQGZKoEOF3WEMS8jgRo3iC4DFQHDZBWGWoViiEMBAU8dhC0Ej22KV4swiCqDRDuBOg
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] fs/ufs/super.c: use va_format instead of buffer/vsnprintf
Date: Fri, 20 Jun 2014 22:22:40 +0200
Message-Id: <1403295760-4952-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove error_buffer and use %pV

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index ca24557..206f7d6 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -286,13 +286,12 @@ static void ufs_print_cylinder_stuff(struct super_block *sb,
 
 static const struct super_operations ufs_super_ops;
 
-static char error_buf[1024];
-
 void ufs_error (struct super_block * sb, const char * function,
 	const char * fmt, ...)
 {
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
+	struct va_format vaf;
 	va_list args;
 
 	uspi = UFS_SB(sb)->s_uspi;
@@ -304,20 +303,21 @@ void ufs_error (struct super_block * sb, const char * function,
 		ufs_mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
-		panic("panic (device %s): %s: %s\n",
-			sb->s_id, function, error_buf);
+		panic("panic (device %s): %s: %pV\n",
+		      sb->s_id, function, &vaf);
 
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		pr_crit("error (device %s): %s: %s\n",
-			sb->s_id, function, error_buf);
-	}		
+		pr_crit("error (device %s): %s: %pV\n",
+			sb->s_id, function, &vaf);
+	}
+	va_end(args);
 }
 
 void ufs_panic (struct super_block * sb, const char * function,
@@ -325,6 +325,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 {
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
+	struct va_format vaf;
 	va_list args;
 	
 	uspi = UFS_SB(sb)->s_uspi;
@@ -335,24 +336,27 @@ void ufs_panic (struct super_block * sb, const char * function,
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
 		ufs_mark_sb_dirty(sb);
 	}
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	sb->s_flags |= MS_RDONLY;
-	pr_crit("panic (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	pr_crit("panic (device %s): %s: %pV\n",
+		sb->s_id, function, &vaf);
+	va_end(args);
 }
 
 void ufs_warning (struct super_block * sb, const char * function,
 	const char * fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
-	pr_warn("warning (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(device %s): %s: %pV\n",
+		sb->s_id, function, &vaf);
+	va_end(args);
 }
 
 enum {
-- 
1.8.4.5

