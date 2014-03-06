Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaCFULn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:11:43 -0500
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:57216 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751578AbaCFULm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:11:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:3868:3871:3872:4050:4119:4321:4605:5007:6119:6261:7875:7903:9592:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13138:13231:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: son99_617927b2bd959
X-Filterd-Recvd-Size: 8126
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 3/3] gfs2: Convert gfs2_lm_withdraw to use fs_err
Date: Thu,  6 Mar 2014 12:10:47 -0800
Message-Id: <5a74f3dbcb3e28eaa80b5e76dacffeca67a6cc3d.1394136338.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
References: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
In-Reply-To: <cover.1394136338.git.joe@perches.com>
References: <cover.1394136338.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vprintk use is not prefixed by a KERN_<LEVEL>,
so emit these messages at KERN_ERR level.

Using %pV can save some code and allow fs_err to
be used, so do it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/sys.c  |  4 +--
 fs/gfs2/util.c | 87 ++++++++++++++++++++++++++++------------------------------
 fs/gfs2/util.h |  4 +--
 3 files changed, 45 insertions(+), 50 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 256354c..5403d42 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -140,9 +140,7 @@ static ssize_t withdraw_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
 
-	gfs2_lm_withdraw(sdp,
-		"GFS2: fsid=%s: withdrawing from cluster at user's request\n",
-		sdp->sd_fsname);
+	gfs2_lm_withdraw(sdp, "withdrawing from cluster at user's request\n");
 	return len;
 }
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 84bf853..5a3ef98 100644
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
+		"fatal: invalid metadata block\n"
+		"  bh = %llu (%s)\n"
+		"  function = %s, file = %s, line = %u\n",
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
1.8.1.2.459.gbcd45b4.dirty

