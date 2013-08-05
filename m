Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3HETiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab3HETiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:38:03 -0400
Subject: [PATCH v4 9/9] pci: Remove aer_do_secondary_bus_reset()
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, indou.takao@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 13:37:59 -0600
Message-ID: <20130805193759.9260.35576.stgit@bling.home>
In-Reply-To: <20130805193200.9260.38729.stgit@bling.home>
References: <20130805193200.9260.38729.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One PCI bus reset function to rule them all.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pcie/aer/aerdrv.c      |    2 +-
 drivers/pci/pcie/aer/aerdrv.h      |    1 -
 drivers/pci/pcie/aer/aerdrv_core.c |   35 +----------------------------------
 3 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 76ef634..0bf82a2 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -352,7 +352,7 @@ static pci_ers_result_t aer_root_reset(struct pci_dev *dev)
 	reg32 &= ~ROOT_PORT_INTR_ON_MESG_MASK;
 	pci_write_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, reg32);
 
-	aer_do_secondary_bus_reset(dev);
+	pci_reset_bridge_secondary_bus(dev);
 	dev_printk(KERN_DEBUG, &dev->dev, "Root Port link has been reset\n");
 
 	/* Clear Root Error Status */
diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index 90ea3e8..84420b7 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -106,7 +106,6 @@ static inline pci_ers_result_t merge_result(enum pci_ers_result orig,
 }
 
 extern struct bus_type pcie_port_bus_type;
-void aer_do_secondary_bus_reset(struct pci_dev *dev);
 int aer_init(struct pcie_device *dev);
 void aer_isr(struct work_struct *work);
 void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 8b68ae5..85ca36f 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -367,39 +367,6 @@ static pci_ers_result_t broadcast_error_message(struct pci_dev *dev,
 }
 
 /**
- * aer_do_secondary_bus_reset - perform secondary bus reset
- * @dev: pointer to bridge's pci_dev data structure
- *
- * Invoked when performing link reset at Root Port or Downstream Port.
- */
-void aer_do_secondary_bus_reset(struct pci_dev *dev)
-{
-	u16 p2p_ctrl;
-
-	/* Assert Secondary Bus Reset */
-	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &p2p_ctrl);
-	p2p_ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
-	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, p2p_ctrl);
-
-	/*
-	 * we should send hot reset message for 2ms to allow it time to
-	 * propagate to all downstream ports
-	 */
-	msleep(2);
-
-	/* De-assert Secondary Bus Reset */
-	p2p_ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
-	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, p2p_ctrl);
-
-	/*
-	 * System software must wait for at least 100ms from the end
-	 * of a reset of one or more device before it is permitted
-	 * to issue Configuration Requests to those devices.
-	 */
-	msleep(200);
-}
-
-/**
  * default_reset_link - default reset function
  * @dev: pointer to pci_dev data structure
  *
@@ -408,7 +375,7 @@ void aer_do_secondary_bus_reset(struct pci_dev *dev)
  */
 static pci_ers_result_t default_reset_link(struct pci_dev *dev)
 {
-	aer_do_secondary_bus_reset(dev);
+	pci_reset_bridge_secondary_bus(dev);
 	dev_printk(KERN_DEBUG, &dev->dev, "downstream link has been reset\n");
 	return PCI_ERS_RESULT_RECOVERED;
 }

