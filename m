Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaFCLl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaFCLl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcel Apfelbaum <marcel.a@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 083/138] PCI: shpchp: Check bridge's secondary (not primary) bus speed
Date: Tue,  3 Jun 2014 12:38:49 +0100
Message-Id: <1401795584-22664-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index 58499277903a..6efc2ec5e4db 100644
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

