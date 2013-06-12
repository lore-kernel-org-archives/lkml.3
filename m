Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3FLV51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:57:27 -0400
Received: from longford.logfs.org ([213.229.74.203]:59543 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab3FLV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:57:25 -0400
Date: Wed, 12 Jun 2013 16:27:54 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Subject: [PATCH] qla_target: remove qlt_check_fcport_exist
Message-ID: <20130612202754.GB2981@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment from original 2012 patch:
  In all our testing this function has never returned true.  However, the
  dropping of hardware_lock necessary to call this function seems to cause
  a use-after-free we manage to hit rather frequently.  Given this
  cost-benefit ratio, I'm willing to remove some 100 lines of code.

And since the same problem exists around shutdown_sess and put_sess,
this patch changes them from taking the hardware_lock to requiring the
hardware_lock to be taken.  In most cases the caller already had the
lock and had to drop it for the called method to reacquire it.  At best
that hurts performance and in rare instances it causes races with fatal
consequences.

We dropped the original 2012 patch when upgrading our kernel and it took
us nearly half a year to discover we still need it.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/qla_target.c  |  151 ++++--------------------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    6 +-
 2 files changed, 17 insertions(+), 140 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 61b5d8c..d34d954 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -544,102 +544,6 @@ out_free_id_list:
 	return res;
 }
 
-static bool qlt_check_fcport_exist(struct scsi_qla_host *vha,
-	struct qla_tgt_sess *sess)
-{
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_port_24xx_data *pmap24;
-	bool res, found = false;
-	int rc, i;
-	uint16_t loop_id = 0xFFFF; /* to eliminate compiler's warning */
-	uint16_t entries;
-	void *pmap;
-	int pmap_len;
-	fc_port_t *fcport;
-	int global_resets;
-	unsigned long flags;
-
-retry:
-	global_resets = atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count);
-
-	rc = qla2x00_get_node_name_list(vha, &pmap, &pmap_len);
-	if (rc != QLA_SUCCESS) {
-		res = false;
-		goto out;
-	}
-
-	pmap24 = pmap;
-	entries = pmap_len/sizeof(*pmap24);
-
-	for (i = 0; i < entries; ++i) {
-		if (!memcmp(sess->port_name, pmap24[i].port_name, WWN_SIZE)) {
-			loop_id = le16_to_cpu(pmap24[i].loop_id);
-			found = true;
-			break;
-		}
-	}
-
-	kfree(pmap);
-
-	if (!found) {
-		res = false;
-		goto out;
-	}
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf046,
-	    "qlt_check_fcport_exist(): loop_id %d", loop_id);
-
-	fcport = kzalloc(sizeof(*fcport), GFP_KERNEL);
-	if (fcport == NULL) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf047,
-		    "qla_target(%d): Allocation of tmp FC port failed",
-		    vha->vp_idx);
-		res = false;
-		goto out;
-	}
-
-	fcport->loop_id = loop_id;
-
-	rc = qla2x00_get_port_database(vha, fcport, 0);
-	if (rc != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf048,
-		    "qla_target(%d): Failed to retrieve fcport "
-		    "information -- get_port_database() returned %x "
-		    "(loop_id=0x%04x)", vha->vp_idx, rc, loop_id);
-		res = false;
-		goto out_free_fcport;
-	}
-
-	if (global_resets !=
-	    atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count)) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf002,
-		    "qla_target(%d): global reset during session discovery"
-		    " (counter was %d, new %d), retrying",
-		    vha->vp_idx, global_resets,
-		    atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count));
-		goto retry;
-	}
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf003,
-	    "Updating sess %p s_id %x:%x:%x, loop_id %d) to d_id %x:%x:%x, "
-	    "loop_id %d", sess, sess->s_id.b.domain, sess->s_id.b.al_pa,
-	    sess->s_id.b.area, sess->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.al_pa, fcport->d_id.b.area, fcport->loop_id);
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
-				(fcport->flags & FCF_CONF_COMP_SUPPORTED));
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	res = true;
-
-out_free_fcport:
-	kfree(fcport);
-
-out:
-	return res;
-}
-
 /* ha->hardware_lock supposed to be held on entry */
 static void qlt_undelete_sess(struct qla_tgt_sess *sess)
 {
@@ -663,43 +567,13 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 		sess = list_entry(tgt->del_sess_list.next, typeof(*sess),
 		    del_list_entry);
 		if (time_after_eq(jiffies, sess->expires)) {
-			bool cancel;
-
 			qlt_undelete_sess(sess);
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			cancel = qlt_check_fcport_exist(vha, sess);
-
-			if (cancel) {
-				if (sess->deleted) {
-					/*
-					 * sess was again deleted while we were
-					 * discovering it
-					 */
-					spin_lock_irqsave(&ha->hardware_lock,
-					    flags);
-					continue;
-				}
-
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf049,
-				    "qla_target(%d): cancel deletion of "
-				    "session for port %02x:%02x:%02x:%02x:%02x:"
-				    "%02x:%02x:%02x (loop ID %d), because "
-				    " it isn't deleted by firmware",
-				    vha->vp_idx, sess->port_name[0],
-				    sess->port_name[1], sess->port_name[2],
-				    sess->port_name[3], sess->port_name[4],
-				    sess->port_name[5], sess->port_name[6],
-				    sess->port_name[7], sess->loop_id);
-			} else {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
-				    "Timeout: sess %p about to be deleted\n",
-				    sess);
-				ha->tgt.tgt_ops->shutdown_sess(sess);
-				ha->tgt.tgt_ops->put_sess(sess);
-			}
-
-			spin_lock_irqsave(&ha->hardware_lock, flags);
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
+			    "Timeout: sess %p about to be deleted\n",
+			    sess);
+			ha->tgt.tgt_ops->shutdown_sess(sess);
+			ha->tgt.tgt_ops->put_sess(sess);
 		} else {
 			schedule_delayed_work(&tgt->sess_del_work,
 			    jiffies - sess->expires);
@@ -884,9 +758,8 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		    sess->loop_id);
 		sess->local = 0;
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -2725,7 +2598,9 @@ static void qlt_do_work(struct work_struct *work)
 	/*
 	 * Drop extra session reference from qla_tgt_handle_cmd_for_atio*(
 	 */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return;
 
 out_term:
@@ -2737,9 +2612,9 @@ out_term:
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
 	kmem_cache_free(qla_tgt_cmd_cachep, cmd);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -4188,16 +4063,16 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	rc = __qlt_24xx_handle_abts(vha, &prm->abts, sess);
 	if (rc != 0)
 		goto out_term;
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return;
 
 out_term:
 	qlt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 static void qlt_tmr_work(struct qla_tgt *tgt,
@@ -4245,16 +4120,16 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	rc = qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
 	if (rc != 0)
 		goto out_term;
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return;
 
 out_term:
 	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 static void qlt_sess_work_fn(struct work_struct *work)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d182c96..2313f06 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -795,12 +795,14 @@ static void tcm_qla2xxx_put_session(struct se_session *se_sess)
 
 static void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
 {
-	tcm_qla2xxx_put_session(sess->se_sess);
+	assert_spin_locked(&sess->vha->hw->hardware_lock);
+	kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
 }
 
 static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
 {
-	tcm_qla2xxx_shutdown_session(sess->se_sess);
+	assert_spin_locked(&sess->vha->hw->hardware_lock);
+	target_sess_cmd_list_set_waiting(sess->se_sess);
 }
 
 static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
-- 
1.7.10.4

