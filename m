Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaEAOfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:35:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaEAOfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:35:33 -0400
From: Marcel Apfelbaum <marcel.a@redhat.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com, matthew@wil.cx,
        mst@redhat.com, marcel.a@redhat.com
Subject: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
Date: Thu,  1 May 2014 17:35:48 +0300
Message-Id: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a board is added, the shpchp driver checks if there
is a mismatch between the bridge's adapter and the bus speed.
If there is, it sets the subordinate speed (if there is no device on it).

However, it takes the reference of the board speed from the primary bus
and not from the subordinate. If the primary bus is PCI and not PCIX/PCIe,
its speed is not updated and remains 0xff. As a result hotplug fails
with error: "Speed of bus ff and adapter 0 mismatch".

Fixed that by checking the speed against the subordinate bus.

Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index 5849927..6efc2ec 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -282,8 +282,8 @@ static int board_added(struct slot *p_slot)
 		return WRONG_BUS_FREQUENCY;
 	}
 
-	bsp = ctrl->pci_dev->bus->cur_bus_speed;
-	msp = ctrl->pci_dev->bus->max_bus_speed;
+	bsp = ctrl->pci_dev->subordinate->cur_bus_speed;
+	msp = ctrl->pci_dev->subordinate->max_bus_speed;
 
 	/* Check if there are other slots or devices on the same bus */
 	if (!list_empty(&ctrl->pci_dev->subordinate->devices))
-- 
1.8.3.1

