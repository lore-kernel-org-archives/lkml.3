Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3GWCjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:39:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:40386 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab3GWCjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:39:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="369445287"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: platform-driver-x86@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v1 3/3] ipc: Add support for default interrupt mode
Date: Mon, 22 Jul 2013 19:48:45 -0700
Message-Id: <871d1b965914d6c90e698aa67827854e748f18e1.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added intel scu ipc access mode config option.

Also, This patch adds support to enable ipc command interrupt
mode by default. This functionality is enabled by following
config option.

CONFIG_INTEL_SCU_IPC_INTR_MODE=y

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 drivers/platform/x86/Kconfig         |   15 ++++++++++
 drivers/platform/x86/intel_scu_ipc.c |   53 ++++++++++++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 36a9e60..26921ce 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -654,6 +654,21 @@ config INTEL_SCU_IPC
 	  some embedded Intel x86 platforms. This is not needed for PC-type
 	  machines.
 
+choice
+	prompt "IPC access mode"
+	depends on INTEL_SCU_IPC
+	default INTEL_SCU_IPC_INTR_MODE
+	---help---
+	Select the desired access mode for IPC call.
+
+config INTEL_SCU_IPC_INTR_MODE
+	bool "Intel SCU IPC interrupt mode"
+
+config INTEL_SCU_IPC_POLL_MODE
+	bool "Intel SCU IPC polling mode"
+
+endchoice
+
 config INTEL_SCU_IPC_UTIL
 	tristate "Intel SCU IPC utility driver"
 	depends on INTEL_SCU_IPC
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index aaaf1c1..6683ee0 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -60,6 +60,7 @@
 
 #define IPC_WWBUF_SIZE    20		/* IPC Write buffer Size */
 #define IPC_RWBUF_SIZE    20		/* IPC Read buffer Size */
+#define IPC_IOC	          0x100		/* IPC command register IOC bit */
 
 enum {
 	SCU_IPC_LINCROFT,
@@ -110,6 +111,9 @@ struct intel_scu_ipc_dev {
 	struct pci_dev *pdev;
 	void __iomem *ipc_base;
 	void __iomem *i2c_base;
+#ifdef CONFIG_INTEL_SCU_IPC_INTR_MODE
+	struct completion cmd_complete;
+#endif
 };
 
 static struct intel_scu_ipc_dev  ipcdev; /* Only one for now */
@@ -136,7 +140,12 @@ static DEFINE_MUTEX(ipclock); /* lock used to prevent multiple call to SCU */
  */
 static inline void ipc_command(u32 cmd) /* Send ipc command */
 {
+#ifdef CONFIG_INTEL_SCU_IPC_INTR_MODE
+	INIT_COMPLETION(ipcdev.cmd_complete);
+	writel(cmd | IPC_IOC, ipcdev.ipc_base);
+#else
 	writel(cmd, ipcdev.ipc_base);
+#endif
 }
 
 /*
@@ -194,6 +203,37 @@ static inline int busy_loop(void) /* Wait till scu status is busy */
 	return 0;
 }
 
+#ifdef CONFIG_INTEL_SCU_IPC_INTR_MODE
+/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+static inline int ipc_wait_for_interrupt(void)
+{
+	int status;
+	int ret = 0;
+
+	if (!wait_for_completion_timeout(&ipcdev.cmd_complete, 3 * HZ)) {
+		ret = -ETIMEDOUT;
+		goto end;
+	}
+
+	status = ipc_read_status();
+
+	if ((status >> 1) & 1)
+		ret = -EIO;
+
+end:
+	return ret;
+}
+#endif
+
+int intel_scu_ipc_check_status(void)
+{
+#ifdef CONFIG_INTEL_SCU_IPC_INTR_MODE
+	return ipc_wait_for_interrupt();
+#else
+	return busy_loop();
+#endif
+}
+
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 {
@@ -234,7 +274,7 @@ static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 		ipc_command(4 << 16 |  id << 12 | 0 << 8 | op);
 	}
 
-	err = busy_loop();
+	err = intel_scu_ipc_check_status();
 	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
 		/* Workaround: values are read as 0 without memcpy_fromio */
 		memcpy_fromio(cbuf, ipcdev.ipc_base + 0x90, 16);
@@ -429,7 +469,7 @@ int intel_scu_ipc_simple_command(int cmd, int sub)
 		return -ENODEV;
 	}
 	ipc_command(sub << 12 | cmd);
-	err = busy_loop();
+	err = intel_scu_ipc_check_status();
 	mutex_unlock(&ipclock);
 	return err;
 }
@@ -463,7 +503,7 @@ int intel_scu_ipc_command(int cmd, int sub, u32 *in, int inlen,
 		ipc_data_writel(*in++, 4 * i);
 
 	ipc_command((inlen << 16) | (sub << 12) | cmd);
-	err = busy_loop();
+	err = intel_scu_ipc_check_status();
 
 	for (i = 0; i < outlen; i++)
 		*out++ = ipc_data_readl(4 * i);
@@ -529,6 +569,9 @@ EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
  */
 static irqreturn_t ioc(int irq, void *dev_id)
 {
+#ifdef CONFIG_INTEL_SCU_IPC_INTR_MODE
+	complete(&ipcdev.cmd_complete);
+#endif
 	return IRQ_HANDLED;
 }
 
@@ -566,6 +609,10 @@ static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!pci_resource)
 		return -ENOMEM;
 
+#ifdef CONFIG_INTEL_SCU_IPC_INTR_MODE
+	init_completion(&ipcdev.cmd_complete);
+#endif
+
 	if (request_irq(dev->irq, ioc, 0, "intel_scu_ipc", &ipcdev))
 		return -EBUSY;
 
-- 
1.7.9.5

