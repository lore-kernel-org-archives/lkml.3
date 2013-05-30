Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab3E3URn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:17:43 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:55148 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722Ab3E3URi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:17:38 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 1/2] ahci: make ahci_transmit_led_message into a function pointer
Date: Thu, 30 May 2013 15:17:30 -0500
Message-Id: <1369945051-2582-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new ata_port_operations function pointer called
transmit_led_message and give it the default value of
ahci_transmit_led_message. This allows AHCI controllers with
non-standard LED interfaces to use the existing em_ interface.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 drivers/ata/libahci.c  | 11 ++++++-----
 include/linux/libata.h |  3 +++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 34c8216..0c36360 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -173,6 +173,7 @@ struct ata_port_operations ahci_ops = {
 	.em_store		= ahci_led_store,
 	.sw_activity_show	= ahci_activity_show,
 	.sw_activity_store	= ahci_activity_store,
+	.transmit_led_message	= ahci_transmit_led_message,
 #ifdef CONFIG_PM
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
@@ -774,7 +775,7 @@ static void ahci_start_port(struct ata_port *ap)
 
 			/* EM Transmit bit maybe busy during init */
 			for (i = 0; i < EM_MAX_RETRY; i++) {
-				rc = ahci_transmit_led_message(ap,
+				rc = ap->ops->transmit_led_message(ap,
 							       emp->led_state,
 							       4);
 				if (rc == -EBUSY)
@@ -915,7 +916,7 @@ static void ahci_sw_activity_blink(unsigned long arg)
 			led_message |= (1 << 16);
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
-	ahci_transmit_led_message(ap, led_message, 4);
+	ap->ops->transmit_led_message(ap, led_message, 4);
 }
 
 static void ahci_init_sw_activity(struct ata_link *link)
@@ -1044,7 +1045,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 	if (emp->blink_policy)
 		state &= ~EM_MSG_LED_VALUE_ACTIVITY;
 
-	return ahci_transmit_led_message(ap, state, size);
+	return ap->ops->transmit_led_message(ap, state, size);
 }
 
 static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
@@ -1063,7 +1064,7 @@ static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
 		/* set the LED to OFF */
 		port_led_state &= EM_MSG_LED_VALUE_OFF;
 		port_led_state |= (ap->port_no | (link->pmp << 8));
-		ahci_transmit_led_message(ap, port_led_state, 4);
+		ap->ops->transmit_led_message(ap, port_led_state, 4);
 	} else {
 		link->flags |= ATA_LFLAG_SW_ACTIVITY;
 		if (val == BLINK_OFF) {
@@ -1071,7 +1072,7 @@ static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
 			port_led_state &= EM_MSG_LED_VALUE_OFF;
 			port_led_state |= (ap->port_no | (link->pmp << 8));
 			port_led_state |= EM_MSG_LED_VALUE_ON; /* check this */
-			ahci_transmit_led_message(ap, port_led_state, 4);
+			ap->ops->transmit_led_message(ap, port_led_state, 4);
 		}
 	}
 	emp->blink_policy = val;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index eae7a05..1d09b65 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -908,6 +908,9 @@ struct ata_port_operations {
 	ssize_t (*sw_activity_show)(struct ata_device *dev, char *buf);
 	ssize_t (*sw_activity_store)(struct ata_device *dev,
 				     enum sw_activity val);
+	ssize_t (*transmit_led_message)(struct ata_port *ap, u32 state,
+					ssize_t size);
+
 	/*
 	 * Obsolete
 	 */
-- 
1.8.1.4

