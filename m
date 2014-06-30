Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaF3L61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:58:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52134 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/181] quota: provide function to grab quota structure reference
Date: Mon, 30 Jun 2014 13:50:53 +0200
Message-Id: <b5258061a2a8f657aa5900dd3c1ded9e868e3544.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9f985cb6c45bc3f8b7e161c9658d409d051d576f upstream.

Provide dqgrab() function to get quota structure reference when we are
sure it already has at least one active reference.  Make use of this
function inside quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/quota/dquot.c         | 4 ++--
 include/linux/quotaops.h | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index cfc8dcc16043..9cd5f63715c0 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -528,7 +528,7 @@ restart:
 		if (atomic_read(&dquot->dq_count)) {
 			DEFINE_WAIT(wait);
 
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			prepare_to_wait(&dquot->dq_wait_unused, &wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock(&dq_list_lock);
@@ -632,7 +632,7 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			/* Now we have active dquot from which someone is
  			 * holding reference so we can safely just increase
 			 * use count */
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
 			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 6965fe394c3b..1d3eee594cd6 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -46,6 +46,14 @@ void inode_reclaim_rsv_space(struct inode *inode, qsize_t number);
 void dquot_initialize(struct inode *inode);
 void dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, struct kqid qid);
+static inline struct dquot *dqgrab(struct dquot *dquot)
+{
+	/* Make sure someone else has active reference to dquot */
+	WARN_ON_ONCE(!atomic_read(&dquot->dq_count));
+	WARN_ON_ONCE(!test_bit(DQ_ACTIVE_B, &dquot->dq_flags));
+	atomic_inc(&dquot->dq_count);
+	return dquot;
+}
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
-- 
2.0.0

