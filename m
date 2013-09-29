Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3I2T2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:28:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3I2T2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hui Wang <hui.wang@canonical.com>, Jan Kara <jack@suse.cz>
Subject: [ 39/49] udf: Refuse RW mount of the filesystem instead of making it RO
Date: Sun, 29 Sep 2013 12:27:13 -0700
Message-Id: <20130929191605.654767823@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e729eac6f65e11c5f03b09adcc84bd5bcb230467 upstream.

Refuse RW mount of udf filesystem. So far we just silently changed it
to RO mount but when the media is writeable, block layer won't notice
this change and thus will think device is used RW and will block eject
button of the drive. That is unexpected by users because for
non-writeable media eject button works just fine.

Userspace mount(8) command handles this just fine and retries mounting
with MS_RDONLY set so userspace shouldn't see any regression.  Plus any
tool mounting udf is likely confronted with the case of read-only
media where block layer already refuses to mount the filesystem without
MS_RDONLY set so our behavior shouldn't be anything new for it.

Reported-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -630,6 +630,12 @@ static int udf_remount_fs(struct super_b
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	int error = 0;
 
+	if (sbi->s_lvid_bh) {
+		int write_rev = le16_to_cpu(udf_sb_lvidiu(sbi)->minUDFWriteRev);
+		if (write_rev > UDF_MAX_WRITE_VERSION && !(*flags & MS_RDONLY))
+			return -EACCES;
+	}
+
 	uopt.flags = sbi->s_flags;
 	uopt.uid   = sbi->s_uid;
 	uopt.gid   = sbi->s_gid;
@@ -649,12 +655,6 @@ static int udf_remount_fs(struct super_b
 	sbi->s_dmode = uopt.dmode;
 	write_unlock(&sbi->s_cred_lock);
 
-	if (sbi->s_lvid_bh) {
-		int write_rev = le16_to_cpu(udf_sb_lvidiu(sbi)->minUDFWriteRev);
-		if (write_rev > UDF_MAX_WRITE_VERSION)
-			*flags |= MS_RDONLY;
-	}
-
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		goto out_unlock;
 
@@ -1284,16 +1284,18 @@ static int udf_load_partdesc(struct supe
 			goto out_bh;
 		}
 	} else {
+		/*
+		 * If we have a partition with virtual map, we don't handle
+		 * writing to it (we overwrite blocks instead of relocating
+		 * them).
+		 */
+		if (!(sb->s_flags & MS_RDONLY)) {
+			ret = -EACCES;
+			goto out_bh;
+		}
 		ret = udf_load_vat(sb, i, type1_idx);
 		if (ret < 0)
 			goto out_bh;
-		/*
-		 * Mark filesystem read-only if we have a partition with
-		 * virtual map since we don't handle writing to it (we
-		 * overwrite blocks instead of relocating them).
-		 */
-		sb->s_flags |= MS_RDONLY;
-		pr_notice("Filesystem marked read-only because writing to pseudooverwrite partition is not implemented\n");
 	}
 	ret = 0;
 out_bh:
@@ -2103,8 +2105,11 @@ static int udf_fill_super(struct super_b
 				UDF_MAX_READ_VERSION);
 			ret = -EINVAL;
 			goto error_out;
-		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION)
-			sb->s_flags |= MS_RDONLY;
+		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION &&
+			   !(sb->s_flags & MS_RDONLY)) {
+			ret = -EACCES;
+			goto error_out;
+		}
 
 		sbi->s_udfrev = minUDFWriteRev;
 
@@ -2121,9 +2126,10 @@ static int udf_fill_super(struct super_b
 	}
 
 	if (sbi->s_partmaps[sbi->s_partition].s_partition_flags &
-			UDF_PART_FLAG_READ_ONLY) {
-		pr_notice("Partition marked readonly; forcing readonly mount\n");
-		sb->s_flags |= MS_RDONLY;
+			UDF_PART_FLAG_READ_ONLY &&
+	    !(sb->s_flags & MS_RDONLY)) {
+		ret = -EACCES;
+		goto error_out;
 	}
 
 	if (udf_find_fileset(sb, &fileset, &rootdir)) {


