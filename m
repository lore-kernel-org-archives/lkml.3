Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LEFpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 00:45:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:58660 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3LEFps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 00:45:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,830,1378882800"; 
   d="scan'208";a="444959678"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: sage@inktank.com, dave@bob-the-boat.me.uk, malcolm@sgi.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] ceph: initialize inode before instantiating dentry
Date: Thu,  5 Dec 2013 13:45:36 +0800
Message-Id: <1386222336-32559-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit b18825a7c8 (Put a small type field into struct dentry::d_flags)
put a type field into struct dentry::d_flags. __d_instantiate() set the
field by checking inode->i_mode. So we should initialize inode before
instantiating dentry when handling mds reply.

Fixes: #6930
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 fs/ceph/inode.c | 114 +++++++++++++++++++++-----------------------------------
 1 file changed, 43 insertions(+), 71 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9a8e396..c1a9367 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -978,7 +978,6 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 	struct ceph_mds_reply_inode *ininfo;
 	struct ceph_vino vino;
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
-	int i = 0;
 	int err = 0;
 
 	dout("fill_trace %p is_dentry %d is_target %d\n", req,
@@ -1039,6 +1038,29 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 		}
 	}
 
+	if (rinfo->head->is_target) {
+		vino.ino = le64_to_cpu(rinfo->targeti.in->ino);
+		vino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
+
+		in = ceph_get_inode(sb, vino);
+		if (IS_ERR(in)) {
+			err = PTR_ERR(in);
+			goto done;
+		}
+		req->r_target_inode = in;
+
+		err = fill_inode(in, &rinfo->targeti, NULL,
+				session, req->r_request_started,
+				(le32_to_cpu(rinfo->head->result) == 0) ?
+				req->r_fmode : -1,
+				&req->r_caps_reservation);
+		if (err < 0) {
+			pr_err("fill_inode badness %p %llx.%llx\n",
+				in, ceph_vinop(in));
+			goto done;
+		}
+	}
+
 	/*
 	 * ignore null lease/binding on snapdir ENOENT, or else we
 	 * will have trouble splicing in the virtual snapdir later
@@ -1108,7 +1130,6 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 			     ceph_dentry(req->r_old_dentry)->offset);
 
 			dn = req->r_old_dentry;  /* use old_dentry */
-			in = dn->d_inode;
 		}
 
 		/* null dentry? */
@@ -1130,44 +1151,28 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 		}
 
 		/* attach proper inode */
-		ininfo = rinfo->targeti.in;
-		vino.ino = le64_to_cpu(ininfo->ino);
-		vino.snap = le64_to_cpu(ininfo->snapid);
-		in = dn->d_inode;
-		if (!in) {
-			in = ceph_get_inode(sb, vino);
-			if (IS_ERR(in)) {
-				pr_err("fill_trace bad get_inode "
-				       "%llx.%llx\n", vino.ino, vino.snap);
-				err = PTR_ERR(in);
-				d_drop(dn);
-				goto done;
-			}
+		if (!dn->d_inode) {
+			ihold(in);
 			dn = splice_dentry(dn, in, &have_lease, true);
 			if (IS_ERR(dn)) {
 				err = PTR_ERR(dn);
 				goto done;
 			}
 			req->r_dentry = dn;  /* may have spliced */
-			ihold(in);
-		} else if (ceph_ino(in) == vino.ino &&
-			   ceph_snap(in) == vino.snap) {
-			ihold(in);
-		} else {
+		} else if (dn->d_inode && dn->d_inode != in) {
 			dout(" %p links to %p %llx.%llx, not %llx.%llx\n",
-			     dn, in, ceph_ino(in), ceph_snap(in),
-			     vino.ino, vino.snap);
+			     dn, dn->d_inode, ceph_vinop(dn->d_inode),
+			     ceph_vinop(in));
 			have_lease = false;
-			in = NULL;
 		}
 
 		if (have_lease)
 			update_dentry_lease(dn, rinfo->dlease, session,
 					    req->r_request_started);
 		dout(" final dn %p\n", dn);
-		i++;
-	} else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
-		   req->r_op == CEPH_MDS_OP_MKSNAP) && !req->r_aborted) {
+	} else if (!req->r_aborted &&
+		   (req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
+		    req->r_op == CEPH_MDS_OP_MKSNAP)) {
 		struct dentry *dn = req->r_dentry;
 
 		/* fill out a snapdir LOOKUPSNAP dentry */
@@ -1177,52 +1182,15 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 		ininfo = rinfo->targeti.in;
 		vino.ino = le64_to_cpu(ininfo->ino);
 		vino.snap = le64_to_cpu(ininfo->snapid);
-		in = ceph_get_inode(sb, vino);
-		if (IS_ERR(in)) {
-			pr_err("fill_inode get_inode badness %llx.%llx\n",
-			       vino.ino, vino.snap);
-			err = PTR_ERR(in);
-			d_delete(dn);
-			goto done;
-		}
 		dout(" linking snapped dir %p to dn %p\n", in, dn);
+		ihold(in);
 		dn = splice_dentry(dn, in, NULL, true);
 		if (IS_ERR(dn)) {
 			err = PTR_ERR(dn);
 			goto done;
 		}
 		req->r_dentry = dn;  /* may have spliced */
-		ihold(in);
-		rinfo->head->is_dentry = 1;  /* fool notrace handlers */
 	}
-
-	if (rinfo->head->is_target) {
-		vino.ino = le64_to_cpu(rinfo->targeti.in->ino);
-		vino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
-
-		if (in == NULL || ceph_ino(in) != vino.ino ||
-		    ceph_snap(in) != vino.snap) {
-			in = ceph_get_inode(sb, vino);
-			if (IS_ERR(in)) {
-				err = PTR_ERR(in);
-				goto done;
-			}
-		}
-		req->r_target_inode = in;
-
-		err = fill_inode(in,
-				 &rinfo->targeti, NULL,
-				 session, req->r_request_started,
-				 (le32_to_cpu(rinfo->head->result) == 0) ?
-				 req->r_fmode : -1,
-				 &req->r_caps_reservation);
-		if (err < 0) {
-			pr_err("fill_inode badness %p %llx.%llx\n",
-			       in, ceph_vinop(in));
-			goto done;
-		}
-	}
-
 done:
 	dout("fill_trace done err=%d\n", err);
 	return err;
@@ -1360,23 +1328,27 @@ retry_lookup:
 		} else {
 			in = ceph_get_inode(parent->d_sb, vino);
 			if (IS_ERR(in)) {
-				dout("new_inode badness\n");
-				d_drop(dn);
-				dput(dn);
 				err = PTR_ERR(in);
-				goto out;
+				d_drop(dn);
+				goto next_item;
 			}
-			dn = splice_dentry(dn, in, NULL, false);
-			if (IS_ERR(dn))
-				dn = NULL;
 		}
 
 		if (fill_inode(in, &rinfo->dir_in[i], NULL, session,
 			       req->r_request_started, -1,
 			       &req->r_caps_reservation) < 0) {
 			pr_err("fill_inode badness on %p\n", in);
+			if (!dn->d_inode)
+				iput(in);
+			d_drop(dn);
 			goto next_item;
 		}
+
+		if (!dn->d_inode) {
+			dn = splice_dentry(dn, in, NULL, false);
+			if (IS_ERR(dn))
+				dn = NULL;
+		}
 		if (dn)
 			update_dentry_lease(dn, rinfo->dir_dlease[i],
 					    req->r_session,
-- 
1.8.1.4

