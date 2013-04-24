Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3DXQbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:31:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55032 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab3DXQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:31:41 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] mfd: vexpress: Handle pending config transactions
Date: Wed, 24 Apr 2013 17:31:24 +0100
Message-Id: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 24 Apr 2013 16:31:39.0910 (UTC) FILETIME=[328F8260:01CE4109]
X-MC-Unique: 113042417314000601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r3OGVkPU022187

The config transactions "scheduler" was hopelessly broken,
repeating completed transaction instead of picking up
next pending one.

Fixed now. Also improved debug messages.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-config.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index 3c1723aa..4991db3 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -184,13 +184,14 @@ static int vexpress_config_schedule(struct vexpress_config_trans *trans)
 
 	spin_lock_irqsave(&bridge->transactions_lock, flags);
 
-	vexpress_config_dump_trans("Executing", trans);
-
-	if (list_empty(&bridge->transactions))
+	if (list_empty(&bridge->transactions)) {
+		vexpress_config_dump_trans("Executing", trans);
 		status = bridge->info->func_exec(trans->func->func,
 				trans->offset, trans->write, trans->data);
-	else
+	} else {
+		vexpress_config_dump_trans("Queuing", trans);
 		status = VEXPRESS_CONFIG_STATUS_WAIT;
+	}
 
 	switch (status) {
 	case VEXPRESS_CONFIG_STATUS_DONE:
@@ -217,20 +218,28 @@ void vexpress_config_complete(struct vexpress_config_bridge *bridge,
 
 	trans = list_first_entry(&bridge->transactions,
 			struct vexpress_config_trans, list);
+	trans->status = status;
 	vexpress_config_dump_trans("Completed", trans);
 
-	trans->status = status;
 	list_del(&trans->list);
 
-	if (!list_empty(&bridge->transactions)) {
-		vexpress_config_dump_trans("Pending", trans);
+	complete(&trans->completion);
+
+	while (!list_empty(&bridge->transactions)) {
+		trans = list_first_entry(&bridge->transactions,
+				struct vexpress_config_trans, list);
 
-		bridge->info->func_exec(trans->func->func, trans->offset,
-				trans->write, trans->data);
+		vexpress_config_dump_trans("Executing pending", trans);
+		status = bridge->info->func_exec(trans->func->func,
+				trans->offset, trans->write, trans->data);
+
+		if (status == VEXPRESS_CONFIG_STATUS_DONE)
+			vexpress_config_dump_trans("Finished pending", trans);
+		else
+			break;
 	}
-	spin_unlock_irqrestore(&bridge->transactions_lock, flags);
 
-	complete(&trans->completion);
+	spin_unlock_irqrestore(&bridge->transactions_lock, flags);
 }
 EXPORT_SYMBOL(vexpress_config_complete);
 
-- 
1.7.10.4


