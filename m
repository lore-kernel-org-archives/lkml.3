Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3CXQcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:32:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54656 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3CXQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:32:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Mar 2013 17:32:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: remove unnecessary alloc/OOM messages
Message-ID: <20130324173200.1d34d7e2@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are redundant to log messages from the mm core.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c   |   24 +++++++++---------------
 drivers/firewire/core-device.c |    4 +---
 drivers/firewire/net.c         |    7 +------
 drivers/firewire/ohci.c        |    3 ---
 drivers/firewire/sbp2.c        |    4 +---
 5 files changed, 12 insertions(+), 30 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -389,10 +389,8 @@ static void queue_bus_reset_event(struct
 	struct bus_reset_event *e;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
-	if (e == NULL) {
-		fw_notice(client->device->card, "out of memory when allocating event\n");
+	if (e == NULL)
 		return;
-	}
 
 	fill_bus_reset_event(&e->reset, client);
 
@@ -692,10 +690,9 @@ static void handle_request(struct fw_car
 
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
-	if (r == NULL || e == NULL) {
-		fw_notice(card, "out of memory when allocating event\n");
+	if (r == NULL || e == NULL)
 		goto failed;
-	}
+
 	r->card    = card;
 	r->request = request;
 	r->data    = payload;
@@ -929,10 +926,9 @@ static void iso_callback(struct fw_iso_c
 	struct iso_interrupt_event *e;
 
 	e = kmalloc(sizeof(*e) + header_length, GFP_ATOMIC);
-	if (e == NULL) {
-		fw_notice(context->card, "out of memory when allocating event\n");
+	if (e == NULL)
 		return;
-	}
+
 	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
 	e->interrupt.closure   = client->iso_closure;
 	e->interrupt.cycle     = cycle;
@@ -949,10 +945,9 @@ static void iso_mc_callback(struct fw_is
 	struct iso_interrupt_mc_event *e;
 
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
-	if (e == NULL) {
-		fw_notice(context->card, "out of memory when allocating event\n");
+	if (e == NULL)
 		return;
-	}
+
 	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL;
 	e->interrupt.closure   = client->iso_closure;
 	e->interrupt.completed = fw_iso_buffer_lookup(&client->buffer,
@@ -1580,10 +1575,9 @@ void fw_cdev_handle_phy_packet(struct fw
 
 	list_for_each_entry(client, &card->phy_receiver_list, phy_receiver_link) {
 		e = kmalloc(sizeof(*e) + 8, GFP_ATOMIC);
-		if (e == NULL) {
-			fw_notice(card, "out of memory when allocating event\n");
+		if (e == NULL)
 			break;
-		}
+
 		e->phy_packet.closure	= client->phy_receiver_closure;
 		e->phy_packet.type	= FW_CDEV_EVENT_PHY_PACKET_RECEIVED;
 		e->phy_packet.rcode	= RCODE_COMPLETE;
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -692,10 +692,8 @@ static void create_units(struct fw_devic
 		 * match the drivers id_tables against it.
 		 */
 		unit = kzalloc(sizeof(*unit), GFP_KERNEL);
-		if (unit == NULL) {
-			fw_err(device->card, "out of memory for unit\n");
+		if (unit == NULL)
 			continue;
-		}
 
 		unit->directory = ci.p + value - 1;
 		unit->device.bus = &fw_bus_type;
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -368,10 +368,8 @@ static struct fwnet_fragment_info *fwnet
 	}
 
 	new = kmalloc(sizeof(*new), GFP_ATOMIC);
-	if (!new) {
-		dev_err(&pd->skb->dev->dev, "out of memory\n");
+	if (!new)
 		return NULL;
-	}
 
 	new->offset = offset;
 	new->len = len;
@@ -414,8 +412,6 @@ fail_w_fi:
 fail_w_new:
 	kfree(new);
 fail:
-	dev_err(&net->dev, "out of memory\n");
-
 	return NULL;
 }
 
@@ -692,7 +688,6 @@ static int fwnet_incoming_packet(struct
 
 		skb = dev_alloc_skb(len + LL_RESERVED_SPACE(net));
 		if (unlikely(!skb)) {
-			dev_err(&net->dev, "out of memory\n");
 			net->stats.rx_dropped++;
 
 			return -ENOMEM;
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3711,9 +3711,6 @@ static int pci_probe(struct pci_dev *dev
 	kfree(ohci);
 	pmac_ohci_off(dev);
  fail:
-	if (err == -ENOMEM)
-		dev_err(&dev->dev, "out of memory\n");
-
 	return err;
 }
 
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1475,10 +1475,8 @@ static int sbp2_scsi_queuecommand(struct
 	}
 
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
-	if (orb == NULL) {
-		dev_notice(lu_dev(lu), "failed to alloc ORB\n");
+	if (orb == NULL)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	}
 
 	/* Initialize rcode to something not RCODE_COMPLETE. */
 	orb->base.rcode = -1;


-- 
Stefan Richter
-=====-===-= --== ==---
http://arcgraph.de/sr/
