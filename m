Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaCNQcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:32:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51138 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaCNQcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:32:09 -0400
Message-ID: <53232F01.8040209@gmail.com>
Date: Fri, 14 Mar 2014 09:32:01 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>,
        Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH] pci: Allow hotplug service drivers to operate in polling
 mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today the PCIe port bus driver disables the Hot-plug service if the
port device does not have the capability to generate interrupts.
However, drivers may have a polling method that can be used in this
case. In case of pciehp, user must be able to use the "pciehp_poll_mode"
parameter to use polling method in such a case. Today it is not
possible.

This patch allows a hotplug service driver to decide whether or not
it would like to continue in absense of interrupts. Also, the current
hotplug service driver (pciehp) is changed to check that either IRQs are
supported, or polling mode is to be used.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/hotplug/pciehp_hpc.c |    8 ++++++++
 drivers/pci/pcie/portdrv_core.c  |    5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 1463412..65fc1ef 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -86,6 +86,14 @@ static inline int pciehp_request_irq(struct controller *ctrl)
 		init_timer(&ctrl->poll_timer);
 		start_int_poll_timer(ctrl, 10);
 		return 0;
+	} else if (irq == -1) {
+		/*
+		 * Bail out if there is neither a way to generate
+		 * interrupts, nor polling is to be used.
+		 */
+		ctrl_err(ctrl,
+			 "No way to generate IRQ. Use pciehp_poll_mode\n");
+		return -1;
 	}
 
 	/* Installs the interrupt handler */
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 986f8ea..e92cd34 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -379,10 +379,13 @@ int pcie_port_device_register(struct pci_dev *dev)
 	/*
 	 * Initialize service irqs. Don't use service devices that
 	 * require interrupts if there is no way to generate them.
+	 * However, some drivers (e.g. pciehp) may have a polling mode
+	 * that can be used in absense of irqs. Allow them to determine
+	 * if that is to be used.
 	 */
 	status = init_service_irqs(dev, irqs, capabilities);
 	if (status) {
-		capabilities &= PCIE_PORT_SERVICE_VC;
+		capabilities &= PCIE_PORT_SERVICE_VC | PCIE_PORT_SERVICE_HP;
 		if (!capabilities)
 			goto error_disable;
 	}
-- 
1.7.9.5

