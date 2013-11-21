Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3KUBqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:46:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:33278 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3KUBqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:46:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438905121"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, eric.ernst@linux.intel.com
Subject: [PATCH v2.2] ipc: Added support for IPC interrupt mode
Date: Wed, 20 Nov 2013 17:45:33 -0800
Message-Id: <1384998333-141121-1-git-send-email-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384561314-11210-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384561314-11210-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ipc command interrupt mode.
Also added platform data option to select 'irq_mode'

irq_mode = 1: configure the driver to receive IOC interrupt
for each successful ipc_command.

irq_mode = 0: makes driver use polling method to
track the command completion status.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

v2.1 to v2.2:

 - Changed INIT_COMPLETION to reinit_completion.

---
 drivers/platform/x86/intel_scu_ipc.c |   48 +++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index e26830f..60ea476 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -60,6 +60,7 @@
 
 #define IPC_WWBUF_SIZE    20		/* IPC Write buffer Size */
 #define IPC_RWBUF_SIZE    20		/* IPC Read buffer Size */
+#define IPC_IOC	          0x100		/* IPC command register IOC bit */
 
 enum {
 	SCU_IPC_LINCROFT,
@@ -74,6 +75,7 @@ struct intel_scu_ipc_pdata_t {
 	u32 i2c_base;
 	u32 ipc_len;
 	u32 i2c_len;
+	u8 irq_mode;
 };
 
 static struct intel_scu_ipc_pdata_t intel_scu_ipc_pdata[] = {
@@ -82,24 +84,28 @@ static struct intel_scu_ipc_pdata_t intel_scu_ipc_pdata[] = {
 		.i2c_base = 0xff12b000,
 		.ipc_len = 0x100,
 		.i2c_len = 0x10,
+		.irq_mode = 0,
 	},
 	[SCU_IPC_PENWELL] = {
 		.ipc_base = 0xff11c000,
 		.i2c_base = 0xff12b000,
 		.ipc_len = 0x100,
 		.i2c_len = 0x10,
+		.irq_mode = 1,
 	},
 	[SCU_IPC_CLOVERVIEW] = {
 		.ipc_base = 0xff11c000,
 		.i2c_base = 0xff12b000,
 		.ipc_len = 0x100,
 		.i2c_len = 0x10,
+		.irq_mode = 1,
 	},
 	[SCU_IPC_TANGIER] = {
 		.ipc_base = 0xff009000,
 		.i2c_base  = 0xff00d000,
 		.ipc_len  = 0x100,
 		.i2c_len = 0x10,
+		.irq_mode = 0,
 	},
 };
 
@@ -110,6 +116,8 @@ struct intel_scu_ipc_dev {
 	struct pci_dev *pdev;
 	void __iomem *ipc_base;
 	void __iomem *i2c_base;
+	struct completion cmd_complete;
+	u8 irq_mode;
 };
 
 static struct intel_scu_ipc_dev  ipcdev; /* Only one for now */
@@ -136,6 +144,10 @@ static DEFINE_MUTEX(ipclock); /* lock used to prevent multiple call to SCU */
  */
 static inline void ipc_command(u32 cmd) /* Send ipc command */
 {
+	if (ipcdev.irq_mode) {
+		reinit_completion(&ipcdev.cmd_complete);
+		writel(cmd | IPC_IOC, ipcdev.ipc_base);
+	}
 	writel(cmd, ipcdev.ipc_base);
 }
 
@@ -194,6 +206,30 @@ static inline int busy_loop(void) /* Wait till scu status is busy */
 	return 0;
 }
 
+/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+static inline int ipc_wait_for_interrupt(void)
+{
+	int status;
+
+	if (!wait_for_completion_timeout(&ipcdev.cmd_complete, 3 * HZ)) {
+		struct device *dev = &ipcdev.pdev->dev;
+		dev_err(dev, "IPC timed out\n");
+		return -ETIMEDOUT;
+	}
+
+	status = ipc_read_status();
+
+	if ((status >> 1) & 1)
+		return -EIO;
+
+	return 0;
+}
+
+int intel_scu_ipc_check_status(void)
+{
+	return ipcdev.irq_mode ? ipc_wait_for_interrupt() : busy_loop();
+}
+
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 {
@@ -234,7 +270,7 @@ static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 		ipc_command(4 << 16 |  id << 12 | 0 << 8 | op);
 	}
 
-	err = busy_loop();
+	err = intel_scu_ipc_check_status();
 	if (!err && id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
 		/* Workaround: values are read as 0 without memcpy_fromio */
 		memcpy_fromio(cbuf, ipcdev.ipc_base + 0x90, 16);
@@ -429,7 +465,7 @@ int intel_scu_ipc_simple_command(int cmd, int sub)
 		return -ENODEV;
 	}
 	ipc_command(sub << 12 | cmd);
-	err = busy_loop();
+	err = intel_scu_ipc_check_status();
 	mutex_unlock(&ipclock);
 	return err;
 }
@@ -463,7 +499,7 @@ int intel_scu_ipc_command(int cmd, int sub, u32 *in, int inlen,
 		ipc_data_writel(*in++, 4 * i);
 
 	ipc_command((inlen << 16) | (sub << 12) | cmd);
-	err = busy_loop();
+	err = intel_scu_ipc_check_status();
 
 	if (!err) {
 		for (i = 0; i < outlen; i++)
@@ -531,6 +567,9 @@ EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
  */
 static irqreturn_t ioc(int irq, void *dev_id)
 {
+	if (ipcdev.irq_mode)
+		complete(&ipcdev.cmd_complete);
+
 	return IRQ_HANDLED;
 }
 
@@ -555,6 +594,7 @@ static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	pdata = &intel_scu_ipc_pdata[pid];
 
 	ipcdev.pdev = pci_dev_get(dev);
+	ipcdev.irq_mode = pdata->irq_mode;
 
 	err = pci_enable_device(dev);
 	if (err)
@@ -568,6 +608,8 @@ static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!pci_resource)
 		return -ENOMEM;
 
+	init_completion(&ipcdev.cmd_complete);
+
 	if (request_irq(dev->irq, ioc, 0, "intel_scu_ipc", &ipcdev))
 		return -EBUSY;
 
-- 
1.7.9.5

