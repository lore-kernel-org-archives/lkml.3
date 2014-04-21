Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaDUL54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:57:56 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:9866 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaDUL5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:57:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4IAIkHVVNXQ6mu/2dsb2JhbABZgwarUZligR8XdIJTExwjGIECJBOIRQHNUo4VTYQ/AQOOaYoEAYpqh2WDMzuBLQ
Date: Mon, 21 Apr 2014 13:57:46 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe <joe@perches.com>
Subject: [PATCH 1/2] FS/AFFS: Convert printk to pr_foo()
Message-Id: <20140421135746.0ba9040659529d91e5e3ebf2@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-All printk(KERN_foo converted to pr_foo()
-Default printk converted to pr_warn()
-Add pr_fmt to affs.h

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/affs.h     |  6 ++++++
 fs/affs/amigaffs.c |  6 +++---
 fs/affs/bitmap.c   | 13 ++++++-------
 fs/affs/super.c    | 24 +++++++++++-------------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 25b23b1..347ee6f 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -1,3 +1,9 @@
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 533a322..fa8ba6a 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -451,10 +451,10 @@ affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
 	va_end(args);
 
-	printk(KERN_CRIT "AFFS error (device %s): %s(): %s\n", sb->s_id,
+	pr_crit("error (device %s): %s(): %s\n", sb->s_id,
 		function,ErrorBuffer);
 	if (!(sb->s_flags & MS_RDONLY))
-		printk(KERN_WARNING "AFFS: Remounting filesystem read-only\n");
+		pr_warn("Remounting filesystem read-only\n");
 	sb->s_flags |= MS_RDONLY;
 }
 
@@ -467,7 +467,7 @@ affs_warning(struct super_block *sb, const char *function, const char *fmt, ...)
 	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
 	va_end(args);
 
-	printk(KERN_WARNING "AFFS warning (device %s): %s(): %s\n", sb->s_id,
+	pr_warn("(device %s): %s(): %s\n", sb->s_id,
 		function,ErrorBuffer);
 }
 
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index a32246b..d9559f5 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -254,8 +254,7 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 		return 0;
 
 	if (!AFFS_ROOT_TAIL(sb, sbi->s_root_bh)->bm_flag) {
-		printk(KERN_NOTICE "AFFS: Bitmap invalid - mounting %s read only\n",
-			sb->s_id);
+		pr_notice("Bitmap invalid - mounting %s read only\n", sb->s_id);
 		*flags |= MS_RDONLY;
 		return 0;
 	}
@@ -268,7 +267,7 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 	size = sbi->s_bmap_count * sizeof(*bm);
 	bm = sbi->s_bitmap = kzalloc(size, GFP_KERNEL);
 	if (!sbi->s_bitmap) {
-		printk(KERN_ERR "AFFS: Bitmap allocation failed\n");
+		pr_err("Bitmap allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -282,13 +281,13 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 		bm->bm_key = be32_to_cpu(bmap_blk[blk]);
 		bh = affs_bread(sb, bm->bm_key);
 		if (!bh) {
-			printk(KERN_ERR "AFFS: Cannot read bitmap\n");
+			pr_err("Cannot read bitmap\n");
 			res = -EIO;
 			goto out;
 		}
 		if (affs_checksum_block(sb, bh)) {
-			printk(KERN_WARNING "AFFS: Bitmap %u invalid - mounting %s read only.\n",
-			       bm->bm_key, sb->s_id);
+			pr_warn("Bitmap %u invalid - mounting %s read only.\n",
+				bm->bm_key, sb->s_id);
 			*flags |= MS_RDONLY;
 			goto out;
 		}
@@ -304,7 +303,7 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 			affs_brelse(bmap_bh);
 		bmap_bh = affs_bread(sb, be32_to_cpu(bmap_blk[blk]));
 		if (!bmap_bh) {
-			printk(KERN_ERR "AFFS: Cannot read bitmap extension\n");
+			pr_err("Cannot read bitmap extension\n");
 			res = -EIO;
 			goto out;
 		}
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 6d589f2..331fc8e 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -220,7 +220,7 @@ parse_options(char *options, kuid_t *uid, kgid_t *gid, int *mode, int *reserved,
 				return 0;
 			if (n != 512 && n != 1024 && n != 2048
 			    && n != 4096) {
-				printk ("AFFS: Invalid blocksize (512, 1024, 2048, 4096 allowed)\n");
+				pr_warn("Invalid blocksize (512, 1024, 2048, 4096 allowed)\n");
 				return 0;
 			}
 			*blocksize = n;
@@ -285,8 +285,8 @@ parse_options(char *options, kuid_t *uid, kgid_t *gid, int *mode, int *reserved,
 		 	/* Silently ignore the quota options */
 			break;
 		default:
-			printk("AFFS: Unrecognized mount option \"%s\" "
-					"or missing value\n", p);
+			pr_warn("Unrecognized mount option \"%s\" or missing value\n",
+				p);
 			return 0;
 		}
 	}
@@ -339,7 +339,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
-		printk(KERN_ERR "AFFS: Error parsing options\n");
+		pr_err("Error parsing options\n");
 		kfree(sbi->s_prefix);
 		kfree(sbi);
 		return -EINVAL;
@@ -409,8 +409,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 	if (!silent)
-		printk(KERN_ERR "AFFS: No valid root block on device %s\n",
-			sb->s_id);
+		pr_err("No valid root block on device %s\n", sb->s_id);
 	return -EINVAL;
 
 	/* N.B. after this point bh must be released */
@@ -422,7 +421,7 @@ got_root:
 	/* Find out which kind of FS we have */
 	boot_bh = sb_bread(sb, 0);
 	if (!boot_bh) {
-		printk(KERN_ERR "AFFS: Cannot read boot block\n");
+		pr_err("Cannot read boot block\n");
 		return -EINVAL;
 	}
 	memcpy(sig, boot_bh->b_data, 4);
@@ -435,8 +434,7 @@ got_root:
 	 */
 	if ((chksum == FS_DCFFS || chksum == MUFS_DCFFS || chksum == FS_DCOFS
 	     || chksum == MUFS_DCOFS) && !(sb->s_flags & MS_RDONLY)) {
-		printk(KERN_NOTICE "AFFS: Dircache FS - mounting %s read only\n",
-			sb->s_id);
+		pr_notice("Dircache FS - mounting %s read only\n", sb->s_id);
 		sb->s_flags |= MS_RDONLY;
 	}
 	switch (chksum) {
@@ -470,14 +468,14 @@ got_root:
 			sb->s_flags |= MS_NOEXEC;
 			break;
 		default:
-			printk(KERN_ERR "AFFS: Unknown filesystem on device %s: %08X\n",
-				sb->s_id, chksum);
+			pr_err("Unknown filesystem on device %s: %08X\n",
+			       sb->s_id, chksum);
 			return -EINVAL;
 	}
 
 	if (mount_flags & SF_VERBOSE) {
 		u8 len = AFFS_ROOT_TAIL(sb, root_bh)->disk_name[0];
-		printk(KERN_NOTICE "AFFS: Mounting volume \"%.*s\": Type=%.3s\\%c, Blocksize=%d\n",
+		pr_notice("Mounting volume \"%.*s\": Type=%.3s\\%c, Blocksize=%d\n",
 			len > 31 ? 31 : len,
 			AFFS_ROOT_TAIL(sb, root_bh)->disk_name + 1,
 			sig, sig[3] + '0', blocksize);
@@ -508,7 +506,7 @@ got_root:
 
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
-		printk(KERN_ERR "AFFS: Get root inode failed\n");
+		pr_err("AFFS: Get root inode failed\n");
 		return -ENOMEM;
 	}
 
-- 
1.9.1
