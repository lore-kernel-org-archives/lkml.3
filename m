Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3GYIXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:23:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57895 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab3GYIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:23:09 -0400
From: zwu.kernel@gmail.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] xfs: introduce object readahead to log recovery
Date: Thu, 25 Jul 2013 16:23:39 +0800
Message-Id: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072508-5806-0000-0000-0000222F1B5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  It can take a long time to run log recovery operation because it is
single threaded and is bound by read latency. We can find that it took
most of the time to wait for the read IO to occur, so if one object
readahead is introduced to log recovery, it will obviously reduce the
log recovery time.

  In dirty log case as below:
    data device: 0xfd10
    log device: 0xfd10 daddr: 20480032 length: 20480

    log tail: 7941 head: 11077 state: <DIRTY>

This dirty ratio is about 15%. I am trying to do tests in larger scale
and dirtier filesystem environment.

Log recovery time stat:

            w/o this patch        w/ this patch
  real         0m1.051s             0m0.965s
  sys          0m0.033s             0m0.035s

  iowait       0m1.018s             0m0.930s

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_log_recover.c | 131 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 127 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6fcc910a..f07e5e0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3107,6 +3107,121 @@ xlog_recover_free_trans(
 	kmem_free(trans);
 }
 
+STATIC void
+xlog_recover_buffer_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
+	xfs_mount_t		*mp = log->l_mp;
+
+	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+			buf_f->blf_len, buf_f->blf_flags)) {
+		return;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
+			buf_f->blf_len, NULL);
+}
+
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	xfs_inode_log_format_t	*in_f;
+	xfs_mount_t		*mp = log->l_mp;
+	int			error;
+	int			need_free = 0;
+
+	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
+		in_f = item->ri_buf[0].i_addr;
+	} else {
+		in_f = kmem_alloc(sizeof(xfs_inode_log_format_t), KM_SLEEP);
+		need_free = 1;
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			goto error;
+	}
+
+	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
+					in_f->ilf_len, 0)) {
+		goto error;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, in_f->ilf_blkno,
+			in_f->ilf_len, &xfs_inode_buf_ops);
+
+error:
+	if (need_free)
+		kmem_free(in_f);
+}
+
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	xfs_mount_t		*mp = log->l_mp;
+	xfs_buf_t		*bp;
+	struct xfs_disk_dquot	*recddq;
+	int			error;
+	xfs_dq_logformat_t	*dq_f;
+	uint			type;
+
+
+	if (mp->m_qflags == 0)
+		return;
+
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL)
+		return;
+	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t))
+		return;
+
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return;
+
+	dq_f = item->ri_buf[0].i_addr;
+	ASSERT(dq_f);
+	error = xfs_qm_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
+			   "xlog_recover_dquot_ra_pass2 (log copy)");
+	if (error)
+		return;
+	ASSERT(dq_f->qlf_len == 1);
+
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
+				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
+				   NULL);
+	if (!error)
+		xfs_buf_relse(bp);
+}
+
+STATIC void
+xlog_recover_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_BUF:
+		xlog_recover_buffer_ra_pass2(log, item);
+		break;
+	case XFS_LI_INODE:
+		xlog_recover_inode_ra_pass2(log, item);
+		break;
+	case XFS_LI_DQUOT:
+		xlog_recover_dquot_ra_pass2(log, item);
+		break;
+	case XFS_LI_EFI:
+	case XFS_LI_EFD:
+	case XFS_LI_QUOTAOFF:
+	default:
+		break;
+	}
+}
+
 STATIC int
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -3140,10 +3255,14 @@ xlog_recover_commit_pass2(
 	struct xlog			*log,
 	struct xlog_recover		*trans,
 	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
+	struct xlog_recover_item	*item,
+	struct xlog_recover_item	*next_item)
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
 
+	if (next_item)
+		xlog_recover_ra_pass2(log, next_item);
+
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_BUF:
 		return xlog_recover_buffer_pass2(log, buffer_list, item);
@@ -3181,7 +3300,7 @@ xlog_recover_commit_trans(
 	int			pass)
 {
 	int			error = 0, error2;
-	xlog_recover_item_t	*item;
+	xlog_recover_item_t	*item, *next_item, *temp_item;
 	LIST_HEAD		(buffer_list);
 
 	hlist_del(&trans->r_list);
@@ -3190,14 +3309,18 @@ xlog_recover_commit_trans(
 	if (error)
 		return error;
 
-	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+	list_for_each_entry_safe(item, temp_item, &trans->r_itemq, ri_list) {
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
+			if (&temp_item->ri_list != &trans->r_itemq)
+				next_item = temp_item;
+			else
+				next_item = NULL;
 			error = xlog_recover_commit_pass2(log, trans,
-							  &buffer_list, item);
+					  &buffer_list, item, next_item);
 			break;
 		default:
 			ASSERT(0);
-- 
1.7.11.7

