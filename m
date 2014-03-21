Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967033AbaCUBdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:33:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbaCUADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 004/149] ocfs2: fix quota file corruption
Date: Thu, 20 Mar 2014 17:02:47 -0700
Message-Id: <20140321000436.903559988@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 15c34a760630ca2c803848fba90ca0646a9907dd upstream.

Global quota files are accessed from different nodes.  Thus we cannot
cache offset of quota structure in the quota file after we drop our node
reference count to it because after that moment quota structure may be
freed and reallocated elsewhere by a different node resulting in
corruption of quota file.

Fix the problem by clearing dq_off when we are releasing dquot structure.
We also remove the DB_READ_B handling because it is useless -
DQ_ACTIVE_B is set iff DQ_READ_B is set.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/quota_global.c |   27 +++++++++++++++++----------
 fs/ocfs2/quota_local.c  |    4 ----
 2 files changed, 17 insertions(+), 14 deletions(-)

--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -717,6 +717,12 @@ static int ocfs2_release_dquot(struct dq
 	 */
 	if (status < 0)
 		mlog_errno(status);
+	/*
+	 * Clear dq_off so that we search for the structure in quota file next
+	 * time we acquire it. The structure might be deleted and reallocated
+	 * elsewhere by another node while our dquot structure is on freelist.
+	 */
+	dquot->dq_off = 0;
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_trans:
 	ocfs2_commit_trans(osb, handle);
@@ -756,16 +762,17 @@ static int ocfs2_acquire_dquot(struct dq
 	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
 		goto out;
-	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
-		status = ocfs2_qinfo_lock(info, 0);
-		if (status < 0)
-			goto out_dq;
-		status = qtree_read_dquot(&info->dqi_gi, dquot);
-		ocfs2_qinfo_unlock(info, 0);
-		if (status < 0)
-			goto out_dq;
-	}
-	set_bit(DQ_READ_B, &dquot->dq_flags);
+	status = ocfs2_qinfo_lock(info, 0);
+	if (status < 0)
+		goto out_dq;
+	/*
+	 * We always want to read dquot structure from disk because we don't
+	 * know what happened with it while it was on freelist.
+	 */
+	status = qtree_read_dquot(&info->dqi_gi, dquot);
+	ocfs2_qinfo_unlock(info, 0);
+	if (status < 0)
+		goto out_dq;
 
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1303,10 +1303,6 @@ int ocfs2_local_release_dquot(handle_t *
 	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
 
 out:
-	/* Clear the read bit so that next time someone uses this
-	 * dquot he reads fresh info from disk and allocates local
-	 * dquot structure */
-	clear_bit(DQ_READ_B, &dquot->dq_flags);
 	return status;
 }
 


