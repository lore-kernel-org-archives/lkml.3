Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3EMV7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:59:07 -0400
Received: from longford.logfs.org ([213.229.74.203]:59178 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3EMV7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:59:02 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
Date: Mon, 13 May 2013 16:30:07 -0400
Message-Id: <1368477007-25274-4-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368477007-25274-1-git-send-email-joern@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter was always 0, leading to effectively dead code.  It
called list_del() and se_cmd->se_tfo->release_cmd(), and had to set a
flag to prevent target_release_cmd_kref() from doing the same.  But most
of all, it iterated the list without taking se_sess->sess_cmd_lock,
leading to races against ABORT and LUN_RESET.

Since the whole point of the function is to wait for the list to drain,
and potentially print a bit of debug information in case that never
happens, I've replaced the wait_for_completion() with 100ms sleep.  The
only callpath that would get delayed by this is rmmod, afaics, so I
didn't want the overhead of a waitqueue.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
 drivers/target/target_core_transport.c |   64 +++++++++-----------------------
 include/target/target_core_base.h      |    2 -
 include/target/target_core_fabric.h    |    2 +-
 5 files changed, 20 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c09d41b..c318f7c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2328,7 +2328,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	se_sess = ch->sess;
 	BUG_ON(!se_sess);
 
-	target_wait_for_sess_cmds(se_sess, 0);
+	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d182c96..7a3870f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1370,7 +1370,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 		dump_stack();
 		return;
 	}
-	target_wait_for_sess_cmds(se_sess, 0);
+	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(sess->se_sess);
 	transport_deregister_session(sess->se_sess);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0d46276..5b6dbf9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1043,7 +1043,6 @@ void transport_init_se_cmd(
 	init_completion(&cmd->transport_lun_fe_stop_comp);
 	init_completion(&cmd->transport_lun_stop_comp);
 	init_completion(&cmd->t_transport_stop_comp);
-	init_completion(&cmd->cmd_wait_comp);
 	init_completion(&cmd->task_stop_comp);
 	spin_lock_init(&cmd->t_state_lock);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
@@ -2219,11 +2218,6 @@ static void target_release_cmd_kref(struct kref *kref)
 		se_cmd->se_tfo->release_cmd(se_cmd);
 		return;
 	}
-	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
-		spin_unlock(&se_sess->sess_cmd_lock);
-		complete(&se_cmd->cmd_wait_comp);
-		return;
-	}
 	list_del(&se_cmd->se_cmd_list);
 	spin_unlock(&se_sess->sess_cmd_lock);
 
@@ -2241,68 +2235,44 @@ int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 }
 EXPORT_SYMBOL(target_put_sess_cmd);
 
-/* target_sess_cmd_list_set_waiting - Flag all commands in
- *         sess_cmd_list to complete cmd_wait_comp.  Set
+/* target_sess_cmd_list_set_waiting - Set
  *         sess_tearing_down so no more commands are queued.
  * @se_sess:	session to flag
  */
 void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 {
-	struct se_cmd *se_cmd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-
 	WARN_ON(se_sess->sess_tearing_down);
 	se_sess->sess_tearing_down = 1;
-
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list)
-		se_cmd->cmd_wait_set = 1;
-
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 }
 EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
 /* target_wait_for_sess_cmds - Wait for outstanding descriptors
  * @se_sess:    session to wait for active I/O
- * @wait_for_tasks:	Make extra transport_wait_for_tasks call
  */
-void target_wait_for_sess_cmds(
-	struct se_session *se_sess,
-	int wait_for_tasks)
+void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
-	struct se_cmd *se_cmd, *tmp_cmd;
-	bool rc = false;
-
-	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_cmd_list, se_cmd_list) {
-		list_del(&se_cmd->se_cmd_list);
-
-		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
-			" %d\n", se_cmd, se_cmd->t_state,
-			se_cmd->se_tfo->get_cmd_state(se_cmd));
-
-		if (wait_for_tasks) {
-			pr_debug("Calling transport_wait_for_tasks se_cmd: %p t_state: %d,"
-				" fabric state: %d\n", se_cmd, se_cmd->t_state,
-				se_cmd->se_tfo->get_cmd_state(se_cmd));
-
-			rc = transport_wait_for_tasks(se_cmd);
-
-			pr_debug("After transport_wait_for_tasks se_cmd: %p t_state: %d,"
-				" fabric state: %d\n", se_cmd, se_cmd->t_state,
-				se_cmd->se_tfo->get_cmd_state(se_cmd));
-		}
+	struct se_cmd *se_cmd, *last_cmd = NULL;
+	unsigned long flags;
 
-		if (!rc) {
-			wait_for_completion(&se_cmd->cmd_wait_comp);
-			pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
-				" fabric state: %d\n", se_cmd, se_cmd->t_state,
-				se_cmd->se_tfo->get_cmd_state(se_cmd));
+	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+	while (!list_empty(&se_sess->sess_cmd_list)) {
+		se_cmd = list_entry(se_sess->sess_cmd_list.next, struct se_cmd,
+			se_cmd_list);
+		if (se_cmd != last_cmd) { /* print this only once per command */
+			pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state: %d\n",
+					se_cmd, se_cmd->t_state,
+					se_cmd->se_tfo->get_cmd_state(se_cmd));
+			last_cmd = se_cmd;
 		}
-
-		se_cmd->se_tfo->release_cmd(se_cmd);
+		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		msleep_interruptible(100);
+		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	}
+	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 068ec0f..16d58b5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -426,7 +426,6 @@ struct se_cmd {
 	enum transport_state_table t_state;
 	/* Used to signal cmd->se_tfo->check_release_cmd() usage per cmd */
 	unsigned		check_release:1;
-	unsigned		cmd_wait_set:1;
 	unsigned		unknown_data_length:1;
 	/* See se_cmd_flags_table */
 	u32			se_cmd_flags;
@@ -449,7 +448,6 @@ struct se_cmd {
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	struct list_head	se_cmd_list;
-	struct completion	cmd_wait_comp;
 	struct kref		cmd_kref;
 	struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index aaa1ee6..57f8fb7 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -123,7 +123,7 @@ int	transport_send_check_condition_and_sense(struct se_cmd *,
 
 int	target_put_sess_cmd(struct se_session *, struct se_cmd *);
 void	target_sess_cmd_list_set_waiting(struct se_session *);
-void	target_wait_for_sess_cmds(struct se_session *, int);
+void	target_wait_for_sess_cmds(struct se_session *);
 
 int	core_alua_check_nonop_delay(struct se_cmd *);
 
-- 
1.7.10.4

