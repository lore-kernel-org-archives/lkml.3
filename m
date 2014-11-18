Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbaKROhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:37:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbaKROKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 113/206] target: Fix APTPL metadata handling for dynamic MappedLUNs
Date: Tue, 18 Nov 2014 15:07:48 +0100
Message-Id: <8bb710aed647d505da7434ff9c3162344e2ad309.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_device.c | 3 ++-
 drivers/target/target_core_pr.c     | 6 +++---
 drivers/target/target_core_pr.h     | 2 +-
 drivers/target/target_core_tpg.c    | 8 ++++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c7a3c5e2b1b3..a3ce91234b77 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1322,7 +1322,8 @@ int core_dev_add_initiator_node_lun_acl(
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
 	 */
-	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, lacl);
+	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, nacl,
+					    lacl->mapped_lun);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index dfe3db7942ea..a1e1ecdab86c 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -944,10 +944,10 @@ int core_scsi3_check_aptpl_registration(
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
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index ed75cdd32cb0..14a0a2e6f9c4 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -55,7 +55,7 @@ extern int core_scsi3_alloc_aptpl_registration(
 			unsigned char *, u16, u32, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
-			struct se_lun_acl *);
+			struct se_node_acl *, u32);
 extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
 					     struct se_node_acl *);
 extern void core_scsi3_free_all_registrations(struct se_device *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b9a6ec0aa5fe..d72583597427 100644
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
-- 
2.1.3

