Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab3GCSrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:47:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab3GCSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:04 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OWA8jfZRzJIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PqPlYQHtIA4A:10 a=z11f-joXAAAA:8 a=4K-K1uyHAAAA:8 a=VwQbUJbxAAAA:8 a=e0gVtgZ23HrhdBXb4dMA:9 a=CJVq-v20pXUA:10 a=wATGTE7Z8MQA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184054.356183920@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [059/141] target: Re-instate sess_wait_list for target_wait_for_sess_cmds
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0059-target-Re-instate-sess_wait_list-for-target_wait_for.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

[ Upstream commit 9b31a328e344e62e7cc98ae574edcb7b674719bb ]

Switch back to pre commit 1c7b13fe652 list splicing logic for active I/O
shutdown with tcm_qla2xxx + ib_srpt fabrics.

The original commit was done under the incorrect assumption that it's safe to
walk se_sess->sess_cmd_list unprotected in target_wait_for_sess_cmds() after
sess->sess_tearing_down = 1 has been set by target_sess_cmd_list_set_waiting()
during session shutdown.

So instead of adding sess->sess_cmd_lock protection around sess->sess_cmd_list
during target_wait_for_sess_cmds(), switch back to sess->sess_wait_list to
allow wait_for_completion() + TFO->release_cmd() to occur without having to
walk ->sess_cmd_list after the list_splice.

Also add a check to exit if target_sess_cmd_list_set_waiting() has already
been called, and add a WARN_ON to check for any fabric bug where new se_cmds
are added to sess->sess_cmd_list after sess->sess_tearing_down = 1 has already
been set.

Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/target_core_transport.c |   18 ++++++++++++++----
 include/target/target_core_base.h      |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 140bfb3..725ab56 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -232,6 +232,7 @@ struct se_session *transport_init_session(void)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
+	INIT_LIST_HEAD(&se_sess->sess_wait_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	kref_init(&se_sess->sess_kref);
 
@@ -2469,11 +2470,14 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 	unsigned long flags;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-
-	WARN_ON(se_sess->sess_tearing_down);
+	if (se_sess->sess_tearing_down) {
+		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		return;
+	}
 	se_sess->sess_tearing_down = 1;
+	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
 
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list)
+	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list)
 		se_cmd->cmd_wait_set = 1;
 
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
@@ -2490,9 +2494,10 @@ void target_wait_for_sess_cmds(
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
 	bool rc = false;
+	unsigned long flags;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_cmd_list, se_cmd_list) {
+				&se_sess->sess_wait_list, se_cmd_list) {
 		list_del(&se_cmd->se_cmd_list);
 
 		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
@@ -2520,6 +2525,11 @@ void target_wait_for_sess_cmds(
 
 		se_cmd->se_tfo->release_cmd(se_cmd);
 	}
+
+	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+	WARN_ON(!list_empty(&se_sess->sess_cmd_list));
+	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5be8937..71f7662 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -613,6 +613,7 @@ struct se_session {
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
+	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
 };
-- 
1.7.10.4


