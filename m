Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab3DYRPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:15:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34931 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3DYRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:15:15 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v2] mfd: vexpress: Handle pending config transactions
Date: Thu, 25 Apr 2013 18:14:51 +0100
Message-Id: <1366910091-17971-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
References: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 25 Apr 2013 17:15:03.0755 (UTC) FILETIME=[6CFC79B0:01CE41D8]
X-MC-Unique: 113042518150401101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r3PHFMIu029974

The config transactions "scheduler" was hopelessly broken,
repeating completed transaction instead of picking up
next pending one.

Fixed now. Also improved debug messages.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-config.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index 3c1723aa..84ce6b9 100644
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
@@ -212,25 +213,31 @@ void vexpress_config_complete(struct vexpress_config_bridge *bridge,
 {
 	struct vexpress_config_trans *trans;
 	unsigned long flags;
+	const char *message = "Completed";
 
 	spin_lock_irqsave(&bridge->transactions_lock, flags);
 
 	trans = list_first_entry(&bridge->transactions,
 			struct vexpress_config_trans, list);
-	vexpress_config_dump_trans("Completed", trans);
-
 	trans->status = status;
-	list_del(&trans->list);
 
-	if (!list_empty(&bridge->transactions)) {
-		vexpress_config_dump_trans("Pending", trans);
+	do {
+		vexpress_config_dump_trans(message, trans);
+		list_del(&trans->list);
+		complete(&trans->completion);
 
-		bridge->info->func_exec(trans->func->func, trans->offset,
-				trans->write, trans->data);
-	}
-	spin_unlock_irqrestore(&bridge->transactions_lock, flags);
+		if (list_empty(&bridge->transactions))
+			break;
+
+		trans = list_first_entry(&bridge->transactions,
+				struct vexpress_config_trans, list);
+		vexpress_config_dump_trans("Executing pending", trans);
+		trans->status = bridge->info->func_exec(trans->func->func,
+				trans->offset, trans->write, trans->data);
+		message = "Finished pending";
+	} while (trans->status == VEXPRESS_CONFIG_STATUS_DONE);
 
-	complete(&trans->completion);
+	spin_unlock_irqrestore(&bridge->transactions_lock, flags);
 }
 EXPORT_SYMBOL(vexpress_config_complete);
 
-- 
1.7.10.4


