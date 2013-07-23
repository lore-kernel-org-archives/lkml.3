Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3GWCkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:40:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:23708 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3GWCjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:39:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="369445285"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: platform-driver-x86@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v1 1/3] ipc: Added platform data structure
Date: Mon, 22 Jul 2013 19:48:43 -0700
Message-Id: <49b9dc2bbbd9daeff74a9e0f0c00c72dad067f72.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the same ipc driver can be used by many platforms, using
macros for defining ipc_base and i2c_base addresses is not
a scalable approach. So added a platform data structure to pass
this information.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 drivers/platform/x86/intel_scu_ipc.c |   37 ++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 9215ed7..93c1b57 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -58,12 +58,29 @@
  *    message handler is called within firmware.
  */
 
-#define IPC_BASE_ADDR     0xFF11C000	/* IPC1 base register address */
-#define IPC_MAX_ADDR      0x100		/* Maximum IPC regisers */
 #define IPC_WWBUF_SIZE    20		/* IPC Write buffer Size */
 #define IPC_RWBUF_SIZE    20		/* IPC Read buffer Size */
-#define IPC_I2C_BASE      0xFF12B000	/* I2C control register base address */
-#define IPC_I2C_MAX_ADDR  0x10		/* Maximum I2C regisers */
+
+enum {
+	SCU_IPC_LINCROFT,
+};
+
+/* intel scu ipc driver data*/
+struct intel_scu_ipc_pdata_t {
+	u32 ipc_base;
+	u32 i2c_base;
+	u32 ipc_len;
+	u32 i2c_len;
+};
+
+static struct intel_scu_ipc_pdata_t intel_scu_ipc_pdata[] = {
+	[SCU_IPC_LINCROFT] = {
+		.ipc_base = 0xff11c000,
+		.i2c_base = 0xff12b000,
+		.ipc_len = 0x100,
+		.i2c_len = 0x10,
+	},
+};
 
 static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id);
 static void ipc_remove(struct pci_dev *pdev);
@@ -504,12 +521,16 @@ static irqreturn_t ioc(int irq, void *dev_id)
  */
 static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	int err;
+	int err, pid;
+	struct intel_scu_ipc_pdata_t *pdata;
 	resource_size_t pci_resource;
 
 	if (ipcdev.pdev)		/* We support only one SCU */
 		return -EBUSY;
 
+	pid = id->driver_data;
+	pdata = &intel_scu_ipc_pdata[pid];
+
 	ipcdev.pdev = pci_dev_get(dev);
 
 	err = pci_enable_device(dev);
@@ -527,11 +548,11 @@ static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (request_irq(dev->irq, ioc, 0, "intel_scu_ipc", &ipcdev))
 		return -EBUSY;
 
-	ipcdev.ipc_base = ioremap_nocache(IPC_BASE_ADDR, IPC_MAX_ADDR);
+	ipcdev.ipc_base = ioremap_nocache(pdata->ipc_base, pdata->ipc_len);
 	if (!ipcdev.ipc_base)
 		return -ENOMEM;
 
-	ipcdev.i2c_base = ioremap_nocache(IPC_I2C_BASE, IPC_I2C_MAX_ADDR);
+	ipcdev.i2c_base = ioremap_nocache(pdata->i2c_base, pdata->i2c_len);
 	if (!ipcdev.i2c_base) {
 		iounmap(ipcdev.ipc_base);
 		return -ENOMEM;
@@ -564,7 +585,7 @@ static void ipc_remove(struct pci_dev *pdev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x082a)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x082a), SCU_IPC_LINCROFT},
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
-- 
1.7.9.5

