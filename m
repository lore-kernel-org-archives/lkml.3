Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3ERAxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 20:53:25 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:45027 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3ERAxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 20:53:19 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Re-instate sess_wait_list for target_wait_for_sess_cmds
Date: Sat, 18 May 2013 00:40:30 +0000
Message-Id: <1368837631-2239-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
References: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   18 ++++++++++++++----
 include/target/target_core_base.h      |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 311c113..bbca144 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -221,6 +221,7 @@ struct se_session *transport_init_session(void)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
+	INIT_LIST_HEAD(&se_sess->sess_wait_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	kref_init(&se_sess->sess_kref);
 
@@ -2250,11 +2251,14 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
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
@@ -2267,9 +2271,10 @@ EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
+	unsigned long flags;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_cmd_list, se_cmd_list) {
+				&se_sess->sess_wait_list, se_cmd_list) {
 		list_del(&se_cmd->se_cmd_list);
 
 		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
@@ -2283,6 +2288,11 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 
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
index e773dfa..4ea4f98 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -543,6 +543,7 @@ struct se_session {
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
+	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
 };
-- 
1.7.2.5

