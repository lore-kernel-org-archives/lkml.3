Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaFEEUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaFEEUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Apfelbaum <marcel.a@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 3.4 071/214] PCI: shpchp: Check bridges secondary (not primary) bus speed
Date: Wed,  4 Jun 2014 21:17:14 -0700
Message-Id: <20140605041649.083952082@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/shpchp_ctrl.c |    4 ++--
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


