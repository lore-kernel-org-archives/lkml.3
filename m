Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaATMbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:31:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbaATMYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:32 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/24] GFS2: Remove gfs2_quota_change_host structure
Date: Mon, 20 Jan 2014 12:23:28 +0000
Message-Id: <1390220627-1571-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one place this is used, when reading in the quota
changes at mount time. It is not really required and much
simpler to just convert the fields from the on-disk structure
as required.

There should be no functional change as a result of this patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 98236d0..1b6b367 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -67,12 +67,6 @@
 #include "inode.h"
 #include "util.h"
 
-struct gfs2_quota_change_host {
-	u64 qc_change;
-	u32 qc_flags; /* GFS2_QCF_... */
-	struct kqid qc_id;
-};
-
 /* Lock order: qd_lock -> qd->lockref.lock -> lru lock */
 static DEFINE_SPINLOCK(qd_lock);
 struct list_lru gfs2_qd_lru;
@@ -1214,17 +1208,6 @@ int gfs2_quota_refresh(struct gfs2_sbd *sdp, struct kqid qid)
 	return error;
 }
 
-static void gfs2_quota_change_in(struct gfs2_quota_change_host *qc, const void *buf)
-{
-	const struct gfs2_quota_change *str = buf;
-
-	qc->qc_change = be64_to_cpu(str->qc_change);
-	qc->qc_flags = be32_to_cpu(str->qc_flags);
-	qc->qc_id = make_kqid(&init_user_ns,
-			      (qc->qc_flags & GFS2_QCF_USER)?USRQUOTA:GRPQUOTA,
-			      be32_to_cpu(str->qc_id));
-}
-
 int gfs2_quota_init(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_qc_inode);
@@ -1257,6 +1240,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 	for (x = 0; x < blocks; x++) {
 		struct buffer_head *bh;
+		const struct gfs2_quota_change *qc;
 		unsigned int y;
 
 		if (!extlen) {
@@ -1274,25 +1258,28 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 			goto fail;
 		}
 
+		qc = (const struct gfs2_quota_change *)(bh->b_data + sizeof(struct gfs2_meta_header));
 		for (y = 0; y < sdp->sd_qc_per_block && slot < sdp->sd_quota_slots;
 		     y++, slot++) {
-			struct gfs2_quota_change_host qc;
 			struct gfs2_quota_data *qd;
-
-			gfs2_quota_change_in(&qc, bh->b_data +
-					  sizeof(struct gfs2_meta_header) +
-					  y * sizeof(struct gfs2_quota_change));
-			if (!qc.qc_change)
+			s64 qc_change = be64_to_cpu(qc->qc_change);
+			u32 qc_flags = be32_to_cpu(qc->qc_flags);
+			enum quota_type qtype = (qc_flags & GFS2_QCF_USER) ?
+						USRQUOTA : GRPQUOTA;
+			struct kqid qc_id = make_kqid(&init_user_ns, qtype,
+						      be32_to_cpu(qc->qc_id));
+			qc++;
+			if (!qc_change)
 				continue;
 
-			error = qd_alloc(sdp, qc.qc_id, &qd);
+			error = qd_alloc(sdp, qc_id, &qd);
 			if (error) {
 				brelse(bh);
 				goto fail;
 			}
 
 			set_bit(QDF_CHANGE, &qd->qd_flags);
-			qd->qd_change = qc.qc_change;
+			qd->qd_change = qc_change;
 			qd->qd_slot = slot;
 			qd->qd_slot_count = 1;
 
-- 
1.8.3.1

