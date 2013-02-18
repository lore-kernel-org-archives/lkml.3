Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3BRKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:09:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab3BRKJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:09:56 -0500
From: Hannes Reinecke <hare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Frederik Himpe <fhimpe@vub.ac.be>,
        Oliver Neukum <oneukum@suse.de>, David Haerdeman <david@hardeman.nu>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] pci: do not try to assign irq 255
Date: Mon, 18 Feb 2013 11:09:53 +0100
Message-Id: <1361182193-31894-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI config space reseves a byte for the interrupt line,
so irq 255 actually refers to 'not set'.
However, the 'irq' field for struct pci_dev is an integer,
so the original meaning is lost, causing the system to
assign an interrupt '255', which fails.

So we should _not_ assign an interrupt value here, and
allow upper layers to fixup things.

This patch make PCI devices with MSI interrupts only
(like the xhci device on certain HP laptops) work properly.

Cc: Frederik Himpe <fhimpe@vub.ac.be>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: David Haerdeman <david@hardeman.nu>
Cc: linux-usb@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6186f03..a2db887f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -923,7 +923,8 @@ static void pci_read_irq(struct pci_dev *dev)
 	dev->pin = irq;
 	if (irq)
 		pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
-	dev->irq = irq;
+	if (irq < 255)
+		dev->irq = irq;
 }
 
 void set_pcie_port_type(struct pci_dev *pdev)
