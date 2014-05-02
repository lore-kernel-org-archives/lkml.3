Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaEBPp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:45:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44273 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaEBPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 127/151] ocfs2: dlm: fix recovery hung
Date: Fri,  2 May 2014 08:38:35 -0700
Message-Id: <1399045139-4531-128-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit ded2cf71419b9353060e633b59e446c42a6a2a09 upstream.

There is a race window in dlm_do_recovery() between dlm_remaster_locks()
and dlm_reset_recovery() when the recovery master nearly finish the
recovery process for a dead node.  After the master sends FINALIZE_RECO
message in dlm_remaster_locks(), another node may become the recovery
master for another dead node, and then send the BEGIN_RECO message to
all the nodes included the old master, in the handler of this message
dlm_begin_reco_handler() of old master, dlm->reco.dead_node and
dlm->reco.new_master will be set to the second dead node and the new
master, then in dlm_reset_recovery(), these two variables will be reset
to default value.  This will cause new recovery master can not finish
the recovery process and hung, at last the whole cluster will hung for
recovery.

old recovery master:                                 new recovery master:
dlm_remaster_locks()
                                                  become recovery master for
                                                  another dead node.
                                                  dlm_send_begin_reco_message()
dlm_begin_reco_handler()
{
 if (dlm->reco.state & DLM_RECO_STATE_FINALIZE) {
  return -EAGAIN;
 }
 dlm_set_reco_master(dlm, br->node_idx);
 dlm_set_reco_dead_node(dlm, br->dead_node);
}
dlm_reset_recovery()
{
 dlm_set_reco_dead_node(dlm, O2NM_INVALID_NODE_NUM);
 dlm_set_reco_master(dlm, O2NM_INVALID_NODE_NUM);
}
                                                  will hang in dlm_remaster_locks() for
                                                  request dlm locks info

Before send FINALIZE_RECO message, recovery master should set
DLM_RECO_STATE_FINALIZE for itself and clear it after the recovery done,
this can break the race windows as the BEGIN_RECO messages will not be
handled before DLM_RECO_STATE_FINALIZE flag is cleared.

A similar race may happen between new recovery master and normal node
which is in dlm_finalize_reco_handler(), also fix it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index c2dd258..fe29f79 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -537,7 +537,10 @@ master_here:
 		/* success!  see if any other nodes need recovery */
 		mlog(0, "DONE mastering recovery of %s:%u here(this=%u)!\n",
 		     dlm->name, dlm->reco.dead_node, dlm->node_num);
-		dlm_reset_recovery(dlm);
+		spin_lock(&dlm->spinlock);
+		__dlm_reset_recovery(dlm);
+		dlm->reco.state &= ~DLM_RECO_STATE_FINALIZE;
+		spin_unlock(&dlm->spinlock);
 	}
 	dlm_end_recovery(dlm);
 
@@ -695,6 +698,14 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 		if (all_nodes_done) {
 			int ret;
 
+			/* Set this flag on recovery master to avoid
+			 * a new recovery for another dead node start
+			 * before the recovery is not done. That may
+			 * cause recovery hung.*/
+			spin_lock(&dlm->spinlock);
+			dlm->reco.state |= DLM_RECO_STATE_FINALIZE;
+			spin_unlock(&dlm->spinlock);
+
 			/* all nodes are now in DLM_RECO_NODE_DATA_DONE state
 	 		 * just send a finalize message to everyone and
 	 		 * clean up */
@@ -2884,8 +2895,8 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 				BUG();
 			}
 			dlm->reco.state &= ~DLM_RECO_STATE_FINALIZE;
+			__dlm_reset_recovery(dlm);
 			spin_unlock(&dlm->spinlock);
-			dlm_reset_recovery(dlm);
 			dlm_kick_recovery_thread(dlm);
 			break;
 		default:
-- 
1.9.1

