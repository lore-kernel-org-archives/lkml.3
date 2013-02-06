Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3BFLZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:25:55 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36945 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3BFLZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:25:47 -0500
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, balbi@ti.com, Julia.Lawall@lip6.fr
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH] usb host: Faraday FUSBH200 HCD driver.
Date: Wed,  6 Feb 2013 19:24:01 +0800
Message-Id: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan-Hsin Chen <yhchen@faraday-tech.com>

USB2.0 HCD driver for Faraday FUSBH200

Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---
 drivers/usb/Makefile            |    2 +-
 drivers/usb/host/Kconfig        |    7 +
 drivers/usb/host/Makefile       |    2 +
 drivers/usb/host/fusbh200-hcd.c | 6830 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/fusbh200.h     |  907 ++++++
 5 files changed, 7747 insertions(+), 1 deletions(-)
 create mode 100644 drivers/usb/host/fusbh200-hcd.c
 create mode 100644 drivers/usb/host/fusbh200.h

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index f5ed3d7..a9f450a 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -3,7 +3,6 @@
 #
 
 # Object files in subdirectories
-
 obj-$(CONFIG_USB)		+= core/
 
 obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
@@ -27,6 +26,7 @@ obj-$(CONFIG_USB_HWA_HCD)	+= host/
 obj-$(CONFIG_USB_ISP1760_HCD)	+= host/
 obj-$(CONFIG_USB_IMX21_HCD)	+= host/
 obj-$(CONFIG_USB_FSL_MPH_DR_OF)	+= host/
+obj-$(CONFIG_USB_FUSBH200_HCD)	+= host/
 
 obj-$(CONFIG_USB_C67X00_HCD)	+= c67x00/
 
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3f1431d..7e72131 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -675,3 +675,10 @@ config USB_HCD_SSB
 	  for ehci and ohci.
 
 	  If unsure, say N.
+
+config USB_FUSBH200_HCD
+	tristate "Faraday FUSBH200 HCD support"
+	depends on USB
+	---help---
+	  The USB HCD Driver of Faraday FUSBH200 is designed to
+	  meet USB2.0 EHCI specification with minor modification
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 9e0a89c..404207e 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_USB_WHCI_HCD)	+= whci/
 obj-$(CONFIG_PCI)		+= pci-quirks.o
 
 obj-$(CONFIG_USB_EHCI_HCD)	+= ehci-hcd.o
+
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
@@ -43,3 +44,4 @@ obj-$(CONFIG_USB_OCTEON2_COMMON) += octeon2-common.o
 obj-$(CONFIG_MIPS_ALCHEMY)	+= alchemy-common.o
 obj-$(CONFIG_USB_HCD_BCMA)	+= bcma-hcd.o
 obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
+obj-$(CONFIG_USB_FUSBH200_HCD)	+= fusbh200-hcd.o
diff --git a/drivers/usb/host/fusbh200-hcd.c b/drivers/usb/host/fusbh200-hcd.c
new file mode 100644
index 0000000..117c30a
--- /dev/null
+++ b/drivers/usb/host/fusbh200-hcd.c
@@ -0,0 +1,6830 @@
+/*
+ * Copyright (c) 2013 Yuan-Hsin Chen <yhchen@faraday-tech>
+ * Copyright (c) 2000-2004 by David Brownell
+ *
+ * This code is *strongly* based on EHCI-HCD code by David Brownell since
+ * fusbh200 is a quasi-EHCI compatible IP.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/ioport.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/timer.h>
+#include <linux/ktime.h>
+#include <linux/list.h>
+#include <linux/interrupt.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/moduleparam.h>
+#include <linux/dma-mapping.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/dmapool.h>
+#include <linux/slab.h>
+#include <linux/usb/ulpi.h>
+#include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
+#include <linux/timer.h>
+
+#include <asm/byteorder.h>
+#include <asm/irq.h>
+#include <asm/system.h>
+#include <asm/unaligned.h>
+
+/*
+ * EHCI hc_driver implementation ... experimental, incomplete.
+ * Based on the final 1.0 register interface specification.
+ *
+ * USB 2.0 shows up in upcoming www.pcmcia.org technology.
+ * First was PCMCIA, like ISA; then CardBus, which is PCI.
+ * Next comes "CardBay", using USB 2.0 signals.
+ *
+ * Contains additional contributions by Brad Hards, Rory Bolt, and others.
+ * Special thanks to Intel and VIA for providing host controllers to
+ * test this driver on, and Cypress (including In-System Design) for
+ * providing early devices for those host controllers to talk to!
+ */
+
+#define DRIVER_AUTHOR "Yuan-Hsin Chen"
+#define DRIVER_DESC "Faraday Fusbh200 Host Controller (EHCI) Driver"
+static const char	hcd_name[] = "fusbh200_hcd";
+
+#undef VERBOSE_DEBUG
+#undef EHCI_URB_TRACE
+
+#ifdef DEBUG
+#define EHCI_STATS
+#endif
+
+/* magic numbers that can affect system performance */
+#define	EHCI_TUNE_CERR		3	/* 0-3 qtd retries; 0 == don't stop */
+#define	EHCI_TUNE_RL_HS		4	/* nak throttle; see 4.9 */
+#define	EHCI_TUNE_RL_TT		0
+#define	EHCI_TUNE_MULT_HS	1	/* 1-3 transactions/uframe; 4.10.3 */
+#define	EHCI_TUNE_MULT_TT	1
+/*
+ * Some drivers think it's safe to schedule isochronous transfers more than
+ * 256 ms into the future (partly as a result of an old bug in the scheduling
+ * code).  In an attempt to avoid trouble, we will use a minimum scheduling
+ * length of 512 frames instead of 256.
+ */
+#define	EHCI_TUNE_FLS		1	/* (medium) 512-frame schedule */
+#define EHCI_IAA_MSECS		10		/* arbitrary */
+#define EHCI_IO_JIFFIES		(HZ/10)		/* io watchdog > irq_thresh */
+#define EHCI_ASYNC_JIFFIES	0		/* async idle timeout */
+#define EHCI_SHRINK_JIFFIES	0
+						/* 5-ms async qh unlink delay */
+
+/* Initial IRQ latency:  faster than hw default */
+static int log2_irq_thresh;/* 0 to 6 */
+module_param(log2_irq_thresh, int, S_IRUGO);
+MODULE_PARM_DESC(log2_irq_thresh, "log2 IRQ latency, 1-64 microframes");
+
+/* initial park setting:  slower than hw default */
+static unsigned park;
+module_param(park, uint, S_IRUGO);
+MODULE_PARM_DESC(park, "park setting; 1-3 back-to-back async packets");
+
+/* for flakey hardware, ignore overcurrent indicators */
+static bool ignore_oc;
+module_param(ignore_oc, bool, S_IRUGO);
+MODULE_PARM_DESC(ignore_oc, "ignore bogus hardware overcurrent indications");
+
+#define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
+
+#include "fusbh200.h"
+
+#define ehci_dbg(ehci, fmt, args...) \
+	dev_dbg(ehci_to_hcd(ehci)->self.controller , fmt , ## args)
+#define ehci_err(ehci, fmt, args...) \
+	dev_err(ehci_to_hcd(ehci)->self.controller , fmt , ## args)
+#define ehci_info(ehci, fmt, args...) \
+	dev_info(ehci_to_hcd(ehci)->self.controller , fmt , ## args)
+#define ehci_warn(ehci, fmt, args...) \
+	dev_warn(ehci_to_hcd(ehci)->self.controller , fmt , ## args)
+
+#ifdef VERBOSE_DEBUG
+#define ehci_vdbg ehci_dbg
+#else
+static inline void ehci_vdbg(struct ehci_hcd *ehci, ...) {}
+#endif
+
+#ifdef DEBUG
+/* check the values in the HCSPARAMS register
+ * (host controller _Structural_ parameters)
+ * see EHCI spec, Table 2-4 for each value
+ */
+static void dbg_hcs_params(struct ehci_hcd *ehci, char *label)
+{
+	u32	params = ehci_readl(ehci, &ehci->caps->hcs_params);
+
+	ehci_dbg(ehci,
+		"%s hcs_params 0x%x dbg=%d%s cc=%d pcc=%d%s%s ports=%d\n",
+		label, params,
+		HCS_DEBUG_PORT(params),
+		HCS_INDICATOR(params) ? " ind" : "",
+		HCS_N_CC(params),
+		HCS_N_PCC(params),
+		HCS_PORTROUTED(params) ? "" : " ordered",
+		HCS_PPC(params) ? "" : " !ppc",
+		HCS_N_PORTS(params)
+		);
+	/* Port routing, per EHCI 0.95 Spec, Section 2.2.5 */
+	if (HCS_PORTROUTED(params)) {
+		int i;
+		char buf[46], tmp[7], byte;
+
+		buf[0] = 0;
+		for (i = 0; i < HCS_N_PORTS(params); i++) {
+			/* FIXME MIPS won't readb() ...*/
+			byte = readb(&ehci->caps->portroute[(i>>1)]);
+			sprintf(tmp, "%d ",
+				((i & 0x1) ? ((byte)&0xf) : ((byte>>4)&0xf)));
+			strcat(buf, tmp);
+		}
+		ehci_dbg(ehci, "%s portroute %s\n",
+				label, buf);
+	}
+}
+
+/* check the values in the HCCPARAMS register
+ * (host controller _Capability_ parameters)
+ * see EHCI Spec, Table 2-5 for each value
+ * */
+static void dbg_hcc_params(struct ehci_hcd *ehci, char *label)
+{
+	u32	params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
+	if (HCC_ISOC_CACHE(params)) {
+		ehci_dbg(ehci,
+			"%s hcc_params %04x caching frame %s%s%s\n",
+			label, params,
+			HCC_PGM_FRAMELISTLEN(params) ? "256/512/1024" : "1024",
+			HCC_CANPARK(params) ? " park" : "",
+			HCC_64BIT_ADDR(params) ? " 64 bit addr" : "");
+	} else {
+		ehci_dbg(ehci,
+			"%s hcc_params %04x thresh %d uframes %s%s%s\n",
+			label,
+			params,
+			HCC_ISOC_THRES(params),
+			HCC_PGM_FRAMELISTLEN(params) ? "256/512/1024" : "1024",
+			HCC_CANPARK(params) ? " park" : "",
+			HCC_64BIT_ADDR(params) ? " 64 bit addr" : "");
+	}
+}
+
+static void __maybe_unused
+dbg_qtd(const char *label, struct ehci_hcd *ehci, struct ehci_qtd *qtd)
+{
+	ehci_dbg(ehci, "%s td %p n%08x %08x t%08x p0=%08x\n", label, qtd,
+		hc32_to_cpup(ehci, &qtd->hw_next),
+		hc32_to_cpup(ehci, &qtd->hw_alt_next),
+		hc32_to_cpup(ehci, &qtd->hw_token),
+		hc32_to_cpup(ehci, &qtd->hw_buf[0]));
+	if (qtd->hw_buf[1])
+		ehci_dbg(ehci, "  p1=%08x p2=%08x p3=%08x p4=%08x\n",
+			hc32_to_cpup(ehci, &qtd->hw_buf[1]),
+			hc32_to_cpup(ehci, &qtd->hw_buf[2]),
+			hc32_to_cpup(ehci, &qtd->hw_buf[3]),
+			hc32_to_cpup(ehci, &qtd->hw_buf[4]));
+}
+
+static void __maybe_unused
+dbg_qh(const char *label, struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	struct ehci_qh_hw *hw = qh->hw;
+
+	ehci_dbg(ehci, "%s qh %p n%08x info %x %x qtd %x\n", label,
+		qh, hw->hw_next, hw->hw_info1, hw->hw_info2, hw->hw_current);
+	dbg_qtd("overlay", ehci, (struct ehci_qtd *) &hw->hw_qtd_next);
+}
+
+static int __maybe_unused
+dbg_status_buf(char *buf, unsigned len, const char *label, u32 status)
+{
+	return scnprintf(buf, len,
+		"%s%sstatus %04x%s%s%s%s%s%s%s%s%s%s",
+		label, label[0] ? " " : "", status,
+		(status & STS_ASS) ? " Async" : "",
+		(status & STS_PSS) ? " Periodic" : "",
+		(status & STS_RECL) ? " Recl" : "",
+		(status & STS_HALT) ? " Halt" : "",
+		(status & STS_IAA) ? " IAA" : "",
+		(status & STS_FATAL) ? " FATAL" : "",
+		(status & STS_FLR) ? " FLR" : "",
+		(status & STS_PCD) ? " PCD" : "",
+		(status & STS_ERR) ? " ERR" : "",
+		(status & STS_INT) ? " INT" : ""
+		);
+}
+
+static int __maybe_unused
+dbg_intr_buf(char *buf, unsigned len, const char *label, u32 enable)
+{
+	return scnprintf(buf, len,
+		"%s%sintrenable %02x%s%s%s%s%s%s",
+		label, label[0] ? " " : "", enable,
+		(enable & STS_IAA) ? " IAA" : "",
+		(enable & STS_FATAL) ? " FATAL" : "",
+		(enable & STS_FLR) ? " FLR" : "",
+		(enable & STS_PCD) ? " PCD" : "",
+		(enable & STS_ERR) ? " ERR" : "",
+		(enable & STS_INT) ? " INT" : ""
+		);
+}
+
+static const char *const fls_strings[] = {"1024", "512", "256", "??"};
+
+static int
+dbg_command_buf(char *buf, unsigned len, const char *label, u32 command)
+{
+	return scnprintf(buf, len,
+		"%s%scommand %07x %s=%d ithresh=%d%s%s%s%s "
+		"period=%s%s %s",
+		label, label[0] ? " " : "", command,
+		(command & CMD_PARK) ? " park" : "(park)",
+		CMD_PARK_CNT(command),
+		(command >> 16) & 0x3f,
+		(command & CMD_LRESET) ? " LReset" : "",
+		(command & CMD_IAAD) ? " IAAD" : "",
+		(command & CMD_ASE) ? " Async" : "",
+		(command & CMD_PSE) ? " Periodic" : "",
+		fls_strings[(command >> 2) & 0x3],
+		(command & CMD_RESET) ? " Reset" : "",
+		(command & CMD_RUN) ? "RUN" : "HALT"
+		);
+}
+
+static void
+dbg_command_reg(struct ehci_hcd *ehci)
+{
+	u32 command = ehci_readl(ehci, &ehci->regs->command);
+	ehci_dbg(ehci, "command %07x %s=%d ithresh=%d%s%s%s%s period=%s%s %s\n",
+		command,
+		(command & CMD_PARK) ? " park" : "(park)",
+		CMD_PARK_CNT(command),
+		(command >> 16) & 0x3f,
+		(command & CMD_LRESET) ? " LReset" : "",
+		(command & CMD_IAAD) ? " IAAD" : "",
+		(command & CMD_ASE) ? " Async" : "",
+		(command & CMD_PSE) ? " Periodic" : "",
+		fls_strings[(command >> 2) & 0x3],
+		(command & CMD_RESET) ? " Reset" : "",
+		(command & CMD_RUN) ? "RUN" : "HALT"
+		);
+}
+
+static int
+dbg_port_buf(char *buf, unsigned len, const char *label, int port, u32 status)
+{
+	char	*sig;
+
+	/* signaling state */
+	switch (status & (3 << 10)) {
+	case 0 << 10:
+		sig = "se0"; break;
+	case 1 << 10:
+		sig = "k"; break;		/* low speed */
+	case 2 << 10:
+		sig = "j"; break;
+	default:
+		sig = "?"; break;
+	}
+
+	return scnprintf(buf, len,
+		"%s%sport:%d status %06x %d %s%s "
+		"sig=%s%s%s%s%s%s%s%s%s%s",
+		label, label[0] ? " " : "", port, status,
+		status>>25,/*device address */
+		(status & PORT_POWER) ? " POWER" : "",
+		(status & PORT_OWNER) ? " OWNER" : "",
+		sig,
+		(status & PORT_RESET) ? " RESET" : "",
+		(status & PORT_SUSPEND) ? " SUSPEND" : "",
+		(status & PORT_RESUME) ? " RESUME" : "",
+		(status & PORT_OCC) ? " OCC" : "",
+		(status & PORT_OC) ? " OC" : "",
+		(status & PORT_PEC) ? " PEC" : "",
+		(status & PORT_PE) ? " PE" : "",
+		(status & PORT_CSC) ? " CSC" : "",
+		(status & PORT_CONNECT) ? " CONNECT" : "");
+}
+
+static void
+dbg_itd(const char *label, struct ehci_hcd *ehci, struct ehci_itd *itd)
+{
+	ehci_dbg(ehci, "%s [%d] itd %p, next %08x, urb %p\n",
+		label, itd->frame, itd, hc32_to_cpu(ehci, itd->hw_next),
+		itd->urb);
+	ehci_dbg(ehci, "  trans: %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		hc32_to_cpu(ehci, itd->hw_transaction[0]),
+		hc32_to_cpu(ehci, itd->hw_transaction[1]),
+		hc32_to_cpu(ehci, itd->hw_transaction[2]),
+		hc32_to_cpu(ehci, itd->hw_transaction[3]),
+		hc32_to_cpu(ehci, itd->hw_transaction[4]),
+		hc32_to_cpu(ehci, itd->hw_transaction[5]),
+		hc32_to_cpu(ehci, itd->hw_transaction[6]),
+		hc32_to_cpu(ehci, itd->hw_transaction[7]));
+	ehci_dbg(ehci, "  buf:   %08x %08x %08x %08x %08x %08x %08x\n",
+		hc32_to_cpu(ehci, itd->hw_bufp[0]),
+		hc32_to_cpu(ehci, itd->hw_bufp[1]),
+		hc32_to_cpu(ehci, itd->hw_bufp[2]),
+		hc32_to_cpu(ehci, itd->hw_bufp[3]),
+		hc32_to_cpu(ehci, itd->hw_bufp[4]),
+		hc32_to_cpu(ehci, itd->hw_bufp[5]),
+		hc32_to_cpu(ehci, itd->hw_bufp[6]));
+	ehci_dbg(ehci, "  index: %d %d %d %d %d %d %d %d\n",
+		itd->index[0], itd->index[1], itd->index[2],
+		itd->index[3], itd->index[4], itd->index[5],
+		itd->index[6], itd->index[7]);
+}
+#else
+static inline void __maybe_unused
+dbg_qh (char *label, struct ehci_hcd *ehci, struct ehci_qh *qh)
+{}
+
+static inline int __maybe_unused
+dbg_status_buf (char *buf, unsigned len, const char *label, u32 status)
+{ return 0; }
+
+static inline int __maybe_unused
+dbg_command_buf (char *buf, unsigned len, const char *label, u32 command)
+{ return 0; }
+
+static inline int __maybe_unused
+dbg_intr_buf (char *buf, unsigned len, const char *label, u32 enable)
+{ return 0; }
+
+static inline int __maybe_unused
+dbg_port_buf (char *buf, unsigned len, const char *label, int port, u32 status)
+{ return 0; }
+
+static inline void dbg_hcs_params (struct ehci_hcd *ehci, char *label) {}
+
+static inline void dbg_hcc_params (struct ehci_hcd *ehci, char *label) {}
+
+#endif	/* DEBUG */
+
+/* functions have the "wrong" filename when they're output... */
+#define dbg_status(ehci, label, status) { \
+	char _buf[80]; \
+	dbg_status_buf(_buf, sizeof(_buf), label, status); \
+	ehci_dbg(ehci, "%s\n", _buf); \
+}
+
+#define dbg_cmd(ehci, label, command) { \
+	char _buf[80]; \
+	dbg_command_buf(_buf, sizeof(_buf), label, command); \
+	ehci_dbg(ehci, "%s\n", _buf); \
+}
+
+#define dbg_port(ehci, label, port, status) { \
+	char _buf[80]; \
+	dbg_port_buf(_buf, sizeof(_buf), label, port, status); \
+	ehci_dbg(ehci, "%s\n", _buf); \
+}
+
+#ifdef STUB_DEBUG_FILES
+
+static inline void create_debug_files(struct ehci_hcd *bus) { }
+static inline void remove_debug_files(struct ehci_hcd *bus) { }
+
+#else
+
+/* troubleshooting help: expose state in debugfs */
+
+static int debug_async_open(struct inode *, struct file *);
+static int debug_periodic_open(struct inode *, struct file *);
+static int debug_registers_open(struct inode *, struct file *);
+static int debug_async_open(struct inode *, struct file *);
+static ssize_t debug_output(struct file*, char __user*, size_t, loff_t*);
+static int debug_close(struct inode *, struct file *);
+
+static const struct file_operations debug_async_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_async_open,
+	.read		= debug_output,
+	.release	= debug_close,
+	.llseek		= default_llseek,
+};
+static const struct file_operations debug_periodic_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_periodic_open,
+	.read		= debug_output,
+	.release	= debug_close,
+	.llseek		= default_llseek,
+};
+static const struct file_operations debug_registers_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_registers_open,
+	.read		= debug_output,
+	.release	= debug_close,
+	.llseek		= default_llseek,
+};
+static struct dentry *ehci_debug_root;
+
+struct debug_buffer {
+	ssize_t (*fill_func)(struct debug_buffer *);	/* fill method */
+	struct usb_bus *bus;
+	struct mutex mutex;	/* protect filling of buffer */
+	size_t count;		/* number of characters filled into buffer */
+	char *output_buf;
+	size_t alloc_size;
+};
+
+#define speed_char(info1) ({ char tmp; \
+		switch (info1 & (3 << 12)) { \
+		case 0 << 12: \
+			tmp = 'f'; break; \
+		case 1 << 12: \
+			tmp = 'l'; break; \
+		case 2 << 12: \
+			tmp = 'h'; break; \
+		default: \
+			tmp = '?'; break; \
+		}; tmp; })
+
+static inline char token_mark(struct ehci_hcd *ehci, __hc32 token)
+{
+	__u32 v = hc32_to_cpu(ehci, token);
+
+	if (v & QTD_STS_ACTIVE)
+		return '*';
+	if (v & QTD_STS_HALT)
+		return '-';
+	if (!IS_SHORT_READ(v))
+		return ' ';
+	/* tries to advance through hw_alt_next */
+	return '/';
+}
+
+static void qh_lines(
+	struct ehci_hcd *ehci,
+	struct ehci_qh *qh,
+	char **nextp,
+	unsigned *sizep
+)
+{
+	u32			scratch;
+	u32			hw_curr;
+	struct list_head	*entry;
+	struct ehci_qtd		*td;
+	unsigned		temp;
+	unsigned		size = *sizep;
+	char			*next = *nextp;
+	char			mark;
+	__le32			list_end = EHCI_LIST_END(ehci);
+	struct ehci_qh_hw	*hw = qh->hw;
+
+	if (hw->hw_qtd_next == list_end)	/* NEC does this */
+		mark = '@';
+	else
+		mark = token_mark(ehci, hw->hw_token);
+	if (mark == '/') {	/* qh_alt_next controls qh advance? */
+		if ((hw->hw_alt_next & QTD_MASK(ehci))
+				== ehci->async->hw->hw_alt_next)
+			mark = '#';	/* blocked */
+		else if (hw->hw_alt_next == list_end)
+			mark = '.';	/* use hw_qtd_next */
+		/* else alt_next points to some other qtd */
+	}
+	scratch = hc32_to_cpup(ehci, &hw->hw_info1);
+	hw_curr = (mark == '*') ? hc32_to_cpup(ehci, &hw->hw_current) : 0;
+	temp = scnprintf(next, size,
+			"qh/%p dev%d %cs ep%d %08x %08x (%08x%c %s nak%d)",
+			qh, scratch & 0x007f,
+			speed_char(scratch),
+			(scratch >> 8) & 0x000f,
+			scratch, hc32_to_cpup(ehci, &hw->hw_info2),
+			hc32_to_cpup(ehci, &hw->hw_token), mark,
+			(cpu_to_hc32(ehci, QTD_TOGGLE) & hw->hw_token)
+				? "data1" : "data0",
+			(hc32_to_cpup(ehci, &hw->hw_alt_next) >> 1) & 0x0f);
+	size -= temp;
+	next += temp;
+
+	/* hc may be modifying the list as we read it ... */
+	list_for_each(entry, &qh->qtd_list) {
+		td = list_entry(entry, struct ehci_qtd, qtd_list);
+		scratch = hc32_to_cpup(ehci, &td->hw_token);
+		mark = ' ';
+		if (hw_curr == td->qtd_dma)
+			mark = '*';
+		else if (hw->hw_qtd_next == cpu_to_hc32(ehci, td->qtd_dma))
+			mark = '+';
+		else if (QTD_LENGTH(scratch)) {
+			if (td->hw_alt_next == ehci->async->hw->hw_alt_next)
+				mark = '#';
+			else if (td->hw_alt_next != list_end)
+				mark = '/';
+		}
+		temp = snprintf(next, size,
+				"\n\t%p%c%s len=%d %08x urb %p",
+				td, mark, ({ char *tmp;
+				 switch ((scratch>>8)&0x03) {
+				 case 0:
+					tmp = "out"; break;
+				 case 1:
+					tmp = "in"; break;
+				 case 2:
+					tmp = "setup"; break;
+				 default:
+					tmp = "?"; break;
+				 } tmp; }),
+				(scratch >> 16) & 0x7fff,
+				scratch,
+				td->urb);
+		if (size < temp)
+			temp = size;
+		size -= temp;
+		next += temp;
+		if (temp == size)
+			goto done;
+	}
+
+	temp = snprintf(next, size, "\n");
+	if (size < temp)
+		temp = size;
+	size -= temp;
+	next += temp;
+
+done:
+	*sizep = size;
+	*nextp = next;
+}
+
+static ssize_t fill_async_buffer(struct debug_buffer *buf)
+{
+	struct usb_hcd		*hcd;
+	struct ehci_hcd		*ehci;
+	unsigned long		flags;
+	unsigned		temp, size;
+	char			*next;
+	struct ehci_qh		*qh;
+
+	hcd = bus_to_hcd(buf->bus);
+	ehci = hcd_to_ehci(hcd);
+	next = buf->output_buf;
+	size = buf->alloc_size;
+
+	*next = 0;
+
+	/* dumps a snapshot of the async schedule.
+	 * usually empty except for long-term bulk reads, or head.
+	 * one QH per line, and TDs we know about
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
+	for (qh = ehci->async->qh_next.qh; size > 0 && qh; qh = qh->qh_next.qh)
+		qh_lines(ehci, qh, &next, &size);
+	if (ehci->reclaim && size > 0) {
+		temp = scnprintf(next, size, "\nreclaim =\n");
+		size -= temp;
+		next += temp;
+
+		for (qh = ehci->reclaim; size > 0 && qh; qh = qh->reclaim)
+			qh_lines(ehci, qh, &next, &size);
+	}
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+	return strlen(buf->output_buf);
+}
+
+#define DBG_SCHED_LIMIT 64
+static ssize_t fill_periodic_buffer(struct debug_buffer *buf)
+{
+	struct usb_hcd		*hcd;
+	struct ehci_hcd		*ehci;
+	unsigned long		flags;
+	union ehci_shadow	p, *seen;
+	unsigned		temp, size, seen_count;
+	char			*next;
+	unsigned		i;
+	__hc32			tag;
+
+	seen = kmalloc(DBG_SCHED_LIMIT * sizeof(*seen), GFP_ATOMIC);
+	if (!seen)
+		return 0;
+	seen_count = 0;
+
+	hcd = bus_to_hcd(buf->bus);
+	ehci = hcd_to_ehci(hcd);
+	next = buf->output_buf;
+	size = buf->alloc_size;
+
+	temp = scnprintf(next, size, "size = %d\n", ehci->periodic_size);
+	size -= temp;
+	next += temp;
+
+	/* dump a snapshot of the periodic schedule.
+	 * iso changes, interrupt usually doesn't.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
+	for (i = 0; i < ehci->periodic_size; i++) {
+		p = ehci->pshadow[i];
+		if (likely(!p.ptr))
+			continue;
+		tag = Q_NEXT_TYPE(ehci, ehci->periodic[i]);
+
+		temp = scnprintf(next, size, "%4d: ", i);
+		size -= temp;
+		next += temp;
+
+		do {
+			struct ehci_qh_hw *hw;
+
+			switch (hc32_to_cpu(ehci, tag)) {
+			case Q_TYPE_QH:
+				hw = p.qh->hw;
+				temp = scnprintf(next, size, " qh%d-%04x/%p",
+						p.qh->period,
+						hc32_to_cpup(ehci,
+							&hw->hw_info2)
+							/* uframe masks */
+							& (QH_CMASK | QH_SMASK),
+						p.qh);
+				size -= temp;
+				next += temp;
+				/* don't repeat what follows this qh */
+				for (temp = 0; temp < seen_count; temp++) {
+					if (seen[temp].ptr != p.ptr)
+						continue;
+					if (p.qh->qh_next.ptr) {
+						temp = scnprintf(next, size,
+							" ...");
+						size -= temp;
+						next += temp;
+					}
+					break;
+				}
+				/* show more info the first time around */
+				if (temp == seen_count) {
+					u32	scratch = hc32_to_cpup(ehci,
+							&hw->hw_info1);
+					struct ehci_qtd	*qtd;
+					char		*type = "";
+
+					/* count tds, get ep direction */
+					temp = 0;
+					list_for_each_entry(qtd,
+							&p.qh->qtd_list,
+							qtd_list) {
+						temp++;
+						switch (0x03 & (hc32_to_cpu(
+							ehci,
+							qtd->hw_token) >> 8)) {
+						case 0:
+							type = "out"; continue;
+						case 1:
+							type = "in"; continue;
+						}
+					}
+
+					temp = scnprintf(next, size,
+						"(%c%d ep%d%s "
+						"[%d/%d] q%d p%d)",
+						speed_char(scratch),
+						scratch & 0x007f,
+						(scratch >> 8) & 0x000f, type,
+						p.qh->usecs, p.qh->c_usecs,
+						temp,
+						0x7ff & (scratch >> 16));
+
+					if (seen_count < DBG_SCHED_LIMIT)
+						seen[seen_count++].qh = p.qh;
+				} else
+					temp = 0;
+				if (p.qh) {
+					tag = Q_NEXT_TYPE(ehci, hw->hw_next);
+					p = p.qh->qh_next;
+				}
+				break;
+			case Q_TYPE_FSTN:
+				temp = scnprintf(next, size,
+					" fstn-%8x/%p", p.fstn->hw_prev,
+					p.fstn);
+				tag = Q_NEXT_TYPE(ehci, p.fstn->hw_next);
+				p = p.fstn->fstn_next;
+				break;
+			case Q_TYPE_ITD:
+				temp = scnprintf(next, size,
+					" itd/%p", p.itd);
+				tag = Q_NEXT_TYPE(ehci, p.itd->hw_next);
+				p = p.itd->itd_next;
+				break;
+			case Q_TYPE_SITD:
+				temp = scnprintf(next, size,
+					" sitd%d-%04x/%p",
+					p.sitd->stream->interval,
+					hc32_to_cpup(ehci, &p.sitd->hw_uframe)
+						& 0x0000ffff,
+					p.sitd);
+				tag = Q_NEXT_TYPE(ehci, p.sitd->hw_next);
+				p = p.sitd->sitd_next;
+				break;
+			}
+			size -= temp;
+			next += temp;
+		} while (p.ptr);
+
+		temp = scnprintf(next, size, "\n");
+		size -= temp;
+		next += temp;
+	}
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	kfree(seen);
+
+	return buf->alloc_size - size;
+}
+
+#undef DBG_SCHED_LIMIT
+
+static const char *rh_state_string(struct ehci_hcd *ehci)
+{
+	switch (ehci->rh_state) {
+	case EHCI_RH_HALTED:
+		return "halted";
+	case EHCI_RH_SUSPENDED:
+		return "suspended";
+	case EHCI_RH_RUNNING:
+		return "running";
+	}
+	return "?";
+}
+
+static ssize_t fill_registers_buffer(struct debug_buffer *buf)
+{
+	struct usb_hcd		*hcd;
+	struct ehci_hcd		*ehci;
+	unsigned long		flags;
+	unsigned		temp, size, i;
+	char			*next, scratch[80];
+	static const char	fmt[] = "%*s\n";
+	static const char	label[] = "";
+
+	hcd = bus_to_hcd(buf->bus);
+	ehci = hcd_to_ehci(hcd);
+	next = buf->output_buf;
+	size = buf->alloc_size;
+
+	spin_lock_irqsave(&ehci->lock, flags);
+
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		size = scnprintf(next, size,
+			"bus %s, device %s\n"
+			"%s\n"
+			"SUSPENDED(no register access)\n",
+			hcd->self.controller->bus->name,
+			dev_name(hcd->self.controller),
+			hcd->product_desc);
+		goto done;
+	}
+
+	/* Capability Registers */
+	i = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	temp = scnprintf(next, size,
+		"bus %s, device %s\n"
+		"%s\n"
+		"EHCI %x.%02x, rh state %s\n",
+		hcd->self.controller->bus->name,
+		dev_name(hcd->self.controller),
+		hcd->product_desc,
+		i >> 8, i & 0x0ff, rh_state_string(ehci));
+	size -= temp;
+	next += temp;
+
+	/* FIXME interpret both types of params */
+	i = ehci_readl(ehci, &ehci->caps->hcs_params);
+	temp = scnprintf(next, size, "structural params 0x%08x\n", i);
+	size -= temp;
+	next += temp;
+
+	i = ehci_readl(ehci, &ehci->caps->hcc_params);
+	temp = scnprintf(next, size, "capability params 0x%08x\n", i);
+	size -= temp;
+	next += temp;
+
+	/* Operational Registers */
+	temp = dbg_status_buf(scratch, sizeof(scratch), label,
+			ehci_readl(ehci, &ehci->regs->status));
+	temp = scnprintf(next, size, fmt, temp, scratch);
+	size -= temp;
+	next += temp;
+
+	temp = dbg_command_buf(scratch, sizeof(scratch), label,
+			ehci_readl(ehci, &ehci->regs->command));
+	temp = scnprintf(next, size, fmt, temp, scratch);
+	size -= temp;
+	next += temp;
+
+	temp = dbg_intr_buf(scratch, sizeof(scratch), label,
+			ehci_readl(ehci, &ehci->regs->intr_enable));
+	temp = scnprintf(next, size, fmt, temp, scratch);
+	size -= temp;
+	next += temp;
+
+	temp = scnprintf(next, size, "uframe %04x\n",
+			ehci_read_frame_index(ehci));
+	size -= temp;
+	next += temp;
+
+	for (i = 1; i <= HCS_N_PORTS(ehci->hcs_params); i++) {
+		temp = dbg_port_buf(scratch, sizeof(scratch), label, i,
+				ehci_readl(ehci,
+					&ehci->regs->port_status[i - 1]));
+		temp = scnprintf(next, size, fmt, temp, scratch);
+		size -= temp;
+		next += temp;
+		if (i == HCS_DEBUG_PORT(ehci->hcs_params) && ehci->debug) {
+			temp = scnprintf(next, size,
+					"    debug control %08x\n",
+					ehci_readl(ehci,
+						&ehci->debug->control));
+			size -= temp;
+			next += temp;
+		}
+	}
+
+	if (ehci->reclaim) {
+		temp = scnprintf(next, size, "reclaim qh %p\n", ehci->reclaim);
+		size -= temp;
+		next += temp;
+	}
+
+#ifdef EHCI_STATS
+	temp = scnprintf(next, size,
+		"irq normal %ld err %ld reclaim %ld (lost %ld)\n",
+		ehci->stats.normal, ehci->stats.error, ehci->stats.reclaim,
+		ehci->stats.lost_iaa);
+	size -= temp;
+	next += temp;
+
+	temp = scnprintf(next, size, "complete %ld unlink %ld\n",
+		ehci->stats.complete, ehci->stats.unlink);
+	size -= temp;
+	next += temp;
+#endif
+
+done:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+	return buf->alloc_size - size;
+}
+
+static struct debug_buffer *alloc_buffer(struct usb_bus *bus,
+				ssize_t (*fill_func)(struct debug_buffer *))
+{
+	struct debug_buffer *buf;
+
+	buf = kzalloc(sizeof(struct debug_buffer), GFP_KERNEL);
+
+	if (buf) {
+		buf->bus = bus;
+		buf->fill_func = fill_func;
+		mutex_init(&buf->mutex);
+		buf->alloc_size = PAGE_SIZE;
+	}
+
+	return buf;
+}
+
+static int fill_buffer(struct debug_buffer *buf)
+{
+	int ret = 0;
+
+	if (!buf->output_buf)
+		buf->output_buf = vmalloc(buf->alloc_size);
+
+	if (!buf->output_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = buf->fill_func(buf);
+
+	if (ret >= 0) {
+		buf->count = ret;
+		ret = 0;
+	}
+
+out:
+	return ret;
+}
+
+static ssize_t debug_output(struct file *file, char __user *user_buf,
+			    size_t len, loff_t *offset)
+{
+	struct debug_buffer *buf = file->private_data;
+	int ret = 0;
+
+	mutex_lock(&buf->mutex);
+	if (buf->count == 0) {
+		ret = fill_buffer(buf);
+		if (ret != 0) {
+			mutex_unlock(&buf->mutex);
+			goto out;
+		}
+	}
+	mutex_unlock(&buf->mutex);
+
+	ret = simple_read_from_buffer(user_buf, len, offset,
+				      buf->output_buf, buf->count);
+
+out:
+	return ret;
+
+}
+
+static int debug_close(struct inode *inode, struct file *file)
+{
+	struct debug_buffer *buf = file->private_data;
+
+	if (buf) {
+		vfree(buf->output_buf);
+		kfree(buf);
+	}
+
+	return 0;
+}
+static int debug_async_open(struct inode *inode, struct file *file)
+{
+	file->private_data = alloc_buffer(inode->i_private, fill_async_buffer);
+
+	return file->private_data ? 0 : -ENOMEM;
+}
+
+static int debug_periodic_open(struct inode *inode, struct file *file)
+{
+	struct debug_buffer *buf;
+	buf = alloc_buffer(inode->i_private, fill_periodic_buffer);
+	if (!buf)
+		return -ENOMEM;
+
+	buf->alloc_size = (sizeof(void *) == 4 ? 6 : 8)*PAGE_SIZE;
+	file->private_data = buf;
+	return 0;
+}
+
+static int debug_registers_open(struct inode *inode, struct file *file)
+{
+	file->private_data = alloc_buffer(inode->i_private,
+					  fill_registers_buffer);
+
+	return file->private_data ? 0 : -ENOMEM;
+}
+
+static inline void create_debug_files(struct ehci_hcd *ehci)
+{
+	struct usb_bus *bus = &ehci_to_hcd(ehci)->self;
+
+	ehci->debug_dir = debugfs_create_dir(bus->bus_name, ehci_debug_root);
+	if (!ehci->debug_dir)
+		return;
+
+	if (!debugfs_create_file("async", S_IRUGO, ehci->debug_dir, bus,
+						&debug_async_fops))
+		goto file_error;
+
+	if (!debugfs_create_file("periodic", S_IRUGO, ehci->debug_dir, bus,
+						&debug_periodic_fops))
+		goto file_error;
+
+	if (!debugfs_create_file("registers", S_IRUGO, ehci->debug_dir, bus,
+						    &debug_registers_fops))
+		goto file_error;
+	return;
+
+file_error:
+	debugfs_remove_recursive(ehci->debug_dir);
+}
+
+static inline void remove_debug_files(struct ehci_hcd *ehci)
+{
+	debugfs_remove_recursive(ehci->debug_dir);
+}
+
+#endif /* STUB_DEBUG_FILES */
+
+static void
+timer_action(struct ehci_hcd *ehci, enum ehci_timer_action action)
+{
+	/* Don't override timeouts which shrink or (later) disable
+	 * the async ring; just the I/O watchdog.  Note that if a
+	 * SHRINK were pending, OFF would never be requested.
+	 */
+	if (timer_pending(&ehci->watchdog)
+			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
+				& ehci->actions))
+		return;
+
+	if (!test_and_set_bit(action, &ehci->actions)) {
+		unsigned long t;
+
+		switch (action) {
+		case TIMER_IO_WATCHDOG:
+			if (!ehci->need_io_watchdog)
+				return;
+			t = EHCI_IO_JIFFIES;
+			break;
+		case TIMER_ASYNC_OFF:
+			t = EHCI_ASYNC_JIFFIES;
+			break;
+		/* case TIMER_ASYNC_SHRINK: */
+		default:
+			t = EHCI_SHRINK_JIFFIES;
+			break;
+		}
+		mod_timer(&ehci->watchdog, t + jiffies);
+	}
+}
+
+/*
+ * handshake - spin reading hc until handshake completes or fails
+ * @ptr: address of hc register to be read
+ * @mask: bits to look at in result of read
+ * @done: value of those bits when handshake succeeds
+ * @usec: timeout in microseconds
+ *
+ * Returns negative errno, or zero on success
+ *
+ * Success happens when the "mask" bits have the specified value (hardware
+ * handshake done).  There are two failure modes:  "usec" have passed (major
+ * hardware flakeout), or the register reads as all-ones (hardware removed).
+ *
+ * That last failure should_only happen in cases like physical cardbus eject
+ * before driver shutdown. But it also seems to be caused by bugs in cardbus
+ * bridge shutdown:  shutting down the bridge before the devices using it.
+ */
+static int handshake(struct ehci_hcd *ehci, void __iomem *ptr,
+		      u32 mask, u32 done, int usec)
+{
+	u32	result;
+
+	do {
+		result = ehci_readl(ehci, ptr);
+		if (result == ~(u32)0)		/* card removed */
+			return -ENODEV;
+		result &= mask;
+		if (result == done)
+			return 0;
+		udelay(1);
+		usec--;
+	} while (usec > 0);
+	return -ETIMEDOUT;
+}
+
+/* check TDI/ARC silicon is in host mode */
+static int tdi_in_host_mode(struct ehci_hcd *ehci)
+{
+	u32 __iomem	*reg_ptr;
+	u32		tmp;
+
+	reg_ptr = (u32 __iomem *)(((u8 __iomem *)ehci->regs) + USBMODE);
+	tmp = ehci_readl(ehci, reg_ptr);
+	return (tmp & 3) == USBMODE_CM_HC;
+}
+
+/* force HC to halt state from unknown (EHCI spec section 2.3) */
+static int fusbh200_ehci_halt(struct ehci_hcd *ehci)
+{
+	u32	temp = ehci_readl(ehci, &ehci->regs->status);
+
+	/* disable any irqs left enabled by previous code */
+	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+
+	if (ehci_is_TDI(ehci) && tdi_in_host_mode(ehci) == 0)
+		return 0;
+
+	if ((temp & STS_HALT) != 0)
+		return 0;
+
+	temp = ehci_readl(ehci, &ehci->regs->command);
+	temp &= ~CMD_RUN;
+	ehci_writel(ehci, temp, &ehci->regs->command);
+	return handshake(ehci, &ehci->regs->status,
+			  STS_HALT, STS_HALT, 16 * 125);
+}
+
+static int handshake_for_broken_root_hub(struct ehci_hcd *ehci,
+					 void __iomem *ptr, u32 mask, u32 done,
+					 int usec)
+{
+	return -ETIMEDOUT;
+}
+
+static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
+				       u32 mask, u32 done, int usec)
+{
+	int error;
+
+	error = handshake(ehci, ptr, mask, done, usec);
+	if (error == -ETIMEDOUT)
+		error = handshake_for_broken_root_hub(ehci, ptr, mask, done,
+						      usec);
+
+	if (error) {
+		fusbh200_ehci_halt(ehci);
+		ehci->rh_state = EHCI_RH_HALTED;
+		ehci_err(ehci, "force halt; handshake %p %08x %08x -> %d\n",
+			ptr, mask, done, error);
+	}
+
+	return error;
+}
+
+/* put TDI/ARC silicon into EHCI mode */
+static void tdi_reset(struct ehci_hcd *ehci)
+{
+	u32 __iomem	*reg_ptr;
+	u32		tmp;
+
+	reg_ptr = (u32 __iomem *)(((u8 __iomem *)ehci->regs) + USBMODE);
+	tmp = ehci_readl(ehci, reg_ptr);
+	tmp |= USBMODE_CM_HC;
+	/* The default byte access to MMR space is LE after
+	 * controller reset. Set the required endian mode
+	 * for transfer buffers to match the host microprocessor
+	 */
+	if (ehci_big_endian_mmio(ehci))
+		tmp |= USBMODE_BE;
+	ehci_writel(ehci, tmp, reg_ptr);
+}
+
+/* reset a non-running (STS_HALT == 1) controller */
+static int ehci_reset(struct ehci_hcd *ehci)
+{
+	int	retval;
+	u32	command = ehci_readl(ehci, &ehci->regs->command);
+
+	/* If the EHCI debug controller is active, special care must be
+	 * taken before and after a host controller reset */
+	if (ehci->debug && !dbgp_reset_prep())
+		ehci->debug = NULL;
+
+	command |= CMD_RESET;
+	dbg_cmd(ehci, "reset", command);
+	ehci_writel(ehci, command, &ehci->regs->command);
+	ehci->rh_state = EHCI_RH_HALTED;
+	ehci->next_statechange = jiffies;
+	retval = handshake(ehci, &ehci->regs->command,
+			    CMD_RESET, 0, 250 * 1000);
+
+	if (ehci->has_hostpc) {
+		ehci_writel(ehci, USBMODE_EX_HC | USBMODE_EX_VBPS,
+			(u32 __iomem *)(((u8 *)ehci->regs) + USBMODE_EX));
+		ehci_writel(ehci, TXFIFO_DEFAULT,
+			(u32 __iomem *)(((u8 *)ehci->regs) + TXFILLTUNING));
+	}
+	if (retval)
+		return retval;
+
+	if (ehci_is_TDI(ehci))
+		tdi_reset(ehci);
+
+	if (ehci->debug)
+		dbgp_external_startup();
+
+	return retval;
+}
+
+/* idle the controller (from running) */
+static void ehci_quiesce(struct ehci_hcd *ehci)
+{
+	u32	temp;
+
+#ifdef DEBUG
+	if (ehci->rh_state != EHCI_RH_RUNNING)
+		BUG();
+#endif
+
+	/* wait for any schedule enables/disables to take effect */
+	temp = ehci_readl(ehci, &ehci->regs->command) << 10;
+	temp &= STS_ASS | STS_PSS;
+	if (handshake_on_error_set_halt(ehci, &ehci->regs->status,
+					STS_ASS | STS_PSS, temp, 16 * 125))
+		return;
+
+	/* then disable anything that's still active */
+	temp = ehci_readl(ehci, &ehci->regs->command);
+	temp &= ~(CMD_ASE | CMD_IAAD | CMD_PSE);
+	ehci_writel(ehci, temp, &ehci->regs->command);
+
+	/* hardware can take 16 microframes to turn off ... */
+	handshake_on_error_set_halt(ehci, &ehci->regs->status,
+				    STS_ASS | STS_PSS, 0, 16 * 125);
+}
+
+static void end_unlink_async(struct ehci_hcd *ehci);
+static void ehci_work(struct ehci_hcd *ehci);
+
+/*
+ * EHCI Root Hub ... the nonsharable stuff
+ *
+ * Registers don't need cpu_to_le32, that happens transparently
+ */
+
+#include <linux/usb/otg.h>
+
+#define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
+
+#ifdef	CONFIG_PM
+
+/* After a power loss, ports that were owned by the companion must be
+ * reset so that the companion can still own them.
+ */
+static void ehci_handover_companion_ports(struct ehci_hcd *ehci)
+{
+	u32 __iomem	*reg;
+	u32		status;
+	int		port;
+	__le32		buf;
+	struct usb_hcd	*hcd = ehci_to_hcd(ehci);
+
+	if (!ehci->owned_ports)
+		return;
+
+	/* Give the connections some time to appear */
+	msleep(20);
+
+	port = HCS_N_PORTS(ehci->hcs_params);
+	while (port--) {
+		if (test_bit(port, &ehci->owned_ports)) {
+			reg = &ehci->regs->port_status[port];
+			status = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
+
+			/* Port already owned by companion? */
+			if (status & PORT_OWNER)
+				clear_bit(port, &ehci->owned_ports);
+			else if (test_bit(port, &ehci->companion_ports))
+				ehci_writel(ehci, status & ~PORT_PE, reg);
+			else
+				fusbh200_ehci_hub_control(hcd, SetPortFeature,
+						USB_PORT_FEAT_RESET, port + 1,
+						NULL, 0);
+		}
+	}
+
+	if (!ehci->owned_ports)
+		return;
+	msleep(90);		/* Wait for resets to complete */
+
+	port = HCS_N_PORTS(ehci->hcs_params);
+	while (port--) {
+		if (test_bit(port, &ehci->owned_ports)) {
+			fusbh200_ehci_hub_control(hcd, GetPortStatus,
+					0, port + 1,
+					(char *) &buf, sizeof(buf));
+
+			/* The companion should now own the port,
+			 * but if something went wrong the port must not
+			 * remain enabled.
+			 */
+			reg = &ehci->regs->port_status[port];
+			status = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
+			if (status & PORT_OWNER)
+				ehci_writel(ehci, status | PORT_CSC, reg);
+			else {
+				ehci_dbg(ehci, "failed handover port %d: %x\n",
+						port + 1, status);
+				ehci_writel(ehci, status & ~PORT_PE, reg);
+			}
+		}
+	}
+
+	ehci->owned_ports = 0;
+}
+#else
+
+#define ehci_bus_suspend	NULL
+#define ehci_bus_resume		NULL
+
+#endif	/* CONFIG_PM */
+
+/*
+ * Sets the owner of a port
+ */
+static void set_owner(struct ehci_hcd *ehci, int portnum, int new_owner)
+{
+	u32 __iomem		*status_reg;
+	u32			port_status;
+	int			try;
+
+	status_reg = &ehci->regs->port_status[portnum];
+
+	/*
+	 * The controller won't set the OWNER bit if the port is
+	 * enabled, so this loop will sometimes require at least two
+	 * iterations: one to disable the port and one to set OWNER.
+	 */
+	for (try = 4; try > 0; --try) {
+		spin_lock_irq(&ehci->lock);
+		port_status = ehci_readl(ehci, status_reg);
+		if ((port_status & PORT_OWNER) == new_owner
+				|| (port_status & (PORT_OWNER | PORT_CONNECT))
+					== 0)
+			try = 0;
+		else {
+			port_status ^= PORT_OWNER;
+			port_status &= ~(PORT_PE | PORT_RWC_BITS);
+			ehci_writel(ehci, port_status, status_reg);
+		}
+		spin_unlock_irq(&ehci->lock);
+		if (try > 1)
+			msleep(5);
+	}
+}
+
+static int check_reset_complete(
+	struct ehci_hcd	*ehci,
+	int		index,
+	u32 __iomem	*status_reg,
+	int		port_status
+) {
+	if (!(port_status & PORT_CONNECT))
+		return port_status;
+
+	/* if reset finished and it's still not enabled -- handoff */
+	if (!(port_status & PORT_PE)) {
+
+		/* with integrated TT, there's nobody to hand it to! */
+		if (ehci_is_TDI(ehci)) {
+			ehci_dbg(ehci,
+				"Failed to enable port %d on root hub TT\n",
+				index+1);
+			return port_status;
+		}
+
+		ehci_dbg(ehci, "port %d full speed --> companion\n",
+			index + 1);
+
+		/* what happens if HCS_N_CC(params) == 0 ? */
+		port_status |= PORT_OWNER;
+		port_status &= ~PORT_RWC_BITS;
+		ehci_writel(ehci, port_status, status_reg);
+
+		/* ensure 440EPX ohci controller state is operational */
+		if (ehci->has_amcc_usb23)
+			set_ohci_hcfs(ehci, 1);
+	} else {
+		ehci_dbg(ehci, "port %d high speed\n", index + 1);
+		/* ensure 440EPx ohci controller state is suspended */
+		if (ehci->has_amcc_usb23)
+			set_ohci_hcfs(ehci, 0);
+	}
+
+	return port_status;
+}
+
+/*-------------------------------------------------------------------------*/
+/* build "status change" packet (one or two bytes) from HC registers */
+static int
+fusbh200_ehci_hub_status_data(struct usb_hcd *hcd, char *buf)
+{
+	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+	u32		temp, status = 0;
+	u32		mask;
+	int		ports, i, retval = 1;
+	unsigned long	flags;
+	u32		ppcd = 0;
+
+	/* if !USB_SUSPEND, root hub timers won't get shut down ... */
+	if (ehci->rh_state != EHCI_RH_RUNNING)
+		return 0;
+
+	/* init status to no-changes */
+	buf[0] = 0;
+	ports = HCS_N_PORTS(ehci->hcs_params);
+	if (ports > 7) {
+		buf[1] = 0;
+		retval++;
+	}
+
+	/* Some boards (mostly VIA?) report bogus overcurrent indications,
+	 * causing massive log spam unless we completely ignore them.  It
+	 * may be relevant that VIA VT8235 controllers, where PORT_POWER is
+	 * always set, seem to clear PORT_OCC and PORT_CSC when writing to
+	 * PORT_POWER; that's surprising, but maybe within-spec.
+	 */
+	if (!ignore_oc)
+		mask = PORT_CSC | PORT_PEC | PORT_OCC;
+	else
+		mask = PORT_CSC | PORT_PEC;
+	/* PORT_RESUME from hardware ~= PORT_STAT_C_SUSPEND */
+
+	/* no hub change reports (bit 0) for now (power, ...) */
+
+	/* port N changes (bit N)? */
+	spin_lock_irqsave(&ehci->lock, flags);
+
+	/* get per-port change detect bits */
+	if (ehci->has_ppcd)
+		ppcd = ehci_readl(ehci, &ehci->regs->status) >> 16;
+
+	for (i = 0; i < ports; i++) {
+		/* leverage per-port change bits feature */
+		if (ehci->has_ppcd && !(ppcd & (1 << i)))
+			continue;
+		temp = ehci_readl(ehci, &ehci->regs->port_status[i]);
+
+		/*
+		 * Return status information even for ports with OWNER set.
+		 * Otherwise khubd wouldn't see the disconnect event when a
+		 * high-speed device is switched over to the companion
+		 * controller by the user.
+		 */
+
+		if ((temp & mask) != 0 || test_bit(i, &ehci->port_c_suspend)
+				|| (ehci->reset_done[i] && time_after_eq(
+					jiffies, ehci->reset_done[i]))) {
+			if (i < 7)
+				buf[0] |= 1 << (i + 1);
+			else
+				buf[1] |= 1 << (i - 7);
+			status = STS_PCD;
+		}
+	}
+	/* FIXME autosuspend idle root hubs */
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	return status ? retval : 0;
+}
+
+static void
+fusbh200_ehci_hub_descriptor(
+	struct ehci_hcd			*ehci,
+	struct usb_hub_descriptor	*desc
+) {
+	int		ports = HCS_N_PORTS(ehci->hcs_params);
+	u16		temp;
+
+	desc->bDescriptorType = 0x29;
+	desc->bPwrOn2PwrGood = 10;	/* ehci 1.0, 2.3.9 says 20ms max */
+	desc->bHubContrCurrent = 0;
+
+	desc->bNbrPorts = ports;
+	temp = 1 + (ports / 8);
+	desc->bDescLength = 7 + 2 * temp;
+
+	/* two bitmaps:  ports removable, and usb 1.0 legacy PortPwrCtrlMask */
+	memset(&desc->u.hs.DeviceRemovable[0], 0, temp);
+	memset(&desc->u.hs.DeviceRemovable[temp], 0xff, temp);
+
+	temp = 0x0008;			/* per-port overcurrent reporting */
+	if (HCS_PPC(ehci->hcs_params))
+		temp |= 0x0001;		/* per-port power control */
+	else
+		temp |= 0x0002;		/* no power switching */
+	desc->wHubCharacteristics = cpu_to_le16(temp);
+}
+
+static int fusbh200_ehci_hub_control(
+	struct usb_hcd	*hcd,
+	u16		typeReq,
+	u16		wValue,
+	u16		wIndex,
+	char		*buf,
+	u16		wLength
+) {
+	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+	int		ports = HCS_N_PORTS(ehci->hcs_params);
+	u32 __iomem	*status_reg = &ehci->regs->port_status[
+				(wIndex & 0xff) - 1];
+	u32 __iomem	*hostpc_reg = NULL;
+	u32		temp, temp1, status;
+	unsigned long	flags;
+	int		retval = 0;
+	unsigned	selector;
+
+	/*
+	 * FIXME:  support SetPortFeatures USB_PORT_FEAT_INDICATOR.
+	 * HCS_INDICATOR may say we can change LEDs to off/amber/green.
+	 * (track current state ourselves) ... blink for diagnostics,
+	 * power, "this is the one", etc.  EHCI spec supports this.
+	 */
+
+	if (ehci->has_hostpc)
+		hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
+				+ HOSTPC0 + 4 * ((wIndex & 0xff) - 1));
+	spin_lock_irqsave(&ehci->lock, flags);
+	switch (typeReq) {
+	case ClearHubFeature:
+		switch (wValue) {
+		case C_HUB_LOCAL_POWER:
+		case C_HUB_OVER_CURRENT:
+			/* no hub-wide feature/status flags */
+			break;
+		default:
+			goto error;
+		}
+		break;
+	case ClearPortFeature:
+		if (!wIndex || wIndex > ports)
+			goto error;
+		wIndex--;
+		temp = ehci_readl(ehci, status_reg);
+
+		/*
+		 * Even if OWNER is set, so the port is owned by the
+		 * companion controller, khubd needs to be able to clear
+		 * the port-change status bits (especially
+		 * USB_PORT_STAT_C_CONNECTION).
+		 */
+
+		switch (wValue) {
+		case USB_PORT_FEAT_ENABLE:
+			ehci_writel(ehci, temp & ~PORT_PE, status_reg);
+			/* fusbh200 */
+			if (temp & PORT_RESET) {
+				u32 retval;
+
+				/* force reset to complete */
+				ehci_writel(ehci, temp &
+					~(PORT_RWC_BITS | PORT_RESET),
+					status_reg);
+				/* REVISIT:  some hardware needs 550+ usec
+				 * to clear this bit; seems too long to
+				 * spin routinely...
+				 */
+				retval = handshake(ehci, status_reg,
+						PORT_RESET, 0, 750);
+				if (retval != 0)
+					ehci_err(ehci, "port %d reset error %d\n",
+						wIndex + 1, retval);
+				else
+					ehci_err(ehci, "PORT_RESET with C_PORT_ENABLE done\n");
+			}
+			break;
+		case USB_PORT_FEAT_C_ENABLE:
+			ehci_writel(ehci, (temp & ~PORT_RWC_BITS) | PORT_PEC,
+					status_reg);
+			break;
+		case USB_PORT_FEAT_SUSPEND:
+			if (temp & PORT_RESET)
+				goto error;
+			if (ehci->no_selective_suspend)
+				break;
+#ifdef CONFIG_USB_OTG
+			if ((hcd->self.otg_port == (wIndex + 1))
+			    && hcd->self.b_hnp_enable) {
+				otg_start_hnp(ehci->transceiver);
+				break;
+			}
+#endif
+			if (!(temp & PORT_SUSPEND))
+				break;
+			if ((temp & PORT_PE) == 0)
+				goto error;
+
+			/* clear phy low-power mode before resume */
+			if (hostpc_reg) {
+				temp1 = ehci_readl(ehci, hostpc_reg);
+				ehci_writel(ehci, temp1 & ~HOSTPC_PHCD,
+						hostpc_reg);
+				spin_unlock_irqrestore(&ehci->lock, flags);
+				msleep(5);/* wait to leave low-power mode */
+				spin_lock_irqsave(&ehci->lock, flags);
+			}
+			/* resume signaling for 20 msec */
+			temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
+			ehci_writel(ehci, temp | PORT_RESUME, status_reg);
+			ehci->reset_done[wIndex] = jiffies
+					+ msecs_to_jiffies(20);
+			break;
+		case USB_PORT_FEAT_C_SUSPEND:
+			clear_bit(wIndex, &ehci->port_c_suspend);
+			break;
+		case USB_PORT_FEAT_POWER:
+			if (HCS_PPC(ehci->hcs_params))
+				ehci_writel(ehci,
+					  temp & ~(PORT_RWC_BITS | PORT_POWER),
+					  status_reg);
+			break;
+		case USB_PORT_FEAT_C_CONNECTION:
+			ehci_writel(ehci, (temp & ~PORT_RWC_BITS) | PORT_CSC,
+					status_reg);
+			break;
+		case USB_PORT_FEAT_C_OVER_CURRENT:
+			ehci_writel(ehci, (temp & ~PORT_RWC_BITS) | PORT_OCC,
+					status_reg);
+			break;
+		case USB_PORT_FEAT_C_RESET:
+			/* GetPortStatus clears reset */
+			break;
+		default:
+			goto error;
+		}
+		/* unblock posted write */
+		ehci_readl(ehci, &ehci->regs->command);
+		break;
+	case GetHubDescriptor:
+		fusbh200_ehci_hub_descriptor(ehci, (struct usb_hub_descriptor *)
+			buf);
+		break;
+	case GetHubStatus:
+		/* no hub-wide feature/status flags */
+		memset(buf, 0, 4);
+		break;
+	case GetPortStatus:
+		if (!wIndex || wIndex > ports)
+			goto error;
+		wIndex--;
+		status = 0;
+		temp = ehci_readl(ehci, status_reg);
+
+		/* wPortChange bits */
+		if (temp & PORT_CSC)
+			status |= USB_PORT_STAT_C_CONNECTION << 16;
+		if (temp & PORT_PEC)
+			status |= USB_PORT_STAT_C_ENABLE << 16;
+
+		if ((temp & PORT_OCC) && !ignore_oc) {
+			status |= USB_PORT_STAT_C_OVERCURRENT << 16;
+
+			/*
+			 * Hubs should disable port power on over-current.
+			 * However, not all EHCI implementations do this
+			 * automatically, even if they _do_ support per-port
+			 * power switching; they're allowed to just limit the
+			 * current.  khubd will turn the power back on.
+			 */
+			if ((temp & PORT_OC) && HCS_PPC(ehci->hcs_params)) {
+				ehci_writel(ehci,
+					temp & ~(PORT_RWC_BITS | PORT_POWER),
+					status_reg);
+				temp = ehci_readl(ehci, status_reg);
+			}
+		}
+
+		/* whoever resumes must GetPortStatus to complete it!! */
+		if (temp & PORT_RESUME) {
+
+			/* Remote Wakeup received? */
+			if (!ehci->reset_done[wIndex]) {
+				/* resume signaling for 20 msec */
+				ehci->reset_done[wIndex] = jiffies
+						+ msecs_to_jiffies(20);
+				/* check the port again */
+				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
+						ehci->reset_done[wIndex]);
+			}
+
+			/* resume completed? */
+			else if (time_after_eq(jiffies,
+					ehci->reset_done[wIndex])) {
+				clear_bit(wIndex, &ehci->suspended_ports);
+				set_bit(wIndex, &ehci->port_c_suspend);
+				ehci->reset_done[wIndex] = 0;
+
+				/* stop resume signaling */
+				temp = ehci_readl(ehci, status_reg);
+				ehci_writel(ehci,
+					temp & ~(PORT_RWC_BITS | PORT_RESUME),
+					status_reg);
+				retval = handshake(ehci, status_reg,
+					   PORT_RESUME, 0, 2000 /* 2msec */);
+				if (retval != 0) {
+					ehci_err(ehci,
+						"port %d resume error %d\n",
+						wIndex + 1, retval);
+					goto error;
+				}
+				temp &= ~(PORT_SUSPEND|PORT_RESUME|(3<<10));
+			}
+		}
+
+		/* whoever resets must GetPortStatus to complete it!! */
+		if ((temp & PORT_RESET)
+				&& time_after_eq(jiffies,
+					ehci->reset_done[wIndex])) {
+			status |= USB_PORT_STAT_C_RESET << 16;
+			ehci->reset_done[wIndex] = 0;
+
+			/* force reset to complete */
+			ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
+					status_reg);
+			/* REVISIT:  some hardware needs 550+ usec to clear
+			 * this bit; seems too long to spin routinely...
+			 */
+			retval = handshake(ehci, status_reg,
+					PORT_RESET, 0, 1000);
+			if (retval != 0) {
+				ehci_err(ehci, "port %d reset error %d\n",
+					wIndex + 1, retval);
+				goto error;
+			}
+
+			/* see what we found out */
+			temp = check_reset_complete(ehci, wIndex, status_reg,
+					ehci_readl(ehci, status_reg));
+			/* fusbh200 */
+			writel(readl(&ehci->regs->command) |
+				CMD_RUN, &ehci->regs->command);
+			while ((readl(&ehci->regs->status) & STS_HALT))
+				;
+		}
+
+		if (!(temp & (PORT_RESUME|PORT_RESET)))
+			ehci->reset_done[wIndex] = 0;
+
+		/* transfer dedicated ports to the companion hc */
+		if ((temp & PORT_CONNECT) &&
+				test_bit(wIndex, &ehci->companion_ports)) {
+			temp &= ~PORT_RWC_BITS;
+			temp |= PORT_OWNER;
+			ehci_writel(ehci, temp, status_reg);
+			ehci_dbg(ehci, "port %d --> companion\n", wIndex + 1);
+			temp = ehci_readl(ehci, status_reg);
+		}
+
+		/*
+		 * Even if OWNER is set, there's no harm letting khubd
+		 * see the wPortStatus values (they should all be 0 except
+		 * for PORT_POWER anyway).
+		 */
+
+		if (temp & PORT_CONNECT) {
+			status |= USB_PORT_STAT_CONNECTION;
+			/* status may be from integrated TT */
+			if (ehci->has_hostpc) {
+				temp1 = ehci_readl(ehci, hostpc_reg);
+				status |= ehci_port_speed(ehci, temp1);
+			} else
+				status |= ehci_port_speed(ehci, temp);
+		}
+		if (temp & PORT_PE)
+			status |= USB_PORT_STAT_ENABLE;
+
+		/* maybe the port was unsuspended without our knowledge */
+		if (temp & (PORT_SUSPEND|PORT_RESUME)) {
+			status |= USB_PORT_STAT_SUSPEND;
+		} else if (test_bit(wIndex, &ehci->suspended_ports)) {
+			clear_bit(wIndex, &ehci->suspended_ports);
+			ehci->reset_done[wIndex] = 0;
+			if (temp & PORT_PE)
+				set_bit(wIndex, &ehci->port_c_suspend);
+		}
+
+		if (temp & PORT_OC)
+			status |= USB_PORT_STAT_OVERCURRENT;
+		if (temp & PORT_RESET)
+			status |= USB_PORT_STAT_RESET;
+		if (temp & PORT_POWER)
+			status |= USB_PORT_STAT_POWER;
+		if (test_bit(wIndex, &ehci->port_c_suspend))
+			status |= USB_PORT_STAT_C_SUSPEND << 16;
+
+#ifndef	VERBOSE_DEBUG
+	if (status & ~0xffff)	/* only if wPortChange is interesting */
+#endif
+		dbg_port(ehci, "GetStatus", wIndex + 1, temp);
+		put_unaligned_le32(status, buf);
+		break;
+	case SetHubFeature:
+		switch (wValue) {
+		case C_HUB_LOCAL_POWER:
+		case C_HUB_OVER_CURRENT:
+			/* no hub-wide feature/status flags */
+			break;
+		default:
+			goto error;
+		}
+		break;
+	case SetPortFeature:
+		selector = wIndex >> 8;
+		wIndex &= 0xff;
+		if (unlikely(ehci->debug)) {
+			/* If the debug port is active any port
+			 * feature requests should get denied */
+			if (wIndex == HCS_DEBUG_PORT(ehci->hcs_params) &&
+			    (readl(&ehci->debug->control) & DBGP_ENABLED)) {
+				retval = -ENODEV;
+				goto error_exit;
+			}
+		}
+		if (!wIndex || wIndex > ports)
+			goto error;
+		wIndex--;
+		temp = ehci_readl(ehci, status_reg);
+		if (temp & PORT_OWNER)
+			break;
+
+		temp &= ~PORT_RWC_BITS;
+		switch (wValue) {
+		case USB_PORT_FEAT_SUSPEND:
+			if (ehci->no_selective_suspend)
+				break;
+			if ((temp & PORT_PE) == 0
+					|| (temp & PORT_RESET) != 0)
+				goto error;
+
+			/* After above check the port must be connected.
+			 * Set appropriate bit thus could put phy into low power
+			 * mode if we have hostpc feature
+			 */
+			temp &= ~PORT_WKCONN_E;
+			temp |= PORT_WKDISC_E | PORT_WKOC_E;
+			ehci_writel(ehci, temp | PORT_SUSPEND, status_reg);
+			if (hostpc_reg) {
+				spin_unlock_irqrestore(&ehci->lock, flags);
+				msleep(5);/* 5ms for HCD enter low pwr mode */
+				spin_lock_irqsave(&ehci->lock, flags);
+				temp1 = ehci_readl(ehci, hostpc_reg);
+				ehci_writel(ehci, temp1 | HOSTPC_PHCD,
+					hostpc_reg);
+				temp1 = ehci_readl(ehci, hostpc_reg);
+				ehci_dbg(ehci, "Port%d phy low pwr mode %s\n",
+					wIndex, (temp1 & HOSTPC_PHCD) ?
+					"succeeded" : "failed");
+			}
+			set_bit(wIndex, &ehci->suspended_ports);
+			break;
+		case USB_PORT_FEAT_POWER:
+			if (HCS_PPC(ehci->hcs_params))
+				ehci_writel(ehci, temp | PORT_POWER,
+						status_reg);
+			break;
+		case USB_PORT_FEAT_RESET:
+			if (temp & PORT_RESUME)
+				goto error;
+			/* line status bits may report this as low speed,
+			 * which can be fine if this root hub has a
+			 * transaction translator built in.
+			 */
+			if ((temp & (PORT_PE|PORT_CONNECT)) == PORT_CONNECT
+					&& !ehci_is_TDI(ehci)
+					&& PORT_USB11(temp)) {
+				ehci_dbg(ehci,
+					"port %d low speed --> companion\n",
+					wIndex + 1);
+				temp |= PORT_OWNER;
+			} else {
+				/* fusbh200 */
+				u32 count;
+				u32 cmd = readl(&ehci->regs->command);
+
+				/* Stop controller for reset */
+				writel(cmd & (~CMD_RUN), &ehci->regs->command);
+				count = 0;
+				cmd = 0;
+				while (((cmd & STS_HALT) == 0) &&
+					(count <= 10000)) {
+					udelay(125);
+					count++;
+					cmd = readl(&ehci->regs->status);
+				}
+				if (count >= 10000) {
+					u32 regcommand, regenable;
+					u32 i, temp;
+
+					ehci_err(ehci, "Host cannot enter HALT state, recover.....\n");
+					regcommand = readl(&ehci->regs->command);
+					regenable = readl(&ehci->regs->intr_enable);
+
+					writel(CMD_RESET, &ehci->regs->command);
+					i = 0;
+					temp = CMD_RESET;
+					while (((temp & CMD_RESET)) &&
+						(i <= 100)) {
+						mdelay(60);
+						i++;
+						temp = readl(&ehci->regs->command);
+					}
+					ehci_err(ehci, "Reset OK.....%d\n", i);
+					writel(regenable, &ehci->regs->intr_enable);
+					writel(regcommand, &ehci->regs->command);
+					mdelay(1);
+					writel(regcommand | CMD_RUN, &ehci->regs->command);
+
+					ehci_err(ehci, "Host recover OK\n");
+				}
+				/* fusbh200 end */
+				ehci_vdbg(ehci, "port %d reset\n", wIndex + 1);
+				temp |= PORT_RESET;
+				temp &= ~PORT_PE;
+				/*
+				 * caller must wait, then call GetPortStatus
+				 * usb 2.0 spec says 50 ms resets on root
+				 */
+				ehci->reset_done[wIndex] = jiffies
+						+ msecs_to_jiffies(50);
+			}
+			ehci_writel(ehci, temp, status_reg);
+			break;
+
+		/* For downstream facing ports (these):  one hub port is put
+		 * into test mode according to USB2 11.24.2.13, then the hub
+		 * must be reset (which for root hub now means rmmod+modprobe,
+		 * or else system reboot).  See EHCI 2.3.9 and 4.14 for info
+		 * about the EHCI-specific stuff.
+		 */
+		case USB_PORT_FEAT_TEST:
+			if (!selector || selector > 5)
+				goto error;
+			ehci_quiesce(ehci);
+
+			/* Put all enabled ports into suspend */
+			while (ports--) {
+				u32 __iomem *sreg =
+						&ehci->regs->port_status[ports];
+
+				temp = ehci_readl(ehci, sreg) & ~PORT_RWC_BITS;
+				if (temp & PORT_PE)
+					ehci_writel(ehci, temp | PORT_SUSPEND,
+							sreg);
+			}
+			fusbh200_ehci_halt(ehci);
+			temp = ehci_readl(ehci, status_reg);
+			temp |= selector << 16;
+			ehci_writel(ehci, temp, status_reg);
+			break;
+
+		default:
+			goto error;
+		}
+		ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+		break;
+
+	default:
+error:
+		/* "stall" on error */
+		retval = -EPIPE;
+	}
+error_exit:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	return retval;
+}
+
+#define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
+
+/* Allocate the key transfer structures from the previously allocated pool */
+
+static inline void ehci_qtd_init(struct ehci_hcd *ehci, struct ehci_qtd *qtd,
+				  dma_addr_t dma)
+{
+	memset(qtd, 0, sizeof(*qtd));
+	qtd->qtd_dma = dma;
+	qtd->hw_token = cpu_to_hc32(ehci, QTD_STS_HALT);
+	qtd->hw_next = EHCI_LIST_END(ehci);
+	qtd->hw_alt_next = EHCI_LIST_END(ehci);
+	INIT_LIST_HEAD(&qtd->qtd_list);
+}
+
+static struct ehci_qtd *ehci_qtd_alloc(struct ehci_hcd *ehci, gfp_t flags)
+{
+	struct ehci_qtd		*qtd;
+	dma_addr_t		dma;
+
+	qtd = dma_pool_alloc(ehci->qtd_pool, flags, &dma);
+	if (qtd != NULL) {
+		ehci_qtd_init(ehci, qtd, dma);
+	}
+	return qtd;
+}
+
+static inline void ehci_qtd_free(struct ehci_hcd *ehci, struct ehci_qtd *qtd)
+{
+	dma_pool_free(ehci->qtd_pool, qtd, qtd->qtd_dma);
+}
+
+
+static void qh_destroy(struct ehci_qh *qh)
+{
+	struct ehci_hcd *ehci = qh->ehci;
+
+	/* clean qtds first, and know this is not linked */
+	if (!list_empty(&qh->qtd_list) || qh->qh_next.ptr) {
+		ehci_dbg(ehci, "unused qh not empty!\n");
+		BUG();
+	}
+	if (qh->dummy)
+		ehci_qtd_free(ehci, qh->dummy);
+	dma_pool_free(ehci->qh_pool, qh->hw, qh->qh_dma);
+	kfree(qh);
+}
+
+static struct ehci_qh *ehci_qh_alloc(struct ehci_hcd *ehci, gfp_t flags)
+{
+	struct ehci_qh		*qh;
+	dma_addr_t		dma;
+
+	qh = kzalloc(sizeof(*qh), GFP_ATOMIC);
+	if (!qh)
+		goto done;
+	qh->hw = (struct ehci_qh_hw *)
+		dma_pool_alloc(ehci->qh_pool, flags, &dma);
+	if (!qh->hw)
+		goto fail;
+	memset(qh->hw, 0, sizeof(*qh->hw));
+	qh->refcount = 1;
+	qh->ehci = ehci;
+	qh->qh_dma = dma;
+	INIT_LIST_HEAD(&qh->qtd_list);
+
+	/* dummy td enables safe urb queuing */
+	qh->dummy = ehci_qtd_alloc(ehci, flags);
+	if (qh->dummy == NULL) {
+		ehci_dbg(ehci, "no dummy td\n");
+		goto fail1;
+	}
+done:
+	return qh;
+fail1:
+	dma_pool_free(ehci->qh_pool, qh->hw, qh->qh_dma);
+fail:
+	kfree(qh);
+	return NULL;
+}
+
+/* to share a qh (cpu threads, or hc) */
+static inline struct ehci_qh *qh_get(struct ehci_qh *qh)
+{
+	WARN_ON(!qh->refcount);
+	qh->refcount++;
+	return qh;
+}
+
+static inline void qh_put(struct ehci_qh *qh)
+{
+	if (!--qh->refcount)
+		qh_destroy(qh);
+}
+
+/* The queue heads and transfer descriptors are managed from pools tied
+ * to each of the "per device" structures.
+ * This is the initialisation and cleanup code.
+ */
+
+static void ehci_mem_cleanup(struct ehci_hcd *ehci)
+{
+	free_cached_lists(ehci);
+	if (ehci->async)
+		qh_put(ehci->async);
+	ehci->async = NULL;
+
+	if (ehci->dummy)
+		qh_put(ehci->dummy);
+	ehci->dummy = NULL;
+
+	/* DMA consistent memory and pools */
+	if (ehci->qtd_pool)
+		dma_pool_destroy(ehci->qtd_pool);
+	ehci->qtd_pool = NULL;
+
+	if (ehci->qh_pool) {
+		dma_pool_destroy(ehci->qh_pool);
+		ehci->qh_pool = NULL;
+	}
+
+	if (ehci->itd_pool)
+		dma_pool_destroy(ehci->itd_pool);
+	ehci->itd_pool = NULL;
+
+	if (ehci->sitd_pool)
+		dma_pool_destroy(ehci->sitd_pool);
+	ehci->sitd_pool = NULL;
+
+	if (ehci->periodic)
+		dma_free_coherent(ehci_to_hcd(ehci)->self.controller,
+			ehci->periodic_size * sizeof(u32),
+			ehci->periodic, ehci->periodic_dma);
+	ehci->periodic = NULL;
+
+	/* shadow periodic table */
+	kfree(ehci->pshadow);
+	ehci->pshadow = NULL;
+}
+
+/* remember to add cleanup code (above) if you add anything here */
+static int ehci_mem_init(struct ehci_hcd *ehci, gfp_t flags)
+{
+	int i;
+
+	/* QTDs for control/bulk/intr transfers */
+	ehci->qtd_pool = dma_pool_create("ehci_qtd",
+			ehci_to_hcd(ehci)->self.controller,
+			sizeof(struct ehci_qtd),
+			32 /* byte alignment (for hw parts) */,
+			4096 /* can't cross 4K */);
+	if (!ehci->qtd_pool) {
+		goto fail;
+	}
+
+	/* QHs for control/bulk/intr transfers */
+	ehci->qh_pool = dma_pool_create("ehci_qh",
+			ehci_to_hcd(ehci)->self.controller,
+			sizeof(struct ehci_qh_hw),
+			32 /* byte alignment (for hw parts) */,
+			4096 /* can't cross 4K */);
+	if (!ehci->qh_pool) {
+		goto fail;
+	}
+	ehci->async = ehci_qh_alloc(ehci, flags);
+	if (!ehci->async) {
+		goto fail;
+	}
+
+	/* ITD for high speed ISO transfers */
+	ehci->itd_pool = dma_pool_create("ehci_itd",
+			ehci_to_hcd(ehci)->self.controller,
+			sizeof(struct ehci_itd),
+			32 /* byte alignment (for hw parts) */,
+			4096 /* can't cross 4K */);
+	if (!ehci->itd_pool) {
+		goto fail;
+	}
+
+	/* SITD for full/low speed split ISO transfers */
+	ehci->sitd_pool = dma_pool_create("ehci_sitd",
+			ehci_to_hcd(ehci)->self.controller,
+			sizeof(struct ehci_sitd),
+			32 /* byte alignment (for hw parts) */,
+			4096 /* can't cross 4K */);
+	if (!ehci->sitd_pool) {
+		goto fail;
+	}
+
+	/* Hardware periodic table */
+	ehci->periodic = (__le32 *)
+		dma_alloc_coherent(ehci_to_hcd(ehci)->self.controller,
+			ehci->periodic_size * sizeof(__le32),
+			&ehci->periodic_dma, 0);
+	if (ehci->periodic == NULL) {
+		goto fail;
+	}
+
+	if (ehci->use_dummy_qh) {
+		struct ehci_qh_hw	*hw;
+		ehci->dummy = ehci_qh_alloc(ehci, flags);
+		if (!ehci->dummy)
+			goto fail;
+
+		hw = ehci->dummy->hw;
+		hw->hw_next = EHCI_LIST_END(ehci);
+		hw->hw_qtd_next = EHCI_LIST_END(ehci);
+		hw->hw_alt_next = EHCI_LIST_END(ehci);
+		hw->hw_token &= ~QTD_STS_ACTIVE;
+		ehci->dummy->hw = hw;
+
+		for (i = 0; i < ehci->periodic_size; i++)
+			ehci->periodic[i] = ehci->dummy->qh_dma;
+	} else {
+		for (i = 0; i < ehci->periodic_size; i++)
+			ehci->periodic[i] = EHCI_LIST_END(ehci);
+	}
+
+	/* software shadow of hardware table */
+	ehci->pshadow = kcalloc(ehci->periodic_size, sizeof(void *), flags);
+	if (ehci->pshadow != NULL)
+		return 0;
+
+fail:
+	ehci_dbg(ehci, "couldn't init memory\n");
+	ehci_mem_cleanup(ehci);
+	return -ENOMEM;
+}
+
+/*
+ * EHCI hardware queue manipulation ... the core.  QH/QTD manipulation.
+ *
+ * Control, bulk, and interrupt traffic all use "qh" lists.  They list "qtd"
+ * entries describing USB transactions, max 16-20kB/entry (with 4kB-aligned
+ * buffers needed for the larger number).  We use one QH per endpoint, queue
+ * multiple urbs (all three types) per endpoint.  URBs may need several qtds.
+ *
+ * ISO traffic uses "ISO TD" (itd, and sitd) records, and (along with
+ * interrupts) needs careful scheduling.  Performance improvements can be
+ * an ongoing challenge.  That's in "ehci-sched.c".
+ *
+ * USB 1.1 devices are handled (a) by "companion" OHCI or UHCI root hubs,
+ * or otherwise through transaction translators (TTs) in USB 2.0 hubs using
+ * (b) special fields in qh entries or (c) split iso entries.  TTs will
+ * buffer low/full speed data so the host collects it at high speed.
+ */
+
+
+/* fill a qtd, returning how much of the buffer we were able to queue up */
+static int
+qtd_fill(struct ehci_hcd *ehci, struct ehci_qtd *qtd, dma_addr_t buf,
+		  size_t len, int token, int maxpacket)
+{
+	int	i, count;
+	u64	addr = buf;
+
+	/* one buffer entry per 4K ... first might be short or unaligned */
+	qtd->hw_buf[0] = cpu_to_hc32(ehci, (u32)addr);
+	qtd->hw_buf_hi[0] = cpu_to_hc32(ehci, (u32)(addr >> 32));
+	count = 0x1000 - (buf & 0x0fff);	/* rest of that page */
+	if (likely(len < count))		/* ... iff needed */
+		count = len;
+	else {
+		buf +=  0x1000;
+		buf &= ~0x0fff;
+
+		/* per-qtd limit: from 16K to 20K (best alignment) */
+		for (i = 1; count < len && i < 5; i++) {
+			addr = buf;
+			qtd->hw_buf[i] = cpu_to_hc32(ehci, (u32)addr);
+			qtd->hw_buf_hi[i] = cpu_to_hc32(ehci,
+					(u32)(addr >> 32));
+			buf += 0x1000;
+			if ((count + 0x1000) < len)
+				count += 0x1000;
+			else
+				count = len;
+		}
+
+		/* short packets may only terminate transfers */
+		if (count != len)
+			count -= (count % maxpacket);
+	}
+	qtd->hw_token = cpu_to_hc32(ehci, (count << 16) | token);
+	qtd->length = count;
+
+	return count;
+}
+
+static inline void
+qh_update(struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
+{
+	struct ehci_qh_hw *hw = qh->hw;
+
+	/* writes to an active overlay are unsafe */
+	BUG_ON(qh->qh_state != QH_STATE_IDLE);
+
+	hw->hw_qtd_next = QTD_NEXT(ehci, qtd->qtd_dma);
+	hw->hw_alt_next = EHCI_LIST_END(ehci);
+
+	/* Except for control endpoints, we make hardware maintain data
+	 * toggle (like OHCI) ... here (re)initialize the toggle in the QH,
+	 * and set the pseudo-toggle in udev. Only usb_clear_halt() will
+	 * ever clear it.
+	 */
+	if (!(hw->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
+		unsigned	is_out, epnum;
+
+		is_out = qh->is_out;
+		epnum = (hc32_to_cpup(ehci, &hw->hw_info1) >> 8) & 0x0f;
+		if (unlikely(!usb_gettoggle(qh->dev, epnum, is_out))) {
+			hw->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
+			usb_settoggle(qh->dev, epnum, is_out, 1);
+		}
+	}
+
+	hw->hw_token &= cpu_to_hc32(ehci, QTD_TOGGLE | QTD_STS_PING);
+}
+
+/* if it weren't for a common silicon quirk (writing the dummy into the qh
+ * overlay, so qh->hw_token wrongly becomes inactive/halted), only fault
+ * recovery (including urb dequeue) would need software changes to a QH...
+ */
+static void
+qh_refresh(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	struct ehci_qtd *qtd;
+
+	if (list_empty(&qh->qtd_list))
+		qtd = qh->dummy;
+	else {
+		qtd = list_entry(qh->qtd_list.next,
+				struct ehci_qtd, qtd_list);
+		/* first qtd may already be partially processed */
+		if (cpu_to_hc32(ehci, qtd->qtd_dma) == qh->hw->hw_current)
+			qtd = NULL;
+	}
+
+	if (qtd)
+		qh_update(ehci, qh, qtd);
+}
+
+static void qh_link_async(struct ehci_hcd *ehci, struct ehci_qh *qh);
+
+static void fusbh200_ehci_clear_tt_buffer_complete(struct usb_hcd *hcd,
+		struct usb_host_endpoint *ep)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	struct ehci_qh		*qh = ep->hcpriv;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&ehci->lock, flags);
+	qh->clearing_tt = 0;
+	if (qh->qh_state == QH_STATE_IDLE && !list_empty(&qh->qtd_list)
+			&& ehci->rh_state == EHCI_RH_RUNNING)
+		qh_link_async(ehci, qh);
+	spin_unlock_irqrestore(&ehci->lock, flags);
+}
+
+static void ehci_clear_tt_buffer(struct ehci_hcd *ehci, struct ehci_qh *qh,
+		struct urb *urb, u32 token)
+{
+
+	/* If an async split transaction gets an error or is unlinked,
+	 * the TT buffer may be left in an indeterminate state.  We
+	 * have to clear the TT buffer.
+	 *
+	 * Note: this routine is never called for Isochronous transfers.
+	 */
+	if (urb->dev->tt && !usb_pipeint(urb->pipe) && !qh->clearing_tt) {
+#ifdef DEBUG
+		struct usb_device *tt = urb->dev->tt->hub;
+		dev_dbg(&tt->dev,
+			"clear tt buffer port %d, a%d ep%d t%08x\n",
+			urb->dev->ttport, urb->dev->devnum,
+			usb_pipeendpoint(urb->pipe), token);
+#endif /* DEBUG */
+		if (!ehci_is_TDI(ehci)
+				|| urb->dev->tt->hub !=
+				   ehci_to_hcd(ehci)->self.root_hub) {
+			if (usb_hub_clear_tt_buffer(urb) == 0)
+				qh->clearing_tt = 1;
+		} else {
+
+			/* REVISIT ARC-derived cores don't clear the root
+			 * hub TT buffer in this way...
+			 */
+		}
+	}
+}
+
+static int qtd_copy_status(
+	struct ehci_hcd *ehci,
+	struct urb *urb,
+	size_t length,
+	u32 token
+)
+{
+	int	status = -EINPROGRESS;
+
+	/* count IN/OUT bytes, not SETUP (even short packets) */
+	if (likely(QTD_PID(token) != 2))
+		urb->actual_length += length - QTD_LENGTH(token);
+
+	/* don't modify error codes */
+	if (unlikely(urb->unlinked))
+		return status;
+
+	/* force cleanup after short read; not always an error */
+	if (unlikely(IS_SHORT_READ(token)))
+		status = -EREMOTEIO;
+
+	/* serious "can't proceed" faults reported by the hardware */
+	if (token & QTD_STS_HALT) {
+		if (token & QTD_STS_BABBLE) {
+			/* FIXME "must" disable babbling device's port too */
+			status = -EOVERFLOW;
+		/* CERR nonzero + halt --> stall */
+		} else if (QTD_CERR(token)) {
+			status = -EPIPE;
+
+		/* In theory, more than one of the following bits can be set
+		 * since they are sticky and the transaction is retried.
+		 * Which to test first is rather arbitrary.
+		 */
+		} else if (token & QTD_STS_MMF) {
+			/* fs/ls interrupt xfer missed the complete-split */
+			status = -EPROTO;
+		} else if (token & QTD_STS_DBE) {
+			status = (QTD_PID(token) == 1) /* IN ? */
+				? -ENOSR  /* hc couldn't read data */
+				: -ECOMM; /* hc couldn't write data */
+		} else if (token & QTD_STS_XACT) {
+			/* timeout, bad CRC, wrong PID, etc */
+			ehci_dbg(ehci, "devpath %s ep%d%s 3strikes\n",
+				urb->dev->devpath,
+				usb_pipeendpoint(urb->pipe),
+				usb_pipein(urb->pipe) ? "in" : "out");
+			status = -EPROTO;
+		} else {	/* unknown */
+			status = -EPROTO;
+		}
+
+		ehci_vdbg(ehci,
+			"dev%d ep%d%s qtd token %08x --> status %d\n",
+			usb_pipedevice(urb->pipe),
+			usb_pipeendpoint(urb->pipe),
+			usb_pipein(urb->pipe) ? "in" : "out",
+			token, status);
+	}
+
+	return status;
+}
+
+static void
+ehci_urb_done(struct ehci_hcd *ehci, struct urb *urb, int status)
+__releases(ehci->lock)
+__acquires(ehci->lock)
+{
+	if (likely(urb->hcpriv != NULL)) {
+		struct ehci_qh	*qh = (struct ehci_qh *) urb->hcpriv;
+
+		/* S-mask in a QH means it's an interrupt urb */
+		if ((qh->hw->hw_info2 & cpu_to_hc32(ehci, QH_SMASK)) != 0) {
+
+			/* ... update hc-wide periodic stats (for usbfs) */
+			ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
+		}
+		qh_put(qh);
+	}
+
+	if (unlikely(urb->unlinked)) {
+		COUNT(ehci->stats.unlink);
+	} else {
+		/* report non-error and short read status as zero */
+		if (status == -EINPROGRESS || status == -EREMOTEIO)
+			status = 0;
+		COUNT(ehci->stats.complete);
+	}
+
+#ifdef EHCI_URB_TRACE
+	ehci_dbg(ehci,
+		"%s %s urb %p ep%d%s status %d len %d/%d\n",
+		__func__, urb->dev->devpath, urb,
+		usb_pipeendpoint(urb->pipe),
+		usb_pipein(urb->pipe) ? "in" : "out",
+		status,
+		urb->actual_length, urb->transfer_buffer_length);
+#endif
+
+	/* complete() can reenter this HCD */
+	usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
+	spin_unlock(&ehci->lock);
+	usb_hcd_giveback_urb(ehci_to_hcd(ehci), urb, status);
+	spin_lock(&ehci->lock);
+}
+
+static void start_unlink_async(struct ehci_hcd *ehci, struct ehci_qh *qh);
+static void unlink_async(struct ehci_hcd *ehci, struct ehci_qh *qh);
+static int qh_schedule(struct ehci_hcd *ehci, struct ehci_qh *qh);
+
+/*
+ * Process and free completed qtds for a qh, returning URBs to drivers.
+ * Chases up to qh->hw_current.  Returns number of completions called,
+ * indicating how much "real" work we did.
+ */
+static unsigned
+qh_completions(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	struct ehci_qtd		*last, *end = qh->dummy;
+	struct list_head	*entry, *tmp;
+	int			last_status;
+	int			stopped;
+	unsigned		count = 0;
+	u8			state;
+	struct ehci_qh_hw	*hw = qh->hw;
+
+	if (unlikely(list_empty(&qh->qtd_list)))
+		return count;
+
+	/* completions (or tasks on other cpus) must never clobber HALT
+	 * till we've gone through and cleaned everything up, even when
+	 * they add urbs to this qh's queue or mark them for unlinking.
+	 *
+	 * NOTE:  unlinking expects to be done in queue order.
+	 *
+	 * It's a bug for qh->qh_state to be anything other than
+	 * QH_STATE_IDLE, unless our caller is scan_async() or
+	 * scan_periodic().
+	 */
+	state = qh->qh_state;
+	qh->qh_state = QH_STATE_COMPLETING;
+	stopped = (state == QH_STATE_IDLE);
+
+ rescan:
+	last = NULL;
+	last_status = -EINPROGRESS;
+	qh->needs_rescan = 0;
+
+	/* remove de-activated QTDs from front of queue.
+	 * after faults (including short reads), cleanup this urb
+	 * then let the queue advance.
+	 * if queue is stopped, handles unlinks.
+	 */
+	list_for_each_safe(entry, tmp, &qh->qtd_list) {
+		struct ehci_qtd	*qtd;
+		struct urb	*urb;
+		u32		token = 0;
+
+		qtd = list_entry(entry, struct ehci_qtd, qtd_list);
+		urb = qtd->urb;
+
+		/* clean up any state from previous QTD ...*/
+		if (last) {
+			if (likely(last->urb != urb)) {
+				ehci_urb_done(ehci, last->urb, last_status);
+				count++;
+				last_status = -EINPROGRESS;
+			}
+			ehci_qtd_free(ehci, last);
+			last = NULL;
+		}
+
+		/* ignore urbs submitted during completions we reported */
+		if (qtd == end)
+			break;
+
+		/* hardware copies qtd out of qh overlay */
+		rmb();
+		token = hc32_to_cpu(ehci, qtd->hw_token);
+
+		/* always clean up qtds the hc de-activated */
+ retry_xacterr:
+		if ((token & QTD_STS_ACTIVE) == 0) {
+
+			/* Report Data Buffer Error: non-fatal but useful */
+			if (token & QTD_STS_DBE)
+				ehci_dbg(ehci,
+					"detected DataBufferErr for urb %p ep%d%s len %d, qtd %p [qh %p]\n",
+					urb,
+					usb_endpoint_num(&urb->ep->desc),
+					usb_endpoint_dir_in(&urb->ep->desc) ? "in" : "out",
+					urb->transfer_buffer_length,
+					qtd,
+					qh);
+
+			/* on STALL, error, and short reads this urb must
+			 * complete and all its qtds must be recycled.
+			 */
+			if ((token & QTD_STS_HALT) != 0) {
+
+				/* retry transaction errors until we
+				 * reach the software xacterr limit
+				 */
+				if ((token & QTD_STS_XACT) &&
+						QTD_CERR(token) == 0 &&
+						++qh->xacterrs < QH_XACTERR_MAX &&
+						!urb->unlinked) {
+					ehci_dbg(ehci,
+	"detected XactErr len %zu/%zu retry %d\n",
+	qtd->length - QTD_LENGTH(token), qtd->length, qh->xacterrs);
+
+					/* reset the token in the qtd and the
+					 * qh overlay (which still contains
+					 * the qtd) so that we pick up from
+					 * where we left off
+					 */
+					token &= ~QTD_STS_HALT;
+					token |= QTD_STS_ACTIVE |
+							(EHCI_TUNE_CERR << 10);
+					qtd->hw_token = cpu_to_hc32(ehci,
+							token);
+					wmb();
+					hw->hw_token = cpu_to_hc32(ehci,
+							token);
+					goto retry_xacterr;
+				}
+				stopped = 1;
+
+			/* magic dummy for some short reads; qh won't advance.
+			 * that silicon quirk can kick in with this dummy too.
+			 *
+			 * other short reads won't stop the queue, including
+			 * control transfers (status stage handles that) or
+			 * most other single-qtd reads ... the queue stops if
+			 * URB_SHORT_NOT_OK was set so the driver submitting
+			 * the urbs could clean it up.
+			 */
+			} else if (IS_SHORT_READ(token)
+					&& !(qtd->hw_alt_next
+						& EHCI_LIST_END(ehci))) {
+				stopped = 1;
+			}
+
+		/* stop scanning when we reach qtds the hc is using */
+		} else if (likely(!stopped
+				&& ehci->rh_state == EHCI_RH_RUNNING)) {
+			break;
+
+		/* scan the whole queue for unlinks whenever it stops */
+		} else {
+			stopped = 1;
+
+			/* cancel everything if we halt, suspend, etc */
+			if (ehci->rh_state != EHCI_RH_RUNNING)
+				last_status = -ESHUTDOWN;
+
+			/* this qtd is active; skip it unless a previous qtd
+			 * for its urb faulted, or its urb was canceled.
+			 */
+			else if (last_status == -EINPROGRESS && !urb->unlinked)
+				continue;
+
+			/* qh unlinked; token in overlay may be most current */
+			if (state == QH_STATE_IDLE
+					&& cpu_to_hc32(ehci, qtd->qtd_dma)
+						== hw->hw_current) {
+				token = hc32_to_cpu(ehci, hw->hw_token);
+
+				/* An unlink may leave an incomplete
+				 * async transaction in the TT buffer.
+				 * We have to clear it.
+				 */
+				ehci_clear_tt_buffer(ehci, qh, urb, token);
+			}
+		}
+
+		/* unless we already know the urb's status, collect qtd status
+		 * and update count of bytes transferred.  in common short read
+		 * cases with only one data qtd (including control transfers),
+		 * queue processing won't halt.  but with two or more qtds (for
+		 * example, with a 32 KB transfer), when the first qtd gets a
+		 * short read the second must be removed by hand.
+		 */
+		if (last_status == -EINPROGRESS) {
+			last_status = qtd_copy_status(ehci, urb,
+					qtd->length, token);
+			if (last_status == -EREMOTEIO
+					&& (qtd->hw_alt_next
+						& EHCI_LIST_END(ehci)))
+				last_status = -EINPROGRESS;
+
+			/* As part of low/full-speed endpoint-halt processing
+			 * we must clear the TT buffer (11.17.5).
+			 */
+			if (unlikely(last_status != -EINPROGRESS &&
+					last_status != -EREMOTEIO)) {
+				/* The TT's in some hubs malfunction when they
+				 * receive this request following a STALL (they
+				 * stop sending isochronous packets).  Since a
+				 * STALL can't leave the TT buffer in a busy
+				 * state (if you believe Figures 11-48 - 11-51
+				 * in the USB 2.0 spec), we won't clear the TT
+				 * buffer in this case.  Strictly speaking this
+				 * is a violation of the spec.
+				 */
+				if (last_status != -EPIPE)
+					ehci_clear_tt_buffer(ehci, qh, urb,
+							token);
+			}
+		}
+
+		/* if we're removing something not at the queue head,
+		 * patch the hardware queue pointer.
+		 */
+		if (stopped && qtd->qtd_list.prev != &qh->qtd_list) {
+			last = list_entry(qtd->qtd_list.prev,
+					struct ehci_qtd, qtd_list);
+			last->hw_next = qtd->hw_next;
+		}
+
+		/* remove qtd; it's recycled after possible urb completion */
+		list_del(&qtd->qtd_list);
+		last = qtd;
+
+		/* reinit the xacterr counter for the next qtd */
+		qh->xacterrs = 0;
+	}
+
+	/* last urb's completion might still need calling */
+	if (likely(last != NULL)) {
+		ehci_urb_done(ehci, last->urb, last_status);
+		count++;
+		ehci_qtd_free(ehci, last);
+	}
+
+	/* Do we need to rescan for URBs dequeued during a giveback? */
+	if (unlikely(qh->needs_rescan)) {
+		/* If the QH is already unlinked, do the rescan now. */
+		if (state == QH_STATE_IDLE)
+			goto rescan;
+
+		/* Otherwise we have to wait until the QH is fully unlinked.
+		 * Our caller will start an unlink if qh->needs_rescan is
+		 * set.  But if an unlink has already started, nothing needs
+		 * to be done.
+		 */
+		if (state != QH_STATE_LINKED)
+			qh->needs_rescan = 0;
+	}
+
+	/* restore original state; caller must unlink or relink */
+	qh->qh_state = state;
+
+	/* be sure the hardware's done with the qh before refreshing
+	 * it after fault cleanup, or recovering from silicon wrongly
+	 * overlaying the dummy qtd (which reduces DMA chatter).
+	 */
+	if (stopped != 0 || hw->hw_qtd_next == EHCI_LIST_END(ehci)) {
+		switch (state) {
+		case QH_STATE_IDLE:
+			qh_refresh(ehci, qh);
+			break;
+		case QH_STATE_LINKED:
+			/* We won't refresh a QH that's linked (after the HC
+			 * stopped the queue).  That avoids a race:
+			 *  - HC reads first part of QH;
+			 *  - CPU updates that first part and the token;
+			 *  - HC reads rest of that QH, including token
+			 * Result:  HC gets an inconsistent image, and then
+			 * DMAs to/from the wrong memory (corrupting it).
+			 *
+			 * That should be rare for interrupt transfers,
+			 * except maybe high bandwidth ...
+			 */
+
+			/* Tell the caller to start an unlink */
+			qh->needs_rescan = 1;
+			break;
+		/* otherwise, unlink already started */
+		}
+	}
+
+	return count;
+}
+
+/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
+#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
+/* ... and packet size, for any kind of endpoint descriptor */
+#define max_packet(wMaxPacketSize) ((wMaxPacketSize) & 0x07ff)
+
+/*
+ * reverse of qh_urb_transaction:  free a list of TDs.
+ * used for cleanup after errors, before HC sees an URB's TDs.
+ */
+static void qtd_list_free(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	struct list_head	*qtd_list
+) {
+	struct list_head	*entry, *temp;
+
+	list_for_each_safe(entry, temp, qtd_list) {
+		struct ehci_qtd	*qtd;
+
+		qtd = list_entry(entry, struct ehci_qtd, qtd_list);
+		list_del(&qtd->qtd_list);
+		ehci_qtd_free(ehci, qtd);
+	}
+}
+
+/*
+ * create a list of filled qtds for this URB; won't link into qh.
+ */
+static struct list_head *
+qh_urb_transaction(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	struct list_head	*head,
+	gfp_t			flags
+) {
+	struct ehci_qtd		*qtd, *qtd_prev;
+	dma_addr_t		buf;
+	int			len, this_sg_len, maxpacket;
+	int			is_input;
+	u32			token;
+	int			i;
+	struct scatterlist	*sg;
+
+	/*
+	 * URBs map to sequences of QTDs:  one logical transaction
+	 */
+	qtd = ehci_qtd_alloc(ehci, flags);
+	if (unlikely(!qtd))
+		return NULL;
+	list_add_tail(&qtd->qtd_list, head);
+	qtd->urb = urb;
+
+	token = QTD_STS_ACTIVE;
+	token |= (EHCI_TUNE_CERR << 10);
+	/* for split transactions, SplitXState initialized to zero */
+
+	len = urb->transfer_buffer_length;
+	is_input = usb_pipein(urb->pipe);
+	if (usb_pipecontrol(urb->pipe)) {
+		/* SETUP pid */
+		qtd_fill(ehci, qtd, urb->setup_dma,
+				sizeof(struct usb_ctrlrequest),
+				token | (2 /* "setup" */ << 8), 8);
+
+		/* ... and always at least one more pid */
+		token ^= QTD_TOGGLE;
+		qtd_prev = qtd;
+		qtd = ehci_qtd_alloc(ehci, flags);
+		if (unlikely(!qtd))
+			goto cleanup;
+		qtd->urb = urb;
+		qtd_prev->hw_next = QTD_NEXT(ehci, qtd->qtd_dma);
+		list_add_tail(&qtd->qtd_list, head);
+
+		/* for zero length DATA stages, STATUS is always IN */
+		if (len == 0)
+			token |= (1 /* "in" */ << 8);
+	}
+
+	/*
+	 * data transfer stage:  buffer setup
+	 */
+	i = urb->num_mapped_sgs;
+	if (len > 0 && i > 0) {
+		sg = urb->sg;
+		buf = sg_dma_address(sg);
+
+		/* urb->transfer_buffer_length may be smaller than the
+		 * size of the scatterlist (or vice versa)
+		 */
+		this_sg_len = min_t(int, sg_dma_len(sg), len);
+	} else {
+		sg = NULL;
+		buf = urb->transfer_dma;
+		this_sg_len = len;
+	}
+
+	if (is_input)
+		token |= (1 /* "in" */ << 8);
+	/* else it's already initted to "out" pid (0 << 8) */
+
+	maxpacket = max_packet(usb_maxpacket(urb->dev, urb->pipe, !is_input));
+
+	/*
+	 * buffer gets wrapped in one or more qtds;
+	 * last one may be "short" (including zero len)
+	 * and may serve as a control status ack
+	 */
+	for (;;) {
+		int this_qtd_len;
+
+		this_qtd_len = qtd_fill(ehci, qtd, buf, this_sg_len, token,
+				maxpacket);
+		this_sg_len -= this_qtd_len;
+		len -= this_qtd_len;
+		buf += this_qtd_len;
+
+		/*
+		 * short reads advance to a "magic" dummy instead of the next
+		 * qtd ... that forces the queue to stop, for manual cleanup.
+		 * (this will usually be overridden later.)
+		 */
+		if (is_input)
+			qtd->hw_alt_next = ehci->async->hw->hw_alt_next;
+
+		/* qh makes control packets use qtd toggle; maybe switch it */
+		if ((maxpacket & (this_qtd_len + (maxpacket - 1))) == 0)
+			token ^= QTD_TOGGLE;
+
+		if (likely(this_sg_len <= 0)) {
+			if (--i <= 0 || len <= 0)
+				break;
+			sg = sg_next(sg);
+			buf = sg_dma_address(sg);
+			this_sg_len = min_t(int, sg_dma_len(sg), len);
+		}
+
+		qtd_prev = qtd;
+		qtd = ehci_qtd_alloc(ehci, flags);
+		if (unlikely(!qtd))
+			goto cleanup;
+		qtd->urb = urb;
+		qtd_prev->hw_next = QTD_NEXT(ehci, qtd->qtd_dma);
+		list_add_tail(&qtd->qtd_list, head);
+	}
+
+	/*
+	 * unless the caller requires manual cleanup after short reads,
+	 * have the alt_next mechanism keep the queue running after the
+	 * last data qtd (the only one, for control and most other cases).
+	 */
+	if (likely((urb->transfer_flags & URB_SHORT_NOT_OK) == 0
+				|| usb_pipecontrol(urb->pipe)))
+		qtd->hw_alt_next = EHCI_LIST_END(ehci);
+
+	/*
+	 * control requests may need a terminating data "status" ack;
+	 * other OUT ones may need a terminating short packet
+	 * (zero length).
+	 */
+	if (likely(urb->transfer_buffer_length != 0)) {
+		int	one_more = 0;
+
+		if (usb_pipecontrol(urb->pipe)) {
+			one_more = 1;
+			token ^= 0x0100;	/* "in" <--> "out"  */
+			token |= QTD_TOGGLE;	/* force DATA1 */
+		} else if (usb_pipeout(urb->pipe)
+				&& (urb->transfer_flags & URB_ZERO_PACKET)
+				&& !(urb->transfer_buffer_length % maxpacket)) {
+			one_more = 1;
+		}
+		if (one_more) {
+			qtd_prev = qtd;
+			qtd = ehci_qtd_alloc(ehci, flags);
+			if (unlikely(!qtd))
+				goto cleanup;
+			qtd->urb = urb;
+			qtd_prev->hw_next = QTD_NEXT(ehci, qtd->qtd_dma);
+			list_add_tail(&qtd->qtd_list, head);
+
+			/* never any data in such packets */
+			qtd_fill(ehci, qtd, 0, 0, token, 0);
+		}
+	}
+
+	/* by default, enable interrupt on urb completion */
+	if (likely(!(urb->transfer_flags & URB_NO_INTERRUPT)))
+		qtd->hw_token |= cpu_to_hc32(ehci, QTD_IOC);
+	return head;
+
+cleanup:
+	qtd_list_free(ehci, urb, head);
+	return NULL;
+}
+
+/* Would be best to create all qh's from config descriptors,*/
+/* when each interface/altsetting is established.  Unlink   */
+/* any previous qh and cancel its urbs first; endpoints are */
+/* implicitly reset then (data toggle too).		    */
+/* That'd mean updating how usbcore talks to HCDs. (2.7?)   */
+
+/*
+ * Each QH holds a qtd list; a QH is used for everything except iso.
+ *
+ * For interrupt urbs, the scheduler must set the microframe scheduling
+ * mask(s) each time the QH gets scheduled.  For highspeed, that's
+ * just one microframe in the s-mask.  For split interrupt transactions
+ * there are additional complications: c-mask, maybe FSTNs.
+ */
+static struct ehci_qh *
+qh_make(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	gfp_t			flags
+) {
+	struct ehci_qh		*qh = ehci_qh_alloc(ehci, flags);
+	u32			info1 = 0, info2 = 0;
+	int			is_input, type;
+	int			maxp = 0;
+	struct usb_tt		*tt = urb->dev->tt;
+	struct ehci_qh_hw	*hw;
+
+	if (!qh)
+		return qh;
+
+	/*
+	 * init endpoint/device data for this QH
+	 */
+	info1 |= usb_pipeendpoint(urb->pipe) << 8;
+	info1 |= usb_pipedevice(urb->pipe) << 0;
+
+	is_input = usb_pipein(urb->pipe);
+	type = usb_pipetype(urb->pipe);
+	maxp = usb_maxpacket(urb->dev, urb->pipe, !is_input);
+
+	/* 1024 byte maxpacket is a hardware ceiling.  High bandwidth
+	 * acts like up to 3KB, but is built from smaller packets.
+	 */
+	if (max_packet(maxp) > 1024) {
+		ehci_dbg(ehci, "bogus qh maxpacket %d\n", max_packet(maxp));
+		goto done;
+	}
+
+	/* Compute interrupt scheduling parameters just once, and save.
+	 * - allowing for high bandwidth, how many nsec/uframe are used?
+	 * - split transactions need a second CSPLIT uframe; same question
+	 * - splits also need a schedule gap (for full/low speed I/O)
+	 * - qh has a polling interval
+	 *
+	 * For control/bulk requests, the HC or TT handles these.
+	 */
+	if (type == PIPE_INTERRUPT) {
+		qh->usecs = NS_TO_US(usb_calc_bus_time(USB_SPEED_HIGH,
+				is_input, 0,
+				hb_mult(maxp) * max_packet(maxp)));
+		qh->start = NO_FRAME;
+		qh->stamp = ehci->periodic_stamp;
+
+		if (urb->dev->speed == USB_SPEED_HIGH) {
+			qh->c_usecs = 0;
+			qh->gap_uf = 0;
+
+			qh->period = urb->interval >> 3;
+			if (qh->period == 0 && urb->interval != 1) {
+				/* NOTE interval 2 or 4 uframes could work.
+				 * But interval 1 scheduling is simpler, and
+				 * includes high bandwidth.
+				 */
+				urb->interval = 1;
+			} else if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period << 3;
+			}
+		} else {
+			int		think_time;
+
+			/* gap is f(FS/LS transfer times) */
+			qh->gap_uf = 1 + usb_calc_bus_time(urb->dev->speed,
+					is_input, 0, maxp) / (125 * 1000);
+
+			/* FIXME this just approximates SPLIT/CSPLIT times */
+			if (is_input) { /* SPLIT, gap, CSPLIT+DATA */
+				qh->c_usecs = qh->usecs + HS_USECS(0);
+				qh->usecs = HS_USECS(1);
+			} else { /*SPLIT+DATA, gap, CSPLIT */
+				qh->usecs += HS_USECS(1);
+				qh->c_usecs = HS_USECS(0);
+			}
+
+			think_time = tt ? tt->think_time : 0;
+			qh->tt_usecs = NS_TO_US(think_time +
+					usb_calc_bus_time(urb->dev->speed,
+					is_input, 0, max_packet(maxp)));
+			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
+		}
+	}
+
+	/* support for tt scheduling, and access to toggles */
+	qh->dev = urb->dev;
+
+	/* using TT? */
+	switch (urb->dev->speed) {
+	case USB_SPEED_LOW:
+		info1 |= (1 << 12);	/* EPS "low" */
+		/* FALL THROUGH */
+
+	case USB_SPEED_FULL:
+		/* EPS 0 means "full" */
+		if (type != PIPE_INTERRUPT)
+			info1 |= (EHCI_TUNE_RL_TT << 28);
+		if (type == PIPE_CONTROL) {
+			info1 |= (1 << 27);	/* for TT */
+			info1 |= 1 << 14;	/* toggle from qtd */
+		}
+		info1 |= maxp << 16;
+
+		info2 |= (EHCI_TUNE_MULT_TT << 30);
+
+		/* Some Freescale processors have an erratum in which the
+		 * port number in the queue head was 0..N-1 instead of 1..N.
+		 */
+		if (ehci_has_fsl_portno_bug(ehci))
+			info2 |= (urb->dev->ttport-1) << 23;
+		else
+			info2 |= urb->dev->ttport << 23;
+
+		/* set the address of the TT; for TDI's integrated
+		 * root hub tt, leave it zeroed.
+		 */
+		if (tt && tt->hub != ehci_to_hcd(ehci)->self.root_hub)
+			info2 |= tt->hub->devnum << 16;
+
+		/* NOTE:  if (PIPE_INTERRUPT) { scheduler sets c-mask } */
+
+		break;
+
+	case USB_SPEED_HIGH:		/* no TT involved */
+		info1 |= (2 << 12);	/* EPS "high" */
+		if (type == PIPE_CONTROL) {
+			info1 |= (EHCI_TUNE_RL_HS << 28);
+			info1 |= 64 << 16;	/* usb2 fixed maxpacket */
+			info1 |= 1 << 14;	/* toggle from qtd */
+			info2 |= (EHCI_TUNE_MULT_HS << 30);
+		} else if (type == PIPE_BULK) {
+			info1 |= (EHCI_TUNE_RL_HS << 28);
+			/* The USB spec says that high speed bulk endpoints
+			 * always use 512 byte maxpacket.  But some device
+			 * vendors decided to ignore that, and MSFT is happy
+			 * to help them do so.  So now people expect to use
+			 * such nonconformant devices with Linux too; sigh.
+			 */
+			info1 |= max_packet(maxp) << 16;
+			info2 |= (EHCI_TUNE_MULT_HS << 30);
+		} else {		/* PIPE_INTERRUPT */
+			info1 |= max_packet(maxp) << 16;
+			info2 |= hb_mult(maxp) << 30;
+		}
+		break;
+	default:
+		ehci_dbg(ehci, "bogus dev %p speed %d\n", urb->dev,
+			urb->dev->speed);
+done:
+		qh_put(qh);
+		return NULL;
+	}
+
+	/* NOTE:  if (PIPE_INTERRUPT) { scheduler sets s-mask } */
+
+	/* init as live, toggle clear, advance to dummy */
+	qh->qh_state = QH_STATE_IDLE;
+	hw = qh->hw;
+	hw->hw_info1 = cpu_to_hc32(ehci, info1);
+	hw->hw_info2 = cpu_to_hc32(ehci, info2);
+	qh->is_out = !is_input;
+	usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), !is_input, 1);
+	qh_refresh(ehci, qh);
+	return qh;
+}
+
+/*-------------------------------------------------------------------------*/
+
+/* move qh (and its qtds) onto async queue; maybe enable queue.  */
+
+static void qh_link_async(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	__hc32		dma = QH_NEXT(ehci, qh->qh_dma);
+	struct ehci_qh	*head;
+
+	/* Don't link a QH if there's a Clear-TT-Buffer pending */
+	if (unlikely(qh->clearing_tt))
+		return;
+
+	WARN_ON(qh->qh_state != QH_STATE_IDLE);
+
+	/* (re)start the async schedule? */
+	head = ehci->async;
+	timer_action_done(ehci, TIMER_ASYNC_OFF);
+	if (!head->qh_next.qh) {
+		u32	cmd = ehci_readl(ehci, &ehci->regs->command);
+
+		if (!(cmd & CMD_ASE)) {
+			/* in case a clear of CMD_ASE didn't take yet */
+			(void)handshake(ehci, &ehci->regs->status,
+					STS_ASS, 0, 150);
+			cmd |= CMD_ASE;
+			ehci_writel(ehci, cmd, &ehci->regs->command);
+			/* posted write need not be known to HC yet ... */
+		}
+	}
+
+	/* clear halt and/or toggle; and maybe recover from silicon quirk */
+	qh_refresh(ehci, qh);
+
+	/* splice right after start */
+	qh->qh_next = head->qh_next;
+	qh->hw->hw_next = head->hw->hw_next;
+	wmb();
+
+	head->qh_next.qh = qh;
+	head->hw->hw_next = dma;
+
+	qh_get(qh);
+	qh->xacterrs = 0;
+	qh->qh_state = QH_STATE_LINKED;
+	/* qtd completions reported later by interrupt */
+}
+
+/*
+ * For control/bulk/interrupt, return QH with these TDs appended.
+ * Allocates and initializes the QH if necessary.
+ * Returns null if it can't allocate a QH it needs to.
+ * If the QH has TDs (urbs) already, that's great.
+ */
+static struct ehci_qh *qh_append_tds(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	struct list_head	*qtd_list,
+	int			epnum,
+	void			**ptr
+)
+{
+	struct ehci_qh		*qh = NULL;
+	__hc32			qh_addr_mask = cpu_to_hc32(ehci, 0x7f);
+
+	qh = (struct ehci_qh *) *ptr;
+	if (unlikely(qh == NULL)) {
+		/* can't sleep here, we have ehci->lock... */
+		qh = qh_make(ehci, urb, GFP_ATOMIC);
+		*ptr = qh;
+	}
+	if (likely(qh != NULL)) {
+		struct ehci_qtd	*qtd;
+
+		if (unlikely(list_empty(qtd_list)))
+			qtd = NULL;
+		else
+			qtd = list_entry(qtd_list->next, struct ehci_qtd,
+					qtd_list);
+
+		/* control qh may need patching ... */
+		if (unlikely(epnum == 0)) {
+			/* usb_reset_device() briefly reverts to address 0 */
+			if (usb_pipedevice(urb->pipe) == 0)
+				qh->hw->hw_info1 &= ~qh_addr_mask;
+		}
+
+		/* just one way to queue requests: swap with the dummy qtd.
+		 * only hc or qh_refresh() ever modify the overlay.
+		 */
+		if (likely(qtd != NULL)) {
+			struct ehci_qtd		*dummy;
+			dma_addr_t		dma;
+			__hc32			token;
+
+			/* to avoid racing the HC, use the dummy td instead of
+			 * the first td of our list (becomes new dummy).  both
+			 * tds stay deactivated until we're done, when the
+			 * HC is allowed to fetch the old dummy (4.10.2).
+			 */
+			token = qtd->hw_token;
+			qtd->hw_token = HALT_BIT(ehci);
+
+			dummy = qh->dummy;
+
+			dma = dummy->qtd_dma;
+			*dummy = *qtd;
+			dummy->qtd_dma = dma;
+
+			list_del(&qtd->qtd_list);
+			list_add(&dummy->qtd_list, qtd_list);
+			list_splice_tail(qtd_list, &qh->qtd_list);
+
+			ehci_qtd_init(ehci, qtd, qtd->qtd_dma);
+			qh->dummy = qtd;
+
+			/* hc must see the new dummy at list end */
+			dma = qtd->qtd_dma;
+			qtd = list_entry(qh->qtd_list.prev,
+					struct ehci_qtd, qtd_list);
+			qtd->hw_next = QTD_NEXT(ehci, dma);
+
+			/* let the hc process these next qtds */
+			wmb();
+			dummy->hw_token = token;
+
+			urb->hcpriv = qh_get(qh);
+		}
+	}
+	return qh;
+}
+
+static int
+submit_async(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	struct list_head	*qtd_list,
+	gfp_t			mem_flags
+) {
+	int			epnum;
+	unsigned long		flags;
+	struct ehci_qh		*qh = NULL;
+	int			rc;
+
+	epnum = urb->ep->desc.bEndpointAddress;
+#ifdef EHCI_URB_TRACE
+	{
+		struct ehci_qtd *qtd;
+		qtd = list_entry(qtd_list->next, struct ehci_qtd, qtd_list);
+		ehci_dbg(ehci,
+			 "%s %s urb %p ep%d%s len %d, qtd %p [qh %p]\n",
+			 __func__, urb->dev->devpath, urb,
+			 epnum & 0x0f, (epnum & USB_DIR_IN) ? "in" : "out",
+			 urb->transfer_buffer_length,
+			 qtd, urb->ep->hcpriv);
+	}
+#endif
+
+	spin_lock_irqsave(&ehci->lock, flags);
+	if (unlikely(!HCD_HW_ACCESSIBLE(ehci_to_hcd(ehci)))) {
+		rc = -ESHUTDOWN;
+		goto done;
+	}
+	rc = usb_hcd_link_urb_to_ep(ehci_to_hcd(ehci), urb);
+	if (unlikely(rc))
+		goto done;
+
+	qh = qh_append_tds(ehci, urb, qtd_list, epnum, &urb->ep->hcpriv);
+	if (unlikely(qh == NULL)) {
+		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
+		rc = -ENOMEM;
+		goto done;
+	}
+
+	/* Control/bulk operations through TTs don't need scheduling,
+	 * the HC and TT handle it when the TT has a buffer ready.
+	 */
+	if (likely(qh->qh_state == QH_STATE_IDLE))
+		qh_link_async(ehci, qh);
+ done:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	if (unlikely(qh == NULL))
+		qtd_list_free(ehci, urb, qtd_list);
+	return rc;
+}
+
+/* the async qh for the qtds being reclaimed are now unlinked from the HC */
+
+static void end_unlink_async(struct ehci_hcd *ehci)
+{
+	struct ehci_qh		*qh = ehci->reclaim;
+	struct ehci_qh		*next;
+
+	/* add for fusbh200 */
+	if (qh == NULL)
+		return;
+
+	iaa_watchdog_done(ehci);
+
+	qh->qh_state = QH_STATE_IDLE;
+	qh->qh_next.qh = NULL;
+	qh_put(qh);/* refcount from reclaim */
+
+	/* other unlink(s) may be pending (in QH_STATE_UNLINK_WAIT) */
+	next = qh->reclaim;
+	ehci->reclaim = next;
+	qh->reclaim = NULL;
+
+	qh_completions(ehci, qh);
+
+	if (!list_empty(&qh->qtd_list) && ehci->rh_state == EHCI_RH_RUNNING) {
+		qh_link_async(ehci, qh);
+	} else {
+		/* it's not free to turn the async schedule on/off; leave it
+		 * active but idle for a while once it empties.
+		 */
+		if (ehci->rh_state == EHCI_RH_RUNNING
+				&& ehci->async->qh_next.qh == NULL)
+			timer_action(ehci, TIMER_ASYNC_OFF);
+	}
+	qh_put(qh);			/* refcount from async list */
+
+	if (next) {
+		ehci->reclaim = NULL;
+		start_unlink_async(ehci, next);
+	}
+
+	if (ehci->has_synopsys_hc_bug)
+		ehci_writel(ehci, (u32) ehci->async->qh_dma,
+			    &ehci->regs->async_next);
+}
+
+/* makes sure the async qh will become idle */
+/* caller must own ehci->lock */
+static void start_unlink_async(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	int		cmd = ehci_readl(ehci, &ehci->regs->command);
+	struct ehci_qh	*prev;
+	u32 		status;
+#ifdef DEBUG
+	assert_spin_locked(&ehci->lock);
+	if (ehci->reclaim
+			|| (qh->qh_state != QH_STATE_LINKED
+				&& qh->qh_state != QH_STATE_UNLINK_WAIT)
+			)
+		BUG();
+#endif
+	/* add for fusbh200 */
+	status = ehci_readl(ehci, &ehci->regs->port_status[0]);
+	if ((cmd & CMD_RUN) == 0) {
+		ehci_err(ehci, "unlink qhead in HALT:..%x..%x..%x\n",
+			(u32)qh, status, cmd);
+		ehci_writel(ehci, ehci->async->qh_dma,
+			&ehci->regs->async_next);
+	}
+
+	/* stop async schedule right now? */
+	if (unlikely(qh == ehci->async)) {
+		/* can't get here without STS_ASS set */
+		if (ehci->rh_state != EHCI_RH_HALTED
+				&& !ehci->reclaim) {
+			/* ... and CMD_IAAD clear */
+			ehci_writel(ehci, cmd & ~CMD_ASE,
+				    &ehci->regs->command);
+			wmb();
+			/* handshake later, if we need to */
+			timer_action_done(ehci, TIMER_ASYNC_OFF);
+		}
+		return;
+	}
+
+	qh->qh_state = QH_STATE_UNLINK;
+	ehci->reclaim = qh = qh_get(qh);
+
+	prev = ehci->async;
+	while (prev->qh_next.qh != qh)
+		prev = prev->qh_next.qh;
+
+	prev->hw->hw_next = qh->hw->hw_next;
+	prev->qh_next = qh->qh_next;
+	if (ehci->qh_scan_next == qh)
+		ehci->qh_scan_next = qh->qh_next.qh;
+	wmb();
+
+	/* If the controller isn't running, we don't have to wait for it */
+	if (unlikely(ehci->rh_state != EHCI_RH_RUNNING)) {
+		/* if (unlikely (qh->reclaim != 0))
+		 *	this will recurse, probably not much
+		 */
+		end_unlink_async(ehci);
+		return;
+	}
+
+	cmd |= CMD_IAAD;
+	ehci_writel(ehci, cmd, &ehci->regs->command);
+	(void)ehci_readl(ehci, &ehci->regs->command);
+	iaa_watchdog_start(ehci);
+}
+
+static void scan_async(struct ehci_hcd *ehci)
+{
+	bool			stopped;
+	struct ehci_qh		*qh;
+	enum ehci_timer_action	action = TIMER_IO_WATCHDOG;
+
+	timer_action_done(ehci, TIMER_ASYNC_SHRINK);
+	stopped = (ehci->rh_state != EHCI_RH_RUNNING);
+
+	ehci->qh_scan_next = ehci->async->qh_next.qh;
+	while (ehci->qh_scan_next) {
+		qh = ehci->qh_scan_next;
+		ehci->qh_scan_next = qh->qh_next.qh;
+ rescan:
+		/* clean any finished work for this qh */
+		if (!list_empty(&qh->qtd_list)) {
+			int temp;
+
+			/*
+			 * Unlinks could happen here; completion reporting
+			 * drops the lock.  That's why ehci->qh_scan_next
+			 * always holds the next qh to scan; if the next qh
+			 * gets unlinked then ehci->qh_scan_next is adjusted
+			 * in start_unlink_async().
+			 */
+			qh = qh_get(qh);
+			temp = qh_completions(ehci, qh);
+			if (qh->needs_rescan)
+				unlink_async(ehci, qh);
+			qh->unlink_time = jiffies + EHCI_SHRINK_JIFFIES;
+			qh_put(qh);
+			if (temp != 0)
+				goto rescan;
+		}
+
+		/* unlink idle entries, reducing DMA usage as well
+		 * as HCD schedule-scanning costs.  delay for any qh
+		 * we just scanned, there's a not-unusual case that it
+		 * doesn't stay idle for long.
+		 * (plus, avoids some kind of re-activation race.)
+		 */
+		if (list_empty(&qh->qtd_list)
+				&& qh->qh_state == QH_STATE_LINKED) {
+			if (!ehci->reclaim && (stopped ||
+					time_after_eq(jiffies, qh->unlink_time)))
+				start_unlink_async(ehci, qh);
+			else
+				action = TIMER_ASYNC_SHRINK;
+		}
+	}
+	if (action == TIMER_ASYNC_SHRINK)
+		timer_action(ehci, TIMER_ASYNC_SHRINK);
+}
+
+/*
+ * EHCI scheduled transaction support:  interrupt, iso, split iso
+ * These are called "periodic" transactions in the EHCI spec.
+ *
+ * Note that for interrupt transfers, the QH/QTD manipulation is shared
+ * with the "asynchronous" transaction support (control/bulk transfers).
+ * The only real difference is in how interrupt transfers are scheduled.
+ *
+ * For ISO, we make an "iso_stream" head to serve the same role as a QH.
+ * It keeps track of every ITD (or SITD) that's linked, and holds enough
+ * pre-calculated schedule data to make appending to the queue be quick.
+ */
+
+/*
+ * periodic_next_shadow - return "next" pointer on shadow list
+ * @periodic: host pointer to qh/itd/sitd
+ * @tag: hardware tag for type of this record
+ */
+static union ehci_shadow *
+periodic_next_shadow(struct ehci_hcd *ehci, union ehci_shadow *periodic,
+		__hc32 tag)
+{
+	switch (hc32_to_cpu(ehci, tag)) {
+	case Q_TYPE_QH:
+		return &periodic->qh->qh_next;
+	case Q_TYPE_FSTN:
+		return &periodic->fstn->fstn_next;
+	case Q_TYPE_ITD:
+		return &periodic->itd->itd_next;
+	default:
+		return &periodic->sitd->sitd_next;
+	}
+}
+
+static __hc32 *
+shadow_next_periodic(struct ehci_hcd *ehci, union ehci_shadow *periodic,
+		__hc32 tag)
+{
+	switch (hc32_to_cpu(ehci, tag)) {
+	/* our ehci_shadow.qh is actually software part */
+	case Q_TYPE_QH:
+		return &periodic->qh->hw->hw_next;
+	/* others are hw parts */
+	default:
+		return periodic->hw_next;
+	}
+}
+
+/* caller must hold ehci->lock */
+static void periodic_unlink(struct ehci_hcd *ehci, unsigned frame, void *ptr)
+{
+	union ehci_shadow	*prev_p = &ehci->pshadow[frame];
+	__hc32			*hw_p = &ehci->periodic[frame];
+	union ehci_shadow	here = *prev_p;
+
+	/* find predecessor of "ptr"; hw and shadow lists are in sync */
+	while (here.ptr && here.ptr != ptr) {
+		prev_p = periodic_next_shadow(ehci, prev_p,
+				Q_NEXT_TYPE(ehci, *hw_p));
+		hw_p = shadow_next_periodic(ehci, &here,
+				Q_NEXT_TYPE(ehci, *hw_p));
+		here = *prev_p;
+	}
+	/* an interrupt entry (at list end) could have been shared */
+	if (!here.ptr)
+		return;
+
+	/* update shadow and hardware lists ... the old "next" pointers
+	 * from ptr may still be in use, the caller updates them.
+	 */
+	*prev_p = *periodic_next_shadow(ehci, &here,
+			Q_NEXT_TYPE(ehci, *hw_p));
+
+	if (!ehci->use_dummy_qh ||
+	    *shadow_next_periodic(ehci, &here, Q_NEXT_TYPE(ehci, *hw_p))
+			!= EHCI_LIST_END(ehci))
+		*hw_p = *shadow_next_periodic(ehci, &here,
+				Q_NEXT_TYPE(ehci, *hw_p));
+	else
+		*hw_p = ehci->dummy->qh_dma;
+}
+
+/* how many of the uframe's 125 usecs are allocated? */
+static unsigned short
+periodic_usecs(struct ehci_hcd *ehci, unsigned frame, unsigned uframe)
+{
+	__hc32			*hw_p = &ehci->periodic[frame];
+	union ehci_shadow	*q = &ehci->pshadow[frame];
+	unsigned		usecs = 0;
+	struct ehci_qh_hw	*hw;
+
+	while (q->ptr) {
+		switch (hc32_to_cpu(ehci, Q_NEXT_TYPE(ehci, *hw_p))) {
+		case Q_TYPE_QH:
+			hw = q->qh->hw;
+			/* is it in the S-mask? */
+			if (hw->hw_info2 & cpu_to_hc32(ehci, 1 << uframe))
+				usecs += q->qh->usecs;
+			/* ... or C-mask? */
+			if (hw->hw_info2 & cpu_to_hc32(ehci,
+					1 << (8 + uframe)))
+				usecs += q->qh->c_usecs;
+			hw_p = &hw->hw_next;
+			q = &q->qh->qh_next;
+			break;
+		default:
+			/* for "save place" FSTNs, count the relevant INTR
+			 * bandwidth from the previous frame
+			 */
+			if (q->fstn->hw_prev != EHCI_LIST_END(ehci)) {
+				ehci_dbg(ehci, "ignoring FSTN cost ...\n");
+			}
+			hw_p = &q->fstn->hw_next;
+			q = &q->fstn->fstn_next;
+			break;
+		case Q_TYPE_ITD:
+			if (q->itd->hw_transaction[uframe])
+				usecs += q->itd->stream->usecs;
+			hw_p = &q->itd->hw_next;
+			q = &q->itd->itd_next;
+			break;
+		case Q_TYPE_SITD:
+			/* is it in the S-mask?  (count SPLIT, DATA) */
+			if (q->sitd->hw_uframe & cpu_to_hc32(ehci,
+					1 << uframe)) {
+				if (q->sitd->hw_fullspeed_ep &
+						cpu_to_hc32(ehci, 1<<31))
+					usecs += q->sitd->stream->usecs;
+				else	/* worst case for OUT start-split */
+					usecs += HS_USECS_ISO(188);
+			}
+
+			/* ... C-mask?  (count CSPLIT, DATA) */
+			if (q->sitd->hw_uframe &
+					cpu_to_hc32(ehci, 1 << (8 + uframe))) {
+				/* worst case for IN complete-split */
+				usecs += q->sitd->stream->c_usecs;
+			}
+
+			hw_p = &q->sitd->hw_next;
+			q = &q->sitd->sitd_next;
+			break;
+		}
+	}
+#ifdef	DEBUG
+	if (usecs > ehci->uframe_periodic_max)
+		ehci_err(ehci, "uframe %d sched overrun: %d usecs\n",
+			frame * 8 + uframe, usecs);
+#endif
+	return usecs;
+}
+
+static int same_tt(struct usb_device *dev1, struct usb_device *dev2)
+{
+	if (!dev1->tt || !dev2->tt)
+		return 0;
+	if (dev1->tt != dev2->tt)
+		return 0;
+	if (dev1->tt->multi)
+		return dev1->ttport == dev2->ttport;
+	else
+		return 1;
+}
+
+/* return true iff the device's transaction translator is available
+ * for a periodic transfer starting at the specified frame, using
+ * all the uframes in the mask.
+ */
+static int tt_no_collision(
+	struct ehci_hcd		*ehci,
+	unsigned		period,
+	struct usb_device	*dev,
+	unsigned		frame,
+	u32			uf_mask
+)
+{
+	if (period == 0)	/* error */
+		return 0;
+
+	/* note bandwidth wastage:  split never follows csplit
+	 * (different dev or endpoint) until the next uframe.
+	 * calling convention doesn't make that distinction.
+	 */
+	for (; frame < ehci->periodic_size; frame += period) {
+		union ehci_shadow	here;
+		__hc32			type;
+		struct ehci_qh_hw	*hw;
+
+		here = ehci->pshadow[frame];
+		type = Q_NEXT_TYPE(ehci, ehci->periodic[frame]);
+		while (here.ptr) {
+			switch (hc32_to_cpu(ehci, type)) {
+			case Q_TYPE_ITD:
+				type = Q_NEXT_TYPE(ehci, here.itd->hw_next);
+				here = here.itd->itd_next;
+				continue;
+			case Q_TYPE_QH:
+				hw = here.qh->hw;
+				if (same_tt(dev, here.qh->dev)) {
+					u32		mask;
+
+					mask = hc32_to_cpu(ehci,
+							hw->hw_info2);
+					/* "knows" no gap is needed */
+					mask |= mask >> 8;
+					if (mask & uf_mask)
+						break;
+				}
+				type = Q_NEXT_TYPE(ehci, hw->hw_next);
+				here = here.qh->qh_next;
+				continue;
+			case Q_TYPE_SITD:
+				if (same_tt(dev, here.sitd->urb->dev)) {
+					u16		mask;
+
+					mask = hc32_to_cpu(ehci, here.sitd
+								->hw_uframe);
+					/* FIXME assumes no gap for IN! */
+					mask |= mask >> 8;
+					if (mask & uf_mask)
+						break;
+				}
+				type = Q_NEXT_TYPE(ehci, here.sitd->hw_next);
+				here = here.sitd->sitd_next;
+				continue;
+			default:
+				ehci_dbg(ehci,
+					"periodic frame %d bogus type %d\n",
+					frame, type);
+			}
+
+			/* collision or error */
+			return 0;
+		}
+	}
+
+	/* no collision */
+	return 1;
+}
+
+static int enable_periodic(struct ehci_hcd *ehci)
+{
+	u32	cmd;
+	int	status;
+
+	if (ehci->periodic_sched++)
+		return 0;
+
+	/* did clearing PSE did take effect yet?
+	 * takes effect only at frame boundaries...
+	 */
+	status = handshake_on_error_set_halt(ehci, &ehci->regs->status,
+					     STS_PSS, 0, 9 * 125);
+	if (status) {
+		usb_hc_died(ehci_to_hcd(ehci));
+		return status;
+	}
+
+	cmd = ehci_readl(ehci, &ehci->regs->command) | CMD_PSE;
+	ehci_writel(ehci, cmd, &ehci->regs->command);
+	/* posted write ... PSS happens later */
+	/* make sure ehci_work scans these */
+	ehci->next_uframe = ehci_read_frame_index(ehci)
+		% (ehci->periodic_size << 3);
+	if (unlikely(ehci->broken_periodic))
+		ehci->last_periodic_enable = ktime_get_real();
+	return 0;
+}
+
+static int disable_periodic(struct ehci_hcd *ehci)
+{
+	u32	cmd;
+	int	status;
+
+	if (--ehci->periodic_sched)
+		return 0;
+
+	if (unlikely(ehci->broken_periodic)) {
+		/* delay experimentally determined */
+		ktime_t safe = ktime_add_us(ehci->last_periodic_enable, 1000);
+		ktime_t now = ktime_get_real();
+		s64 delay = ktime_us_delta(safe, now);
+
+		if (unlikely(delay > 0))
+			udelay(delay);
+	}
+
+	/* did setting PSE not take effect yet?
+	 * takes effect only at frame boundaries...
+	 */
+	status = handshake_on_error_set_halt(ehci, &ehci->regs->status,
+					     STS_PSS, STS_PSS, 9 * 125);
+	if (status) {
+		usb_hc_died(ehci_to_hcd(ehci));
+		return status;
+	}
+
+	cmd = ehci_readl(ehci, &ehci->regs->command) & ~CMD_PSE;
+	ehci_writel(ehci, cmd, &ehci->regs->command);
+	/* posted write ... */
+
+	free_cached_lists(ehci);
+
+	ehci->next_uframe = -1;
+	return 0;
+}
+
+/* periodic schedule slots have iso tds (normal or split) first, then a
+ * sparse tree for active interrupt transfers.
+ *
+ * this just links in a qh; caller guarantees uframe masks are set right.
+ * no FSTN support (yet; ehci 0.96+)
+ */
+static int qh_link_periodic(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	unsigned	i;
+	unsigned	period = qh->period;
+
+	dev_dbg(&qh->dev->dev,
+		"link qh%d-%04x/%p start %d [%d/%d us]\n",
+		period, hc32_to_cpup(ehci, &qh->hw->hw_info2)
+			& (QH_CMASK | QH_SMASK),
+		qh, qh->start, qh->usecs, qh->c_usecs);
+
+	/* high bandwidth, or otherwise every microframe */
+	if (period == 0)
+		period = 1;
+
+	for (i = qh->start; i < ehci->periodic_size; i += period) {
+		union ehci_shadow	*prev = &ehci->pshadow[i];
+		__hc32			*hw_p = &ehci->periodic[i];
+		union ehci_shadow	here = *prev;
+		__hc32			type = 0;
+
+		/* skip the iso nodes at list head */
+		while (here.ptr) {
+			type = Q_NEXT_TYPE(ehci, *hw_p);
+			if (type == cpu_to_hc32(ehci, Q_TYPE_QH))
+				break;
+			prev = periodic_next_shadow(ehci, prev, type);
+			hw_p = shadow_next_periodic(ehci, &here, type);
+			here = *prev;
+		}
+
+		/* sorting each branch by period (slow-->fast)
+		 * enables sharing interior tree nodes
+		 */
+		while (here.ptr && qh != here.qh) {
+			if (qh->period > here.qh->period)
+				break;
+			prev = &here.qh->qh_next;
+			hw_p = &here.qh->hw->hw_next;
+			here = *prev;
+		}
+		/* link in this qh, unless some earlier pass did that */
+		if (qh != here.qh) {
+			qh->qh_next = here;
+			if (here.qh)
+				qh->hw->hw_next = *hw_p;
+			wmb();
+			prev->qh = qh;
+			*hw_p = QH_NEXT(ehci, qh->qh_dma);
+		}
+	}
+	qh->qh_state = QH_STATE_LINKED;
+	qh->xacterrs = 0;
+	qh_get(qh);
+
+	/* update per-qh bandwidth for usbfs */
+	ehci_to_hcd(ehci)->self.bandwidth_allocated += qh->period
+		? ((qh->usecs + qh->c_usecs) / qh->period)
+		: (qh->usecs * 8);
+
+	/* maybe enable periodic schedule processing */
+	return enable_periodic(ehci);
+}
+
+static int qh_unlink_periodic(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	unsigned	i;
+	unsigned	period;
+
+	/* FIXME:						*/
+	/* IF this isn't high speed				*/
+	/*   and this qh is active in the current uframe	*/
+	/*   (and overlay token SplitXstate is false?)		*/
+	/* THEN							*/
+	/*   qh->hw_info1 |= cpu_to_hc32(1 << 7 "ignore");	*/
+
+	/* high bandwidth, or otherwise part of every microframe */
+	period = qh->period;
+	if (!period)
+		period = 1;
+
+	for (i = qh->start; i < ehci->periodic_size; i += period)
+		periodic_unlink(ehci, i, qh);
+
+	/* update per-qh bandwidth for usbfs */
+	ehci_to_hcd(ehci)->self.bandwidth_allocated -= qh->period
+		? ((qh->usecs + qh->c_usecs) / qh->period)
+		: (qh->usecs * 8);
+
+	dev_dbg(&qh->dev->dev,
+		"unlink qh%d-%04x/%p start %d [%d/%d us]\n",
+		qh->period,
+		hc32_to_cpup(ehci, &qh->hw->hw_info2) & (QH_CMASK | QH_SMASK),
+		qh, qh->start, qh->usecs, qh->c_usecs);
+
+	/* qh->qh_next still "live" to HC */
+	qh->qh_state = QH_STATE_UNLINK;
+	qh->qh_next.ptr = NULL;
+	qh_put(qh);
+
+	/* maybe turn off periodic schedule */
+	return disable_periodic(ehci);
+}
+
+static void intr_deschedule(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	unsigned		wait;
+	struct ehci_qh_hw	*hw = qh->hw;
+	int			rc;
+
+	/* If the QH isn't linked then there's nothing we can do
+	 * unless we were called during a giveback, in which case
+	 * qh_completions() has to deal with it.
+	 */
+	if (qh->qh_state != QH_STATE_LINKED) {
+		if (qh->qh_state == QH_STATE_COMPLETING)
+			qh->needs_rescan = 1;
+		return;
+	}
+
+	qh_unlink_periodic(ehci, qh);
+
+	/* simple/paranoid:  always delay, expecting the HC needs to read
+	 * qh->hw_next or finish a writeback after SPLIT/CSPLIT ... and
+	 * expect khubd to clean up after any CSPLITs we won't issue.
+	 * active high speed queues may need bigger delays...
+	 */
+	if (list_empty(&qh->qtd_list)
+			|| (cpu_to_hc32(ehci, QH_CMASK)
+					& hw->hw_info2) != 0)
+		wait = 2;
+	else
+		wait = 55;	/* worst case: 3 * 1024 */
+
+	udelay(wait);
+	qh->qh_state = QH_STATE_IDLE;
+	hw->hw_next = EHCI_LIST_END(ehci);
+	wmb();
+
+	qh_completions(ehci, qh);
+
+	/* reschedule QH iff another request is queued */
+	if (!list_empty(&qh->qtd_list) &&
+			ehci->rh_state == EHCI_RH_RUNNING) {
+		rc = qh_schedule(ehci, qh);
+
+		/* An error here likely indicates handshake failure
+		 * or no space left in the schedule.  Neither fault
+		 * should happen often ...
+		 *
+		 * FIXME kill the now-dysfunctional queued urbs
+		 */
+		if (rc != 0)
+			ehci_err(ehci, "can't reschedule qh %p, err %d\n",
+					qh, rc);
+	}
+}
+
+static int check_period(
+	struct ehci_hcd *ehci,
+	unsigned	frame,
+	unsigned	uframe,
+	unsigned	period,
+	unsigned	usecs
+) {
+	int		claimed;
+
+	/* complete split running into next frame?
+	 * given FSTN support, we could sometimes check...
+	 */
+	if (uframe >= 8)
+		return 0;
+
+	/* convert "usecs we need" to "max already claimed" */
+	usecs = ehci->uframe_periodic_max - usecs;
+
+	/* we "know" 2 and 4 uframe intervals were rejected; so
+	 * for period 0, check _every_ microframe in the schedule.
+	 */
+	if (unlikely(period == 0)) {
+		do {
+			for (uframe = 0; uframe < 7; uframe++) {
+				claimed = periodic_usecs(ehci, frame, uframe);
+				if (claimed > usecs)
+					return 0;
+			}
+		} while ((frame += 1) < ehci->periodic_size);
+
+	/* just check the specified uframe, at that period */
+	} else {
+		do {
+			claimed = periodic_usecs(ehci, frame, uframe);
+			if (claimed > usecs)
+				return 0;
+		} while ((frame += period) < ehci->periodic_size);
+	}
+
+	/* success! */
+	return 1;
+}
+
+static int check_intr_schedule(
+	struct ehci_hcd		*ehci,
+	unsigned		frame,
+	unsigned		uframe,
+	const struct ehci_qh	*qh,
+	__hc32			*c_maskp
+)
+{
+	int		retval = -ENOSPC;
+	u8		mask = 0;
+
+	if (qh->c_usecs && uframe >= 6)		/* FSTN territory? */
+		goto done;
+
+	if (!check_period(ehci, frame, uframe, qh->period, qh->usecs))
+		goto done;
+	if (!qh->c_usecs) {
+		retval = 0;
+		*c_maskp = 0;
+		goto done;
+	}
+
+	/* Make sure this tt's buffer is also available for CSPLITs.
+	 * We pessimize a bit; probably the typical full speed case
+	 * doesn't need the second CSPLIT.
+	 *
+	 * NOTE:  both SPLIT and CSPLIT could be checked in just
+	 * one smart pass...
+	 */
+	mask = 0x03 << (uframe + qh->gap_uf);
+	*c_maskp = cpu_to_hc32(ehci, mask << 8);
+
+	mask |= 1 << uframe;
+	if (tt_no_collision(ehci, qh->period, qh->dev, frame, mask)) {
+		if (!check_period(ehci, frame, uframe + qh->gap_uf + 1,
+					qh->period, qh->c_usecs))
+			goto done;
+		if (!check_period(ehci, frame, uframe + qh->gap_uf,
+					qh->period, qh->c_usecs))
+			goto done;
+		retval = 0;
+	}
+done:
+	return retval;
+}
+
+/* "first fit" scheduling policy used the first time through,
+ * or when the previous schedule slot can't be re-used.
+ */
+static int qh_schedule(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	int		status;
+	unsigned	uframe;
+	__hc32		c_mask;
+	unsigned	frame;		/* 0..(qh->period - 1), or NO_FRAME */
+	struct ehci_qh_hw	*hw = qh->hw;
+
+	qh_refresh(ehci, qh);
+	hw->hw_next = EHCI_LIST_END(ehci);
+	frame = qh->start;
+
+	/* reuse the previous schedule slots, if we can */
+	if (frame < qh->period) {
+		uframe = ffs(hc32_to_cpup(ehci, &hw->hw_info2) & QH_SMASK);
+		status = check_intr_schedule(ehci, frame, --uframe,
+				qh, &c_mask);
+	} else {
+		uframe = 0;
+		c_mask = 0;
+		status = -ENOSPC;
+	}
+
+	/* else scan the schedule to find a group of slots such that all
+	 * uframes have enough periodic bandwidth available.
+	 */
+	if (status) {
+		/* "normal" case, uframing flexible except with splits */
+		if (qh->period) {
+			int		i;
+
+			for (i = qh->period; status && i > 0; --i) {
+				frame = ++ehci->random_frame % qh->period;
+				for (uframe = 0; uframe < 8; uframe++) {
+					status = check_intr_schedule(ehci,
+							frame, uframe, qh,
+							&c_mask);
+					if (status == 0)
+						break;
+				}
+			}
+
+		/* qh->period == 0 means every uframe */
+		} else {
+			frame = 0;
+			status = check_intr_schedule(ehci, 0, 0, qh, &c_mask);
+		}
+		if (status)
+			goto done;
+		qh->start = frame;
+
+		/* reset S-frame and (maybe) C-frame masks */
+		hw->hw_info2 &= cpu_to_hc32(ehci, ~(QH_CMASK | QH_SMASK));
+		hw->hw_info2 |= qh->period
+			? cpu_to_hc32(ehci, 1 << uframe)
+			: cpu_to_hc32(ehci, QH_SMASK);
+		hw->hw_info2 |= c_mask;
+	} else
+		ehci_dbg(ehci, "reused qh %p schedule\n", qh);
+
+	/* stuff into the periodic schedule */
+	status = qh_link_periodic(ehci, qh);
+done:
+	return status;
+}
+
+static int intr_submit(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	struct list_head	*qtd_list,
+	gfp_t			mem_flags
+) {
+	unsigned		epnum;
+	unsigned long		flags;
+	struct ehci_qh		*qh;
+	int			status;
+	struct list_head	empty;
+
+	/* get endpoint and transfer/schedule data */
+	epnum = urb->ep->desc.bEndpointAddress;
+
+	spin_lock_irqsave(&ehci->lock, flags);
+
+	if (unlikely(!HCD_HW_ACCESSIBLE(ehci_to_hcd(ehci)))) {
+		status = -ESHUTDOWN;
+		goto done_not_linked;
+	}
+	status = usb_hcd_link_urb_to_ep(ehci_to_hcd(ehci), urb);
+	if (unlikely(status))
+		goto done_not_linked;
+
+	/* get qh and force any scheduling errors */
+	INIT_LIST_HEAD(&empty);
+	qh = qh_append_tds(ehci, urb, &empty, epnum, &urb->ep->hcpriv);
+	if (qh == NULL) {
+		status = -ENOMEM;
+		goto done;
+	}
+	if (qh->qh_state == QH_STATE_IDLE) {
+		status = qh_schedule(ehci, qh);
+		if (status != 0)
+			goto done;
+	}
+
+	/* then queue the urb's tds to the qh */
+	qh = qh_append_tds(ehci, urb, qtd_list, epnum, &urb->ep->hcpriv);
+	BUG_ON(qh == NULL);
+
+	/* ... update usbfs periodic stats */
+	ehci_to_hcd(ehci)->self.bandwidth_int_reqs++;
+
+done:
+	if (unlikely(status))
+		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
+done_not_linked:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	if (status)
+		qtd_list_free(ehci, urb, qtd_list);
+
+	return status;
+}
+
+/* ehci_iso_stream ops work with both ITD and SITD */
+
+static struct ehci_iso_stream *
+iso_stream_alloc(gfp_t mem_flags)
+{
+	struct ehci_iso_stream *stream;
+
+	stream = kzalloc(sizeof(*stream), mem_flags);
+	if (likely(stream != NULL)) {
+		INIT_LIST_HEAD(&stream->td_list);
+		INIT_LIST_HEAD(&stream->free_list);
+		stream->next_uframe = -1;
+		stream->refcount = 1;
+	}
+	return stream;
+}
+
+static void
+iso_stream_init(
+	struct ehci_hcd		*ehci,
+	struct ehci_iso_stream	*stream,
+	struct usb_device	*dev,
+	int			pipe,
+	unsigned		interval
+)
+{
+	static const u8 smask_out[] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f };
+
+	u32			buf1;
+	unsigned		epnum, maxp;
+	int			is_input;
+	long			bandwidth;
+	u32			ehci_speed;
+
+	/*
+	 * this might be a "high bandwidth" highspeed endpoint,
+	 * as encoded in the ep descriptor's wMaxPacket field
+	 */
+	epnum = usb_pipeendpoint(pipe);
+	is_input = usb_pipein(pipe) ? USB_DIR_IN : 0;
+	maxp = usb_maxpacket(dev, pipe, !is_input);
+	if (is_input) {
+		buf1 = (1 << 11);
+	} else {
+		buf1 = 0;
+	}
+	/* add for fusbh200 */
+	ehci_speed = ehci_port_speed(ehci, 0);
+	if (ehci_is_TDI(ehci)) {
+		/* we use 125us as unit */
+		if (ehci_speed != USB_PORT_STAT_HIGH_SPEED)
+			interval = interval << 3;
+	}
+	if ((dev->speed == USB_SPEED_HIGH) ||
+		((ehci_is_TDI(ehci)) &&
+		(ehci_speed != USB_PORT_STAT_HIGH_SPEED))) {
+		unsigned multi = hb_mult(maxp);
+
+		/* knows about ITD vs SITD */
+		if (dev->speed == USB_SPEED_HIGH)
+			stream->highspeed = 1;
+
+		maxp = max_packet(maxp);
+		buf1 |= maxp;
+		maxp *= multi;
+
+		stream->buf0 = cpu_to_hc32(ehci, (epnum << 8) | dev->devnum);
+		stream->buf1 = cpu_to_hc32(ehci, buf1);
+		stream->buf2 = cpu_to_hc32(ehci, multi);
+
+		/* usbfs wants to report the average usecs per frame tied up
+		 * when transfers on this endpoint are scheduled ...
+		 */
+		if (ehci_speed != USB_PORT_STAT_HIGH_SPEED) {/*full speed */
+			stream->usecs =
+				NS_TO_US(usb_calc_bus_time(dev->speed, is_input, 1, maxp));
+			/* convert from FS to HS, use 125us as unit */
+			stream->usecs /= 8;
+		} else
+			stream->usecs = HS_USECS_ISO(maxp);
+
+		bandwidth = stream->usecs * 8;
+		bandwidth /= interval;
+
+	} else {
+		u32		addr;
+		int		think_time;
+		int		hs_transfers;
+
+		addr = dev->ttport << 24;
+		if (!ehci_is_TDI(ehci)
+				|| (dev->tt->hub !=
+					ehci_to_hcd(ehci)->self.root_hub))
+			addr |= dev->tt->hub->devnum << 16;
+		addr |= epnum << 8;
+		addr |= dev->devnum;
+		stream->usecs = HS_USECS_ISO(maxp);
+		think_time = dev->tt ? dev->tt->think_time : 0;
+		stream->tt_usecs = NS_TO_US(think_time + usb_calc_bus_time(
+				dev->speed, is_input, 1, maxp));
+		hs_transfers = max(1u, (maxp + 187) / 188);
+		if (is_input) {
+			u32	tmp;
+
+			addr |= 1 << 31;
+			stream->c_usecs = stream->usecs;
+			stream->usecs = HS_USECS_ISO(1);
+			stream->raw_mask = 1;
+
+			/* c-mask as specified in USB 2.0 11.18.4 3.c */
+			tmp = (1 << (hs_transfers + 2)) - 1;
+			stream->raw_mask |= tmp << (8 + 2);
+		} else
+			stream->raw_mask = smask_out[hs_transfers - 1];
+		bandwidth = stream->usecs + stream->c_usecs;
+		bandwidth /= interval << 3;
+
+		/* stream->splits gets created from raw_mask later */
+		stream->address = cpu_to_hc32(ehci, addr);
+	}
+	stream->bandwidth = bandwidth;
+
+	stream->udev = dev;
+
+	stream->bEndpointAddress = is_input | epnum;
+	stream->interval = interval;
+	stream->maxp = maxp;
+}
+
+static void
+iso_stream_put(struct ehci_hcd *ehci, struct ehci_iso_stream *stream)
+{
+	u32 ehci_speed = ehci_port_speed(ehci, 0);
+
+	stream->refcount--;
+
+	/* free whenever just a dev->ep reference remains.
+	 * not like a QH -- no persistent state (toggle, halt)
+	 */
+	if (stream->refcount == 1) {
+		while (!list_empty(&stream->free_list)) {
+			struct list_head	*entry;
+
+			entry = stream->free_list.next;
+			list_del(entry);
+
+			/* knows about ITD vs SITD */
+			if ((stream->highspeed) || ((ehci_is_TDI(ehci)) &&
+				(ehci_speed != USB_PORT_STAT_HIGH_SPEED))) {
+				struct ehci_itd		*itd;
+
+				itd = list_entry(entry, struct ehci_itd,
+						itd_list);
+				dma_pool_free(ehci->itd_pool, itd,
+						itd->itd_dma);
+			} else {
+				struct ehci_sitd	*sitd;
+
+				sitd = list_entry(entry, struct ehci_sitd,
+						sitd_list);
+				dma_pool_free(ehci->sitd_pool, sitd,
+						sitd->sitd_dma);
+			}
+		}
+
+		stream->bEndpointAddress &= 0x0f;
+		if (stream->ep)
+			stream->ep->hcpriv = NULL;
+
+		kfree(stream);
+	}
+}
+
+static inline struct ehci_iso_stream *
+iso_stream_get(struct ehci_iso_stream *stream)
+{
+	if (likely(stream != NULL))
+		stream->refcount++;
+	return stream;
+}
+
+static struct ehci_iso_stream *
+iso_stream_find(struct ehci_hcd *ehci, struct urb *urb)
+{
+	unsigned		epnum;
+	struct ehci_iso_stream	*stream;
+	struct usb_host_endpoint *ep;
+	unsigned long		flags;
+
+	epnum = usb_pipeendpoint(urb->pipe);
+	if (usb_pipein(urb->pipe))
+		ep = urb->dev->ep_in[epnum];
+	else
+		ep = urb->dev->ep_out[epnum];
+
+	spin_lock_irqsave(&ehci->lock, flags);
+	stream = ep->hcpriv;
+
+	if (unlikely(stream == NULL)) {
+		stream = iso_stream_alloc(GFP_ATOMIC);
+		if (likely(stream != NULL)) {
+			/* dev->ep owns the initial refcount */
+			ep->hcpriv = stream;
+			stream->ep = ep;
+			iso_stream_init(ehci, stream, urb->dev, urb->pipe,
+					urb->interval);
+		}
+
+	/* if dev->ep[epnum] is a QH, hw is set */
+	} else if (unlikely(stream->hw != NULL)) {
+		ehci_dbg(ehci, "dev %s ep%d%s, not iso??\n",
+			urb->dev->devpath, epnum,
+			usb_pipein(urb->pipe) ? "in" : "out");
+		stream = NULL;
+	}
+	/* caller guarantees an eventual matching iso_stream_put */
+	stream = iso_stream_get(stream);
+
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	return stream;
+}
+
+/* ehci_iso_sched ops can be ITD-only or SITD-only */
+
+static struct ehci_iso_sched *
+iso_sched_alloc(unsigned packets, gfp_t mem_flags)
+{
+	struct ehci_iso_sched	*iso_sched;
+	int			size = sizeof(*iso_sched);
+
+	size += packets * sizeof(struct ehci_iso_packet);
+	iso_sched = kzalloc(size, mem_flags);
+	if (likely(iso_sched != NULL)) {
+		INIT_LIST_HEAD(&iso_sched->td_list);
+	}
+	return iso_sched;
+}
+
+static inline void
+itd_sched_init(
+	struct ehci_hcd		*ehci,
+	struct ehci_iso_sched	*iso_sched,
+	struct ehci_iso_stream	*stream,
+	struct urb		*urb
+)
+{
+	unsigned	i;
+	dma_addr_t	dma = urb->transfer_dma;
+
+	/* how many uframes are needed for these transfers */
+	iso_sched->span = urb->number_of_packets * stream->interval;
+
+	/* figure out per-uframe itd fields that we'll need later
+	 * when we fit new itds into the schedule.
+	 */
+	for (i = 0; i < urb->number_of_packets; i++) {
+		struct ehci_iso_packet	*uframe = &iso_sched->packet[i];
+		unsigned		length;
+		dma_addr_t		buf;
+		u32			trans;
+
+		length = urb->iso_frame_desc[i].length;
+		buf = dma + urb->iso_frame_desc[i].offset;
+
+		trans = EHCI_ISOC_ACTIVE;
+		trans |= buf & 0x0fff;
+		if (unlikely(((i + 1) == urb->number_of_packets))
+				&& !(urb->transfer_flags & URB_NO_INTERRUPT))
+			trans |= EHCI_ITD_IOC;
+		trans |= length << 16;
+		uframe->transaction = cpu_to_hc32(ehci, trans);
+
+		/* might need to cross a buffer page within a uframe */
+		uframe->bufp = (buf & ~(u64)0x0fff);
+		buf += length;
+		if (unlikely((uframe->bufp != (buf & ~(u64)0x0fff))))
+			uframe->cross = 1;
+	}
+}
+
+static void
+iso_sched_free(
+	struct ehci_iso_stream	*stream,
+	struct ehci_iso_sched	*iso_sched
+)
+{
+	if (!iso_sched)
+		return;
+	/* caller must hold ehci->lock! */
+	list_splice(&iso_sched->td_list, &stream->free_list);
+	kfree(iso_sched);
+}
+
+static int
+itd_urb_transaction(
+	struct ehci_iso_stream	*stream,
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	gfp_t			mem_flags
+)
+{
+	struct ehci_itd		*itd;
+	dma_addr_t		itd_dma;
+	int			i;
+	unsigned		num_itds;
+	struct ehci_iso_sched	*sched;
+	unsigned long		flags;
+
+	sched = iso_sched_alloc(urb->number_of_packets, mem_flags);
+	if (unlikely(sched == NULL))
+		return -ENOMEM;
+
+	itd_sched_init(ehci, sched, stream, urb);
+
+	if (urb->interval < 8)
+		num_itds = 1 + (sched->span + 7) / 8;
+	else
+		num_itds = urb->number_of_packets;
+	/* allocate/init ITDs */
+	spin_lock_irqsave(&ehci->lock, flags);
+	for (i = 0; i < num_itds; i++) {
+
+		/* free_list.next might be cache-hot ... but maybe
+		 * the HC caches it too. avoid that issue for now.
+		 */
+
+		/* prefer previously-allocated itds */
+		if (likely(!list_empty(&stream->free_list))) {
+			itd = list_entry(stream->free_list.prev,
+					struct ehci_itd, itd_list);
+			list_del(&itd->itd_list);
+			itd_dma = itd->itd_dma;
+		} else {
+			spin_unlock_irqrestore(&ehci->lock, flags);
+			itd = dma_pool_alloc(ehci->itd_pool, mem_flags,
+					&itd_dma);
+			spin_lock_irqsave(&ehci->lock, flags);
+			if (!itd) {
+				iso_sched_free(stream, sched);
+				spin_unlock_irqrestore(&ehci->lock, flags);
+				return -ENOMEM;
+			}
+		}
+		memset(itd, 0, sizeof(*itd));
+		itd->itd_dma = itd_dma;
+		list_add(&itd->itd_list, &sched->td_list);
+	}
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+	/* temporarily store schedule info in hcpriv */
+	urb->hcpriv = sched;
+	urb->error_count = 0;
+	return 0;
+}
+
+static inline int
+itd_slot_ok(
+	struct ehci_hcd		*ehci,
+	u32			mod,
+	u32			uframe,
+	u8			usecs,
+	u32			period
+)
+{
+	uframe %= period;
+	do {
+		/* can't commit more than uframe_periodic_max usec */
+		if (periodic_usecs(ehci, uframe >> 3, uframe & 0x7)
+				> (ehci->uframe_periodic_max - usecs))
+			return 0;
+
+		/* we know urb->interval is 2^N uframes */
+		uframe += period;
+	} while (uframe < mod);
+	return 1;
+}
+
+/*
+ * This scheduler plans almost as far into the future as it has actual
+ * periodic schedule slots.  (Affected by TUNE_FLS, which defaults to
+ * "as small as possible" to be cache-friendlier.)  That limits the size
+ * transfers you can stream reliably; avoid more than 64 msec per urb.
+ * Also avoid queue depths of less than ehci's worst irq latency (affected
+ * by the per-urb URB_NO_INTERRUPT hint, the log2_irq_thresh module parameter,
+ * and other factors); or more than about 230 msec total (for portability,
+ * given EHCI_TUNE_FLS and the slop).  Or, write a smarter scheduler!
+ */
+
+#define SCHEDULE_SLOP	80	/* microframes */
+
+static int
+iso_stream_schedule(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	struct ehci_iso_stream	*stream
+)
+{
+	u32			now, next, start, period, span;
+	int			status;
+	unsigned		mod = ehci->periodic_size << 3;
+	struct ehci_iso_sched	*sched = urb->hcpriv;
+
+	period = urb->interval;
+	span = sched->span;
+
+	if (span > mod - SCHEDULE_SLOP) {
+		ehci_dbg(ehci, "iso request %p too long\n", urb);
+		status = -EFBIG;
+		goto fail;
+	}
+
+	now = ehci_read_frame_index(ehci) & (mod - 1);
+
+	/* Typical case: reuse current schedule, stream is still active.
+	 * Hopefully there are no gaps from the host falling behind
+	 * (irq delays etc), but if there are we'll take the next
+	 * slot in the schedule, implicitly assuming URB_ISO_ASAP.
+	 */
+	if (likely(!list_empty(&stream->td_list))) {
+		u32	excess;
+
+		/* Fell behind (by up to twice the slop amount)?
+		 * We decide based on the time of the last currently-scheduled
+		 * slot, not the time of the next available slot.
+		 */
+		excess = (stream->next_uframe - period - now) & (mod - 1);
+		if (excess >= mod - 2 * SCHEDULE_SLOP)
+			start = now + excess - mod + period *
+					DIV_ROUND_UP(mod - excess, period);
+		else
+			start = now + excess + period;
+		if (start - now >= mod) {
+			ehci_dbg(ehci, "request %p would overflow (%d+%d >= %d)\n",
+					urb, start - now - period, period,
+					mod);
+			status = -EFBIG;
+			goto fail;
+		}
+	}
+
+	/* need to schedule; when's the next (u)frame we could start?
+	 * this is bigger than ehci->i_thresh allows; scheduling itself
+	 * isn't free, the slop should handle reasonably slow cpus.  it
+	 * can also help high bandwidth if the dma and irq loads don't
+	 * jump until after the queue is primed.
+	 */
+	else {
+		int done = 0;
+		start = SCHEDULE_SLOP + (now & ~0x07);
+
+		/* NOTE:  assumes URB_ISO_ASAP, to limit complexity/bugs */
+
+		/* find a uframe slot with enough bandwidth.
+		 * Early uframes are more precious because full-speed
+		 * iso IN transfers can't use late uframes,
+		 * and therefore they should be allocated last.
+		 */
+		next = start;
+		start += period;
+		do {
+			start--;
+			/* check schedule: enough space? */
+			if (itd_slot_ok(ehci, mod, start, stream->usecs, period))
+				done = 1;
+
+		} while (start > next && !done);
+
+		/* no room in the schedule */
+		if (!done) {
+			ehci_dbg(ehci, "iso resched full %p (now %d max %d)\n",
+				urb, now, now + mod);
+			status = -ENOSPC;
+			goto fail;
+		}
+	}
+
+	/* Tried to schedule too far into the future? */
+	if (unlikely(start - now + span - period
+				>= mod - 2 * SCHEDULE_SLOP)) {
+		ehci_dbg(ehci, "request %p would overflow (%d+%d >= %d)\n",
+				urb, start - now, span - period,
+				mod - 2 * SCHEDULE_SLOP);
+		status = -EFBIG;
+		goto fail;
+	}
+	stream->next_uframe = start & (mod - 1);
+
+	/* report high speed start in uframes; full speed, in frames */
+	urb->start_frame = stream->next_uframe;
+
+	if (!stream->highspeed)
+		urb->start_frame >>= 3;
+
+	return 0;
+
+ fail:
+	iso_sched_free(stream, sched);
+	urb->hcpriv = NULL;
+	return status;
+}
+
+static inline void
+itd_init(struct ehci_hcd *ehci, struct ehci_iso_stream *stream,
+		struct ehci_itd *itd)
+{
+	int i;
+
+	/* it's been recently zeroed */
+	itd->hw_next = EHCI_LIST_END(ehci);
+	itd->hw_bufp[0] = stream->buf0;
+	itd->hw_bufp[1] = stream->buf1;
+	itd->hw_bufp[2] = stream->buf2;
+
+	for (i = 0; i < 8; i++)
+		itd->index[i] = -1;
+
+	/* All other fields are filled when scheduling */
+}
+
+static inline void
+itd_patch(
+	struct ehci_hcd		*ehci,
+	struct ehci_itd		*itd,
+	struct ehci_iso_sched	*iso_sched,
+	unsigned		index,
+	u16			uframe
+)
+{
+	struct ehci_iso_packet	*uf = &iso_sched->packet[index];
+	unsigned		pg = itd->pg;
+
+	uframe &= 0x07;
+	itd->index[uframe] = index;
+
+	itd->hw_transaction[uframe] = uf->transaction;
+	itd->hw_transaction[uframe] |= cpu_to_hc32(ehci, pg << 12);
+	itd->hw_bufp[pg] |= cpu_to_hc32(ehci, uf->bufp & ~(u32)0);
+	itd->hw_bufp_hi[pg] |= cpu_to_hc32(ehci, (u32)(uf->bufp >> 32));
+
+	/* iso_frame_desc[].offset must be strictly increasing */
+	if (unlikely(uf->cross)) {
+		u64	bufp = uf->bufp + 4096;
+
+		itd->pg = ++pg;
+		itd->hw_bufp[pg] |= cpu_to_hc32(ehci, bufp & ~(u32)0);
+		itd->hw_bufp_hi[pg] |= cpu_to_hc32(ehci, (u32)(bufp >> 32));
+	}
+}
+
+static inline void
+itd_link(struct ehci_hcd *ehci, unsigned frame, struct ehci_itd *itd)
+{
+	union ehci_shadow	*prev = &ehci->pshadow[frame];
+	__hc32			*hw_p = &ehci->periodic[frame];
+	union ehci_shadow	here = *prev;
+	__hc32			type = 0;
+
+	/* skip any iso nodes which might belong to previous microframes */
+	while (here.ptr) {
+		type = Q_NEXT_TYPE(ehci, *hw_p);
+		if (type == cpu_to_hc32(ehci, Q_TYPE_QH))
+			break;
+		prev = periodic_next_shadow(ehci, prev, type);
+		hw_p = shadow_next_periodic(ehci, &here, type);
+		here = *prev;
+	}
+	itd->itd_next = here;
+	itd->hw_next = *hw_p;
+	prev->itd = itd;
+	itd->frame = frame;
+	wmb();
+	*hw_p = cpu_to_hc32(ehci, itd->itd_dma | Q_TYPE_ITD);
+}
+
+/* fit urb's itds into the selected schedule slot; activate as needed */
+static int
+itd_link_urb(
+	struct ehci_hcd		*ehci,
+	struct urb		*urb,
+	unsigned		mod,
+	struct ehci_iso_stream	*stream
+)
+{
+	int			packet;
+	unsigned		next_uframe, uframe, frame;
+	struct ehci_iso_sched	*iso_sched = urb->hcpriv;
+	struct ehci_itd		*itd;
+
+	next_uframe = stream->next_uframe & (mod - 1);
+
+	if (unlikely(list_empty(&stream->td_list))) {
+		ehci_to_hcd(ehci)->self.bandwidth_allocated
+				+= stream->bandwidth;
+		ehci_vdbg(ehci,
+			"schedule devp %s ep%d%s-iso period %d start %d.%d\n",
+			urb->dev->devpath, stream->bEndpointAddress & 0x0f,
+			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out",
+			urb->interval,
+			next_uframe >> 3, next_uframe & 0x7);
+	}
+
+	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs++;
+
+	/* fill iTDs uframe by uframe */
+	for (packet = 0, itd = NULL; packet < urb->number_of_packets;) {
+		if (itd == NULL) {
+			/* ASSERT:  we have all necessary itds */
+			/* BUG_ON (list_empty (&iso_sched->td_list)); */
+
+			/* ASSERT:  no itds for this endpoint in this uframe */
+
+			itd = list_entry(iso_sched->td_list.next,
+					struct ehci_itd, itd_list);
+			list_move_tail(&itd->itd_list, &stream->td_list);
+			itd->stream = iso_stream_get(stream);
+			itd->urb = urb;
+			itd_init(ehci, stream, itd);
+		}
+
+		uframe = next_uframe & 0x07;
+		frame = next_uframe >> 3;
+
+		itd_patch(ehci, itd, iso_sched, packet, uframe);
+
+		next_uframe += stream->interval;
+		next_uframe &= mod - 1;
+		packet++;
+
+		/* link completed itds into the schedule */
+		if (((next_uframe >> 3) != frame)
+				|| packet == urb->number_of_packets) {
+			itd_link(ehci, frame & (ehci->periodic_size - 1), itd);
+			itd = NULL;
+		}
+	}
+	stream->next_uframe = next_uframe;
+
+	/* don't need that schedule data any more */
+	iso_sched_free(stream, iso_sched);
+	urb->hcpriv = NULL;
+
+	timer_action(ehci, TIMER_IO_WATCHDOG);
+	return enable_periodic(ehci);
+}
+
+#define	ISO_ERRS (EHCI_ISOC_BUF_ERR | EHCI_ISOC_BABBLE | EHCI_ISOC_XACTERR)
+
+/* Process and recycle a completed ITD.  Return true iff its urb completed,
+ * and hence its completion callback probably added things to the hardware
+ * schedule.
+ *
+ * Note that we carefully avoid recycling this descriptor until after any
+ * completion callback runs, so that it won't be reused quickly.  That is,
+ * assuming (a) no more than two urbs per frame on this endpoint, and also
+ * (b) only this endpoint's completions submit URBs.  It seems some silicon
+ * corrupts things if you reuse completed descriptors very quickly...
+ */
+static unsigned
+itd_complete(
+	struct ehci_hcd	*ehci,
+	struct ehci_itd	*itd
+) {
+	struct urb				*urb = itd->urb;
+	struct usb_iso_packet_descriptor	*desc;
+	u32					t;
+	unsigned				uframe;
+	int					urb_index = -1;
+	struct ehci_iso_stream			*stream = itd->stream;
+	struct usb_device			*dev;
+	unsigned				retval = false;
+	u32					itdDir = 0;
+
+	/* for each uframe with a packet */
+	for (uframe = 0; uframe < 8; uframe++) {
+		itdDir = hc32_to_cpup(ehci,
+			&itd->hw_bufp[1]) & (1 << 11);
+		if (likely(itd->index[uframe] == -1))
+			continue;
+		urb_index = itd->index[uframe];
+		desc = &urb->iso_frame_desc[urb_index];
+
+		t = hc32_to_cpup(ehci, &itd->hw_transaction[uframe]);
+		itd->hw_transaction[uframe] = 0;
+		/* report transfer status */
+		if (unlikely(t & ISO_ERRS)) {
+			urb->error_count++;
+			if (t & EHCI_ISOC_BUF_ERR)
+				desc->status = usb_pipein(urb->pipe)
+					? -ENOSR  /* hc couldn't read */
+					: -ECOMM; /* hc couldn't write */
+			else if (t & EHCI_ISOC_BABBLE)
+				desc->status = -EOVERFLOW;
+			else /* (t & EHCI_ISOC_XACTERR) */
+				desc->status = -EPROTO;
+
+			/* HC need not update length with this error */
+			/* add for fusbh200 */
+			if (!(t & EHCI_ISOC_BABBLE)) {
+				/* Faraday EHCI HC decrement the counter of the transaction
+				length for itd ISO IN (It is differ with EHCI Spec) So the
+				length means how many remaining bytes have not been sent by
+				host for ISO IN */
+				if (itdDir) {
+					desc->actual_length = desc->length - EHCI_ITD_LENGTH(t);
+					urb->actual_length += desc->actual_length;
+				} else {
+					desc->actual_length = EHCI_ITD_LENGTH(t);
+					urb->actual_length += desc->actual_length;
+				}
+				if (desc->actual_length < 0)
+					ehci_err(ehci, "Error: length < 0 (%x)\n",
+						desc->actual_length);
+			}
+
+
+		} else if (likely((t & EHCI_ISOC_ACTIVE) == 0)) {
+			desc->status = 0;
+			/* add for fusbh200 */
+			if (itdDir)
+				desc->actual_length =
+					desc->length - EHCI_ITD_LENGTH(t);
+			else
+				desc->actual_length = EHCI_ITD_LENGTH(t);
+			urb->actual_length += desc->actual_length;
+		} else {
+			/* URB was too late */
+			desc->status = -EXDEV;
+		}
+	}
+
+
+	/* handle completion now? */
+	if (likely((urb_index + 1) != urb->number_of_packets))
+		goto done;
+
+	/* ASSERT: it's really the last itd for this urb
+	list_for_each_entry (itd, &stream->td_list, itd_list)
+		BUG_ON (itd->urb == urb);
+	 */
+
+	/* give urb back to the driver; completion often (re)submits */
+	dev = urb->dev;
+	ehci_urb_done(ehci, urb, 0);
+	retval = true;
+	urb = NULL;
+	(void) disable_periodic(ehci);
+	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
+
+	if (unlikely(list_is_singular(&stream->td_list))) {
+		ehci_to_hcd(ehci)->self.bandwidth_allocated
+				-= stream->bandwidth;
+		ehci_vdbg(ehci,
+			"deschedule devp %s ep%d%s-iso\n",
+			dev->devpath, stream->bEndpointAddress & 0x0f,
+			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
+	}
+	iso_stream_put(ehci, stream);
+
+done:
+	itd->urb = NULL;
+	if (ehci->clock_frame != itd->frame || itd->index[7] != -1) {
+		/* OK to recycle this ITD now. */
+		itd->stream = NULL;
+		list_move(&itd->itd_list, &stream->free_list);
+		iso_stream_put(ehci, stream);
+	} else {
+		/* HW might remember this ITD, so we can't recycle it yet.
+		 * Move it to a safe place until a new frame starts.
+		 */
+		list_move(&itd->itd_list, &ehci->cached_itd_list);
+		if (stream->refcount == 2) {
+			/* If iso_stream_put() were called here, stream
+			 * would be freed.  Instead, just prevent reuse.
+			 */
+			stream->ep->hcpriv = NULL;
+			stream->ep = NULL;
+		}
+	}
+	return retval;
+}
+
+static int itd_submit(struct ehci_hcd *ehci, struct urb *urb,
+	gfp_t mem_flags)
+{
+	int			status = -EINVAL;
+	unsigned long		flags;
+	struct ehci_iso_stream	*stream;
+
+	/* Get iso_stream head */
+	stream = iso_stream_find(ehci, urb);
+	if (unlikely(stream == NULL)) {
+		ehci_dbg(ehci, "can't get iso stream\n");
+		return -ENOMEM;
+	}
+	if (ehci_is_TDI(ehci)) {
+		u32 ehci_speed = ehci_port_speed(ehci, 0);
+		if (unlikely(urb->interval != stream->interval) &&
+			(ehci_speed == USB_PORT_STAT_HIGH_SPEED)) {
+			ehci_dbg(ehci,
+				"can't change iso interval %d --> %d\n",
+				stream->interval, urb->interval);
+			goto done;
+		}
+	} else {
+		if (unlikely(urb->interval != stream->interval)) {
+			ehci_dbg(ehci,
+				"can't change iso interval %d --> %d\n",
+				stream->interval, urb->interval);
+			goto done;
+		}
+	}
+
+#ifdef EHCI_URB_TRACE
+	ehci_dbg(ehci,
+		"%s %s urb %p ep%d%s len %d, %d pkts %d uframes[%p]\n",
+		__func__, urb->dev->devpath, urb,
+		usb_pipeendpoint(urb->pipe),
+		usb_pipein(urb->pipe) ? "in" : "out",
+		urb->transfer_buffer_length,
+		urb->number_of_packets, urb->interval,
+		stream);
+#endif
+
+	/* allocate ITDs w/o locking anything */
+	status = itd_urb_transaction(stream, ehci, urb, mem_flags);
+	if (unlikely(status < 0)) {
+		ehci_dbg(ehci, "can't init itds\n");
+		goto done;
+	}
+
+	/* schedule ... need to lock */
+	spin_lock_irqsave(&ehci->lock, flags);
+	if (unlikely(!HCD_HW_ACCESSIBLE(ehci_to_hcd(ehci)))) {
+		status = -ESHUTDOWN;
+		goto done_not_linked;
+	}
+	status = usb_hcd_link_urb_to_ep(ehci_to_hcd(ehci), urb);
+	if (unlikely(status))
+		goto done_not_linked;
+	status = iso_stream_schedule(ehci, urb, stream);
+	if (likely(status == 0))
+		itd_link_urb(ehci, urb, ehci->periodic_size << 3, stream);
+	else
+		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
+done_not_linked:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+done:
+	if (unlikely(status < 0))
+		iso_stream_put(ehci, stream);
+	return status;
+}
+
+static void free_cached_lists(struct ehci_hcd *ehci)
+{
+	struct ehci_itd *itd, *n;
+	struct ehci_sitd *sitd, *sn;
+
+	list_for_each_entry_safe(itd, n, &ehci->cached_itd_list, itd_list) {
+		struct ehci_iso_stream	*stream = itd->stream;
+		itd->stream = NULL;
+		list_move(&itd->itd_list, &stream->free_list);
+		iso_stream_put(ehci, stream);
+	}
+
+	list_for_each_entry_safe(sitd, sn, &ehci->cached_sitd_list, sitd_list) {
+		struct ehci_iso_stream	*stream = sitd->stream;
+		sitd->stream = NULL;
+		list_move(&sitd->sitd_list, &stream->free_list);
+		iso_stream_put(ehci, stream);
+	}
+}
+
+static void
+scan_periodic(struct ehci_hcd *ehci)
+{
+	unsigned	now_uframe, frame, clock, clock_frame, mod;
+	unsigned	modified;
+	unsigned	cur_frame;
+
+	mod = ehci->periodic_size << 3;
+	/*
+	 * When running, scan from last scan point up to "now"
+	 * else clean up by scanning everything that's left.
+	 * Touches as few pages as possible:  cache-friendly.
+	 */
+	now_uframe = ehci->next_uframe;
+	if (ehci->rh_state == EHCI_RH_RUNNING) {
+		clock = ehci_read_frame_index(ehci);
+		clock_frame = (clock >> 3) & (ehci->periodic_size - 1);
+	} else  {
+		clock = now_uframe + mod - 1;
+		clock_frame = -1;
+	}
+	if (ehci->clock_frame != clock_frame) {
+		free_cached_lists(ehci);
+		ehci->clock_frame = clock_frame;
+	}
+	cur_frame = clock_frame;
+	clock &= mod - 1;
+	clock_frame = clock >> 3;
+	++ehci->periodic_stamp;
+	for (;;) {
+		union ehci_shadow	q, *q_p;
+		__hc32			type, *hw_p;
+		unsigned		incomplete = false;
+
+		frame = now_uframe >> 3;
+
+restart:
+		/* scan each element in frame's queue for completions */
+		q_p = &ehci->pshadow[frame];
+		hw_p = &ehci->periodic[frame];
+		q.ptr = q_p->ptr;
+		type = Q_NEXT_TYPE(ehci, *hw_p);
+		modified = 0;
+
+		while (q.ptr != NULL) {
+			unsigned		uf;
+			union ehci_shadow	temp;
+			int			live;
+
+			live = (ehci->rh_state == EHCI_RH_RUNNING);
+			switch (hc32_to_cpu(ehci, type)) {
+			case Q_TYPE_QH:
+				/* handle any completions */
+				temp.qh = qh_get(q.qh);
+				type = Q_NEXT_TYPE(ehci, q.qh->hw->hw_next);
+				q = q.qh->qh_next;
+				if (temp.qh->stamp != ehci->periodic_stamp) {
+					modified = qh_completions(ehci, temp.qh);
+					if (!modified)
+						temp.qh->stamp = ehci->periodic_stamp;
+					if (unlikely(list_empty(&temp.qh->qtd_list) ||
+							temp.qh->needs_rescan))
+						intr_deschedule(ehci, temp.qh);
+				}
+				qh_put(temp.qh);
+				break;
+			case Q_TYPE_FSTN:
+				/* for "save place" FSTNs, look at QH entries
+				 * in the previous frame for completions.
+				 */
+				if (q.fstn->hw_prev != EHCI_LIST_END(ehci)) {
+					ehci_dbg(ehci, "ignoring FSTN cost ...\n");
+				}
+				type = Q_NEXT_TYPE(ehci, q.fstn->hw_next);
+				q = q.fstn->fstn_next;
+				break;
+			case Q_TYPE_ITD:
+				/* If this ITD is still active, leave it for
+				 * later processing ... check the next entry.
+				 * No need to check for activity unless the
+				 * frame is current.
+				 */
+				if (frame == clock_frame && live) {
+					rmb();
+					for (uf = 0; uf < 8; uf++) {
+						if (q.itd->hw_transaction[uf] &
+							    ITD_ACTIVE(ehci))
+							break;
+					}
+					if (uf < 8) {
+						incomplete = true;
+						q_p = &q.itd->itd_next;
+						hw_p = &q.itd->hw_next;
+						type = Q_NEXT_TYPE(ehci,
+							q.itd->hw_next);
+						q = *q_p;
+						break;
+					}
+				}
+
+				/* Take finished ITDs out of the schedule
+				 * and process them:  recycle, maybe report
+				 * URB completion.  HC won't cache the
+				 * pointer for much longer, if at all.
+				 */
+				*q_p = q.itd->itd_next;
+				if (!ehci->use_dummy_qh ||
+				    q.itd->hw_next != EHCI_LIST_END(ehci))
+					*hw_p = q.itd->hw_next;
+				else
+					*hw_p = ehci->dummy->qh_dma;
+				type = Q_NEXT_TYPE(ehci, q.itd->hw_next);
+				wmb();
+				modified = itd_complete(ehci, q.itd);
+				q = *q_p;
+				break;
+			default:
+				ehci_dbg(ehci, "corrupt type %d frame %d shadow %p\n",
+					type, frame, q.ptr);
+				q.ptr = NULL;
+			}
+
+			/* assume completion callbacks modify the queue */
+			if (unlikely(modified)) {
+				if (likely(ehci->periodic_sched > 0))
+					goto restart;
+				/* short-circuit this scan */
+				now_uframe = clock;
+				break;
+			}
+		}
+
+		/* If we can tell we caught up to the hardware, stop now.
+		 * We can't advance our scan without collecting the ISO
+		 * transfers that are still pending in this frame.
+		 */
+		if (incomplete && ehci->rh_state == EHCI_RH_RUNNING) {
+			ehci->next_uframe = now_uframe;
+			break;
+		}
+
+		/* FIXME:  this assumes we won't get lapped when	*/
+		/* latencies climb; that should be rare, but...		*/
+		/* detect it, and just go all the way around.		*/
+		/* FLR might help detect this case, so long as latencies*/
+		/* don't exceed periodic_size msec (default 1.024 sec).	*/
+
+		/* FIXME:  likewise assumes HC doesn't halt mid-scan	*/
+
+		if (now_uframe == clock) {
+			unsigned	now;
+
+			if (ehci->rh_state != EHCI_RH_RUNNING
+					|| ehci->periodic_sched == 0)
+				break;
+			ehci->next_uframe = now_uframe;
+			now = ehci_read_frame_index(ehci) & (mod - 1);
+			if (now_uframe == now)
+				break;
+
+			/* rescan the rest of this frame, then ... */
+			clock = now;
+			clock_frame = clock >> 3;
+			if (ehci->clock_frame != clock_frame) {
+				free_cached_lists(ehci);
+				ehci->clock_frame = clock_frame;
+				++ehci->periodic_stamp;
+			}
+		} else {
+			now_uframe++;
+			now_uframe &= mod - 1;
+		}
+	}
+}
+
+/* Display the ports dedicated to the companion controller */
+static ssize_t show_companion(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct ehci_hcd		*ehci;
+	int			nports, index, n;
+	int			count = PAGE_SIZE;
+	char			*ptr = buf;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	nports = HCS_N_PORTS(ehci->hcs_params);
+
+	for (index = 0; index < nports; ++index) {
+		if (test_bit(index, &ehci->companion_ports)) {
+			n = scnprintf(ptr, count, "%d\n", index + 1);
+			ptr += n;
+			count -= n;
+		}
+	}
+	return ptr - buf;
+}
+
+/*
+ * Dedicate or undedicate a port to the companion controller.
+ * Syntax is "[-]portnum", where a leading '-' sign means
+ * return control of the port to the EHCI controller.
+ */
+static ssize_t store_companion(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct ehci_hcd		*ehci;
+	int			portnum, new_owner;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	new_owner = PORT_OWNER;		/* Owned by companion */
+	if (sscanf(buf, "%d", &portnum) != 1)
+		return -EINVAL;
+	if (portnum < 0) {
+		portnum = -portnum;
+		new_owner = 0;		/* Owned by EHCI */
+	}
+	if (portnum <= 0 || portnum > HCS_N_PORTS(ehci->hcs_params))
+		return -ENOENT;
+	portnum--;
+	if (new_owner)
+		set_bit(portnum, &ehci->companion_ports);
+	else
+		clear_bit(portnum, &ehci->companion_ports);
+	set_owner(ehci, portnum, new_owner);
+	return count;
+}
+
+static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
+
+/*
+ * Display / Set uframe_periodic_max
+ */
+static ssize_t show_uframe_periodic_max(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct ehci_hcd		*ehci;
+	int			n;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	n = scnprintf(buf, PAGE_SIZE, "%d\n", ehci->uframe_periodic_max);
+	return n;
+}
+
+static ssize_t store_uframe_periodic_max(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct ehci_hcd		*ehci;
+	unsigned		uframe_periodic_max;
+	unsigned		frame, uframe;
+	unsigned short		allocated_max;
+	unsigned long		flags;
+	ssize_t			ret;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	if (kstrtouint(buf, 0, &uframe_periodic_max) < 0)
+		return -EINVAL;
+
+	if (uframe_periodic_max < 100 || uframe_periodic_max >= 125) {
+		ehci_info(ehci, "rejecting invalid request for "
+				"uframe_periodic_max=%u\n", uframe_periodic_max);
+		return -EINVAL;
+	}
+
+	ret = -EINVAL;
+
+	/*
+	 * lock, so that our checking does not race with possible periodic
+	 * bandwidth allocation through submitting new urbs.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
+
+	/*
+	 * for request to decrease max periodic bandwidth, we have to check
+	 * every microframe in the schedule to see whether the decrease is
+	 * possible.
+	 */
+	if (uframe_periodic_max < ehci->uframe_periodic_max) {
+		allocated_max = 0;
+
+		for (frame = 0; frame < ehci->periodic_size; ++frame)
+			for (uframe = 0; uframe < 7; ++uframe)
+				allocated_max = max(allocated_max,
+						    periodic_usecs(ehci, frame, uframe));
+
+		if (allocated_max > uframe_periodic_max) {
+			ehci_info(ehci,
+				"cannot decrease uframe_periodic_max becase "
+				"periodic bandwidth is already allocated "
+				"(%u > %u)\n",
+				allocated_max, uframe_periodic_max);
+			goto out_unlock;
+		}
+	}
+
+	/* increasing is always ok */
+
+	ehci_info(ehci, "setting max periodic bandwidth to %u%% "
+			"(== %u usec/uframe)\n",
+			100*uframe_periodic_max/125, uframe_periodic_max);
+
+	if (uframe_periodic_max != 100)
+		ehci_warn(ehci, "max periodic bandwidth set is non-standard\n");
+
+	ehci->uframe_periodic_max = uframe_periodic_max;
+	ret = count;
+
+out_unlock:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	return ret;
+}
+static DEVICE_ATTR(uframe_periodic_max, 0644, show_uframe_periodic_max, store_uframe_periodic_max);
+
+
+static inline int create_sysfs_files(struct ehci_hcd *ehci)
+{
+	struct device	*controller = ehci_to_hcd(ehci)->self.controller;
+	int	i = 0;
+
+	/* with integrated TT there is no companion! */
+	if (!ehci_is_TDI(ehci))
+		i = device_create_file(controller, &dev_attr_companion);
+	if (i)
+		goto out;
+
+	i = device_create_file(controller, &dev_attr_uframe_periodic_max);
+out:
+	return i;
+}
+
+static inline void remove_sysfs_files(struct ehci_hcd *ehci)
+{
+	struct device	*controller = ehci_to_hcd(ehci)->self.controller;
+
+	/* with integrated TT there is no companion! */
+	if (!ehci_is_TDI(ehci))
+		device_remove_file(controller, &dev_attr_companion);
+
+	device_remove_file(controller, &dev_attr_uframe_periodic_max);
+}
+
+static void ehci_iaa_watchdog(unsigned long param)
+{
+	struct ehci_hcd		*ehci = (struct ehci_hcd *) param;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&ehci->lock, flags);
+
+	/* Lost IAA irqs wedge things badly; seen first with a vt8235.
+	 * So we need this watchdog, but must protect it against both
+	 * (a) SMP races against real IAA firing and retriggering, and
+	 * (b) clean HC shutdown, when IAA watchdog was pending.
+	 */
+	if (ehci->reclaim
+			&& !timer_pending(&ehci->iaa_watchdog)
+			&& ehci->rh_state == EHCI_RH_RUNNING) {
+		u32 cmd, status;
+
+		/* If we get here, IAA is *REALLY* late.  It's barely
+		 * conceivable that the system is so busy that CMD_IAAD
+		 * is still legitimately set, so let's be sure it's
+		 * clear before we read STS_IAA.  (The HC should clear
+		 * CMD_IAAD when it sets STS_IAA.)
+		 */
+		cmd = ehci_readl(ehci, &ehci->regs->command);
+		if (cmd & CMD_IAAD)
+			ehci_writel(ehci, cmd & ~CMD_IAAD,
+					&ehci->regs->command);
+
+		/* If IAA is set here it either legitimately triggered
+		 * before we cleared IAAD above (but _way_ late, so we'll
+		 * still count it as lost) ... or a silicon erratum:
+		 * - VIA seems to set IAA without triggering the IRQ;
+		 * - IAAD potentially cleared without setting IAA.
+		 */
+		status = ehci_readl(ehci, &ehci->regs->status);
+		if ((status & STS_IAA) || !(cmd & CMD_IAAD)) {
+			COUNT(ehci->stats.lost_iaa);
+			ehci_writel(ehci, STS_IAA, &ehci->regs->status);
+		}
+
+		ehci_vdbg(ehci, "IAA watchdog: status %x cmd %x\n",
+				status, cmd);
+		end_unlink_async(ehci);
+	}
+
+	spin_unlock_irqrestore(&ehci->lock, flags);
+}
+
+static void ehci_watchdog(unsigned long param)
+{
+	struct ehci_hcd		*ehci = (struct ehci_hcd *) param;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&ehci->lock, flags);
+	/* stop async processing after it's idled a bit */
+	if (test_bit(TIMER_ASYNC_OFF, &ehci->actions))
+		start_unlink_async(ehci, ehci->async);
+
+	/* ehci could run by timer, without IRQs ... */
+	ehci_work(ehci);
+
+	spin_unlock_irqrestore(&ehci->lock, flags);
+}
+
+/* one-time init, only for memory state */
+static int fusbh200_ehci_init(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	u32			temp;
+	int			retval;
+	u32			hcc_params;
+	struct ehci_qh_hw	*hw;
+
+	spin_lock_init(&ehci->lock);
+
+	/*
+	 * keep io watchdog by default, those good HCDs could turn off it later
+	 */
+	ehci->need_io_watchdog = 1;
+	init_timer(&ehci->watchdog);
+	ehci->watchdog.function = ehci_watchdog;
+	ehci->watchdog.data = (unsigned long) ehci;
+
+	init_timer(&ehci->iaa_watchdog);
+	ehci->iaa_watchdog.function = ehci_iaa_watchdog;
+	ehci->iaa_watchdog.data = (unsigned long) ehci;
+
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
+	/*
+	 * by default set standard 80% (== 100 usec/uframe) max periodic
+	 * bandwidth as required by USB 2.0
+	 */
+	ehci->uframe_periodic_max = 100;
+
+	/*
+	 * hw default: 1K periodic list heads, one per frame.
+	 * periodic_size can shrink by USBCMD update if hcc_params allows.
+	 */
+	ehci->periodic_size = DEFAULT_I_TDPS;
+	INIT_LIST_HEAD(&ehci->cached_itd_list);
+	INIT_LIST_HEAD(&ehci->cached_sitd_list);
+
+	if (HCC_PGM_FRAMELISTLEN(hcc_params)) {
+		/* periodic schedule size can be smaller than default */
+		switch (EHCI_TUNE_FLS) {
+		case 0:
+			ehci->periodic_size = 1024;
+			break;
+		case 1:
+			ehci->periodic_size = 512;
+			break;
+		case 2:
+			ehci->periodic_size = 256;
+			break;
+		default:
+			BUG();
+		}
+	}
+	retval = ehci_mem_init(ehci, GFP_KERNEL);
+	if (retval < 0)
+		return retval;
+
+	/* controllers may cache some of the periodic schedule ... */
+	if (HCC_ISOC_CACHE(hcc_params))/* full frame cache */
+		ehci->i_thresh = 2 + 8;
+	else /* N microframes cached */
+		ehci->i_thresh = 2 + HCC_ISOC_THRES(hcc_params);
+
+	ehci->reclaim = NULL;
+	ehci->next_uframe = -1;
+	ehci->clock_frame = -1;
+
+	/*
+	 * dedicate a qh for the async ring head, since we couldn't unlink
+	 * a 'real' qh without stopping the async schedule [4.8].  use it
+	 * as the 'reclamation list head' too.
+	 * its dummy is used in hw_alt_next of many tds, to prevent the qh
+	 * from automatically advancing to the next td after short reads.
+	 */
+	ehci->async->qh_next.qh = NULL;
+	hw = ehci->async->hw;
+	hw->hw_next = QH_NEXT(ehci, ehci->async->qh_dma);
+	hw->hw_info1 = cpu_to_hc32(ehci, QH_HEAD);
+	hw->hw_info1 |= cpu_to_hc32(ehci, (1 << 7));	/* I = 1 */
+	hw->hw_token = cpu_to_hc32(ehci, QTD_STS_HALT);
+	hw->hw_qtd_next = EHCI_LIST_END(ehci);
+	ehci->async->qh_state = QH_STATE_LINKED;
+	hw->hw_alt_next = QTD_NEXT(ehci, ehci->async->dummy->qtd_dma);
+
+	/* clear interrupt enables, set irq latency */
+	if (log2_irq_thresh < 0 || log2_irq_thresh > 6)
+		log2_irq_thresh = 0;
+	temp = 1 << (16 + log2_irq_thresh);
+	if (HCC_CANPARK(hcc_params)) {
+		/* HW default park == 3, on hardware that supports it (like
+		 * NVidia and ALI silicon), maximizes throughput on the async
+		 * schedule by avoiding QH fetches between transfers.
+		 *
+		 * With fast usb storage devices and NForce2, "park" seems to
+		 * make problems:  throughput reduction (!), data errors...
+		 */
+		if (park) {
+			park = min(park, (unsigned) 3);
+			temp |= CMD_PARK;
+			temp |= park << 8;
+		}
+		ehci_dbg(ehci, "park %d\n", park);
+	}
+	if (HCC_PGM_FRAMELISTLEN(hcc_params)) {
+		/* periodic schedule size can be smaller than default */
+		temp &= ~(3 << 2);
+		temp |= (EHCI_TUNE_FLS << 2);
+	}
+	ehci->command = temp;
+
+	/* Accept arbitrarily long scatter-gather lists */
+	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
+		hcd->self.sg_tablesize = ~0;
+	return 0;
+}
+
+static int fusbh200_ehci_hub_control(
+	struct usb_hcd	*hcd,
+	u16		typeReq,
+	u16		wValue,
+	u16		wIndex,
+	char		*buf,
+	u16		wLength
+);
+
+static void ehci_port_power(struct ehci_hcd *ehci, int is_on)
+{
+	unsigned port;
+
+	if (!HCS_PPC(ehci->hcs_params))
+		return;
+
+	ehci_dbg(ehci, "...power%s ports...\n", is_on ? "up" : "down");
+	for (port = HCS_N_PORTS(ehci->hcs_params); port > 0;)
+		(void) fusbh200_ehci_hub_control(ehci_to_hcd(ehci),
+				is_on ? SetPortFeature : ClearPortFeature,
+				USB_PORT_FEAT_POWER,
+				port--, NULL, 0);
+	/* Flush those writes */
+	ehci_readl(ehci, &ehci->regs->command);
+	msleep(20);
+}
+
+/*
+ * ehci_work is called from some interrupts, timers, and so on.
+ * it calls driver completion functions, after dropping ehci->lock.
+ */
+static void ehci_work(struct ehci_hcd *ehci)
+{
+	timer_action_done(ehci, TIMER_IO_WATCHDOG);
+
+	/* another CPU may drop ehci->lock during a schedule scan while
+	 * it reports urb completions.  this flag guards against bogus
+	 * attempts at re-entrant schedule scanning.
+	 */
+	if (ehci->scanning)
+		return;
+	ehci->scanning = 1;
+	scan_async(ehci);
+	if (ehci->next_uframe != -1)
+		scan_periodic(ehci);
+	ehci->scanning = 0;
+
+	/* the IO watchdog guards against hardware or driver bugs that
+	 * misplace IRQs, and should let us run completely without IRQs.
+	 * such lossage has been observed on both VT6202 and VT8235.
+	 */
+	if (ehci->rh_state == EHCI_RH_RUNNING &&
+			(ehci->async->qh_next.ptr != NULL ||
+			 ehci->periodic_sched != 0))
+		timer_action(ehci, TIMER_IO_WATCHDOG);
+}
+
+static void reset_host(struct ehci_hcd *ehci)
+{
+	u32 regcommand, regenable;
+	u32 i, temp;
+
+	regcommand = readl(&ehci->regs->command);
+	regenable = readl(&ehci->regs->intr_enable);
+
+	writel(CMD_RESET, &ehci->regs->command);
+	i = 0;
+	temp = CMD_RESET;
+	while (((temp & CMD_RESET)) && (i <= 1000)) {
+		mdelay(1);
+		i++;
+		temp = readl(&ehci->regs->command);
+	}
+	writel(regenable, &ehci->regs->intr_enable);
+	writel(regcommand, &ehci->regs->command);
+	mdelay(1);
+	writel(regcommand | CMD_RUN, &ehci->regs->command);
+}
+
+static irqreturn_t fusbh200_ehci_irq(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	u32			status, masked_status, pcd_status = 0, cmd;
+	int			bh = 0;
+	u32 __iomem 		*reg_ptr;
+	u32 			tmp;
+
+	spin_lock(&ehci->lock);
+	/* add for fusbh200 */
+	reg_ptr = (u32 __iomem *)(((u8 __iomem *)ehci->caps) +
+		FUSBH200_BMISR);
+	tmp = ehci_readl(ehci, reg_ptr);
+
+	if (tmp & FUSBH200_BMISR_OVC) {
+		printk("Over current!!\n");
+		ehci_writel(ehci, FUSBH200_BMISR_OVC, reg_ptr);
+		reset_host(ehci);
+		spin_unlock(&ehci->lock);
+		return IRQ_HANDLED;
+	} else if (tmp & FUSBH200_BMISR_VBUS_ERR) {
+		printk("Vbus Error!!\n");
+		ehci_writel(ehci, FUSBH200_BMISR_VBUS_ERR, reg_ptr);
+		reset_host(ehci);
+		spin_unlock(&ehci->lock);
+		return IRQ_HANDLED;
+	}
+
+	status = ehci_readl(ehci, &ehci->regs->status);
+
+	/* e.g. cardbus physical eject */
+	if (status == ~(u32) 0) {
+		ehci_dbg(ehci, "device removed\n");
+		goto dead;
+	}
+
+	/* Shared IRQ? */
+	masked_status = status & INTR_MASK;
+	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
+		spin_unlock(&ehci->lock);
+		return IRQ_NONE;
+	}
+
+	/* clear (just) interrupts */
+	ehci_writel(ehci, masked_status, &ehci->regs->status);
+	cmd = ehci_readl(ehci, &ehci->regs->command);
+	bh = 0;
+
+#ifdef	VERBOSE_DEBUG
+	/* unrequested/ignored: Frame List Rollover */
+	dbg_status(ehci, "irq", status);
+#endif
+
+	/* INT, ERR, and IAA interrupt rates can be throttled */
+
+	/* normal [4.15.1.2] or error [4.15.1.1] completion */
+	if (likely((status & (STS_INT|STS_ERR)) != 0)) {
+		if (likely((status & STS_ERR) == 0))
+			COUNT(ehci->stats.normal);
+		else
+			COUNT(ehci->stats.error);
+		bh = 1;
+	}
+
+	/* complete the unlinking of some qh [4.15.2.3] */
+	if (status & STS_IAA) {
+		/* guard against (alleged) silicon errata */
+		if (cmd & CMD_IAAD) {
+			ehci_writel(ehci, cmd & ~CMD_IAAD,
+					&ehci->regs->command);
+			ehci_dbg(ehci, "IAA with IAAD still set?\n");
+		}
+		if (ehci->reclaim) {
+			COUNT(ehci->stats.reclaim);
+			end_unlink_async(ehci);
+		} else
+			ehci_dbg(ehci, "IAA with nothing to reclaim?\n");
+	}
+
+	/* remote wakeup [4.3.1] */
+	if (status & STS_PCD) {
+		unsigned	i = HCS_N_PORTS(ehci->hcs_params);
+		u32		ppcd = 0;
+
+		/* kick root hub later */
+		pcd_status = status;
+
+		/* resume root hub? */
+		if (!(cmd & CMD_RUN))
+			usb_hcd_resume_root_hub(hcd);
+
+		/* add for fusbh200 */
+		if (!(cmd & CMD_RUN)) {
+			u32 i = 0;
+			u32 temp = ehci_readl(ehci, &ehci->regs->status);
+
+			while ((!(temp & STS_HALT)) && (i < 1000)) {
+				udelay(125);
+				i++;
+				temp = ehci_readl(ehci, &ehci->regs->status);
+			}
+
+			if (i < 1000) {
+				temp = ehci_readl(ehci, &ehci->regs->command);
+				temp |= CMD_RUN;
+				ehci_writel(ehci, temp, &ehci->regs->command);
+
+				i = 0;
+				temp = ehci_readl(ehci, &ehci->regs->status);
+				while ((temp & STS_HALT) && (i < 10)) {
+					udelay(125);
+					i++;
+					temp = ehci_readl(ehci, &ehci->regs->status);
+				}
+
+				if (i > 0)
+					printk("polling NOT HALT times.....%d\n", i);
+			} else {
+				u32 i, temp;
+				u32 regcommand = readl(&ehci->regs->command);
+				u32 regenable = readl(&ehci->regs->intr_enable);
+
+				printk("Host cannot exit HALT state, recover.....\n");
+				writel(CMD_RESET, &ehci->regs->command);
+				i = 0;
+				temp = CMD_RESET;
+
+				while (((temp & CMD_RESET)) && (i <= 100)) {
+					mdelay(3);
+					i++;
+					temp = readl(&ehci->regs->command);
+				}
+				printk("exit HALT OK.....%d\n", i);
+				writel(regenable, &ehci->regs->intr_enable);
+				writel(regcommand, &ehci->regs->command);
+				mdelay(1);
+				writel(regcommand | CMD_RUN, &ehci->regs->command);
+				printk("Host-halt recover OK\n");
+			}
+		}
+
+		/* get per-port change detect bits */
+		if (ehci->has_ppcd)
+			ppcd = status >> 16;
+
+		while (i--) {
+			int pstatus;
+
+			/* leverage per-port change bits feature */
+			if (ehci->has_ppcd && !(ppcd & (1 << i)))
+				continue;
+			pstatus = ehci_readl(ehci,
+					 &ehci->regs->port_status[i]);
+
+			if (pstatus & PORT_OWNER)
+				continue;
+			if (!(test_bit(i, &ehci->suspended_ports) &&
+					((pstatus & PORT_RESUME) ||
+						!(pstatus & PORT_SUSPEND)) &&
+					(pstatus & PORT_PE) &&
+					ehci->reset_done[i] == 0))
+				continue;
+
+			/* start 20 msec resume signaling from this port,
+			 * and make khubd collect PORT_STAT_C_SUSPEND to
+			 * stop that signaling.  Use 5 ms extra for safety,
+			 * like usb_port_resume() does.
+			 */
+			ehci->reset_done[i] = jiffies + msecs_to_jiffies(25);
+			ehci_dbg(ehci, "port %d remote wakeup\n", i + 1);
+			mod_timer(&hcd->rh_timer, ehci->reset_done[i]);
+		}
+	}
+
+	/* PCI errors [4.15.2.4] */
+	if (unlikely((status & STS_FATAL) != 0)) {
+			u32 i, temp;
+			u32 regcommand = readl(&ehci->regs->command);
+			u32 regenable = readl(&ehci->regs->intr_enable);
+
+			printk("Fatal error.....\n");
+
+			writel(CMD_RESET, &ehci->regs->command);
+			i = 0;
+			temp = CMD_RESET;
+
+			while (((temp & CMD_RESET)) && (i <= 100)) {
+				mdelay(3);
+				i++;
+				temp = readl(&ehci->regs->command);
+			}
+
+			writel(regenable, &ehci->regs->intr_enable);
+			writel(regcommand, &ehci->regs->command);
+			mdelay(1);
+			writel(regcommand | CMD_RUN, &ehci->regs->command);
+			printk("recover OK\n");
+	}
+dead:
+	if (bh)
+		ehci_work(ehci);
+	spin_unlock(&ehci->lock);
+	if (pcd_status)
+		usb_hcd_poll_rh_status(hcd);
+	return IRQ_HANDLED;
+}
+
+/* start HC running; it's halted, ehci_init() has been run (once) */
+static int fusbh200_ehci_run(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	u32			temp;
+	u32			hcc_params;
+
+	hcd->uses_new_polling = 1;
+
+	/* EHCI spec section 4.1 */
+
+	ehci_writel(ehci, ehci->periodic_dma, &ehci->regs->frame_list);
+	ehci_writel(ehci, (u32)ehci->async->qh_dma, &ehci->regs->async_next);
+
+	/*
+	 * hcc_params controls whether ehci->regs->segment must (!!!)
+	 * be used; it constrains QH/ITD/SITD and QTD locations.
+	 * pci_pool consistent memory always uses segment zero.
+	 * streaming mappings for I/O buffers, like pci_map_single(),
+	 * can return segments above 4GB, if the device allows.
+	 *
+	 * NOTE:  the dma mask is visible through dma_supported(), so
+	 * drivers can pass this info along ... like NETIF_F_HIGHDMA,
+	 * Scsi_Host.highmem_io, and so forth.  It's readonly to all
+	 * host side drivers though.
+	 */
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+	if (HCC_64BIT_ADDR(hcc_params)) {
+		ehci_writel(ehci, 0, &ehci->regs->segment);
+	}
+
+	/* Philips, Intel, and maybe others need CMD_RUN before the
+	   root hub will detect new devices (why?); NEC doesn't*/
+	ehci->command &= ~(CMD_LRESET|CMD_IAAD|CMD_PSE|CMD_ASE|CMD_RESET);
+	/* fusbh200: enable park mode */
+	ehci->command |= CMD_PARK | (3 << 8);
+	ehci->command |= CMD_RUN;
+	ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	dbg_cmd(ehci, "init", ehci->command);
+
+	/*
+	 * Start, enabling full USB 2.0 functionality ... usb 1.1 devices
+	 * are explicitly handed to companion controller(s), so no TT is
+	 * involved with the root hub.  (Except where one is integrated,
+	 * and there's no companion controller unless maybe for USB OTG.)
+	 *
+	 * Turning on the CF flag will transfer ownership of all ports
+	 * from the companions to the EHCI controller.  If any of the
+	 * companions are in the middle of a port reset at the time, it
+	 * could cause trouble.  Write-locking ehci_cf_port_reset_rwsem
+	 * guarantees that no resets are in progress.  After we set CF,
+	 * a short delay lets the hardware catch up; new resets shouldn't
+	 * be started before the port switching actions could complete.
+	 */
+	down_write(&ehci_cf_port_reset_rwsem);
+	ehci->rh_state = EHCI_RH_RUNNING;
+	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
+	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	/* fusbh200: cannot busy wait, use short delay */
+	udelay(500);
+	up_write(&ehci_cf_port_reset_rwsem);
+	ehci->last_periodic_enable = ktime_get_real();
+
+	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	ehci_info(ehci,
+		"USB %x.%x started, EHCI %x.%02x%s\n",
+		((ehci->sbrn & 0xf0)>>4), (ehci->sbrn & 0x0f),
+		temp >> 8, temp & 0xff,
+		ignore_oc ? ", overcurrent ignored" : "");
+
+	ehci_writel(ehci, INTR_MASK,
+		    &ehci->regs->intr_enable); /* Turn On Interrupts */
+
+	/* GRR this is run-once init(), being done every time the HC starts.
+	 * So long as they're part of class devices, we can't do it init()
+	 * since the class device isn't created that early.
+	 */
+	create_debug_files(ehci);
+	create_sysfs_files(ehci);
+
+	return 0;
+}
+
+/* On some systems, leaving remote wakeup enabled prevents system shutdown.
+ * The firmware seems to think that powering off is a wakeup event!
+ * This routine turns off remote wakeup and everything else, on all ports.
+ */
+static void ehci_turn_off_all_ports(struct ehci_hcd *ehci)
+{
+	int	port = HCS_N_PORTS(ehci->hcs_params);
+
+	while (port--)
+		ehci_writel(ehci, PORT_RWC_BITS,
+				&ehci->regs->port_status[port]);
+}
+
+/*
+ * Halt HC, turn off all ports, and let the BIOS use the companion controllers.
+ * Should be called with ehci->lock held.
+ */
+static void ehci_silence_controller(struct ehci_hcd *ehci)
+{
+	fusbh200_ehci_halt(ehci);
+	ehci_turn_off_all_ports(ehci);
+
+	/* make BIOS/etc use companion controller during reboot */
+	ehci_writel(ehci, 0, &ehci->regs->configured_flag);
+
+	/* unblock posted writes */
+	ehci_readl(ehci, &ehci->regs->configured_flag);
+}
+
+/*
+ * Called when the ehci_hcd module is removed.
+ */
+static void fusbh200_ehci_stop(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+
+	ehci_dbg(ehci, "stop\n");
+
+	/* no more interrupts ... */
+	del_timer_sync(&ehci->watchdog);
+	del_timer_sync(&ehci->iaa_watchdog);
+
+	spin_lock_irq(&ehci->lock);
+	if (ehci->rh_state == EHCI_RH_RUNNING)
+		ehci_quiesce(ehci);
+
+	ehci_silence_controller(ehci);
+	ehci_reset(ehci);
+	spin_unlock_irq(&ehci->lock);
+
+	remove_sysfs_files(ehci);
+	remove_debug_files(ehci);
+
+	/* root hub is shut down separately (first, when possible) */
+	spin_lock_irq(&ehci->lock);
+	if (ehci->async)
+		ehci_work(ehci);
+	spin_unlock_irq(&ehci->lock);
+	ehci_mem_cleanup(ehci);
+
+#ifdef	EHCI_STATS
+	ehci_dbg(ehci, "irq normal %ld err %ld reclaim %ld (lost %ld)\n",
+		ehci->stats.normal, ehci->stats.error, ehci->stats.reclaim,
+		ehci->stats.lost_iaa);
+	ehci_dbg(ehci, "complete %ld unlink %ld\n",
+		ehci->stats.complete, ehci->stats.unlink);
+#endif
+
+	dbg_status(ehci, "ehci_stop completed",
+		    ehci_readl(ehci, &ehci->regs->status));
+}
+
+/* fusbh200_ehci_shutdown kick in for silicon on any bus (not just pci, etc).
+ * This forcibly disables dma and IRQs, helping kexec and other cases
+ * where the next system software may expect clean state.
+ */
+static void fusbh200_ehci_shutdown(struct usb_hcd *hcd)
+{
+	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+
+	del_timer_sync(&ehci->watchdog);
+	del_timer_sync(&ehci->iaa_watchdog);
+
+	spin_lock_irq(&ehci->lock);
+	ehci_silence_controller(ehci);
+	spin_unlock_irq(&ehci->lock);
+}
+
+static void
+fusbh200_ehci_endpoint_disable(struct usb_hcd *hcd, struct usb_host_endpoint *ep)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	unsigned long		flags;
+	struct ehci_qh		*qh, *tmp;
+
+	/* ASSERT:  any requests/urbs are being unlinked */
+	/* ASSERT:  nobody can be submitting urbs for this any more */
+
+rescan:
+	spin_lock_irqsave(&ehci->lock, flags);
+	qh = ep->hcpriv;
+	if (!qh)
+		goto done;
+
+	/* endpoints can be iso streams.  for now, we don't
+	 * accelerate iso completions ... so spin a while.
+	 */
+	if (qh->hw == NULL) {
+		ehci_vdbg(ehci, "iso delay\n");
+		goto idle_timeout;
+	}
+
+	if (ehci->rh_state != EHCI_RH_RUNNING)
+		qh->qh_state = QH_STATE_IDLE;
+	switch (qh->qh_state) {
+	case QH_STATE_LINKED:
+	case QH_STATE_COMPLETING:
+		for (tmp = ehci->async->qh_next.qh;
+				tmp && tmp != qh;
+				tmp = tmp->qh_next.qh)
+			continue;
+		/* periodic qh self-unlinks on empty, and a COMPLETING qh
+		 * may already be unlinked.
+		 */
+		if (tmp)
+			unlink_async(ehci, qh);
+		/* FALL THROUGH */
+	case QH_STATE_UNLINK:		/* wait for hw to finish? */
+	case QH_STATE_UNLINK_WAIT:
+idle_timeout:
+		spin_unlock_irqrestore(&ehci->lock, flags);
+		schedule_timeout_uninterruptible(1);
+		goto rescan;
+	case QH_STATE_IDLE:		/* fully unlinked */
+		if (qh->clearing_tt)
+			goto idle_timeout;
+		if (list_empty(&qh->qtd_list)) {
+			qh_put(qh);
+			break;
+		}
+		/* else FALL THROUGH */
+	default:
+		/* caller was supposed to have unlinked any requests;
+		 * that's not our job.  just leak this memory.
+		 */
+		ehci_err(ehci, "qh %p (#%02x) state %d%s\n",
+			qh, ep->desc.bEndpointAddress, qh->qh_state,
+			list_empty(&qh->qtd_list) ? "" : "(has tds)");
+		break;
+	}
+	ep->hcpriv = NULL;
+done:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+}
+
+static int qh_schedule(struct ehci_hcd *ehci, struct ehci_qh *qh);
+
+static void
+fusbh200_ehci_endpoint_reset(struct usb_hcd *hcd, struct usb_host_endpoint *ep)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	struct ehci_qh		*qh;
+	int			eptype = usb_endpoint_type(&ep->desc);
+	int			epnum = usb_endpoint_num(&ep->desc);
+	int			is_out = usb_endpoint_dir_out(&ep->desc);
+	unsigned long		flags;
+
+	if (eptype != USB_ENDPOINT_XFER_BULK && eptype != USB_ENDPOINT_XFER_INT)
+		return;
+
+	spin_lock_irqsave(&ehci->lock, flags);
+	qh = ep->hcpriv;
+
+	/* For Bulk and Interrupt endpoints we maintain the toggle state
+	 * in the hardware; the toggle bits in udev aren't used at all.
+	 * When an endpoint is reset by usb_clear_halt() we must reset
+	 * the toggle bit in the QH.
+	 */
+	if (qh) {
+		usb_settoggle(qh->dev, epnum, is_out, 0);
+		if (!list_empty(&qh->qtd_list)) {
+			WARN_ONCE(1, "clear_halt for a busy endpoint\n");
+		} else if (qh->qh_state == QH_STATE_LINKED ||
+				qh->qh_state == QH_STATE_COMPLETING) {
+
+			/* The toggle value in the QH can't be updated
+			 * while the QH is active.  Unlink it now;
+			 * re-linking will call qh_refresh().
+			 */
+			if (eptype == USB_ENDPOINT_XFER_BULK)
+				unlink_async(ehci, qh);
+			else
+				intr_deschedule(ehci, qh);
+		}
+	}
+	spin_unlock_irqrestore(&ehci->lock, flags);
+}
+
+static int fusbh200_ehci_get_frame(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	return (ehci_read_frame_index(ehci) >> 3) % ehci->periodic_size;
+}
+
+#ifdef CONFIG_PM
+static int fusbh200_ehci_bus_suspend(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	int			port;
+	int			mask;
+	int			changed;
+
+	ehci_dbg(ehci, "suspend root hub\n");
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(5);
+	del_timer_sync(&ehci->watchdog);
+	del_timer_sync(&ehci->iaa_watchdog);
+
+	spin_lock_irq(&ehci->lock);
+
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	if (hcd->self.root_hub->do_remote_wakeup) {
+		port = HCS_N_PORTS(ehci->hcs_params);
+		while (port--) {
+			if (ehci->reset_done[port] != 0) {
+				spin_unlock_irq(&ehci->lock);
+				ehci_dbg(ehci, "suspend failed because "
+						"port %d is resuming\n",
+						port + 1);
+				return -EBUSY;
+			}
+		}
+	}
+
+	/* stop schedules, clean any completed work */
+	if (ehci->rh_state == EHCI_RH_RUNNING)
+		ehci_quiesce(ehci);
+	ehci->command = ehci_readl(ehci, &ehci->regs->command);
+	ehci_work(ehci);
+
+	/* Unlike other USB host controller types, EHCI doesn't have
+	 * any notion of "global" or bus-wide suspend.  The driver has
+	 * to manually suspend all the active unsuspended ports, and
+	 * then manually resume them in the bus_resume() routine.
+	 */
+	ehci->bus_suspended = 0;
+	ehci->owned_ports = 0;
+	changed = 0;
+	port = HCS_N_PORTS(ehci->hcs_params);
+	while (port--) {
+		u32 __iomem	*reg = &ehci->regs->port_status[port];
+		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
+		u32		t2 = t1 & ~PORT_WAKE_BITS;
+
+		/* keep track of which ports we suspend */
+		if (t1 & PORT_OWNER)
+			set_bit(port, &ehci->owned_ports);
+		else if ((t1 & PORT_PE) && !(t1 & PORT_SUSPEND)) {
+			t2 |= PORT_SUSPEND;
+			set_bit(port, &ehci->bus_suspended);
+		}
+
+		/* enable remote wakeup on all ports, if told to do so */
+		if (hcd->self.root_hub->do_remote_wakeup) {
+			/* only enable appropriate wake bits, otherwise the
+			 * hardware can not go phy low power mode. If a race
+			 * condition happens here(connection change during bits
+			 * set), the port change detection will finally fix it.
+			 */
+			if (t1 & PORT_CONNECT)
+				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
+			else
+				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
+		}
+
+		if (t1 != t2) {
+			ehci_vdbg(ehci, "port %d, %08x -> %08x\n",
+				port + 1, t1, t2);
+			ehci_writel(ehci, t2, reg);
+			changed = 1;
+		}
+	}
+
+	if (changed && ehci->has_hostpc) {
+		spin_unlock_irq(&ehci->lock);
+		msleep(5);	/* 5 ms for HCD to enter low-power mode */
+		spin_lock_irq(&ehci->lock);
+
+		port = HCS_N_PORTS(ehci->hcs_params);
+		while (port--) {
+			u32 __iomem	*hostpc_reg;
+			u32		t3;
+
+			hostpc_reg = (u32 __iomem *)((u8 *) ehci->regs
+					+ HOSTPC0 + 4 * port);
+			t3 = ehci_readl(ehci, hostpc_reg);
+			ehci_writel(ehci, t3 | HOSTPC_PHCD, hostpc_reg);
+			t3 = ehci_readl(ehci, hostpc_reg);
+			ehci_dbg(ehci, "Port %d phy low-power mode %s\n",
+					port, (t3 & HOSTPC_PHCD) ?
+					"succeeded" : "failed");
+		}
+	}
+
+	/* Apparently some devices need a >= 1-uframe delay here */
+	if (ehci->bus_suspended)
+		udelay(150);
+
+	/* turn off now-idle HC */
+	fusbh200_ehci_halt(ehci);
+	ehci->rh_state = EHCI_RH_SUSPENDED;
+
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+
+	/* allow remote wakeup */
+	mask = INTR_MASK;
+	if (!hcd->self.root_hub->do_remote_wakeup)
+		mask &= ~STS_PCD;
+	ehci_writel(ehci, mask, &ehci->regs->intr_enable);
+	ehci_readl(ehci, &ehci->regs->intr_enable);
+
+	ehci->next_statechange = jiffies + msecs_to_jiffies(10);
+	spin_unlock_irq(&ehci->lock);
+
+	/* ehci_work() may have re-enabled the watchdog timer, which we do not
+	 * want, and so we must delete any pending watchdog timer events.
+	 */
+	del_timer_sync(&ehci->watchdog);
+	return 0;
+}
+
+
+/* caller has locked the root hub, and should reset/reinit on error */
+static int fusbh200_ehci_bus_resume(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	u32			temp;
+	u32			power_okay;
+	int			i;
+	unsigned long		resume_needed = 0;
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(5);
+	spin_lock_irq(&ehci->lock);
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		spin_unlock_irq(&ehci->lock);
+		return -ESHUTDOWN;
+	}
+
+	if (unlikely(ehci->debug)) {
+		if (!dbgp_reset_prep())
+			ehci->debug = NULL;
+		else
+			dbgp_external_startup();
+	}
+
+	/* Ideally and we've got a real resume here, and no port's power
+	 * was lost.  (For PCI, that means Vaux was maintained.)  But we
+	 * could instead be restoring a swsusp snapshot -- so that BIOS was
+	 * the last user of the controller, not reset/pm hardware keeping
+	 * state we gave to it.
+	 */
+	power_okay = ehci_readl(ehci, &ehci->regs->intr_enable);
+	ehci_dbg(ehci, "resume root hub%s\n",
+			power_okay ? "" : " after power loss");
+
+	/* at least some APM implementations will try to deliver
+	 * IRQs right away, so delay them until we're ready.
+	 */
+	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+
+	/* re-init operational registers */
+	ehci_writel(ehci, 0, &ehci->regs->segment);
+	ehci_writel(ehci, ehci->periodic_dma, &ehci->regs->frame_list);
+	ehci_writel(ehci, (u32) ehci->async->qh_dma, &ehci->regs->async_next);
+
+	/* restore CMD_RUN, framelist size, and irq threshold */
+	ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	ehci->rh_state = EHCI_RH_RUNNING;
+
+	/* Some controller/firmware combinations need a delay during which
+	 * they set up the port statuses.  See Bugzilla #8190. */
+	spin_unlock_irq(&ehci->lock);
+	msleep(8);
+	spin_lock_irq(&ehci->lock);
+
+	/* clear phy low-power mode before resume */
+	if (ehci->bus_suspended && ehci->has_hostpc) {
+		i = HCS_N_PORTS(ehci->hcs_params);
+		while (i--) {
+			if (test_bit(i, &ehci->bus_suspended)) {
+				u32 __iomem	*hostpc_reg;
+
+				hostpc_reg = (u32 __iomem *)((u8 *) ehci->regs
+						+ HOSTPC0 + 4 * i);
+				temp = ehci_readl(ehci, hostpc_reg);
+				ehci_writel(ehci, temp & ~HOSTPC_PHCD,
+						hostpc_reg);
+			}
+		}
+		spin_unlock_irq(&ehci->lock);
+		msleep(5);
+		spin_lock_irq(&ehci->lock);
+	}
+
+	/* manually resume the ports we suspended during bus_suspend() */
+	i = HCS_N_PORTS(ehci->hcs_params);
+	while (i--) {
+		temp = ehci_readl(ehci, &ehci->regs->port_status[i]);
+		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
+		if (test_bit(i, &ehci->bus_suspended) &&
+				(temp & PORT_SUSPEND)) {
+			temp |= PORT_RESUME;
+			set_bit(i, &resume_needed);
+		}
+		ehci_writel(ehci, temp, &ehci->regs->port_status[i]);
+	}
+
+	/* msleep for 20ms only if code is trying to resume port */
+	if (resume_needed) {
+		spin_unlock_irq(&ehci->lock);
+		msleep(20);
+		spin_lock_irq(&ehci->lock);
+	}
+
+	i = HCS_N_PORTS(ehci->hcs_params);
+	while (i--) {
+		temp = ehci_readl(ehci, &ehci->regs->port_status[i]);
+		if (test_bit(i, &resume_needed)) {
+			temp &= ~(PORT_RWC_BITS | PORT_RESUME);
+			ehci_writel(ehci, temp, &ehci->regs->port_status[i]);
+			ehci_vdbg(ehci, "resumed port %d\n", i + 1);
+		}
+	}
+	(void) ehci_readl(ehci, &ehci->regs->command);
+
+	/* maybe re-activate the schedule(s) */
+	temp = 0;
+	if (ehci->async->qh_next.qh)
+		temp |= CMD_ASE;
+	if (ehci->periodic_sched)
+		temp |= CMD_PSE;
+	if (temp) {
+		ehci->command |= temp;
+		ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	}
+
+	ehci->next_statechange = jiffies + msecs_to_jiffies(5);
+
+	/* Now we can safely re-enable irqs */
+	ehci_writel(ehci, INTR_MASK, &ehci->regs->intr_enable);
+
+	spin_unlock_irq(&ehci->lock);
+	ehci_handover_companion_ports(ehci);
+	return 0;
+}
+
+#else
+
+#define fusbh200_ehci_bus_suspend	NULL
+#define fusbh200_ehci_bus_resume	NULL
+
+#endif	/* CONFIG_PM */
+
+static void fusbh200_ehci_relinquish_port(struct usb_hcd *hcd, int portnum)
+{
+	return;
+}
+
+static int fusbh200_ehci_port_handed_over(struct usb_hcd *hcd, int portnum)
+{
+	return 0;
+}
+
+/*
+ * non-error returns are a promise to giveback() the urb later
+ * we drop ownership so next owner (or urb unlink) can get it
+ *
+ * urb + dev is in hcd.self.controller.urb_list
+ * we're queueing TDs onto software and hardware lists
+ *
+ * hcd-specific init for hcpriv hasn't been done yet
+ *
+ * NOTE:  control, bulk, and interrupt share the same code to append TDs
+ * to a (possibly active) QH, and the same QH scanning code.
+ */
+static int fusbh200_ehci_urb_enqueue(
+	struct usb_hcd	*hcd,
+	struct urb	*urb,
+	gfp_t		mem_flags
+) {
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	struct list_head	qtd_list;
+
+	INIT_LIST_HEAD(&qtd_list);
+	switch (usb_pipetype(urb->pipe)) {
+	case PIPE_CONTROL:
+		/* qh_completions() code doesn't handle all the fault cases
+		 * in multi-TD control transfers.  Even 1KB is rare anyway.
+		 */
+		if (urb->transfer_buffer_length > (16 * 1024))
+			return -EMSGSIZE;
+		/* FALLTHROUGH */
+	/* case PIPE_BULK: */
+	default:
+		if (!qh_urb_transaction(ehci, urb, &qtd_list, mem_flags))
+			return -ENOMEM;
+		return submit_async(ehci, urb, &qtd_list, mem_flags);
+
+	case PIPE_INTERRUPT:
+		if (!qh_urb_transaction(ehci, urb, &qtd_list, mem_flags))
+			return -ENOMEM;
+		return intr_submit(ehci, urb, &qtd_list, mem_flags);
+
+	case PIPE_ISOCHRONOUS:
+		return itd_submit(ehci, urb, mem_flags);
+	}
+}
+
+static void unlink_async(struct ehci_hcd *ehci, struct ehci_qh *qh)
+{
+	/* failfast */
+	if (ehci->rh_state != EHCI_RH_RUNNING && ehci->reclaim)
+		end_unlink_async(ehci);
+
+	/* If the QH isn't linked then there's nothing we can do
+	 * unless we were called during a giveback, in which case
+	 * qh_completions() has to deal with it.
+	 */
+	if (qh->qh_state != QH_STATE_LINKED) {
+		if (qh->qh_state == QH_STATE_COMPLETING)
+			qh->needs_rescan = 1;
+		return;
+	}
+
+	/* defer till later if busy */
+	if (ehci->reclaim) {
+		struct ehci_qh		*last;
+
+		for (last = ehci->reclaim;
+				last->reclaim;
+				last = last->reclaim)
+			continue;
+		qh->qh_state = QH_STATE_UNLINK_WAIT;
+		last->reclaim = qh;
+
+	/* start IAA cycle */
+	} else
+		start_unlink_async(ehci, qh);
+}
+
+/* remove from hardware lists
+ * completions normally happen asynchronously
+ */
+
+static int fusbh200_ehci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	struct ehci_qh		*qh;
+	unsigned long		flags;
+	int			rc;
+	spin_lock_irqsave(&ehci->lock, flags);
+	rc = usb_hcd_check_unlink_urb(hcd, urb, status);
+	if (rc)
+		goto done;
+
+	switch (usb_pipetype(urb->pipe)) {
+	default:
+		qh = (struct ehci_qh *) urb->hcpriv;
+		if (!qh)
+			break;
+		switch (qh->qh_state) {
+		case QH_STATE_LINKED:
+		case QH_STATE_COMPLETING:
+			unlink_async(ehci, qh);
+			break;
+		case QH_STATE_UNLINK:
+		case QH_STATE_UNLINK_WAIT:
+			/* already started */
+			break;
+		case QH_STATE_IDLE:
+			/* QH might be waiting for a Clear-TT-Buffer */
+			qh_completions(ehci, qh);
+			break;
+		}
+		break;
+
+	case PIPE_INTERRUPT:
+		qh = (struct ehci_qh *) urb->hcpriv;
+		if (!qh)
+			break;
+		switch (qh->qh_state) {
+		case QH_STATE_LINKED:
+		case QH_STATE_COMPLETING:
+			intr_deschedule(ehci, qh);
+			break;
+		case QH_STATE_IDLE:
+			qh_completions(ehci, qh);
+			break;
+		default:
+			ehci_dbg(ehci, "bogus qh %p state %d\n",
+					qh, qh->qh_state);
+			goto done;
+		}
+		break;
+
+	case PIPE_ISOCHRONOUS:
+		/* itd or sitd ...
+		   wait till next completion, do it then.
+		   completion irqs can wait up to 1024 msec,
+		*/
+		break;
+	}
+done:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+	return rc;
+}
+
+struct hc_driver ehci_fusbh200_hc_driver = {
+	.description 		= hcd_name,
+	.product_desc 		= "Faraday USB2.0 Host Controller",
+	.hcd_priv_size 		= sizeof(struct ehci_hcd),
+
+	/*
+	 * generic hardware linkage
+	 */
+	.irq 			= fusbh200_ehci_irq,
+	.flags 			= HCD_MEMORY | HCD_USB2,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset 			= fusbh200_ehci_init,
+	.start 			= fusbh200_ehci_run,
+	.stop 			= fusbh200_ehci_stop,
+	.shutdown 		= fusbh200_ehci_shutdown,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue 		= fusbh200_ehci_urb_enqueue,
+	.urb_dequeue 		= fusbh200_ehci_urb_dequeue,
+	.endpoint_disable 	= fusbh200_ehci_endpoint_disable,
+	.endpoint_reset 	= fusbh200_ehci_endpoint_reset,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number 	= fusbh200_ehci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_status_data 	= fusbh200_ehci_hub_status_data,
+	.hub_control 		= fusbh200_ehci_hub_control,
+	.bus_suspend 		= fusbh200_ehci_bus_suspend,
+	.bus_resume 		= fusbh200_ehci_bus_resume,
+
+	.relinquish_port 	= fusbh200_ehci_relinquish_port,
+	.port_handed_over 	= fusbh200_ehci_port_handed_over,
+
+	.clear_tt_buffer_complete = fusbh200_ehci_clear_tt_buffer_complete,
+};
+
+void fusbh200_init(u32 addr)
+{
+	u32 reg;
+
+	reg = ioread32((const volatile void __iomem*)(addr + FUSBH200_BMCSR));
+	reg |= FUSBH200_BMCSR_INT_POLARITY;
+	iowrite32(reg, (volatile void __iomem*)(addr + FUSBH200_BMCSR));
+
+	/*Important: If AHB clock is >=15Mhz and <= 30MHz,*/
+	/*please remark this line (Enable half speed)).*/
+	/*IF > 30Hz, Disable half speed*/
+	reg = ioread32((const volatile void __iomem*)(addr + FUSBH200_BMCSR));
+	reg &= ~FUSBH200_BMCSR_VBUS_OFF;
+	iowrite32(reg, (volatile void __iomem*)(addr + FUSBH200_BMCSR));
+
+	reg = ioread32((const volatile void __iomem*)(addr + FUSBH200_BMIER));
+	reg |= FUSBH200_BMIER_OVC_EN | FUSBH200_BMIER_VBUS_ERR_EN;
+	iowrite32(reg, (volatile void __iomem*)(addr + FUSBH200_BMIER));
+}
+
+/**
+ * ehci_hcd_fusbh200_probe - initialize faraday fusbh200 HCDs
+ *
+ * Allocates basic resources for this USB host controller, and
+ * then invokes the start() method for the HCD associated with it
+ * through the hotplug entry's driver_data.
+ */
+int ehci_hcd_fusbh200_probe(struct platform_device *pdev)
+{
+	struct device			*dev = &pdev->dev;
+	struct usb_hcd 			*hcd;
+	struct resource			*res;
+	int 				irq;
+	int 				retval = -ENODEV;
+	int				result;
+	struct ehci_hcd 		*ehci;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	pdev->dev.power.power_state = PMSG_ON;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev,
+			"Found HC with no IRQ. Check %s setup!\n",
+			dev_name(dev));
+		return -ENODEV;
+	}
+	irq = res->start;
+
+	hcd = usb_create_hcd(&ehci_fusbh200_hc_driver, dev,
+			dev_name(dev));
+	if (!hcd) {
+		dev_err(dev, "failed to create hcd with err %d\n", retval);
+		retval = -ENOMEM;
+		goto fail_create_hcd;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(dev));
+		retval = -ENODEV;
+		goto fail_request_resource;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
+				ehci_fusbh200_hc_driver.description)) {
+		dev_dbg(dev, "controller already in use\n");
+		retval = -EBUSY;
+		goto fail_request_resource;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(dev));
+		retval = -ENODEV;
+		goto fail_request_resource;
+	}
+
+	hcd->regs = ioremap_nocache(res->start, resource_size(res));
+	if (hcd->regs == NULL) {
+		dev_dbg(dev, "error mapping memory\n");
+		retval = -EFAULT;
+		goto fail_ioremap;
+	}
+	/* initial HW setting for host and otg */
+	fusbh200_init((u32)hcd->regs);
+
+	ehci = hcd_to_ehci(hcd);
+
+	ehci->big_endian_mmio = 0;
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs
+		+ HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+
+	dbg_hcs_params(ehci, "reset");
+	dbg_hcc_params(ehci, "reset");
+
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+
+	result = fusbh200_ehci_halt(ehci);
+	if (result)
+		return result;
+
+	/* host include transaction-translator, will change speed to FS/LS */
+	hcd->has_tt = 1;
+	ehci->sbrn = 0x20;
+	ehci_port_power(ehci, 0);
+
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (retval) {
+		dev_err(dev, "failed to add hcd with err %d\n", retval);
+		goto fail_add_hcd;
+	}
+
+	return retval;
+
+fail_add_hcd:
+	iounmap(hcd->regs);
+fail_ioremap:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+fail_request_resource:
+	usb_put_hcd(hcd);
+fail_create_hcd:
+	dev_err(dev, "init %s fail, %d\n", dev_name(dev), retval);
+	return retval;
+}
+
+/**
+ * ehci_hcd_fusbh200_remove - shutdown processing for EHCI HCDs
+ * @dev: USB Host Controller being removed
+ *
+ * Reverses the effect of fotg2xx_usb_hcd_probe(), first invoking
+ * the HCD's stop() method.  It is always called from a thread
+ * context, normally "rmmod", "apmd", or something similar.
+ */
+int ehci_hcd_fusbh200_remove(struct platform_device *pdev)
+{
+	struct device *dev	= &pdev->dev;
+	struct usb_hcd *hcd	= dev_get_drvdata(dev);
+
+	if (!hcd)
+		return 0;
+
+	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+struct platform_driver ehci_hcd_fusbh200_driver = {
+	.driver = {
+		.name   = "fusbh200",
+	},
+	.probe  = ehci_hcd_fusbh200_probe,
+	.remove = ehci_hcd_fusbh200_remove,
+};
+
+static int __init ehci_hcd_init(void)
+{
+	int retval = 0;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	printk(KERN_INFO "%s: " DRIVER_DESC "\n", hcd_name);
+	set_bit(USB_EHCI_LOADED, &usb_hcds_loaded);
+	if (test_bit(USB_UHCI_LOADED, &usb_hcds_loaded) ||
+			test_bit(USB_OHCI_LOADED, &usb_hcds_loaded))
+		printk(KERN_WARNING "Warning! ehci_hcd should always be loaded"
+				" before uhci_hcd and ohci_hcd, not after\n");
+
+	pr_debug("%s: block sizes: qh %Zd qtd %Zd itd %Zd sitd %Zd\n",
+		 hcd_name,
+		 sizeof(struct ehci_qh), sizeof(struct ehci_qtd),
+		 sizeof(struct ehci_itd), sizeof(struct ehci_sitd));
+
+#ifdef DEBUG
+	ehci_debug_root = debugfs_create_dir("ehci", usb_debug_root);
+	if (!ehci_debug_root) {
+		retval = -ENOENT;
+		goto err_debug;
+	}
+#endif
+	retval = platform_driver_register(&ehci_hcd_fusbh200_driver);
+	if (retval < 0)
+		goto clean0;
+clean0:
+#ifdef DEBUG
+	debugfs_remove(ehci_debug_root);
+	ehci_debug_root = NULL;
+err_debug:
+#endif
+	clear_bit(USB_EHCI_LOADED, &usb_hcds_loaded);
+	return retval;
+}
+module_init(ehci_hcd_init);
+
+static void __exit ehci_hcd_cleanup(void)
+{
+	platform_driver_unregister(&ehci_hcd_fusbh200_driver);
+#ifdef DEBUG
+	debugfs_remove(ehci_debug_root);
+#endif
+	clear_bit(USB_EHCI_LOADED, &usb_hcds_loaded);
+}
+module_exit(ehci_hcd_cleanup);
diff --git a/drivers/usb/host/fusbh200.h b/drivers/usb/host/fusbh200.h
new file mode 100644
index 0000000..0fcf975
--- /dev/null
+++ b/drivers/usb/host/fusbh200.h
@@ -0,0 +1,907 @@
+/*
+ * Definition of EHCI
+ *
+ * Refer to ehci.h and ehci_def.h
+ *
+ * Copyright (c) 2001-2002 by David Brownell
+ *
+ * Definition of fotg210 by Faraday Tech.
+ *
+ * Copyright (c) 2012 by Yuan-Hsin Chen
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* definitions used for the EHCI driver */
+
+/*
+ * __hc32 and __hc16 are "Host Controller" types, they may be equivalent to
+ * __leXX (normally) or __beXX (given EHCI_BIG_ENDIAN_DESC), depending on
+ * the host controller implementation.
+ *
+ * To facilitate the strongest possible byte-order checking from "sparse"
+ * and so on, we use __leXX unless that's not practical.
+ */
+#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_DESC
+typedef __u32 __bitwise __hc32;
+typedef __u16 __bitwise __hc16;
+#else
+#define __hc32	__le32
+#define __hc16	__le16
+#endif
+
+/* statistics can be kept for tuning/monitoring */
+struct ehci_stats {
+	/* irq usage */
+	unsigned long		normal;
+	unsigned long		error;
+	unsigned long		reclaim;
+	unsigned long		lost_iaa;
+
+	/* termination of urbs from core */
+	unsigned long		complete;
+	unsigned long		unlink;
+};
+
+/* ehci_hcd->lock guards shared data against other CPUs:
+ *   ehci_hcd:	async, reclaim, periodic (and shadow), ...
+ *   usb_host_endpoint: hcpriv
+ *   ehci_qh:	qh_next, qtd_list
+ *   ehci_qtd:	qtd_list
+ *
+ * Also, hold this lock when talking to HC registers or
+ * when updating hw_* fields in shared qh/qtd/... structures.
+ */
+
+#define	EHCI_MAX_ROOT_PORTS	15		/* see HCS_N_PORTS */
+
+enum ehci_rh_state {
+	EHCI_RH_HALTED,
+	EHCI_RH_SUSPENDED,
+	EHCI_RH_RUNNING
+};
+
+struct ehci_hcd {			/* one per controller */
+	/* glue to PCI and HCD framework */
+	struct ehci_caps __iomem *caps;
+	struct ehci_regs __iomem *regs;
+	struct ehci_dbg_port __iomem *debug;
+
+	__u32			hcs_params;	/* cached register copy */
+	spinlock_t		lock;
+	enum ehci_rh_state	rh_state;
+
+	/* async schedule support */
+	struct ehci_qh		*async;
+	struct ehci_qh		*dummy;		/* For AMD quirk use */
+	struct ehci_qh		*reclaim;
+	struct ehci_qh		*qh_scan_next;
+	unsigned		scanning:1;
+
+	/* periodic schedule support */
+#define	DEFAULT_I_TDPS		1024		/* some HCs can do less */
+	unsigned		periodic_size;
+	__hc32			*periodic;	/* hw periodic table */
+	dma_addr_t		periodic_dma;
+	unsigned		i_thresh;	/* uframes HC might cache */
+
+	union ehci_shadow	*pshadow;	/* mirror hw periodic table */
+	int			next_uframe;	/* scan periodic, start here */
+	unsigned		periodic_sched;	/* periodic activity count */
+	unsigned		uframe_periodic_max; /* max periodic time per uframe */
+
+
+	/* list of itds & sitds completed while clock_frame was still active */
+	struct list_head	cached_itd_list;
+	struct list_head	cached_sitd_list;
+	unsigned		clock_frame;
+
+	/* per root hub port */
+	unsigned long		reset_done[EHCI_MAX_ROOT_PORTS];
+
+	/* bit vectors (one bit per port) */
+	unsigned long		bus_suspended;		/* which ports were
+			already suspended at the start of a bus suspend */
+	unsigned long		companion_ports;	/* which ports are
+			dedicated to the companion controller */
+	unsigned long		owned_ports;		/* which ports are
+			owned by the companion during a bus suspend */
+	unsigned long		port_c_suspend;		/* which ports have
+			the change-suspend feature turned on */
+	unsigned long		suspended_ports;	/* which ports are
+			suspended */
+
+	/* per-HC memory pools (could be per-bus, but ...) */
+	struct dma_pool		*qh_pool;	/* qh per active urb */
+	struct dma_pool		*qtd_pool;	/* one or more per qh */
+	struct dma_pool		*itd_pool;	/* itd per iso urb */
+	struct dma_pool		*sitd_pool;	/* sitd per split iso urb */
+
+	struct timer_list	iaa_watchdog;
+	struct timer_list	watchdog;
+	unsigned long		actions;
+	unsigned		periodic_stamp;
+	unsigned		random_frame;
+	unsigned long		next_statechange;
+	ktime_t			last_periodic_enable;
+	u32			command;
+
+	/* SILICON QUIRKS */
+	unsigned		no_selective_suspend:1;
+	unsigned		has_fsl_port_bug:1; /* FreeScale */
+	unsigned		big_endian_mmio:1;
+	unsigned		big_endian_desc:1;
+	unsigned		big_endian_capbase:1;
+	unsigned		has_amcc_usb23:1;
+	unsigned		need_io_watchdog:1;
+	unsigned		broken_periodic:1;
+	unsigned		amd_pll_fix:1;
+	unsigned		fs_i_thresh:1;	/* Intel iso scheduling */
+	unsigned		use_dummy_qh:1;	/* AMD Frame List table quirk*/
+	unsigned		has_synopsys_hc_bug:1; /* Synopsys HC */
+	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
+
+	/* required for usb32 quirk */
+	#define OHCI_CTRL_HCFS          (3 << 6)
+	#define OHCI_USB_OPER           (2 << 6)
+	#define OHCI_USB_SUSPEND        (3 << 6)
+
+	#define OHCI_HCCTRL_OFFSET      0x4
+	#define OHCI_HCCTRL_LEN         0x4
+	__hc32			*ohci_hcctrl_reg;
+	unsigned		has_hostpc:1;
+	unsigned		has_lpm:1;  /* support link power management */
+	unsigned		has_ppcd:1; /* support per-port change bits */
+	u8			sbrn;		/* packed release number */
+
+	/* irq statistics */
+#ifdef EHCI_STATS
+	struct ehci_stats	stats;
+#	define COUNT(x) do { (x)++; } while (0)
+#else
+#	define COUNT(x) do {} while (0)
+#endif
+
+	/* debug files */
+#ifdef DEBUG
+	struct dentry		*debug_dir;
+#endif
+	/*
+	 * OTG controllers and transceivers need software interaction
+	 */
+	struct otg_transceiver	*transceiver;
+};
+
+/* convert between an HCD pointer and the corresponding EHCI_HCD */
+static inline struct ehci_hcd *hcd_to_ehci(struct usb_hcd *hcd)
+{
+	return (struct ehci_hcd *)(hcd->hcd_priv);
+}
+static inline struct usb_hcd *ehci_to_hcd(struct ehci_hcd *ehci)
+{
+	return container_of((void *) ehci, struct usb_hcd, hcd_priv);
+}
+
+
+static inline void
+iaa_watchdog_start(struct ehci_hcd *ehci)
+{
+	WARN_ON(timer_pending(&ehci->iaa_watchdog));
+	mod_timer(&ehci->iaa_watchdog,
+			jiffies + msecs_to_jiffies(EHCI_IAA_MSECS));
+}
+
+static inline void iaa_watchdog_done(struct ehci_hcd *ehci)
+{
+	del_timer(&ehci->iaa_watchdog);
+}
+
+enum ehci_timer_action {
+	TIMER_IO_WATCHDOG,
+	TIMER_ASYNC_SHRINK,
+	TIMER_ASYNC_OFF,
+};
+
+static inline void
+timer_action_done(struct ehci_hcd *ehci, enum ehci_timer_action action)
+{
+	clear_bit(action, &ehci->actions);
+}
+
+static void free_cached_lists(struct ehci_hcd *ehci);
+
+#define	QTD_NEXT(ehci, dma)	cpu_to_hc32(ehci, (u32)dma)
+
+/*
+ * EHCI Specification 0.95 Section 3.5
+ * QTD: describe data transfer components (buffer, direction, ...)
+ * See Fig 3-6 "Queue Element Transfer Descriptor Block Diagram".
+ *
+ * These are associated only with "QH" (Queue Head) structures,
+ * used with control, bulk, and interrupt transfers.
+ */
+struct ehci_qtd {
+	/* first part defined by EHCI spec */
+	__hc32			hw_next;	/* see EHCI 3.5.1 */
+	__hc32			hw_alt_next;    /* see EHCI 3.5.2 */
+	__hc32			hw_token;       /* see EHCI 3.5.3 */
+#define	QTD_TOGGLE	(1 << 31)	/* data toggle */
+#define	QTD_LENGTH(tok)	(((tok)>>16) & 0x7fff)
+#define	QTD_IOC		(1 << 15)	/* interrupt on complete */
+#define	QTD_CERR(tok)	(((tok)>>10) & 0x3)
+#define	QTD_PID(tok)	(((tok)>>8) & 0x3)
+#define	QTD_STS_ACTIVE	(1 << 7)	/* HC may execute this */
+#define	QTD_STS_HALT	(1 << 6)	/* halted on error */
+#define	QTD_STS_DBE	(1 << 5)	/* data buffer error (in HC) */
+#define	QTD_STS_BABBLE	(1 << 4)	/* device was babbling (qtd halted) */
+#define	QTD_STS_XACT	(1 << 3)	/* device gave illegal response */
+#define	QTD_STS_MMF	(1 << 2)	/* incomplete split transaction */
+#define	QTD_STS_STS	(1 << 1)	/* split transaction state */
+#define	QTD_STS_PING	(1 << 0)	/* issue PING? */
+
+#define ACTIVE_BIT(ehci)	cpu_to_hc32(ehci, QTD_STS_ACTIVE)
+#define HALT_BIT(ehci)		cpu_to_hc32(ehci, QTD_STS_HALT)
+#define STATUS_BIT(ehci)	cpu_to_hc32(ehci, QTD_STS_STS)
+
+	__hc32			hw_buf[5];        /* see EHCI 3.5.4 */
+	__hc32			hw_buf_hi[5];        /* Appendix B */
+
+	/* the rest is HCD-private */
+	dma_addr_t		qtd_dma;		/* qtd address */
+	struct list_head	qtd_list;		/* sw qtd list */
+	struct urb		*urb;			/* qtd's urb */
+	size_t			length;			/* length of buffer */
+} __attribute__ ((aligned(32)));
+
+/* mask NakCnt+T in qh->hw_alt_next */
+#define QTD_MASK(ehci)	(cpu_to_hc32(ehci, ~0x1f))
+
+#define IS_SHORT_READ(token) (QTD_LENGTH(token) != 0 && QTD_PID(token) == 1)
+
+/* type tag from {qh,itd,sitd,fstn}->hw_next */
+#define Q_NEXT_TYPE(ehci, dma)	((dma) & cpu_to_hc32(ehci, 3 << 1))
+
+/*
+ * Now the following defines are not converted using the
+ * cpu_to_le32() macro anymore, since we have to support
+ * "dynamic" switching between be and le support, so that the driver
+ * can be used on one system with SoC EHCI controller using big-endian
+ * descriptors as well as a normal little-endian PCI EHCI controller.
+ */
+/* values for that type tag */
+#define Q_TYPE_ITD	(0 << 1)
+#define Q_TYPE_QH	(1 << 1)
+#define Q_TYPE_SITD	(2 << 1)
+#define Q_TYPE_FSTN	(3 << 1)
+
+/* next async queue entry, or pointer to interrupt/periodic QH */
+#define QH_NEXT(ehci, dma)	(cpu_to_hc32(ehci, (((u32)dma)&~0x01f)|Q_TYPE_QH))
+
+/* for periodic/async schedules and qtd lists, mark end of list */
+#define EHCI_LIST_END(ehci)	cpu_to_hc32(ehci, 1) /* "null pointer" to hw */
+
+/*
+ * Entries in periodic shadow table are pointers to one of four kinds
+ * of data structure.  That's dictated by the hardware; a type tag is
+ * encoded in the low bits of the hardware's periodic schedule.  Use
+ * Q_NEXT_TYPE to get the tag.
+ *
+ * For entries in the async schedule, the type tag always says "qh".
+ */
+union ehci_shadow {
+	struct ehci_qh		*qh;		/* Q_TYPE_QH */
+	struct ehci_itd		*itd;		/* Q_TYPE_ITD */
+	struct ehci_sitd	*sitd;		/* Q_TYPE_SITD */
+	struct ehci_fstn	*fstn;		/* Q_TYPE_FSTN */
+	__hc32			*hw_next;	/* (all types) */
+	void			*ptr;
+};
+
+/*
+ * EHCI Specification 0.95 Section 3.6
+ * QH: describes control/bulk/interrupt endpoints
+ * See Fig 3-7 "Queue Head Structure Layout".
+ *
+ * These appear in both the async and (for interrupt) periodic schedules.
+ */
+
+/* first part defined by EHCI spec */
+struct ehci_qh_hw {
+	__hc32			hw_next;	/* see EHCI 3.6.1 */
+	__hc32			hw_info1;       /* see EHCI 3.6.2 */
+#define	QH_HEAD		0x00008000
+	__hc32			hw_info2;        /* see EHCI 3.6.2 */
+#define	QH_SMASK	0x000000ff
+#define	QH_CMASK	0x0000ff00
+#define	QH_HUBADDR	0x007f0000
+#define	QH_HUBPORT	0x3f800000
+#define	QH_MULT		0xc0000000
+	__hc32			hw_current;	/* qtd list - see EHCI 3.6.4 */
+
+	/* qtd overlay (hardware parts of a struct ehci_qtd) */
+	__hc32			hw_qtd_next;
+	__hc32			hw_alt_next;
+	__hc32			hw_token;
+	__hc32			hw_buf[5];
+	__hc32			hw_buf_hi[5];
+} __attribute__ ((aligned(32)));
+
+struct ehci_qh {
+	struct ehci_qh_hw	*hw;
+	/* the rest is HCD-private */
+	dma_addr_t		qh_dma;		/* address of qh */
+	union ehci_shadow	qh_next;	/* ptr to qh; or periodic */
+	struct list_head	qtd_list;	/* sw qtd list */
+	struct ehci_qtd		*dummy;
+	struct ehci_qh		*reclaim;	/* next to reclaim */
+
+	struct ehci_hcd		*ehci;
+	unsigned long		unlink_time;
+
+	/*
+	 * Do NOT use atomic operations for QH refcounting. On some CPUs
+	 * (PPC7448 for example), atomic operations cannot be performed on
+	 * memory that is cache-inhibited (i.e. being used for DMA).
+	 * Spinlocks are used to protect all QH fields.
+	 */
+	u32			refcount;
+	unsigned		stamp;
+
+	u8			needs_rescan;	/* Dequeue during giveback */
+	u8			qh_state;
+#define	QH_STATE_LINKED		1		/* HC sees this */
+#define	QH_STATE_UNLINK		2		/* HC may still see this */
+#define	QH_STATE_IDLE		3		/* HC doesn't see this */
+#define	QH_STATE_UNLINK_WAIT	4		/* LINKED and on reclaim q */
+#define	QH_STATE_COMPLETING	5		/* don't touch token.HALT */
+
+	u8			xacterrs;	/* XactErr retry counter */
+#define	QH_XACTERR_MAX		32		/* XactErr retry limit */
+
+	/* periodic schedule info */
+	u8			usecs;		/* intr bandwidth */
+	u8			gap_uf;		/* uframes split/csplit gap */
+	u8			c_usecs;	/* ... split completion bw */
+	u16			tt_usecs;	/* tt downstream bandwidth */
+	unsigned short		period;		/* polling interval */
+	unsigned short		start;		/* where polling starts */
+#define NO_FRAME ((unsigned short)~0)			/* pick new start */
+
+	struct usb_device	*dev;		/* access to TT */
+	unsigned		is_out:1;	/* bulk or intr OUT */
+	unsigned		clearing_tt:1;	/* Clear-TT-Buf in progress */
+};
+
+/* description of one iso transaction (up to 3 KB data if highspeed) */
+struct ehci_iso_packet {
+	/* These will be copied to iTD when scheduling */
+	u64			bufp;		/* itd->hw_bufp{,_hi}[pg] |= */
+	__hc32			transaction;	/* itd->hw_transaction[i] |= */
+	u8			cross;		/* buf crosses pages */
+	/* for full speed OUT splits */
+	u32			buf1;
+};
+
+/* temporary schedule data for packets from iso urbs (both speeds)
+ * each packet is one logical usb transaction to the device (not TT),
+ * beginning at stream->next_uframe
+ */
+struct ehci_iso_sched {
+	struct list_head	td_list;
+	unsigned		span;
+	struct ehci_iso_packet	packet[0];
+};
+
+/*
+ * ehci_iso_stream - groups all (s)itds for this endpoint.
+ * acts like a qh would, if EHCI had them for ISO.
+ */
+struct ehci_iso_stream {
+	/* first field matches ehci_hq, but is NULL */
+	struct ehci_qh_hw	*hw;
+
+	u32			refcount;
+	u8			bEndpointAddress;
+	u8			highspeed;
+	struct list_head	td_list;	/* queued itds/sitds */
+	struct list_head	free_list;	/* list of unused itds/sitds */
+	struct usb_device	*udev;
+	struct usb_host_endpoint *ep;
+
+	/* output of (re)scheduling */
+	int			next_uframe;
+	__hc32			splits;
+
+	/* the rest is derived from the endpoint descriptor,
+	 * trusting urb->interval == f(epdesc->bInterval) and
+	 * including the extra info for hw_bufp[0..2]
+	 */
+	u8			usecs, c_usecs;
+	u16			interval;
+	u16			tt_usecs;
+	u16			maxp;
+	u16			raw_mask;
+	unsigned		bandwidth;
+
+	/* This is used to initialize iTD's hw_bufp fields */
+	__hc32			buf0;
+	__hc32			buf1;
+	__hc32			buf2;
+
+	/* this is used to initialize sITD's tt info */
+	__hc32			address;
+};
+
+/*
+ * EHCI Specification 0.95 Section 3.3
+ * Fig 3-4 "Isochronous Transaction Descriptor (iTD)"
+ *
+ * Schedule records for high speed iso xfers
+ */
+struct ehci_itd {
+	/* first part defined by EHCI spec */
+	__hc32			hw_next;           /* see EHCI 3.3.1 */
+	__hc32			hw_transaction[8]; /* see EHCI 3.3.2 */
+#define EHCI_ISOC_ACTIVE        (1<<31)        /* activate transfer this slot */
+#define EHCI_ISOC_BUF_ERR       (1<<30)        /* Data buffer error */
+#define EHCI_ISOC_BABBLE        (1<<29)        /* babble detected */
+#define EHCI_ISOC_XACTERR       (1<<28)        /* XactErr - transaction error */
+#define	EHCI_ITD_LENGTH(tok)	(((tok)>>16) & 0x0fff)
+#define	EHCI_ITD_IOC		(1 << 15)	/* interrupt on complete */
+
+#define ITD_ACTIVE(ehci)	cpu_to_hc32(ehci, EHCI_ISOC_ACTIVE)
+
+	__hc32			hw_bufp[7];	/* see EHCI 3.3.3 */
+	__hc32			hw_bufp_hi[7];	/* Appendix B */
+
+	/* the rest is HCD-private */
+	dma_addr_t		itd_dma;	/* for this itd */
+	union ehci_shadow	itd_next;	/* ptr to periodic q entry */
+
+	struct urb		*urb;
+	struct ehci_iso_stream	*stream;	/* endpoint's queue */
+	struct list_head	itd_list;	/* list of stream's itds */
+
+	/* any/all hw_transactions here may be used by that urb */
+	unsigned		frame;		/* where scheduled */
+	unsigned		pg;
+	unsigned		index[8];	/* in urb->iso_frame_desc */
+} __attribute__ ((aligned(64)));
+
+/*-------------------------------------------------------------------------*/
+
+/*
+ * EHCI Specification 0.95 Section 3.4
+ * siTD, aka split-transaction isochronous Transfer Descriptor
+ *       ... describe full speed iso xfers through TT in hubs
+ * see Figure 3-5 "Split-transaction Isochronous Transaction Descriptor (siTD)
+ */
+struct ehci_sitd {
+	/* first part defined by EHCI spec */
+	__hc32			hw_next;
+/* uses bit field macros above - see EHCI 0.95 Table 3-8 */
+	__hc32			hw_fullspeed_ep;	/* EHCI table 3-9 */
+	__hc32			hw_uframe;		/* EHCI table 3-10 */
+	__hc32			hw_results;		/* EHCI table 3-11 */
+#define	SITD_IOC	(1 << 31)	/* interrupt on completion */
+#define	SITD_PAGE	(1 << 30)	/* buffer 0/1 */
+#define	SITD_LENGTH(x)	(0x3ff & ((x)>>16))
+#define	SITD_STS_ACTIVE	(1 << 7)	/* HC may execute this */
+#define	SITD_STS_ERR	(1 << 6)	/* error from TT */
+#define	SITD_STS_DBE	(1 << 5)	/* data buffer error (in HC) */
+#define	SITD_STS_BABBLE	(1 << 4)	/* device was babbling */
+#define	SITD_STS_XACT	(1 << 3)	/* illegal IN response */
+#define	SITD_STS_MMF	(1 << 2)	/* incomplete split transaction */
+#define	SITD_STS_STS	(1 << 1)	/* split transaction state */
+
+#define SITD_ACTIVE(ehci)	cpu_to_hc32(ehci, SITD_STS_ACTIVE)
+
+	__hc32			hw_buf[2];		/* EHCI table 3-12 */
+	__hc32			hw_backpointer;		/* EHCI table 3-13 */
+	__hc32			hw_buf_hi[2];		/* Appendix B */
+
+	/* the rest is HCD-private */
+	dma_addr_t		sitd_dma;
+	union ehci_shadow	sitd_next;	/* ptr to periodic q entry */
+
+	struct urb		*urb;
+	struct ehci_iso_stream	*stream;	/* endpoint's queue */
+	struct list_head	sitd_list;	/* list of stream's sitds */
+	unsigned		frame;
+	unsigned		index;
+} __attribute__ ((aligned(32)));
+
+/*
+ * EHCI Specification 0.96 Section 3.7
+ * Periodic Frame Span Traversal Node (FSTN)
+ *
+ * Manages split interrupt transactions (using TT) that span frame boundaries
+ * into uframes 0/1; see 4.12.2.2.  In those uframes, a "save place" FSTN
+ * makes the HC jump (back) to a QH to scan for fs/ls QH completions until
+ * it hits a "restore" FSTN; then it returns to finish other uframe 0/1 work.
+ */
+struct ehci_fstn {
+	__hc32			hw_next;	/* any periodic q entry */
+	__hc32			hw_prev;	/* qh or EHCI_LIST_END */
+
+	/* the rest is HCD-private */
+	dma_addr_t		fstn_dma;
+	union ehci_shadow	fstn_next;	/* ptr to periodic q entry */
+} __attribute__ ((aligned(32)));
+
+/* Prepare the PORTSC wakeup flags during controller suspend/resume */
+
+#define ehci_prepare_ports_for_controller_suspend(ehci, do_wakeup)	\
+		ehci_adjust_port_wakeup_flags(ehci, true, do_wakeup);
+
+#define ehci_prepare_ports_for_controller_resume(ehci)			\
+		ehci_adjust_port_wakeup_flags(ehci, false, false);
+
+#ifdef CONFIG_PPC_83xx
+/* Some Freescale processors have an erratum in which the TT
+ * port number in the queue head was 0..N-1 instead of 1..N.
+ */
+#define	ehci_has_fsl_portno_bug(e)		((e)->has_fsl_port_bug)
+#else
+#define	ehci_has_fsl_portno_bug(e)		(0)
+#endif
+
+/*
+ * While most USB host controllers implement their registers in
+ * little-endian format, a minority (celleb companion chip) implement
+ * them in big endian format.
+ *
+ * This attempts to support either format at compile time without a
+ * runtime penalty, or both formats with the additional overhead
+ * of checking a flag bit.
+ *
+ * ehci_big_endian_capbase is a special quirk for controllers that
+ * implement the HC capability registers as separate registers and not
+ * as fields of a 32-bit register.
+ */
+
+#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
+#define ehci_big_endian_mmio(e)		((e)->big_endian_mmio)
+#define ehci_big_endian_capbase(e)	((e)->big_endian_capbase)
+#else
+#define ehci_big_endian_mmio(e)		0
+#define ehci_big_endian_capbase(e)	0
+#endif
+
+/*
+ * Big-endian read/write functions are arch-specific.
+ * Other arches can be added if/when they're needed.
+ */
+#if defined(CONFIG_ARM) && defined(CONFIG_ARCH_IXP4XX)
+#define readl_be(addr)		__raw_readl((__force unsigned *)addr)
+#define writel_be(val, addr)	__raw_writel(val, (__force unsigned *)addr)
+#endif
+
+static inline unsigned int ehci_readl(const struct ehci_hcd *ehci,
+			__u32 __iomem *regs)
+{
+#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
+	return ehci_big_endian_mmio(ehci) ?
+		readl_be(regs) :
+		readl(regs);
+#else
+	return readl(regs);
+#endif
+}
+
+static inline void ehci_writel(const struct ehci_hcd *ehci,
+		const unsigned int val, __u32 __iomem *regs)
+{
+#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
+	ehci_big_endian_mmio(ehci) ?
+		writel_be(val, regs) :
+		writel(val, regs);
+#else
+	writel(val, regs);
+#endif
+}
+
+/*
+ * On certain ppc-44x SoC there is a HW issue, that could only worked around with
+ * explicit suspend/operate of OHCI. This function hereby makes sense only on that arch.
+ * Other common bits are dependent on has_amcc_usb23 quirk flag.
+ */
+#ifdef CONFIG_44x
+static inline void set_ohci_hcfs(struct ehci_hcd *ehci, int operational)
+{
+	u32 hc_control;
+
+	hc_control = (readl_be(ehci->ohci_hcctrl_reg) & ~OHCI_CTRL_HCFS);
+	if (operational)
+		hc_control |= OHCI_USB_OPER;
+	else
+		hc_control |= OHCI_USB_SUSPEND;
+
+	writel_be(hc_control, ehci->ohci_hcctrl_reg);
+	(void) readl_be(ehci->ohci_hcctrl_reg);
+}
+#else
+static inline void set_ohci_hcfs(struct ehci_hcd *ehci, int operational)
+{ }
+#endif
+
+/*
+ * The AMCC 440EPx not only implements its EHCI registers in big-endian
+ * format, but also its DMA data structures (descriptors).
+ *
+ * EHCI controllers accessed through PCI work normally (little-endian
+ * everywhere), so we won't bother supporting a BE-only mode for now.
+ */
+/* cpu to ehci */
+static inline __hc32 cpu_to_hc32(const struct ehci_hcd *ehci, const u32 x)
+{
+	return cpu_to_le32(x);
+}
+
+/* ehci to cpu */
+static inline u32 hc32_to_cpu(const struct ehci_hcd *ehci, const __hc32 x)
+{
+	return le32_to_cpu(x);
+}
+
+static inline u32 hc32_to_cpup(const struct ehci_hcd *ehci, const __hc32 *x)
+{
+	return le32_to_cpup(x);
+}
+
+#ifndef DEBUG
+#define STUB_DEBUG_FILES
+#endif	/* DEBUG */
+
+/* EHCI register interface, corresponds to EHCI Revision 0.95 specification */
+
+/* Section 2.2 Host Controller Capability Registers */
+struct ehci_caps {
+	/* these fields are specified as 8 and 16 bit registers,
+	 * but some hosts can't perform 8 or 16 bit PCI accesses.
+	 */
+	u32		hc_capbase;
+#define HC_LENGTH(p)		((p)&0x00ff)	/* bits 7:0 */
+#define HC_VERSION(p)		(((p)>>16)&0xffff)	/* bits 31:16 */
+	u32		hcs_params;     /* HCSPARAMS - offset 0x4 */
+#define HCS_DEBUG_PORT(p)	(((p)>>20)&0xf)	/* bits 23:20, debug port? */
+#define HCS_INDICATOR(p)	((p)&(1 << 16))	/* true: has port indicators */
+#define HCS_N_CC(p)		(((p)>>12)&0xf)	/* bits 15:12, #companion HCs */
+#define HCS_N_PCC(p)		(((p)>>8)&0xf)	/* bits 11:8, ports per CC */
+#define HCS_PORTROUTED(p)	((p)&(1 << 7))	/* true: port routing */
+#define HCS_PPC(p)		((p)&(1 << 4))	/* true: port power control */
+#define HCS_N_PORTS(p)		(((p)>>0)&0xf)	/* bits 3:0, ports on HC */
+
+	u32		hcc_params;      /* HCCPARAMS - offset 0x8 */
+#define HCC_EXT_CAPS(p)		(((p)>>8)&0xff)	/* for pci extended caps */
+#define HCC_ISOC_CACHE(p)       ((p)&(1 << 7))  /* true: can cache isoc frame */
+#define HCC_ISOC_THRES(p)       (((p)>>4)&0x7)  /* bits 6:4, uframes cached */
+#define HCC_CANPARK(p)		((p)&(1 << 2))  /* true: can park on async qh */
+#define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
+#define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
+	u8		portroute[8];	 /* nibbles for routing - offset 0xC */
+} __attribute__ ((packed));
+
+/* Section 2.3 Host Controller Operational Registers */
+struct ehci_regs {
+
+	/* USBCMD: offset 0x00 */
+	u32		command;
+/* 23:16 is r/w intr rate, in microframes; default "8" == 1/msec */
+#define CMD_PARK	(1<<11)		/* enable "park" on async qh */
+#define CMD_PARK_CNT(c)	(((c)>>8)&3)	/* how many transfers to park for */
+#define CMD_LRESET	(1<<7)		/* partial reset (no ports, etc) */
+#define CMD_IAAD	(1<<6)		/* "doorbell" interrupt async advance */
+#define CMD_ASE		(1<<5)		/* async schedule enable */
+#define CMD_PSE		(1<<4)		/* periodic schedule enable */
+/* 3:2 is periodic frame list size */
+#define CMD_RESET	(1<<1)		/* reset HC not bus */
+#define CMD_RUN		(1<<0)		/* start/stop HC */
+
+	/* USBSTS: offset 0x04 */
+	u32		status;
+#define STS_ASS		(1<<15)		/* Async Schedule Status */
+#define STS_PSS		(1<<14)		/* Periodic Schedule Status */
+#define STS_RECL	(1<<13)		/* Reclamation */
+#define STS_HALT	(1<<12)		/* Not running (any reason) */
+/* some bits reserved */
+	/* these STS_* flags are also intr_enable bits (USBINTR) */
+#define STS_IAA		(1<<5)		/* Interrupted on async advance */
+#define STS_FATAL	(1<<4)		/* such as some PCI access errors */
+#define STS_FLR		(1<<3)		/* frame list rolled over */
+#define STS_PCD		(1<<2)		/* port change detect */
+#define STS_ERR		(1<<1)		/* "error" completion (overflow, ...) */
+#define STS_INT		(1<<0)		/* "normal" completion (short, ...) */
+
+	/* USBINTR: offset 0x08 */
+	u32		intr_enable;
+
+	/* FRINDEX: offset 0x0C */
+	u32		frame_index;	/* current microframe number */
+	/* CTRLDSSEGMENT: offset 0x10 */
+	u32		segment;	/* address bits 63:32 if needed */
+	/* PERIODICLISTBASE: offset 0x14 */
+	u32		frame_list;	/* points to periodic list */
+	/* ASYNCLISTADDR: offset 0x18 */
+	u32		async_next;	/* address of next async queue head */
+
+	/* missed on Faraday controller */
+	/* u32		reserved[9]; */
+
+	/* CONFIGFLAG: offset 0x40 */
+	u32		configured_flag;
+#define FLAG_CF		(1<<0)		/* true: we'll support "high speed" */
+
+	/* PORTSC: offset 0x20 (0x44) */
+	u32		port_status[0];	/* up to N_PORTS */
+/* 31:23 reserved */
+#define PORT_WKOC_E	(1<<22)		/* wake on overcurrent (enable) */
+#define PORT_WKDISC_E	(1<<21)		/* wake on disconnect (enable) */
+#define PORT_WKCONN_E	(1<<20)		/* wake on connect (enable) */
+/* 19:16 for port testing */
+#define PORT_TEST_PKT	(0x4<<16)	/* Port Test Control - packet test */
+#define PORT_LED_OFF	(0<<14)
+#define PORT_LED_AMBER	(1<<14)
+#define PORT_LED_GREEN	(2<<14)
+#define PORT_LED_MASK	(3<<14)
+#define PORT_OWNER	(1<<13)		/* true: companion hc owns this port */
+#define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
+#define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
+/* 11:10 for detecting lowspeed devices (reset vs release ownership) */
+/* 9 reserved */
+#define PORT_RESET	(1<<8)		/* reset port */
+#define PORT_SUSPEND	(1<<7)		/* suspend port */
+#define PORT_RESUME	(1<<6)		/* resume it */
+#define PORT_OCC	(1<<5)		/* over current change */
+#define PORT_OC		(1<<4)		/* over current active */
+#define PORT_PEC	(1<<3)		/* port enable change */
+#define PORT_PE		(1<<2)		/* port enable */
+#define PORT_CSC	(1<<1)		/* connect status change */
+#define PORT_CONNECT	(1<<0)		/* device connected */
+#define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
+} __attribute__ ((packed));
+
+#define USBMODE		0x68		/* USB Device mode */
+#define USBMODE_SDIS	(1<<3)		/* Stream disable */
+#define USBMODE_BE	(1<<2)		/* BE/LE endianness select */
+#define USBMODE_CM_HC	(3<<0)		/* host controller mode */
+#define USBMODE_CM_IDLE	(0<<0)		/* idle state */
+
+/* Moorestown has some non-standard registers, partially due to the fact that
+ * its EHCI controller has both TT and LPM support. HOSTPCx are extentions to
+ * PORTSCx
+ */
+#define HOSTPC0		0x84		/* HOSTPC extension */
+#define HOSTPC_PHCD	(1<<22)		/* Phy clock disable */
+#define HOSTPC_PSPD	(3<<25)		/* Port speed detection */
+#define USBMODE_EX	0xc8		/* USB Device mode extension */
+#define USBMODE_EX_VBPS	(1<<5)		/* VBus Power Select On */
+#define USBMODE_EX_HC	(3<<0)		/* host controller mode */
+#define TXFILLTUNING	0x24		/* TX FIFO Tuning register */
+#define TXFIFO_DEFAULT	(8<<16)		/* FIFO burst threshold 8 */
+
+/* Appendix C, Debug port ... intended for use with special "debug devices"
+ * that can help if there's no serial console.  (nonstandard enumeration.)
+ */
+struct ehci_dbg_port {
+	u32	control;
+#define DBGP_OWNER	(1<<30)
+#define DBGP_ENABLED	(1<<28)
+#define DBGP_DONE	(1<<16)
+#define DBGP_INUSE	(1<<10)
+#define DBGP_ERRCODE(x)	(((x)>>7)&0x07)
+#	define DBGP_ERR_BAD	1
+#	define DBGP_ERR_SIGNAL	2
+#define DBGP_ERROR	(1<<6)
+#define DBGP_GO		(1<<5)
+#define DBGP_OUT	(1<<4)
+#define DBGP_LEN(x)	(((x)>>0)&0x0f)
+	u32	pids;
+#define DBGP_PID_GET(x)		(((x)>>16)&0xff)
+#define DBGP_PID_SET(data, tok)	(((data)<<8)|(tok))
+	u32	data03;
+	u32	data47;
+	u32	address;
+#define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
+} __attribute__ ((packed));
+
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+#include <linux/init.h>
+extern int __init early_dbgp_init(char *s);
+extern struct console early_dbgp_console;
+#endif /* CONFIG_EARLY_PRINTK_DBGP */
+
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+/* Call backs from ehci host driver to ehci debug driver */
+extern int dbgp_external_startup(void);
+extern int dbgp_reset_prep(void);
+#else
+static inline int dbgp_reset_prep(void)
+{
+	return 1;
+}
+static inline int dbgp_external_startup(void)
+{
+	return -1;
+}
+#endif
+
+static inline unsigned ehci_read_frame_index(struct ehci_hcd *ehci)
+{
+	return ehci_readl(ehci, &ehci->regs->frame_index);
+}
+
+/* Bus Monitor Control/Status Register (Address = 40h) */
+#define FUSBH200_BMCSR			0x40
+#define FUSBH200_BMCSR_VBUS_FLT_SEL	BIT(0)
+#define FUSBH200_BMCSR_HDISCON_FLT_SEL	BIT(1)
+#define FUSBH200_BMCSR_HALF_SPEED	BIT(2)
+#define FUSBH200_BMCSR_INT_POLARITY	BIT(3)
+#define FUSBH200_BMCSR_VBUS_OFF		BIT(4)
+#define FUSBH200_BMCSR_VBUS_VLD		BIT(8)
+#define FUSBH200_BMCSR_HOST_SPD_TYP	(BIT(9) | BIT(10))
+
+#ifdef CONFIG_711MA_PHY
+/* Cover 711MA PHY (Full speed reset issue) */
+#define mwH20_Control_COVER_FS_PHY_Reset_Set(base)    REG_OR_WRITE(base, 0x40, BIT(12))
+#define mwH20_Control_COVER_FS_PHY_Reset_Clr(base)    REG_CLR(base, 0x40, BIT(12))
+#endif
+
+/* Bus Monitor Interrupt Status Register (Address = 44h) */
+#define FUSBH200_BMISR		0x44
+#define FUSBH200_BMISR_VBUS_ERR		BIT(0)
+#define FUSBH200_BMISR_OVC		BIT(1)
+#define FUSBH200_BMISR_DPLGRMV		BIT(2)
+#define FUSBH200_BMISR_DMA_CMPLT	BIT(3)
+#define FUSBH200_BMISR_DMA_ERROR	BIT(4)
+
+/* Bus Monitor Interrupt Enable Register (Address = 48h) */
+#define FUSBH200_BMIER		0x48
+#define FUSBH200_BMIER_DMA_ERROR_EN	BIT(4)
+#define FUSBH200_BMIER_DMA_CMPLT_EN	BIT(3)
+#define FUSBH200_BMIER_DPLGRMV_EN	BIT(2)
+#define FUSBH200_BMIER_OVC_EN		BIT(1)
+#define FUSBH200_BMIER_VBUS_ERR_EN	BIT(0)
+
+/*
+ * Some EHCI controllers have a Transaction Translator built into the
+ * root hub. This is a non-standard feature.  Each controller will need
+ * to add code to the following inline functions, and call them as
+ * needed (mostly in root hub code).
+ */
+
+#define	ehci_is_TDI(e)			(ehci_to_hcd(e)->has_tt)
+
+/* Returns the speed of a device attached to a port on the root hub. */
+static inline unsigned int
+ehci_port_speed(struct ehci_hcd *ehci, unsigned int portsc)
+{
+	u32 __iomem *reg_ptr;
+	u32 tmp;
+
+	reg_ptr = (u32 __iomem *)(((u8 __iomem *)ehci->caps) +
+		FUSBH200_BMCSR);
+	tmp = readl(reg_ptr);
+	tmp = (tmp & FUSBH200_BMCSR_HOST_SPD_TYP) >> 9;
+
+	if (tmp == 2)
+		return USB_PORT_STAT_HIGH_SPEED;
+	else if (tmp == 1)
+		return USB_PORT_STAT_LOW_SPEED;
+	else if (tmp == 0)
+		return 0;
+	else
+		return USB_PORT_STAT_HIGH_SPEED;
+}
-- 
1.7.4.1

