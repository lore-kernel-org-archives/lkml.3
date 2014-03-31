Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaCaXv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:51:27 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35520 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaXvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:51:25 -0400
Message-ID: <5339FF7B.4020904@gmail.com>
Date: Mon, 31 Mar 2014 16:51:23 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: [PATCH v2] pci: Allow hotplug service drivers to operate in polling
 mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today the PCIe port bus driver disables the Hot-plug service if the
port device does not have the capability to generate interrupts.
However, a user must be able to use the "pciehp_poll_mode" parameter
to use the pciehp in polling method in such a case. Today it is not
possible.

This patch allows a hotplug service driver to decide whether or not
it would like to continue in absense of interrupts.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v2: Drop the extra debug msg in pciehp
    (and just retain the changes in portdrv_core.c)

 drivers/pci/pcie/portdrv_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 0b6e766..ba31deb 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -377,10 +377,13 @@ int pcie_port_device_register(struct pci_dev *dev)
 	/*
 	 * Initialize service irqs. Don't use service devices that
 	 * require interrupts if there is no way to generate them.
+	 * However, some drivers may have a polling mode (e.g pciehp_poll_mode)
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

