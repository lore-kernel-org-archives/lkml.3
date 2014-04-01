Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaDAJQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaDAJQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/29] GFS2: Use pr_<level> more consistently
Date: Tue,  1 Apr 2014 10:15:30 +0100
Message-Id: <1396343741-1524-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Add pr_fmt, remove embedded "GFS2: " prefixes.
This now consistently emits lower case "gfs2: " for each message.

Other miscellanea around these changes:

o Add missing newlines
o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 39c7081..1a349f9 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -53,6 +53,8 @@
  * but never before the maximum hash table size has been reached.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/buffer_head.h>
@@ -507,8 +509,8 @@ static int gfs2_check_dirent(struct gfs2_dirent *dent, unsigned int offset,
 		goto error;
 	return 0;
 error:
-	pr_warn("gfs2_check_dirent: %s (%s)\n", msg,
-	       first ? "first in block" : "not first in block");
+	pr_warn("%s: %s (%s)\n",
+		__func__, msg, first ? "first in block" : "not first in block");
 	return -EIO;
 }
 
@@ -531,8 +533,7 @@ static int gfs2_dirent_offset(const void *buf)
 	}
 	return offset;
 wrong_type:
-	pr_warn("gfs2_scan_dirent: wrong block type %u\n",
-	        be32_to_cpu(h->mh_type));
+	pr_warn("%s: wrong block type %u\n", __func__, be32_to_cpu(h->mh_type));
 	return -1;
 }
 
@@ -728,7 +729,7 @@ static int get_leaf(struct gfs2_inode *dip, u64 leaf_no,
 
 	error = gfs2_meta_read(dip->i_gl, leaf_no, DIO_WAIT, bhp);
 	if (!error && gfs2_metatype_check(GFS2_SB(&dip->i_inode), *bhp, GFS2_METATYPE_LF)) {
-		/* printk(KERN_INFO "block num=%llu\n", leaf_no); */
+		/* pr_info("block num=%llu\n", leaf_no); */
 		error = -EIO;
 	}
 
@@ -1006,7 +1007,8 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	len = 1 << (dip->i_depth - be16_to_cpu(oleaf->lf_depth));
 	half_len = len >> 1;
 	if (!half_len) {
-		pr_warn("i_depth %u lf_depth %u index %u\n", dip->i_depth, be16_to_cpu(oleaf->lf_depth), index);
+		pr_warn("i_depth %u lf_depth %u index %u\n",
+			dip->i_depth, be16_to_cpu(oleaf->lf_depth), index);
 		gfs2_consist_inode(dip);
 		error = -EIO;
 		goto fail_brelse;
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 329dc80..52f7478 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -468,7 +470,7 @@ retry:
 			do_xmote(gl, gh, LM_ST_UNLOCKED);
 			break;
 		default: /* Everything else */
-			pr_err("GFS2: wanted %u got %u\n", gl->gl_target, state);
+			pr_err("wanted %u got %u\n", gl->gl_target, state);
 			GLOCK_BUG_ON(gl, 1);
 		}
 		spin_unlock(&gl->gl_spin);
@@ -542,7 +544,7 @@ __acquires(&gl->gl_spin)
 		/* lock_dlm */
 		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
 		if (ret) {
-			pr_err("GFS2: lm_lock ret %d\n", ret);
+			pr_err("lm_lock ret %d\n", ret);
 			GLOCK_BUG_ON(gl, 1);
 		}
 	} else { /* lock_nolock */
@@ -935,7 +937,7 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		pr_err(" %pV", &vaf);
+		pr_err("%pV", &vaf);
 	}
 
 	va_end(args);
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index a664ddd..c1eb555 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/dlm.h>
 #include <linux/slab.h>
@@ -176,7 +178,7 @@ static void gdlm_bast(void *arg, int mode)
 		gfs2_glock_cb(gl, LM_ST_SHARED);
 		break;
 	default:
-		pr_err("unknown bast mode %d", mode);
+		pr_err("unknown bast mode %d\n", mode);
 		BUG();
 	}
 }
@@ -195,7 +197,7 @@ static int make_mode(const unsigned int lmstate)
 	case LM_ST_SHARED:
 		return DLM_LOCK_PR;
 	}
-	pr_err("unknown LM state %d", lmstate);
+	pr_err("unknown LM state %d\n", lmstate);
 	BUG();
 	return -1;
 }
@@ -308,7 +310,8 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_VALBLK,
 			   NULL, gl);
 	if (error) {
-		pr_err("gdlm_unlock %x,%llx err=%d\n", gl->gl_name.ln_type,
+		pr_err("gdlm_unlock %x,%llx err=%d\n",
+		       gl->gl_name.ln_type,
 		       (unsigned long long)gl->gl_name.ln_number, error);
 		return;
 	}
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index ae9b02b..82b6ac8 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ea9c35c..fba74a2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -150,7 +152,7 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 	if (sb->sb_magic != GFS2_MAGIC ||
 	    sb->sb_type != GFS2_METATYPE_SB) {
 		if (!silent)
-			pr_warn("GFS2: not a GFS2 filesystem\n");
+			pr_warn("not a GFS2 filesystem\n");
 		return -EINVAL;
 	}
 
@@ -172,7 +174,7 @@ static void end_bio_io_page(struct bio *bio, int error)
 	if (!error)
 		SetPageUptodate(page);
 	else
-		pr_warn("gfs2: error %d reading superblock\n", error);
+		pr_warn("error %d reading superblock\n", error);
 	unlock_page(page);
 }
 
@@ -945,7 +947,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 		lm = &gfs2_dlm_ops;
 #endif
 	} else {
-		pr_info("GFS2: can't find protocol %s\n", proto);
+		pr_info("can't find protocol %s\n", proto);
 		return -ENOENT;
 	}
 
@@ -1052,7 +1054,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 
 	sdp = init_sbd(sb);
 	if (!sdp) {
-		pr_warn("GFS2: can't alloc struct gfs2_sbd\n");
+		pr_warn("can't alloc struct gfs2_sbd\n");
 		return -ENOMEM;
 	}
 	sdp->sd_args = *args;
@@ -1300,7 +1302,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 
 	error = gfs2_mount_args(&args, data);
 	if (error) {
-		pr_warn("GFS2: can't parse mount arguments\n");
+		pr_warn("can't parse mount arguments\n");
 		goto error_super;
 	}
 
@@ -1350,15 +1352,15 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
 
 	error = kern_path(dev_name, LOOKUP_FOLLOW, &path);
 	if (error) {
-		pr_warn("GFS2: path_lookup on %s returned error %d\n",
-		       dev_name, error);
+		pr_warn("path_lookup on %s returned error %d\n",
+			dev_name, error);
 		return ERR_PTR(error);
 	}
 	s = sget(&gfs2_fs_type, test_gfs2_super, set_meta_super, flags,
 		 path.dentry->d_inode->i_sb->s_bdev);
 	path_put(&path);
 	if (IS_ERR(s)) {
-		pr_warn("GFS2: gfs2 mount does not exist\n");
+		pr_warn("gfs2 mount does not exist\n");
 		return ERR_CAST(s);
 	}
 	if ((flags ^ s->s_flags) & MS_RDONLY) {
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6e25ee4..73ed925 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -36,6 +36,8 @@
  * the quota file, so it is not being constantly read.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -1081,10 +1083,10 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	pr_info("GFS2: fsid=%s: quota %s for %s %u\n",
-	       sdp->sd_fsname, type,
-	       (qd->qd_id.type == USRQUOTA) ? "user" : "group",
-	       from_kqid(&init_user_ns, qd->qd_id));
+	pr_info("fsid=%s: quota %s for %s %u\n",
+		sdp->sd_fsname, type,
+		(qd->qd_id.type == USRQUOTA) ? "user" : "group",
+		from_kqid(&init_user_ns, qd->qd_id));
 
 	return 0;
 }
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8d12038..281a771 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
@@ -99,12 +101,12 @@ static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
 	cur_state = (*byte1 >> bit) & GFS2_BIT_MASK;
 
 	if (unlikely(!valid_change[new_state * 4 + cur_state])) {
-		pr_warn("GFS2: buf_blk = 0x%x old_state=%d, "
-		       "new_state=%d\n", rbm->offset, cur_state, new_state);
-		pr_warn("GFS2: rgrp=0x%llx bi_start=0x%x\n",
-		       (unsigned long long)rbm->rgd->rd_addr, bi->bi_start);
-		pr_warn("GFS2: bi_offset=0x%x bi_len=0x%x\n",
-		       bi->bi_offset, bi->bi_len);
+		pr_warn("buf_blk = 0x%x old_state=%d, new_state=%d\n",
+			rbm->offset, cur_state, new_state);
+		pr_warn("rgrp=0x%llx bi_start=0x%x\n",
+			(unsigned long long)rbm->rgd->rd_addr, bi->bi_start);
+		pr_warn("bi_offset=0x%x bi_len=0x%x\n",
+			bi->bi_offset, bi->bi_len);
 		dump_stack();
 		gfs2_consist_rgrpd(rbm->rgd);
 		return;
@@ -736,11 +738,11 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
 
 static void gfs2_rindex_print(const struct gfs2_rgrpd *rgd)
 {
-	pr_info("  ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
-	pr_info("  ri_length = %u\n", rgd->rd_length);
-	pr_info("  ri_data0 = %llu\n", (unsigned long long)rgd->rd_data0);
-	pr_info("  ri_data = %u\n", rgd->rd_data);
-	pr_info("  ri_bitbytes = %u\n", rgd->rd_bitbytes);
+	pr_info("ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
+	pr_info("ri_length = %u\n", rgd->rd_length);
+	pr_info("ri_data0 = %llu\n", (unsigned long long)rgd->rd_data0);
+	pr_info("ri_data = %u\n", rgd->rd_data);
+	pr_info("ri_bitbytes = %u\n", rgd->rd_bitbytes);
 }
 
 /**
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 584c757..a08c66e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bio.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -175,8 +177,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			break;
 		case Opt_debug:
 			if (args->ar_errors == GFS2_ERRORS_PANIC) {
-				pr_warn("GFS2: -o debug and -o errors=panic "
-				       "are mutually exclusive.\n");
+				pr_warn("-o debug and -o errors=panic are mutually exclusive\n");
 				return -EINVAL;
 			}
 			args->ar_debug = 1;
@@ -228,21 +229,21 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 		case Opt_commit:
 			rv = match_int(&tmp[0], &args->ar_commit);
 			if (rv || args->ar_commit <= 0) {
-				pr_warn("GFS2: commit mount option requires a positive numeric argument\n");
+				pr_warn("commit mount option requires a positive numeric argument\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
 		case Opt_statfs_quantum:
 			rv = match_int(&tmp[0], &args->ar_statfs_quantum);
 			if (rv || args->ar_statfs_quantum < 0) {
-				pr_warn("GFS2: statfs_quantum mount option requires a non-negative numeric argument\n");
+				pr_warn("statfs_quantum mount option requires a non-negative numeric argument\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
 		case Opt_quota_quantum:
 			rv = match_int(&tmp[0], &args->ar_quota_quantum);
 			if (rv || args->ar_quota_quantum <= 0) {
-				pr_warn("GFS2: quota_quantum mount option requires a positive numeric argument\n");
+				pr_warn("quota_quantum mount option requires a positive numeric argument\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
@@ -259,8 +260,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			break;
 		case Opt_err_panic:
 			if (args->ar_debug) {
-				pr_warn("GFS2: -o debug and -o errors=panic "
-					"are mutually exclusive.\n");
+				pr_warn("-o debug and -o errors=panic are mutually exclusive\n");
 				return -EINVAL;
 			}
 			args->ar_errors = GFS2_ERRORS_PANIC;
@@ -279,7 +279,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			break;
 		case Opt_error:
 		default:
-			pr_warn("GFS2: invalid mount option: %s\n", o);
+			pr_warn("invalid mount option: %s\n", o);
 			return -EINVAL;
 		}
 	}
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d09f6ed..256354c 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 3fe8e34..bead90d 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -99,13 +101,13 @@ static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 
 static void gfs2_print_trans(const struct gfs2_trans *tr)
 {
-	pr_warn("GFS2: Transaction created at: %pSR\n", (void *)tr->tr_ip);
-	pr_warn("GFS2: blocks=%u revokes=%u reserved=%u touched=%u\n",
-	       tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
-	pr_warn("GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
-	       tr->tr_num_buf_new, tr->tr_num_buf_rm,
-	       tr->tr_num_databuf_new, tr->tr_num_databuf_rm,
-	       tr->tr_num_revoke, tr->tr_num_revoke_rm);
+	pr_warn("Transaction created at: %pSR\n", (void *)tr->tr_ip);
+	pr_warn("blocks=%u revokes=%u reserved=%u touched=%u\n",
+		tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
+	pr_warn("Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
+		tr->tr_num_buf_new, tr->tr_num_buf_rm,
+		tr->tr_num_databuf_new, tr->tr_num_databuf_rm,
+		tr->tr_num_revoke, tr->tr_num_revoke_rm);
 }
 
 void gfs2_trans_end(struct gfs2_sbd *sdp)
@@ -231,8 +233,7 @@ static void meta_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
 	if (unlikely(mh->mh_magic != cpu_to_be32(GFS2_MAGIC))) {
-		pr_err("Attempting to add uninitialised block to journal "
-		       "(inplace block=%lld)\n",
+		pr_err("Attempting to add uninitialised block to journal (inplace block=%lld)\n",
 		       (unsigned long long)bd->bd_bh->b_blocknr);
 		BUG();
 	}
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index e9d7001..02fb38d 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -7,6 +7,8 @@
  * of the GNU General Public License version 2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
@@ -30,7 +32,7 @@ mempool_t *gfs2_page_pool __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
-	pr_emerg("GFS2: fsid=%s: fatal assertion failed\n", sdp->sd_fsname);
+	pr_emerg("fsid=%s: fatal assertion failed\n", sdp->sd_fsname);
 }
 
 int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
@@ -65,7 +67,7 @@ int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
 	}
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_PANIC)
-		panic("GFS2: fsid=%s: panic requested.\n", sdp->sd_fsname);
+		panic("GFS2: fsid=%s: panic requested\n", sdp->sd_fsname);
 
 	return -1;
 }
@@ -104,10 +106,8 @@ int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
 		return -2;
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW)
-		pr_warn("GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
-		       "GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		       sdp->sd_fsname, assertion,
-		       sdp->sd_fsname, function, file, line);
+		pr_warn("fsid=%s: warning: assertion \"%s\" failed at function = %s, file = %s, line = %u\n",
+			sdp->sd_fsname, assertion, function, file, line);
 
 	if (sdp->sd_args.ar_debug)
 		BUG();
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index b7ffb09..d365733 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -10,22 +10,21 @@
 #ifndef __UTIL_DOT_H__
 #define __UTIL_DOT_H__
 
+#ifdef pr_fmt
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#endif
+
 #include <linux/mempool.h>
 
 #include "incore.h"
 
-#define fs_printk(level, fs, fmt, arg...) \
-	printk(level "GFS2: fsid=%s: " fmt , (fs)->sd_fsname , ## arg)
-
-#define fs_info(fs, fmt, arg...) \
-	fs_printk(KERN_INFO , fs , fmt , ## arg)
-
-#define fs_warn(fs, fmt, arg...) \
-	fs_printk(KERN_WARNING , fs , fmt , ## arg)
-
-#define fs_err(fs, fmt, arg...) \
-	fs_printk(KERN_ERR, fs , fmt , ## arg)
-
+#define fs_warn(fs, fmt, ...)						\
+	pr_warn("fsid=%s: " fmt, (fs)->sd_fsname, ##__VA_ARGS__)
+#define fs_err(fs, fmt, ...)						\
+	pr_err("fsid=%s: " fmt, (fs)->sd_fsname, ##__VA_ARGS__)
+#define fs_info(fs, fmt, ...)						\
+	pr_info("fsid=%s: " fmt, (fs)->sd_fsname, ##__VA_ARGS__)
 
 void gfs2_assert_i(struct gfs2_sbd *sdp);
 
@@ -85,7 +84,7 @@ static inline int gfs2_meta_check(struct gfs2_sbd *sdp,
 	struct gfs2_meta_header *mh = (struct gfs2_meta_header *)bh->b_data;
 	u32 magic = be32_to_cpu(mh->mh_magic);
 	if (unlikely(magic != GFS2_MAGIC)) {
-		printk(KERN_ERR "GFS2: Magic number missing at %llu\n",
+		pr_err("Magic number missing at %llu\n",
 		       (unsigned long long)bh->b_blocknr);
 		return -EIO;
 	}
-- 
1.8.3.1

