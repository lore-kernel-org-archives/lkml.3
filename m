Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3FEVlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:41:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab3FEVgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>,
        Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 117/127] target: Re-instate sess_wait_list for target_wait_for_sess_cmds
Date: Wed,  5 Jun 2013 14:34:44 -0700
Message-Id: <20130605213231.292431421@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 9b31a328e344e62e7cc98ae574edcb7b674719bb upstream.

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

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   18 ++++++++++++++----
 include/target/target_core_base.h      |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -222,6 +222,7 @@ struct se_session *transport_init_sessio
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
+	INIT_LIST_HEAD(&se_sess->sess_wait_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	kref_init(&se_sess->sess_kref);
 
@@ -2252,11 +2253,14 @@ void target_sess_cmd_list_set_waiting(st
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
@@ -2273,9 +2277,10 @@ void target_wait_for_sess_cmds(
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
 	bool rc = false;
+	unsigned long flags;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_cmd_list, se_cmd_list) {
+				&se_sess->sess_wait_list, se_cmd_list) {
 		list_del(&se_cmd->se_cmd_list);
 
 		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
@@ -2303,6 +2308,11 @@ void target_wait_for_sess_cmds(
 
 		se_cmd->se_tfo->release_cmd(se_cmd);
 	}
+
+	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+	WARN_ON(!list_empty(&se_sess->sess_cmd_list));
+	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -544,6 +544,7 @@ struct se_session {
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
+	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
 };


