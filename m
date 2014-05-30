Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433AbaE3UGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:06:50 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50666 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaE3UGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:06:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org
Subject: [RFC 08/32] fs/ceph: convert to 'struct inode_time'
Date: Fri, 30 May 2014 22:01:32 +0200
Message-Id: <1401480116-1973111-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:JRS8HpWAmg1gsBSykXbzza7NqdoKTp7yqyQbFJ4gWmu
 74tClMOkmnCYhBAW9nuYcaolJyqwjMH6Gy60O/WTKks54OsIxW
 QomIN1SOtAdelgL0XSJ18ki2cC07wIzSLdw94FVI5yU4og+E88
 bVUBIsUv5nrVQFUf6F1fcvTjHDbW5YYIzTrld6QCvJKSqjH0l7
 fuvYXvOO6scqoklvMRApJj8ds9cl/LgatgDefUwTDVJcpqZrR3
 jJgsCthkuGBJbPoMF63nhxABR/pDDIYXDO8TzL5OpvK3zYI7G6
 wLuUoW7y2Smvyu19ppkZ5HT2inyoiwhKZZIjVZfsgUeyDflbRK
 QJDroLfiPwJUUEfVQGoVG2LdF44S4zBF/hWadabY3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ceph supports timestamps until year 2106 using u32 seconds on the
wire, but the kernel internally limits this to a signed value
that only works until 2038 on 32 bit CPUs.

This changes the type used in the ceph code to struct inode_time
to lift that limitation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 drivers/block/rbd.c             |  2 +-
 fs/ceph/cache.c                 |  2 +-
 fs/ceph/caps.c                  |  6 +++---
 fs/ceph/file.c                  |  4 ++--
 fs/ceph/inode.c                 | 20 ++++++++++----------
 fs/ceph/super.h                 |  8 ++++----
 include/linux/ceph/decode.h     |  8 ++++----
 include/linux/ceph/osd_client.h |  4 ++--
 net/ceph/auth_x.c               |  2 +-
 net/ceph/osd_client.c           |  4 ++--
 10 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 4c95b50..d4a7404 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1710,7 +1710,7 @@ static void rbd_osd_req_format_write(struct rbd_obj_request *obj_request)
 	struct rbd_img_request *img_request = obj_request->img_request;
 	struct ceph_osd_request *osd_req = obj_request->osd_req;
 	struct ceph_snap_context *snapc;
-	struct timespec mtime = CURRENT_TIME;
+	struct inode_time mtime = CURRENT_TIME;
 
 	rbd_assert(osd_req != NULL);
 
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 834f9f3..cf48f4b 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -25,7 +25,7 @@
 #include "cache.h"
 
 struct ceph_aux_inode {
-	struct timespec	mtime;
+	struct inode_time mtime;
 	loff_t          size;
 };
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c561b62..263eecd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -988,7 +988,7 @@ static int send_cap_msg(struct ceph_mds_session *session,
 			int caps, int wanted, int dirty,
 			u32 seq, u64 flush_tid, u32 issue_seq, u32 mseq,
 			u64 size, u64 max_size,
-			struct timespec *mtime, struct timespec *atime,
+			struct inode_time *mtime, struct inode_time *atime,
 			u64 time_warp_seq,
 			kuid_t uid, kgid_t gid, umode_t mode,
 			u64 xattr_version,
@@ -1132,7 +1132,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	int held, revoking, dropping, keep;
 	u64 seq, issue_seq, mseq, time_warp_seq, follows;
 	u64 size, max_size;
-	struct timespec mtime, atime;
+	struct inode_time mtime, atime;
 	int wake = 0;
 	umode_t mode;
 	kuid_t uid;
@@ -2416,7 +2416,7 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 	int issued, implemented, used, wanted, dirty;
 	u64 size = le64_to_cpu(grant->size);
 	u64 max_size = le64_to_cpu(grant->max_size);
-	struct timespec mtime, atime, ctime;
+	struct inode_time mtime, atime, ctime;
 	int check_caps = 0;
 	int wake = 0;
 	int writeback = 0;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3020851..0ebb709 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -546,7 +546,7 @@ ceph_sync_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	int flags;
 	int check_caps = 0;
 	int ret;
-	struct timespec mtime = CURRENT_TIME;
+	struct inode_time mtime = CURRENT_TIME;
 	loff_t pos = iocb->ki_pos;
 	size_t count = iov_iter_count(from);
 
@@ -662,7 +662,7 @@ static ssize_t ceph_sync_write(struct kiocb *iocb, struct iov_iter *from)
 	int flags;
 	int check_caps = 0;
 	int ret;
-	struct timespec mtime = CURRENT_TIME;
+	struct inode_time mtime = CURRENT_TIME;
 	loff_t pos = iocb->ki_pos;
 	size_t count = iov_iter_count(from);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e4fff9f..ba18c9d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -506,8 +506,8 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 }
 
 void ceph_fill_file_time(struct inode *inode, int issued,
-			 u64 time_warp_seq, struct timespec *ctime,
-			 struct timespec *mtime, struct timespec *atime)
+			 u64 time_warp_seq, struct inode_time *ctime,
+			 struct inode_time *mtime, struct inode_time *atime)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int warn = 0;
@@ -517,7 +517,7 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 		      CEPH_CAP_FILE_BUFFER|
 		      CEPH_CAP_AUTH_EXCL|
 		      CEPH_CAP_XATTR_EXCL)) {
-		if (timespec_compare(ctime, &inode->i_ctime) > 0) {
+		if (inode_time_compare(ctime, &inode->i_ctime) > 0) {
 			dout("ctime %ld.%09ld -> %ld.%09ld inc w/ cap\n",
 			     inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
 			     ctime->tv_sec, ctime->tv_nsec);
@@ -536,14 +536,14 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 			ci->i_time_warp_seq = time_warp_seq;
 		} else if (time_warp_seq == ci->i_time_warp_seq) {
 			/* nobody did utimes(); take the max */
-			if (timespec_compare(mtime, &inode->i_mtime) > 0) {
+			if (inode_time_compare(mtime, &inode->i_mtime) > 0) {
 				dout("mtime %ld.%09ld -> %ld.%09ld inc\n",
 				     inode->i_mtime.tv_sec,
 				     inode->i_mtime.tv_nsec,
 				     mtime->tv_sec, mtime->tv_nsec);
 				inode->i_mtime = *mtime;
 			}
-			if (timespec_compare(atime, &inode->i_atime) > 0) {
+			if (inode_time_compare(atime, &inode->i_atime) > 0) {
 				dout("atime %ld.%09ld -> %ld.%09ld inc\n",
 				     inode->i_atime.tv_sec,
 				     inode->i_atime.tv_nsec,
@@ -586,7 +586,7 @@ static int fill_inode(struct inode *inode,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int i;
 	int issued = 0, implemented;
-	struct timespec mtime, atime, ctime;
+	struct inode_time mtime, atime, ctime;
 	u32 nsplits;
 	struct ceph_inode_frag *frag;
 	struct rb_node *rb_node;
@@ -1714,12 +1714,12 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_atime = attr->ia_atime;
 			dirtied |= CEPH_CAP_FILE_EXCL;
 		} else if ((issued & CEPH_CAP_FILE_WR) &&
-			   timespec_compare(&inode->i_atime,
+			   inode_time_compare(&inode->i_atime,
 					    &attr->ia_atime) < 0) {
 			inode->i_atime = attr->ia_atime;
 			dirtied |= CEPH_CAP_FILE_WR;
 		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
-			   !timespec_equal(&inode->i_atime, &attr->ia_atime)) {
+			   !inode_time_equal(&inode->i_atime, &attr->ia_atime)) {
 			ceph_encode_timespec(&req->r_args.setattr.atime,
 					     &attr->ia_atime);
 			mask |= CEPH_SETATTR_ATIME;
@@ -1736,12 +1736,12 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_mtime = attr->ia_mtime;
 			dirtied |= CEPH_CAP_FILE_EXCL;
 		} else if ((issued & CEPH_CAP_FILE_WR) &&
-			   timespec_compare(&inode->i_mtime,
+			   inode_time_compare(&inode->i_mtime,
 					    &attr->ia_mtime) < 0) {
 			inode->i_mtime = attr->ia_mtime;
 			dirtied |= CEPH_CAP_FILE_WR;
 		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
-			   !timespec_equal(&inode->i_mtime, &attr->ia_mtime)) {
+			   !inode_time_equal(&inode->i_mtime, &attr->ia_mtime)) {
 			ceph_encode_timespec(&req->r_args.setattr.mtime,
 					     &attr->ia_mtime);
 			mask |= CEPH_SETATTR_MTIME;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ead05cc..15dc11a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -156,7 +156,7 @@ struct ceph_cap_snap {
 	u64 xattr_version;
 
 	u64 size;
-	struct timespec mtime, atime, ctime;
+	struct inode_time mtime, atime, ctime;
 	u64 time_warp_seq;
 	int writing;   /* a sync write is still in progress */
 	int dirty_pages;     /* dirty pages awaiting writeback */
@@ -263,7 +263,7 @@ struct ceph_inode_info {
 	char *i_symlink;
 
 	/* for dirs */
-	struct timespec i_rctime;
+	struct inode_time i_rctime;
 	u64 i_rbytes, i_rfiles, i_rsubdirs;
 	u64 i_files, i_subdirs;
 
@@ -698,8 +698,8 @@ extern struct inode *ceph_get_snapdir(struct inode *parent);
 extern int ceph_fill_file_size(struct inode *inode, int issued,
 			       u32 truncate_seq, u64 truncate_size, u64 size);
 extern void ceph_fill_file_time(struct inode *inode, int issued,
-				u64 time_warp_seq, struct timespec *ctime,
-				struct timespec *mtime, struct timespec *atime);
+				u64 time_warp_seq, struct inode_time *ctime,
+				struct inode_time *mtime, struct inode_time *atime);
 extern int ceph_fill_trace(struct super_block *sb,
 			   struct ceph_mds_request *req,
 			   struct ceph_mds_session *session);
diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index a6ef9cc..f1bb277 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -132,16 +132,16 @@ bad:
 }
 
 /*
- * struct ceph_timespec <-> struct timespec
+ * struct ceph_timespec <-> struct inode_time
  */
-static inline void ceph_decode_timespec(struct timespec *ts,
+static inline void ceph_decode_timespec(struct inode_time *ts,
 					const struct ceph_timespec *tv)
 {
-	ts->tv_sec = (__kernel_time_t)le32_to_cpu(tv->tv_sec);
+	ts->tv_sec = (u64)le32_to_cpu(tv->tv_sec);
 	ts->tv_nsec = (long)le32_to_cpu(tv->tv_nsec);
 }
 static inline void ceph_encode_timespec(struct ceph_timespec *tv,
-					const struct timespec *ts)
+					const struct inode_time *ts)
 {
 	tv->tv_sec = cpu_to_le32((u32)ts->tv_sec);
 	tv->tv_nsec = cpu_to_le32((u32)ts->tv_nsec);
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 94ec696..1617d31 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -312,7 +312,7 @@ extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *
 extern void ceph_osdc_build_request(struct ceph_osd_request *req, u64 off,
 				    struct ceph_snap_context *snapc,
 				    u64 snap_id,
-				    struct timespec *mtime);
+				    struct inode_time *mtime);
 
 extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      struct ceph_file_layout *layout,
@@ -361,7 +361,7 @@ extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
 				struct ceph_snap_context *sc,
 				u64 off, u64 len,
 				u32 truncate_seq, u64 truncate_size,
-				struct timespec *mtime,
+				struct inode_time *mtime,
 				struct page **pages, int nr_pages);
 
 /* watch/notify events */
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index 96238ba..14f0e8a 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -163,7 +163,7 @@ static int ceph_x_proc_ticket_reply(struct ceph_auth_client *ac,
 		void *dp, *dend;
 		int dlen;
 		char is_enc;
-		struct timespec validity;
+		struct inode_time validity;
 		struct ceph_crypto_key old_key;
 		void *tp, *tpend;
 		struct ceph_timespec new_validity;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b0dfce7..1433798 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2315,7 +2315,7 @@ bad:
  */
 void ceph_osdc_build_request(struct ceph_osd_request *req, u64 off,
 				struct ceph_snap_context *snapc, u64 snap_id,
-				struct timespec *mtime)
+				struct inode_time *mtime)
 {
 	struct ceph_msg *msg = req->r_request;
 	void *p;
@@ -2630,7 +2630,7 @@ int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
 			 struct ceph_snap_context *snapc,
 			 u64 off, u64 len,
 			 u32 truncate_seq, u64 truncate_size,
-			 struct timespec *mtime,
+			 struct inode_time *mtime,
 			 struct page **pages, int num_pages)
 {
 	struct ceph_osd_request *req;
-- 
1.8.3.2

