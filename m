Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab3GCURG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:17:06 -0400
Received: from mxout1.idt.com ([157.165.5.25]:44988 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab3GCURE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:17:04 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>
Subject: [PATCH] rapidio: change endpoint device name format
Date: Wed,  3 Jul 2013 16:15:52 -0400
Message-Id: <1372882552-21746-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change endpoint device name format to use a component tag value instead of
device destination ID.

RapidIO specification defines a component tag to be a unique identifier
for devices in a network. RapidIO switches already use component tag as
part of their device name and also use it for device identification when
processing error management event notifications.

Forming an endpoint's device name using its component tag instead of destination ID
allows to keep sysfs device directories unchanged in case if a routing
process dynamically changes endpoint's destination ID as a result of route
optimization.

This change should not affect any existing users because a valid device
destination ID always should be obtained by reading "destid" attribute and
not by parsing device name.

This patch also removes switchid member from struct rio_switch because it
simply duplicates the component tag and does not have other use than in
device name generation.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
---
 drivers/rapidio/rio-scan.c |    5 ++---
 include/linux/rio.h        |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 0e86569..c744800 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -433,7 +433,6 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
 		rswitch = rdev->rswitch;
-		rswitch->switchid = rdev->comp_tag & RIO_CTAG_UDEVID;
 		rswitch->port_ok = 0;
 		spin_lock_init(&rswitch->lock);
 		rswitch->route_table = kzalloc(sizeof(u8)*
@@ -446,7 +445,7 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
-			     rswitch->switchid);
+			     rdev->comp_tag & RIO_CTAG_UDEVID);
 
 		if (do_enum)
 			rio_route_clr_table(rdev, RIO_GLOBAL_TABLE, 0);
@@ -459,7 +458,7 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 			rio_enable_rx_tx_port(port, 0, destid, hopcount, 0);
 
 		dev_set_name(&rdev->dev, "%02x:e:%04x", rdev->net->id,
-			     rdev->destid);
+			     rdev->comp_tag & RIO_CTAG_UDEVID);
 	}
 
 	rio_attach_device(rdev);
diff --git a/include/linux/rio.h b/include/linux/rio.h
index e2faf7b..b71d573 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -92,7 +92,6 @@ union rio_pw_msg;
 /**
  * struct rio_switch - RIO switch info
  * @node: Node in global list of switches
- * @switchid: Switch ID that is unique across a network
  * @route_table: Copy of switch routing table
  * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
  * @ops: pointer to switch-specific operations
@@ -101,7 +100,6 @@ union rio_pw_msg;
  */
 struct rio_switch {
 	struct list_head node;
-	u16 switchid;
 	u8 *route_table;
 	u32 port_ok;
 	struct rio_switch_ops *ops;
-- 
1.7.8.4

