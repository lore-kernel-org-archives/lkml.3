Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967474AbaFQWID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:08:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966956AbaFQVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcel Apfelbaum <marcel.a@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 126/212] PCI: shpchp: Check bridge's secondary (not primary) bus speed
Date: Tue, 17 Jun 2014 14:43:40 -0700
Message-Id: <1403041506-13646-127-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Apfelbaum <marcel.a@redhat.com>

commit 93fa9d32670f5592c8e56abc9928fc194e1e72fc upstream.

When a new device is added below a hotplug bridge, the bridge's secondary
bus speed and the device's bus speed must match.  The shpchp driver
previously checked the bridge's *primary* bus speed, not the secondary bus
speed.

This caused hot-add errors like:

  shpchp 0000:00:03.0: Speed of bus ff and adapter 0 mismatch

Check the secondary bus speed instead.

[bhelgaas: changelog]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=75251
Fixes: 3749c51ac6c1 ("PCI: Make current and maximum bus speeds part of the PCI core")
Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.9.1

