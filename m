Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3G3J63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:58:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58671 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab3G3J6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:58:25 -0400
From: zwu.kernel@gmail.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2] xfs: introduce object readahead to log recovery
Date: Tue, 30 Jul 2013 17:59:07 +0800
Message-Id: <1375178347-29037-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073009-4834-0000-0000-0000098C1979
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
 fs/xfs/xfs_log_recover.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_log_recover.h |   2 +
 2 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7681b19..029826f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3116,6 +3116,111 @@ xlog_recover_free_trans(
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
+				buf_f->blf_len, NULL);
+}
+
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	xfs_inode_log_format_t	in_buf, *in_f;
+	xfs_mount_t		*mp = log->l_mp;
+	int			error;
+
+	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
+		in_f = item->ri_buf[0].i_addr;
+	} else {
+		in_f = &in_buf;
+		memset(in_f, 0, sizeof(*in_f));
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			return;
+	}
+
+	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
+					in_f->ilf_len, 0))
+		return;
+
+	xfs_buf_readahead(mp->m_ddev_targp, in_f->ilf_blkno,
+				in_f->ilf_len, &xfs_inode_buf_ops);
+}
+
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	xfs_mount_t		*mp = log->l_mp;
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
@@ -3177,6 +3282,26 @@ xlog_recover_commit_pass2(
 	}
 }
 
+STATIC int
+xlog_recover_items_pass2(
+	struct xlog                     *log,
+	struct xlog_recover             *trans,
+	struct list_head                *buffer_list,
+	struct list_head                *ra_list)
+{
+	int			error = 0;
+	xlog_recover_item_t	*item;
+
+	list_for_each_entry(item, ra_list, ri_list) {
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
@@ -3189,9 +3314,11 @@ xlog_recover_commit_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error = 0, error2;
-	xlog_recover_item_t	*item;
+	int			error = 0, error2, ra_qdepth = 0;
+	xlog_recover_item_t	*item, *next;
 	LIST_HEAD		(buffer_list);
+	LIST_HEAD		(ra_list);
+	LIST_HEAD		(all_ra_list);
 
 	hlist_del(&trans->r_list);
 
@@ -3199,14 +3326,21 @@ xlog_recover_commit_trans(
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
+			if (ra_qdepth++ >= XLOG_RECOVER_MAX_QDEPTH) {
+				error = xlog_recover_items_pass2(log, trans,
+						&buffer_list, &ra_list);
+				list_splice_tail_init(&ra_list, &all_ra_list);
+				ra_qdepth = 0;
+			} else {
+				xlog_recover_ra_pass2(log, item);
+				list_move_tail(&item->ri_list, &ra_list);
+			}
 			break;
 		default:
 			ASSERT(0);
@@ -3216,9 +3350,27 @@ xlog_recover_commit_trans(
 			goto out;
 	}
 
+	if (!list_empty(&ra_list)) {
+		error = xlog_recover_items_pass2(log, trans,
+				&buffer_list, &ra_list);
+		if (error)
+			goto out;
+
+		list_splice_tail_init(&ra_list, &all_ra_list);
+	}
+
+	if (!list_empty(&all_ra_list))
+		list_splice_init(&all_ra_list, &trans->r_itemq);
+
 	xlog_recover_free_trans(trans);
 
 out:
+	if (!list_empty(&ra_list))
+		list_splice_tail_init(&ra_list, &all_ra_list);
+
+	if (!list_empty(&all_ra_list))
+		list_splice_init(&all_ra_list, &trans->r_itemq);
+
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
diff --git a/fs/xfs/xfs_log_recover.h b/fs/xfs/xfs_log_recover.h
index 1c55ccb..16322f6 100644
--- a/fs/xfs/xfs_log_recover.h
+++ b/fs/xfs/xfs_log_recover.h
@@ -63,4 +63,6 @@ typedef struct xlog_recover {
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
 
+#define XLOG_RECOVER_MAX_QDEPTH 100
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
-- 
1.7.11.7

