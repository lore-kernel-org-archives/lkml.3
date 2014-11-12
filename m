Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966304AbaKLBwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:52:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966217AbaKLBwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:52:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 062/123] target: Fix APTPL metadata handling for dynamic MappedLUNs
Date: Wed, 12 Nov 2014 10:17:08 +0900
Message-Id: <20141112011721.835451247@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit e24805637d2d270d7975502e9024d473de86afdb upstream.

This patch fixes a bug in handling of SPC-3 PR Activate Persistence
across Target Power Loss (APTPL) logic where re-creation of state for
MappedLUNs from dynamically generated NodeACLs did not occur during
I_T Nexus establishment.

It adds the missing core_scsi3_check_aptpl_registration() call during
core_tpg_check_initiator_node_acl() -> core_tpg_add_node_to_devs() in
order to replay any pre-loaded APTPL metadata state associated with
the newly connected SCSI Initiator Port.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    3 ++-
 drivers/target/target_core_pr.c     |    6 +++---
 drivers/target/target_core_pr.h     |    2 +-
 drivers/target/target_core_tpg.c    |    8 ++++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1293,7 +1293,8 @@ int core_dev_add_initiator_node_lun_acl(
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
 	 */
-	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, lacl);
+	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, nacl,
+					    lacl->mapped_lun);
 	return 0;
 }
 
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -945,10 +945,10 @@ int core_scsi3_check_aptpl_registration(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
-	struct se_lun_acl *lun_acl)
+	struct se_node_acl *nacl,
+	u32 mapped_lun)
 {
-	struct se_node_acl *nacl = lun_acl->se_lun_nacl;
-	struct se_dev_entry *deve = nacl->device_list[lun_acl->mapped_lun];
+	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
 
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -55,7 +55,7 @@ extern int core_scsi3_alloc_aptpl_regist
 			unsigned char *, u16, u32, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
-			struct se_lun_acl *);
+			struct se_node_acl *, u32);
 extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
 					     struct se_node_acl *);
 extern void core_scsi3_free_all_registrations(struct se_device *);
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -40,6 +40,7 @@
 #include <target/target_core_fabric.h>
 
 #include "target_core_internal.h"
+#include "target_core_pr.h"
 
 extern struct se_device *g_lun0_dev;
 
@@ -165,6 +166,13 @@ void core_tpg_add_node_to_devs(
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
 				lun_access, acl, tpg);
+		/*
+		 * Check to see if there are any existing persistent reservation
+		 * APTPL pre-registrations that need to be enabled for this dynamic
+		 * LUN ACL now..
+		 */
+		core_scsi3_check_aptpl_registration(dev, tpg, lun, acl,
+						    lun->unpacked_lun);
 		spin_lock(&tpg->tpg_lun_lock);
 	}
 	spin_unlock(&tpg->tpg_lun_lock);


