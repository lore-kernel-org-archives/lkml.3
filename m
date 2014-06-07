Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaFGBoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:44:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35971 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bjorn Helgaas" <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Marcel Apfelbaum" <marcel.a@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.156824668@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 73/92] PCI: shpchp: Check bridge's secondary (not
 primary) bus speed
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -285,8 +285,8 @@ static int board_added(struct slot *p_sl
 		return WRONG_BUS_FREQUENCY;
 	}
 
-	bsp = ctrl->pci_dev->bus->cur_bus_speed;
-	msp = ctrl->pci_dev->bus->max_bus_speed;
+	bsp = ctrl->pci_dev->subordinate->cur_bus_speed;
+	msp = ctrl->pci_dev->subordinate->max_bus_speed;
 
 	/* Check if there are other slots or devices on the same bus */
 	if (!list_empty(&ctrl->pci_dev->subordinate->devices))

