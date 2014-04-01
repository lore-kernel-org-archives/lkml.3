Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaDAJQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaDAJQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:40 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/29] GFS2: Convert gfs2_lm_withdraw to use fs_err
Date: Tue,  1 Apr 2014 10:15:32 +0100
Message-Id: <1396343741-1524-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

vprintk use is not prefixed by a KERN_<LEVEL>,
so emit these messages at KERN_ERR level.

Using %pV can save some code and allow fs_err to
be used, so do it.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 256354c..de25d55 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -140,9 +140,8 @@ static ssize_t withdraw_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
 
-	gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: withdrawing from cluster at user's request\n",
-		sdp->sd_fsname);
+	gfs2_lm_withdraw(sdp, "withdrawing from cluster at user's request\n");
+
 	return len;
 }
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 84bf853..86d2035 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -35,18 +35,24 @@ void gfs2_assert_i(struct gfs2_sbd *sdp)
 	fs_emerg(sdp, "fatal assertion failed\n");
 }
 
-int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
+int gfs2_lm_withdraw(struct gfs2_sbd *sdp, const char *fmt, ...)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	const struct lm_lockops *lm = ls->ls_ops;
 	va_list args;
+	struct va_format vaf;
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW &&
 	    test_and_set_bit(SDF_SHUTDOWN, &sdp->sd_flags))
 		return 0;
 
 	va_start(args, fmt);
-	vprintk(fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	fs_err(sdp, "%pV", &vaf);
+
 	va_end(args);
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW) {
@@ -83,10 +89,9 @@ int gfs2_assert_withdraw_i(struct gfs2_sbd *sdp, char *assertion,
 {
 	int me;
 	me = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: assertion \"%s\" failed\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname, assertion,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: assertion \"%s\" failed\n"
+			      "   function = %s, file = %s, line = %u\n",
+			      assertion, function, file, line);
 	dump_stack();
 	return (me) ? -1 : -2;
 }
@@ -136,10 +141,8 @@ int gfs2_consist_i(struct gfs2_sbd *sdp, int cluster_wide, const char *function,
 {
 	int rv;
 	rv = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: filesystem consistency error\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: filesystem consistency error - function = %s, file = %s, line = %u\n",
+			      function, file, line);
 	return rv;
 }
 
@@ -155,13 +158,12 @@ int gfs2_consist_inode_i(struct gfs2_inode *ip, int cluster_wide,
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	int rv;
 	rv = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: filesystem consistency error\n"
-		"GFS2: fsid=%s:   inode = %llu %llu\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, (unsigned long long)ip->i_no_formal_ino,
-		(unsigned long long)ip->i_no_addr,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: filesystem consistency error\n"
+			      "  inode = %llu %llu\n"
+			      "  function = %s, file = %s, line = %u\n",
+			      (unsigned long long)ip->i_no_formal_ino,
+			      (unsigned long long)ip->i_no_addr,
+			      function, file, line);
 	return rv;
 }
 
@@ -177,12 +179,11 @@ int gfs2_consist_rgrpd_i(struct gfs2_rgrpd *rgd, int cluster_wide,
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	int rv;
 	rv = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: filesystem consistency error\n"
-		"GFS2: fsid=%s:   RG = %llu\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, (unsigned long long)rgd->rd_addr,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: filesystem consistency error\n"
+			      "  RG = %llu\n"
+			      "  function = %s, file = %s, line = %u\n",
+			      (unsigned long long)rgd->rd_addr,
+			      function, file, line);
 	return rv;
 }
 
@@ -198,12 +199,11 @@ int gfs2_meta_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
 {
 	int me;
 	me = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: invalid metadata block\n"
-		"GFS2: fsid=%s:   bh = %llu (%s)\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, (unsigned long long)bh->b_blocknr, type,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: invalid metadata block\n"
+			      "  bh = %llu (%s)\n"
+			      "  function = %s, file = %s, line = %u\n",
+			      (unsigned long long)bh->b_blocknr, type,
+			      function, file, line);
 	return (me) ? -1 : -2;
 }
 
@@ -219,12 +219,11 @@ int gfs2_metatype_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
 {
 	int me;
 	me = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: invalid metadata block\n"
-		"GFS2: fsid=%s:   bh = %llu (type: exp=%u, found=%u)\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, (unsigned long long)bh->b_blocknr, type, t,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: invalid metadata block\n"
+			      "  bh = %llu (type: exp=%u, found=%u)\n"
+			      "  function = %s, file = %s, line = %u\n",
+			      (unsigned long long)bh->b_blocknr, type, t,
+			      function, file, line);
 	return (me) ? -1 : -2;
 }
 
@@ -239,10 +238,9 @@ int gfs2_io_error_i(struct gfs2_sbd *sdp, const char *function, char *file,
 {
 	int rv;
 	rv = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: I/O error\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: I/O error\n"
+			      "  function = %s, file = %s, line = %u\n",
+			      function, file, line);
 	return rv;
 }
 
@@ -257,12 +255,11 @@ int gfs2_io_error_bh_i(struct gfs2_sbd *sdp, struct buffer_head *bh,
 {
 	int rv;
 	rv = gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: fatal: I/O error\n"
-		"GFS2: fsid=%s:   block = %llu\n"
-		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-		sdp->sd_fsname,
-		sdp->sd_fsname, (unsigned long long)bh->b_blocknr,
-		sdp->sd_fsname, function, file, line);
+			      "fatal: I/O error\n"
+			      "  block = %llu\n"
+			      "  function = %s, file = %s, line = %u\n",
+			      (unsigned long long)bh->b_blocknr,
+			      function, file, line);
 	return rv;
 }
 
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 515cce2..cbdcbdf 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -165,7 +165,7 @@ static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 #define gfs2_tune_get(sdp, field) \
 gfs2_tune_get_i(&(sdp)->sd_tune, &(sdp)->sd_tune.field)
 
-int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...);
+__printf(2, 3)
+int gfs2_lm_withdraw(struct gfs2_sbd *sdp, const char *fmt, ...);
 
 #endif /* __UTIL_DOT_H__ */
-
-- 
1.8.3.1

