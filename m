Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3CDD7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:59:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab3CDDoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:05 -0500
Message-Id: <20130304033714.677687576@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 072/153] target: Fix lookup of dynamic NodeACLs during cached demo-mode
 operation
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit fcf29481fb8e106daad6688f2e898226ee928992 upstream.

This patch fixes a bug in core_tpg_check_initiator_node_acl() ->
core_tpg_get_initiator_node_acl() where a dynamically created
se_node_acl generated during session login would be skipped during
subsequent lookup due to the '!acl->dynamic_node_acl' check, causing
a new se_node_acl to be created with a duplicate ->initiatorname.

This would occur when a fabric endpoint was configured with
TFO->tpg_check_demo_mode()=1 + TPF->tpg_check_demo_mode_cache()=1
preventing the release of an existing se_node_acl during se_session
shutdown.

Also, drop the unnecessary usage of core_tpg_get_initiator_node_acl()
within core_dev_init_initiator_node_lun_acl() that originally
required the extra '!acl->dynamic_node_acl' check, and just pass
the configfs provided se_node_acl pointer instead.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust context, filename of header]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1439,24 +1439,18 @@ static struct se_lun *core_dev_get_lun(s
 
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
+	struct se_node_acl *nacl,
 	u32 mapped_lun,
-	char *initiatorname,
 	int *ret)
 {
 	struct se_lun_acl *lacl;
-	struct se_node_acl *nacl;
 
-	if (strlen(initiatorname) >= TRANSPORT_IQN_LEN) {
+	if (strlen(nacl->initiatorname) >= TRANSPORT_IQN_LEN) {
 		pr_err("%s InitiatorName exceeds maximum size.\n",
 			tpg->se_tpg_tfo->get_fabric_name());
 		*ret = -EOVERFLOW;
 		return NULL;
 	}
-	nacl = core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if (!nacl) {
-		*ret = -EINVAL;
-		return NULL;
-	}
 	lacl = kzalloc(sizeof(struct se_lun_acl), GFP_KERNEL);
 	if (!lacl) {
 		pr_err("Unable to allocate memory for struct se_lun_acl.\n");
@@ -1467,7 +1461,8 @@ struct se_lun_acl *core_dev_init_initiat
 	INIT_LIST_HEAD(&lacl->lacl_list);
 	lacl->mapped_lun = mapped_lun;
 	lacl->se_lun_nacl = nacl;
-	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
+	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s",
+		 nacl->initiatorname);
 
 	return lacl;
 }
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -355,8 +355,8 @@ static struct config_group *target_fabri
 		goto out;
 	}
 
-	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
-			config_item_name(acl_ci), &ret);
+	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, se_nacl,
+			mapped_lun, &ret);
 	if (!lacl) {
 		ret = -EINVAL;
 		goto out;
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -50,7 +50,7 @@ extern struct se_lun *core_dev_add_lun(s
 extern int core_dev_del_lun(struct se_portal_group *, u32);
 extern struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 extern struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
-							u32, char *, int *);
+		struct se_node_acl *, u32, int *);
 extern int core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
 						struct se_lun_acl *, u32, u32);
 extern int core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -117,16 +117,10 @@ struct se_node_acl *core_tpg_get_initiat
 	struct se_node_acl *acl;
 
 	spin_lock_irq(&tpg->acl_node_lock);
-	list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
-		if (!strcmp(acl->initiatorname, initiatorname) &&
-		    !acl->dynamic_node_acl) {
-			spin_unlock_irq(&tpg->acl_node_lock);
-			return acl;
-		}
-	}
+	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
 	spin_unlock_irq(&tpg->acl_node_lock);
 
-	return NULL;
+	return acl;
 }
 
 /*	core_tpg_add_node_to_devs():


