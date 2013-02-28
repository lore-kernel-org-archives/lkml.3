Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab3B1PBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:01:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab3B1Ot6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/139] target: Fix lookup of dynamic NodeACLs during cached demo-mode operation
Date: Thu, 28 Feb 2013 14:44:10 +0000
Message-Id: <1362062689-2567-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_device.c          | 13 ++++---------
 drivers/target/target_core_fabric_configfs.c |  4 ++--
 drivers/target/target_core_internal.h        |  2 +-
 drivers/target/target_core_tpg.c             | 10 ++--------
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 0208baa..5dafeaa 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1415,24 +1415,18 @@ static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked
 
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
@@ -1443,7 +1437,8 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	INIT_LIST_HEAD(&lacl->lacl_list);
 	lacl->mapped_lun = mapped_lun;
 	lacl->se_lun_nacl = nacl;
-	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
+	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s",
+		 nacl->initiatorname);
 
 	return lacl;
 }
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 405cc98..040751b 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -351,8 +351,8 @@ static struct config_group *target_fabric_make_mappedlun(
 		goto out;
 	}
 
-	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
-			config_item_name(acl_ci), &ret);
+	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, se_nacl,
+			mapped_lun, &ret);
 	if (!lacl) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 165e824..e57190d 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -61,7 +61,7 @@ struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_hba *,
 int	core_dev_del_lun(struct se_portal_group *, u32);
 struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
-		u32, char *, int *);
+		struct se_node_acl *, u32, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun_acl *, u32, u32);
 int	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 8bd58e2..6eee53f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -114,16 +114,10 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
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
-- 
1.8.1.2

