Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab3HNHSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:18:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33256 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3HNHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:18:15 -0400
From: zwu.kernel@gmail.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v4] xfs: introduce object readahead to log recovery
Date: Wed, 14 Aug 2013 15:16:03 +0800
Message-Id: <1376464563-27821-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081407-3620-0000-0000-000003EDCAB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  It can take a long time to run log recovery operation because it is
single threaded and is bound by read latency. We can find that it took
most of the time to wait for the read IO to occur, so if one object
readahead is introduced to log recovery, it will obviously reduce the
log recovery time.

Log recovery time stat:

          w/o this patch        w/ this patch

real:        0m15.023s             0m7.802s
user:        0m0.001s              0m0.001s
sys:         0m0.246s              0m0.107s

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_log_recover.c | 159 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 152 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7681b19..5f48a92 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3116,6 +3116,106 @@ xlog_recover_free_trans(
 	kmem_free(trans);
 }
 
+STATIC void
+xlog_recover_buffer_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+	struct xfs_mount		*mp = log->l_mp;
+
+	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+			buf_f->blf_len, buf_f->blf_flags)) {
+		return;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
+				buf_f->blf_len, NULL);
+}
+
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_inode_log_format	ilf_buf;
+	struct xfs_inode_log_format	*ilfp;
+	struct xfs_mount		*mp = log->l_mp;
+	int			error;
+
+	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
+		ilfp = item->ri_buf[0].i_addr;
+	} else {
+		ilfp = &ilf_buf;
+		memset(ilfp, 0, sizeof(*ilfp));
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
+		if (error)
+			return;
+	}
+
+	if (xlog_check_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
+		return;
+
+	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
+				ilfp->ilf_len, &xfs_inode_buf_ops);
+}
+
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_disk_dquot	*recddq;
+	struct xfs_dq_logformat	*dq_f;
+	uint			type;
+
+
+	if (mp->m_qflags == 0)
+		return;
+
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL)
+		return;
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
+		return;
+
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return;
+
+	dq_f = item->ri_buf[0].i_addr;
+	ASSERT(dq_f);
+	ASSERT(dq_f->qlf_len == 1);
+
+	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno,
+				dq_f->qlf_len, NULL);
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
@@ -3177,6 +3277,26 @@ xlog_recover_commit_pass2(
 	}
 }
 
+STATIC int
+xlog_recover_items_pass2(
+	struct xlog                     *log,
+	struct xlog_recover             *trans,
+	struct list_head                *buffer_list,
+	struct list_head                *item_list)
+{
+	struct xlog_recover_item	*item;
+	int				error = 0;
+
+	list_for_each_entry(item, item_list, ri_list) {
+		error = xlog_recover_commit_pass2(log, trans,
+					  buffer_list, item);
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
 /*
  * Perform the transaction.
  *
@@ -3189,9 +3309,16 @@ xlog_recover_commit_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error = 0, error2;
-	xlog_recover_item_t	*item;
-	LIST_HEAD		(buffer_list);
+	int				error = 0;
+	int				error2;
+	int				items_queued = 0;
+	struct xlog_recover_item	*item;
+	struct xlog_recover_item	*next;
+	LIST_HEAD			(buffer_list);
+	LIST_HEAD			(ra_list);
+	LIST_HEAD			(done_list);
+
+	#define XLOG_RECOVER_COMMIT_QUEUE_MAX 100
 
 	hlist_del(&trans->r_list);
 
@@ -3199,14 +3326,22 @@ xlog_recover_commit_trans(
 	if (error)
 		return error;
 
-	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
-			error = xlog_recover_commit_pass2(log, trans,
-							  &buffer_list, item);
+			xlog_recover_ra_pass2(log, item);
+			list_move_tail(&item->ri_list, &ra_list);
+			items_queued++;
+			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
+				error = xlog_recover_items_pass2(log, trans,
+						&buffer_list, &ra_list);
+				list_splice_tail_init(&ra_list, &done_list);
+				items_queued = 0;
+			}
+
 			break;
 		default:
 			ASSERT(0);
@@ -3216,9 +3351,19 @@ xlog_recover_commit_trans(
 			goto out;
 	}
 
+out:
+	if (!list_empty(&ra_list)) {
+		if (!error)
+			error = xlog_recover_items_pass2(log, trans,
+					&buffer_list, &ra_list);
+		list_splice_tail_init(&ra_list, &done_list);
+	}
+
+	if (!list_empty(&done_list))
+		list_splice_init(&done_list, &trans->r_itemq);
+
 	xlog_recover_free_trans(trans);
 
-out:
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
-- 
1.7.11.7

