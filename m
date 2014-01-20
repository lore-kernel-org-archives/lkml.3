Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaATEf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:35:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50249 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaATEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:34:55 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>
CC: Satish Patel <satish.patel@ti.com>
Subject: [PATCH v2 3/5] char: ti-usim: Add driver for USIM module on AM43xx
Date: Mon, 20 Jan 2014 10:03:52 +0530
Message-ID: <1390192434-19386-4-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI-USIM driver is a platform driver that provides a character
driver interface to user applications.

It allows user applications to call IOCTL's to
perform smart card operations.

Driver currently supports
- ATR
- T=0 & T=1 protocol
- clock stop mode
- smart card clock configuration
- Tx/Rx application data units (APDU) to smart card
- Interface to PHY using DT & phy interface

Validation is done with ACOS3 smart cards

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 .../devicetree/bindings/ti-usim/ti-usim.txt        |   31 +
 drivers/char/Kconfig                               |    7 +
 drivers/char/Makefile                              |    1 +
 drivers/char/ti-usim-hw.h                          |  863 +++++++++
 drivers/char/ti-usim.c                             | 1859 ++++++++++++++++++++
 include/linux/ti-usim.h                            |   98 +
 6 files changed, 2859 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ti-usim/ti-usim.txt
 create mode 100644 drivers/char/ti-usim-hw.h
 create mode 100644 drivers/char/ti-usim.c
 create mode 100644 include/linux/ti-usim.h

diff --git a/Documentation/devicetree/bindings/ti-usim/ti-usim.txt b/Documentation/devicetree/bindings/ti-usim/ti-usim.txt
new file mode 100644
index 0000000..6dc5d9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/ti-usim/ti-usim.txt
@@ -0,0 +1,31 @@
+ti-usim: USIM - Smart Card Controller
+
+Required Properties:
+- compatible: Should be "ti,usim"
+- reg: Specifies base physical address and size of the USIM registers
+- interrupts:  Interrupt number for the USIM controller
+- ti,hwmods: Name of the hwmod associated to the USIM controller
+
+- clocks	: list of clock specifiers, corresponding to entries in  the
+		  clock-names property
+- clock-names   : should contain "opt_fck" and "opt_fck32" entries, matching
+		  entries in the clocks property.
+
+Optional properties:
+- pinctrl-0: Should specify pin control group used for this controller.
+- pinctrl-names: Should contain only one value - "default", for more details
+                 please refer to pinctrl-bindings.txt
+
+- phy : Should specify <smart card phy> reference connected to controller
+- phy-slots : No of slots to which controller will communicate
+
+Example:
+
+usim0: usim@48034000 {
+	       compatible = "ti,usim";
+	       reg = <0x48034000 0x1000>;
+	       interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+	       ti,hwmods = "usim0";
+	       clocks = <&usim0_opt_fck>, <&usim0_opt_fck32>;
+	       clock-names = "opt_fck", "opt_fck32";
+       };
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index fa3243d..dee0209 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -599,5 +599,12 @@ config TILE_SROM
 	  device appear much like a simple EEPROM, and knows
 	  how to partition a single ROM for multiple purposes.
 
+config TI_USIM
+	tristate "Character device access to TI's USIM module on AM43X"
+	depends on SOC_AM43XX
+	help
+	This device creates a character device interface that enables
+	user applications to exchange data with TI's USIM module.
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 7ff1d0d..763fd3d 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -62,3 +62,4 @@ obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
+obj-$(CONFIG_TI_USIM)          += ti-usim.o
diff --git a/drivers/char/ti-usim-hw.h b/drivers/char/ti-usim-hw.h
new file mode 100644
index 0000000..b6d69ff
--- /dev/null
+++ b/drivers/char/ti-usim-hw.h
@@ -0,0 +1,863 @@
+/*
+ * ti-usim-hw.h - Header file for USIM smart card interface
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __TI_USIM_HW_H__
+#define __TI_USIM_HW_H__
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <linux/sc_phy.h>
+#include <linux/ti-usim.h>
+
+
+#define USIM_MAX_SLOTS	0x2
+
+/* WWT Work Wait Time */
+#define USIM_EMV_WI      (10)
+#define USIM_EMV_WWT     ((960 * USIM_EMV_WI) + (480))
+/* CGT Character Guard Time */
+#define USIM_EMV_CGT     (12)
+
+#define USIM_ATR_TIMEOUT_EMV	(20160)
+#define USIM_EMV_ATR_EARLY_TO	(370)
+#define USIM_EMV_ATR_MUTE_TO	(42000)
+
+#define USIM_MAX_RX_FIFO_SIZE    (260)
+#define USIM_MAX_TX_FIFO_SIZE    (260)
+#define USIM_MAX_PARITY_RETRIES  (7)
+
+#define USIM_IRQ_NATR           (0x00000001)
+#define USIM_IRQ_WT		(0x00000002)
+#define USIM_IRQ_RXFULL		(0x00000004)
+#define USIM_IRQ_TX		(0x00000008)
+#define USIM_IRQ_RX		(0x00000010)
+#define USIM_IRQ_CD		(0x00000020)
+#define USIM_IRQ_EOB		(0x00000040)
+#define USIM_IRQ_TOC		(0x00000080)
+#define USIM_IRQ_TOB		(0x00000100)
+#define USIM_IRQ_RESENT		(0x00000200)
+#define USIM_IRQ_TS_ERR		(0x00000400)
+#define USIM_IRQ_EMV_ATR_LENGTH_TIME_OUT	(0x00000800)
+#define USIM_IRQ_STOP		(0x00001000)
+#define USIM_IRQ_PAR_ERR_LEVEL_REACHED	(0x00002000)
+#define USIM_IRQ_FRAME_ERR	(0x00004000)
+#define USIM_IRQ_RXDMA_RDY	(0x00008000)
+#define USIM_IRQ_ATR_START	(0x00010000)
+#define USIM_IRQ_ACT_DONE	(0x00020000)
+#define USIM_IRQ_DEACT_DONE	(0x00040000)
+#define USIM_IRQ_TX_BLOCK_DONE	(0x00080000)
+#define USIM_IRQ_TX_BLOCK_REQ	(0x00100000)
+
+#define USIM_CONFSCLKMODE_LEGACY	0x0
+#define USIM_CONFSCLKMODE_HF		0x1
+
+/*
+ * Different operating modes supported in USIM.
+ * Programming USIM to a different mode from current mode would
+ * endup in state machine state change within the IPs FSM
+ */
+enum usim_mode {
+	USIM_MODE_LEGACY = 0x0,
+	USIM_MODE_FREEZE = 0x1,
+	USIM_MODE_TXRX   = 0x2,
+	USIM_MODE_ATR    = 0x3,
+	USIM_MODE_ACT    = 0x4,
+	USIM_MODE_DEACT  = 0x5,
+	USIM_MODE_IDLE   = 0x6,
+};
+
+/*
+ * structure to store slot specific information
+ */
+struct usim_slotcontext {
+	char atr[USIM_MAX_ATRLENGTH];
+	char rxbuf[USIM_MAX_APDU_LENGTH];
+	bool emv;
+	enum usim_mode state;
+	int event;
+	int protocol;
+	enum usim_card_voltage supply;
+	int rx_explen;
+	int rx_counter;
+	int atr_length;
+	enum usim_smartcard_clock clock;
+};
+
+struct usim {
+	struct device *dev;
+
+	/* to protect interrput handling */
+	spinlock_t	lock;
+	int irq;
+	void __iomem            *base;
+	int slot;
+	int max_slots;
+	int phy_present;
+	int txdone;
+	int rxdone;
+	int atrdone;
+	int user_pid;
+	int enable;
+	struct sc_phy *phy;
+	struct usim_slotcontext *slot_ctx;
+
+	struct clk      *opt_fclk;
+	struct clk      *opt_fclk32;
+	struct clk      *usim_dbclk;
+	struct clk      *clkdiv32k_ick;
+	struct clk      *usim0_fck;
+	struct clk      *dpll_core_m4_ck;
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry	*debugfs_root;
+#endif
+};
+
+/*
+ * Register Definitions: Taken from auto generated file
+ */
+#define USIM_REVISION                    (0x0U)
+#define USIM_IDENT                       (0x4U)
+#define USIM_SYSCONFIG                   (0x10U)
+#define USIM_SYSSTATUS                   (0x14U)
+#define USIM_IRQSTATUS                   (0x18U)
+#define USIM_IRQENABLE                   (0x1cU)
+#define USIM_WAKEUPEN                    (0x20U)
+#define USIM_CMD                         (0x24U)
+#define USIM_STAT                        (0x28U)
+#define USIM_CONF1                       (0x2cU)
+#define USIM_CONF2                       (0x30U)
+#define USIM_CONF3                       (0x34U)
+#define USIM_DRX                         (0x38U)
+#define USIM_DTX                         (0x3cU)
+#define USIM_FIFOS                       (0x40U)
+#define USIM_CGT                         (0x44U)
+#define USIM_CWT                         (0x48U)
+#define USIM_BWT                         (0x4cU)
+#define USIM_DEBUG                       (0x50U)
+#define USIM_CONF_SAM1_DIV               (0x54U)
+#define USIM_CONF4                       (0x58U)
+#define USIM_ATR_CLK_PRD_NBS             (0x5cU)
+#define USIM_CONF_ETU_DIV                (0x60U)
+#define USIM_CONF5                       (0x64U)
+#define USIM_TC_GUARD_TIME_ADD           (0x68U)
+#define USIM_RXFIFO_LEVEL                (0x6cU)
+#define USIM_RXFIFO_BYTECNT              (0x70U)
+#define USIM_WWT                         (0x74U)
+#define USIM_CONF6                       (0x78U)
+#define USIM_IO_DIRECT                   (0x7cU)
+#define USIM_TX_BLOCK                    (0x84U)
+
+/*
+ * Field Definition Macros
+ */
+#define USIM_REVISION_REV_SHIFT                       (0U)
+#define USIM_REVISION_REV_MASK                        (0x000000ffU)
+
+#define USIM_REVISION_RESERVED_24_SHIFT               (8U)
+#define USIM_REVISION_RESERVED_24_MASK                (0xffffff00U)
+
+#define USIM_IDENT_VC_SHIFT                           (0U)
+#define USIM_IDENT_VC_MASK                            (0x0000ffffU)
+
+#define USIM_IDENT_RESERVED_16_31_SHIFT               (16U)
+#define USIM_IDENT_RESERVED_16_31_MASK                (0xffff0000U)
+
+#define USIM_SYSCONFIG_AUTOIDLE_SHIFT                 (0U)
+#define USIM_SYSCONFIG_AUTOIDLE_MASK                  (0x00000001U)
+#define USIM_SYSCONFIG_AUTOIDLE_AUTOIDLE_VALUE_1       (1U)
+#define USIM_SYSCONFIG_AUTOIDLE_AUTOIDLE_VALUE_0       (0U)
+
+#define USIM_SYSCONFIG_SOFTRESET_SHIFT                (1U)
+#define USIM_SYSCONFIG_SOFTRESET_MASK                 (0x00000002U)
+#define USIM_SYSCONFIG_SOFTRESET_SOFTRESET_VALUE_1     (1U)
+#define USIM_SYSCONFIG_SOFTRESET_SOFTRESET_VALUE_0     (0U)
+
+#define USIM_SYSCONFIG_ENAWAKEUP_SHIFT                (2U)
+#define USIM_SYSCONFIG_ENAWAKEUP_MASK                 (0x00000004U)
+#define USIM_SYSCONFIG_ENAWAKEUP_ENAWAKEUP_VALUE_1     (1U)
+#define USIM_SYSCONFIG_ENAWAKEUP_ENAWAKEUP_VALUE_0     (0U)
+
+#define USIM_SYSCONFIG_IDLEMODE_SHIFT                 (3U)
+#define USIM_SYSCONFIG_IDLEMODE_MASK                  (0x00000018U)
+#define USIM_SYSCONFIG_IDLEMODE_IDLEMODE_VALUE_3       (3U)
+#define USIM_SYSCONFIG_IDLEMODE_IDLEMODE_VALUE_2       (2U)
+#define USIM_SYSCONFIG_IDLEMODE_IDLEMODE_VALUE_1       (1U)
+#define USIM_SYSCONFIG_IDLEMODE_IDLEMODE_VALUE_0       (0U)
+
+#define USIM_SYSCONFIG_EMUFREE_SHIFT                  (5U)
+#define USIM_SYSCONFIG_EMUFREE_MASK                   (0x00000020U)
+#define USIM_SYSCONFIG_EMUFREE_EMUFREE_VALUE_0         (0U)
+#define USIM_SYSCONFIG_EMUFREE_EMUFREE_VALUE_1         (1U)
+
+#define USIM_SYSCONFIG_RESERVED_6_7_SHIFT             (6U)
+#define USIM_SYSCONFIG_RESERVED_6_7_MASK              (0x000000c0U)
+
+#define USIM_SYSCONFIG_CLOCKACTIVITY_SHIFT            (8U)
+#define USIM_SYSCONFIG_CLOCKACTIVITY_MASK             (0x00000300U)
+
+#define USIM_SYSCONFIG_RESERVED_22_SHIFT              (10U)
+#define USIM_SYSCONFIG_RESERVED_22_MASK               (0xfffffc00U)
+
+#define USIM_SYSSTATUS_RESETDONE_SHIFT                (0U)
+#define USIM_SYSSTATUS_RESETDONE_MASK                 (0x00000001U)
+#define USIM_SYSSTATUS_RESETDONE_RESETDONE_VALUE_1     (1U)
+#define USIM_SYSSTATUS_RESETDONE_RESETDONE_VALUE_0     (0U)
+
+#define USIM_SYSSTATUS_RESERVED_31_SHIFT              (1U)
+#define USIM_SYSSTATUS_RESERVED_31_MASK               (0xfffffffeU)
+
+#define USIM_IRQSTATUS_USIM_NATR_SHIFT                (0U)
+#define USIM_IRQSTATUS_USIM_NATR_MASK                 (0x00000001U)
+
+#define USIM_IRQSTATUS_USIM_WT_SHIFT                  (1U)
+#define USIM_IRQSTATUS_USIM_WT_MASK                   (0x00000002U)
+
+#define USIM_IRQSTATUS_USIM_RXFULL_SHIFT              (2U)
+#define USIM_IRQSTATUS_USIM_RXFULL_MASK               (0x00000004U)
+
+#define USIM_IRQSTATUS_USIM_TX_SHIFT                  (3U)
+#define USIM_IRQSTATUS_USIM_TX_MASK                   (0x00000008U)
+
+#define USIM_IRQSTATUS_USIM_RX_SHIFT                  (4U)
+#define USIM_IRQSTATUS_USIM_RX_MASK                   (0x00000010U)
+
+#define USIM_IRQSTATUS_USIM_CD_SHIFT                  (5U)
+#define USIM_IRQSTATUS_USIM_CD_MASK                   (0x00000020U)
+
+#define USIM_IRQSTATUS_USIM_EOB_SHIFT                 (6U)
+#define USIM_IRQSTATUS_USIM_EOB_MASK                  (0x00000040U)
+
+#define USIM_IRQSTATUS_USIM_TOC_SHIFT                 (7U)
+#define USIM_IRQSTATUS_USIM_TOC_MASK                  (0x00000080U)
+
+#define USIM_IRQSTATUS_USIM_TOB_SHIFT                 (8U)
+#define USIM_IRQSTATUS_USIM_TOB_MASK                  (0x00000100U)
+
+#define USIM_IRQSTATUS_USIM_RESENT_SHIFT              (9U)
+#define USIM_IRQSTATUS_USIM_RESENT_MASK               (0x00000200U)
+
+#define USIM_IRQSTATUS_TS_ERROR_SHIFT                 (10U)
+#define USIM_IRQSTATUS_TS_ERROR_MASK                  (0x00000400U)
+
+#define USIM_IRQSTATUS_IT_EMV_ATR_LENGTH_TIME_OUT_SHIFT  (11U)
+#define USIM_IRQSTATUS_IT_EMV_ATR_LENGTH_TIME_OUT_MASK   (0x00000800U)
+
+#define USIM_IRQSTATUS_RESERVED_SHIFT                    (21U)
+#define USIM_IRQSTATUS_RESERVED_MASK                     (0xffe00000U)
+
+#define USIM_IRQSTATUS_USIM_STOP_CLK_SHIFT               (12U)
+#define USIM_IRQSTATUS_USIM_STOP_CLK_MASK                (0x00001000U)
+
+#define USIM_IRQSTATUS_PAR_ERR_LEVEL_REACHED_SHIFT       (13U)
+#define USIM_IRQSTATUS_PAR_ERR_LEVEL_REACHED_MASK        (0x00002000U)
+
+#define USIM_IRQSTATUS_FRAME_ERR_SHIFT            (14U)
+#define USIM_IRQSTATUS_FRAME_ERR_MASK             (0x00004000U)
+
+#define USIM_IRQSTATUS_RXDMA_RDY_SHIFT            (15U)
+#define USIM_IRQSTATUS_RXDMA_RDY_MASK             (0x00008000U)
+
+#define USIM_IRQSTATUS_ATR_START_SHIFT            (16U)
+#define USIM_IRQSTATUS_ATR_START_MASK             (0x00010000U)
+
+#define USIM_IRQSTATUS_ACT_DONE_SHIFT             (17U)
+#define USIM_IRQSTATUS_ACT_DONE_MASK              (0x00020000U)
+
+#define USIM_IRQSTATUS_DEACT_DONE_SHIFT           (18U)
+#define USIM_IRQSTATUS_DEACT_DONE_MASK            (0x00040000U)
+
+#define USIM_IRQSTATUS_TX_BLOCK_DONE_SHIFT        (19U)
+#define USIM_IRQSTATUS_TX_BLOCK_DONE_MASK         (0x00080000U)
+
+#define USIM_IRQSTATUS_TX_BLOCK_REQ_SHIFT         (20U)
+#define USIM_IRQSTATUS_TX_BLOCK_REQ_MASK          (0x00100000U)
+
+#define USIM_IRQENABLE_RESERVED_SHIFT             (21U)
+#define USIM_IRQENABLE_RESERVED_MASK              (0xffe00000U)
+
+#define USIM_IRQENABLE_EMV_ATR_LENGTH_TIME_OUT_EN_SHIFT    (11U)
+#define USIM_IRQENABLE_EMV_ATR_LENGTH_TIME_OUT_EN_MASK     (0x00000800U)
+
+#define USIM_IRQENABLE_TS_ERR_EN_SHIFT         (10U)
+#define USIM_IRQENABLE_TS_ERR_EN_MASK          (0x00000400U)
+
+#define USIM_IRQENABLE_RESENT_EN_SHIFT         (9U)
+#define USIM_IRQENABLE_RESENT_EN_MASK          (0x00000200U)
+
+#define USIM_IRQENABLE_TOB_EN_SHIFT            (8U)
+#define USIM_IRQENABLE_TOB_EN_MASK             (0x00000100U)
+
+#define USIM_IRQENABLE_TOC_EN_SHIFT            (7U)
+#define USIM_IRQENABLE_TOC_EN_MASK             (0x00000080U)
+
+#define USIM_IRQENABLE_EOB_EN_SHIFT            (6U)
+#define USIM_IRQENABLE_EOB_EN_MASK             (0x00000040U)
+
+#define USIM_IRQENABLE_CD_EN_SHIFT             (5U)
+#define USIM_IRQENABLE_CD_EN_MASK              (0x00000020U)
+
+#define USIM_IRQENABLE_RX_EN_SHIFT             (4U)
+#define USIM_IRQENABLE_RX_EN_MASK              (0x00000010U)
+
+#define USIM_IRQENABLE_TX_EN_SHIFT             (3U)
+#define USIM_IRQENABLE_TX_EN_MASK              (0x00000008U)
+
+#define USIM_IRQENABLE_RXFULL_EN_SHIFT         (2U)
+#define USIM_IRQENABLE_RXFULL_EN_MASK          (0x00000004U)
+
+#define USIM_IRQENABLE_WT_EN_SHIFT             (1U)
+#define USIM_IRQENABLE_WT_EN_MASK              (0x00000002U)
+
+#define USIM_IRQENABLE_NATR_EN_SHIFT           (0U)
+#define USIM_IRQENABLE_NATR_EN_MASK            (0x00000001U)
+
+#define USIM_IRQENABLE_STOP_CLK_SHIFT          (12U)
+#define USIM_IRQENABLE_STOP_CLK_MASK           (0x00001000U)
+
+#define USIM_IRQENABLE_PAR_ERR_LEVEL_REACHED_EN_SHIFT      (13U)
+#define USIM_IRQENABLE_PAR_ERR_LEVEL_REACHED_EN_MASK       (0x00002000U)
+
+#define USIM_IRQENABLE_FRAME_ERR_EN_SHIFT           (14U)
+#define USIM_IRQENABLE_FRAME_ERR_EN_MASK            (0x00004000U)
+
+#define USIM_IRQENABLE_RXDMA_RDY_EN_SHIFT           (15U)
+#define USIM_IRQENABLE_RXDMA_RDY_EN_MASK            (0x00008000U)
+
+#define USIM_IRQENABLE_ATR_START_EN_SHIFT           (16U)
+#define USIM_IRQENABLE_ATR_START_EN_MASK            (0x00010000U)
+
+#define USIM_IRQENABLE_ACT_DONE_EN_SHIFT            (17U)
+#define USIM_IRQENABLE_ACT_DONE_EN_MASK             (0x00020000U)
+
+#define USIM_IRQENABLE_DEACT_DONE_EN_SHIFT          (18U)
+#define USIM_IRQENABLE_DEACT_DONE_EN_MASK           (0x00040000U)
+
+#define USIM_IRQENABLE_TX_BLOCK_DONE_EN_SHIFT       (19U)
+#define USIM_IRQENABLE_TX_BLOCK_DONE_EN_MASK        (0x00080000U)
+
+#define USIM_IRQENABLE_TX_BLOCK_REQ_EN_SHIFT        (20U)
+#define USIM_IRQENABLE_TX_BLOCK_REQ_EN_MASK         (0x00100000U)
+
+#define USIM_WAKEUPEN_STOP_CLK_SHIFT                (12U)
+#define USIM_WAKEUPEN_STOP_CLK_MASK                 (0x00001000U)
+
+#define USIM_WAKEUPEN_NATR_EN_SHIFT                 (0U)
+#define USIM_WAKEUPEN_NATR_EN_MASK                  (0x00000001U)
+
+#define USIM_WAKEUPEN_WT_EN_SHIFT                   (1U)
+#define USIM_WAKEUPEN_WT_EN_MASK                    (0x00000002U)
+
+#define USIM_WAKEUPEN_RXFULL_EN_SHIFT               (2U)
+#define USIM_WAKEUPEN_RXFULL_EN_MASK                (0x00000004U)
+
+#define USIM_WAKEUPEN_TX_EN_SHIFT                   (3U)
+#define USIM_WAKEUPEN_TX_EN_MASK                    (0x00000008U)
+
+#define USIM_WAKEUPEN_RX_EN_SHIFT                   (4U)
+#define USIM_WAKEUPEN_RX_EN_MASK                    (0x00000010U)
+
+#define USIM_WAKEUPEN_CD_EN_SHIFT                   (5U)
+#define USIM_WAKEUPEN_CD_EN_MASK                    (0x00000020U)
+
+#define USIM_WAKEUPEN_EOB_EN_SHIFT                  (6U)
+#define USIM_WAKEUPEN_EOB_EN_MASK                   (0x00000040U)
+
+#define USIM_WAKEUPEN_TOC_EN_SHIFT                  (7U)
+#define USIM_WAKEUPEN_TOC_EN_MASK                   (0x00000080U)
+
+#define USIM_WAKEUPEN_TOB_EN_SHIFT                  (8U)
+#define USIM_WAKEUPEN_TOB_EN_MASK                   (0x00000100U)
+
+#define USIM_WAKEUPEN_RESENT_EN_SHIFT               (9U)
+#define USIM_WAKEUPEN_RESENT_EN_MASK                (0x00000200U)
+
+#define USIM_WAKEUPEN_TS_ERR_EN_SHIFT               (10U)
+#define USIM_WAKEUPEN_TS_ERR_EN_MASK                (0x00000400U)
+
+#define USIM_WAKEUPEN_EMV_ATR_LENGTH_TIME_OUT_EN_SHIFT    (11U)
+#define USIM_WAKEUPEN_EMV_ATR_LENGTH_TIME_OUT_EN_MASK     (0x00000800U)
+
+#define USIM_WAKEUPEN_RESERVED_SHIFT       (21U)
+#define USIM_WAKEUPEN_RESERVED_MASK        (0xffe00000U)
+
+#define USIM_WAKEUPEN_PAR_ERR_LEVEL_REACHED_EN_SHIFT     (13U)
+#define USIM_WAKEUPEN_PAR_ERR_LEVEL_REACHED_EN_MASK      (0x00002000U)
+
+#define USIM_WAKEUPEN_FRAME_ERR_EN_SHIFT        (14U)
+#define USIM_WAKEUPEN_FRAME_ERR_EN_MASK         (0x00004000U)
+
+#define USIM_WAKEUPEN_RXDMA_RDY_EN_SHIFT        (15U)
+#define USIM_WAKEUPEN_RXDMA_RDY_EN_MASK         (0x00008000U)
+
+#define USIM_WAKEUPEN_ATR_START_EN_SHIFT        (16U)
+#define USIM_WAKEUPEN_ATR_START_EN_MASK         (0x00010000U)
+
+#define USIM_WAKEUPEN_ACT_DONE_EN_SHIFT         (17U)
+#define USIM_WAKEUPEN_ACT_DONE_EN_MASK          (0x00020000U)
+
+#define USIM_WAKEUPEN_DEACT_DONE_EN_SHIFT       (18U)
+#define USIM_WAKEUPEN_DEACT_DONE_EN_MASK        (0x00040000U)
+
+#define USIM_WAKEUPEN_TX_BLOCK_DONE_EN_SHIFT         (19U)
+#define USIM_WAKEUPEN_TX_BLOCK_DONE_EN_MASK          (0x00080000U)
+
+#define USIM_WAKEUPEN_TX_BLOCK_REQ_EN_SHIFT          (20U)
+#define USIM_WAKEUPEN_TX_BLOCK_REQ_EN_MASK           (0x00100000U)
+
+#define USIM_CMD_RESERVED_0_SHIFT                    (0U)
+#define USIM_CMD_RESERVED_0_MASK                     (0x00000001U)
+
+#define USIM_CMD_CMDSTOP_SHIFT                       (1U)
+#define USIM_CMD_CMDSTOP_MASK                        (0x00000002U)
+#define USIM_CMD_CMDSTOP_CMDSTOP_VALUE_0              (0U)
+#define USIM_CMD_CMDSTOP_CMDSTOP_VALUE_1              (1U)
+
+#define USIM_CMD_CMDSTART_SHIFT                      (2U)
+#define USIM_CMD_CMDSTART_MASK                       (0x00000004U)
+#define USIM_CMD_CMDSTART_CMDSTART_VALUE_0            (0U)
+#define USIM_CMD_CMDSTART_CMDSTART_VALUE_1            (1U)
+
+#define USIM_CMD_MODULE_CLK_EN_SHIFT                 (3U)
+#define USIM_CMD_MODULE_CLK_EN_MASK                  (0x00000008U)
+#define USIM_CMD_MODULE_CLK_EN_0                      (0U)
+#define USIM_CMD_MODULE_CLK_EN_1                      (1U)
+
+#define USIM_CMD_CMD_WARM_RST_SHIFT                  (4U)
+#define USIM_CMD_CMD_WARM_RST_MASK                   (0x00000010U)
+#define USIM_CMD_CMD_WARM_RST_WARM_RST_VALUE_1        (1U)
+#define USIM_CMD_CMD_WARM_RST_WARM_RST_VALUE_0        (0U)
+
+#define USIM_CMD_CMD_CLOCK_STOP_SHIFT                (5U)
+#define USIM_CMD_CMD_CLOCK_STOP_MASK                 (0x00000020U)
+#define USIM_CMD_CMD_CLOCK_STOP_1                     (1U)
+#define USIM_CMD_CMD_CLOCK_STOP_0                     (0U)
+
+#define USIM_CMD_RESERVED_7_31_SHIFT                 (7U)
+#define USIM_CMD_RESERVED_7_31_MASK                  (0xffffff80U)
+
+#define USIM_CMD_STOP_EMV_ATR_LENGTH_TIMER_SHIFT     (6U)
+#define USIM_CMD_STOP_EMV_ATR_LENGTH_TIMER_MASK      (0x00000040U)
+#define USIM_CMD_STOP_EMV_ATR_LENGTH_TIMER_1          (1U)
+#define USIM_CMD_STOP_EMV_ATR_LENGTH_TIMER_0          (0U)
+
+#define USIM_STAT_STATNOCARD_SHIFT                   (0U)
+#define USIM_STAT_STATNOCARD_MASK                    (0x00000001U)
+#define USIM_STAT_STATNOCARD_STATNOCARD_VALUE_1       (1U)
+#define USIM_STAT_STATNOCARD_STATNOCARD_VALUE_0       (0U)
+#define USIM_STAT_STATNOCARD_WRITE0                   (0U)
+#define USIM_STAT_STATNOCARD_WRITE1                   (1U)
+
+#define USIM_STAT_RESERVED_7_31_SHIFT                (7U)
+#define USIM_STAT_RESERVED_7_31_MASK                 (0xffffff80U)
+
+#define USIM_STAT_STATTXPAR_SHIFT                    (1U)
+#define USIM_STAT_STATTXPAR_MASK                     (0x00000002U)
+#define USIM_STAT_STATTXPAR_STATTXPAR_VALUE_1         (1U)
+#define USIM_STAT_STATTXPAR_STATTXPAR_VALUE_0         (0U)
+
+#define USIM_STAT_STATLRC_SHIFT                      (2U)
+#define USIM_STAT_STATLRC_MASK                       (0x00000004U)
+#define USIM_STAT_STATLRC_STATLRC_VALUE_1             (1U)
+#define USIM_STAT_STATLRC_STATLRC_VALUE_0             (0U)
+
+#define USIM_STAT_CONFCODCONV_SHIFT                  (3U)
+#define USIM_STAT_CONFCODCONV_MASK                   (0x00000008U)
+#define USIM_STAT_CONFCODCONV_CONFCODCONV_VALUE_1     (1U)
+#define USIM_STAT_CONFCODCONV_CONFCODCONV_VALUE_0     (0U)
+
+#define USIM_STAT_RESERVED_SHIFT                     (4U)
+#define USIM_STAT_RESERVED_MASK                      (0x00000010U)
+
+#define USIM_STAT_FDDEACTSTATE_SHIFT                 (5U)
+#define USIM_STAT_FDDEACTSTATE_MASK                  (0x00000020U)
+#define USIM_STAT_FDDEACTSTATE_FDDEACTSTATE_VALUE_0    (0U)
+#define USIM_STAT_FDDEACTSTATE_FDDEACTSTATE_VALUE_1    (1U)
+
+#define USIM_STAT_ATRRX_AFTER_TIMEOUT_SHIFT           (6U)
+#define USIM_STAT_ATRRX_AFTER_TIMEOUT_MASK            (0x00000040U)
+
+#define USIM_CONF1_CONFSIOLOW_SHIFT                   (1U)
+#define USIM_CONF1_CONFSIOLOW_MASK                    (0x00000002U)
+#define USIM_CONF1_CONFSIOLOW_CONFSIOLOW_VALUE_0       (0U)
+#define USIM_CONF1_CONFSIOLOW_CONFSIOLOW_VALUE_1       (1U)
+
+#define USIM_CONF1_RESERVED_8_31_SHIFT                (8U)
+#define USIM_CONF1_RESERVED_8_31_MASK                 (0xffffff00U)
+
+#define USIM_CONF1_SCLKLEV_SHIFT                      (0U)
+#define USIM_CONF1_SCLKLEV_MASK                       (0x00000001U)
+#define USIM_CONF1_SCLKLEV_SCLKLEV_VALUE_0             (0U)
+#define USIM_CONF1_SCLKLEV_SCLKLEV_VALUE_1             (1U)
+
+#define USIM_CONF1_CONFBYPASS_SHIFT                   (2U)
+#define USIM_CONF1_CONFBYPASS_MASK                    (0x00000004U)
+#define USIM_CONF1_CONFBYPASS_CONFBYPASS_VALUE_0       (0U)
+#define USIM_CONF1_CONFBYPASS_CONFBYPASS_VALUE_1       (1U)
+
+#define USIM_CONF1_SVCCLEV_SHIFT                      (3U)
+#define USIM_CONF1_SVCCLEV_MASK                       (0x00000008U)
+#define USIM_CONF1_SVCCLEV_SVCCLEV_VALUE_0             (0U)
+#define USIM_CONF1_SVCCLEV_SVCCLEV_VALUE_1             (1U)
+
+#define USIM_CONF1_SRSTLEV_SHIFT                      (4U)
+#define USIM_CONF1_SRSTLEV_MASK                       (0x00000010U)
+#define USIM_CONF1_SRSTLEV_SRSTLEV_VALUE_0             (0U)
+#define USIM_CONF1_SRSTLEV_SRSTLEV_VALUE_1             (1U)
+
+#define USIM_CONF1_CONF_SCLK_EN_SHIFT                 (5U)
+#define USIM_CONF1_CONF_SCLK_EN_MASK                  (0x00000020U)
+#define USIM_CONF1_CONF_SCLK_EN_CONF_SCLK_EN_VALUE_0     (0U)
+#define USIM_CONF1_CONF_SCLK_EN_CONF_SCLK_EN_VALUE_1     (1U)
+#define USIM_CONF1_EMV_CONF_SHIFT                       (6U)
+#define USIM_CONF1_EMV_CONF_MASK                        (0x00000040U)
+#define USIM_CONF1_EMV_CONF_EMV_CONF_VALUE_0             (0U)
+#define USIM_CONF1_EMV_CONF_EMV_CONF_VALUE_1             (1U)
+#define USIM_CONF1_BYPASS_HW_AUTO_SHIFT                 (7U)
+#define USIM_CONF1_BYPASS_HW_AUTO_MASK                  (0x00000080U)
+#define USIM_CONF1_BYPASS_HW_AUTO_BYPASS_HW_AUTO_VALUE_0             (0U)
+#define USIM_CONF1_BYPASS_HW_AUTO_BYPASS_HW_AUTO_VALUE_1             (1U)
+
+#define USIM_CONF2_CONFCHKPAR_SHIFT                    (0U)
+#define USIM_CONF2_CONFCHKPAR_MASK                     (0x00000001U)
+#define USIM_CONF2_CONFCHKPAR_CONFCHKPAR_VALUE_0        (0U)
+#define USIM_CONF2_CONFCHKPAR_CONFCHKPAR_VALUE_1        (1U)
+#define USIM_CONF2_RESERVED_22_31_SHIFT                (22U)
+#define USIM_CONF2_RESERVED_22_31_MASK                 (0xffc00000U)
+#define USIM_CONF2_TX_EN_SHIFT                         (1U)
+#define USIM_CONF2_TX_EN_MASK                          (0x00000002U)
+#define USIM_CONF2_CONFSCLKDIV_SHIFT                   (2U)
+#define USIM_CONF2_CONFSCLKDIV_MASK                    (0x0000000cU)
+#define USIM_CONF2_ATR_ASYN_BYPASS_SHIFT               (4U)
+#define USIM_CONF2_ATR_ASYN_BYPASS_MASK                (0x00000010U)
+#define USIM_CONF2_ATR_ASYN_BYPASS_ATR_ASYN_BYPASS_VALUE_0           (0U)
+#define USIM_CONF2_ATR_ASYN_BYPASS_ATR_ASYN_BYPASS_VALUE_1           (1U)
+#define USIM_CONF2_CONFPROTOCOL_SHIFT                   (5U)
+#define USIM_CONF2_CONFPROTOCOL_MASK                    (0x00000020U)
+#define USIM_CONF2_CONFPROTOCOL_CONFPROTOCOL_VALUE_0     (0U)
+#define USIM_CONF2_CONFPROTOCOL_CONFPROTOCOL_VALUE_1     (1U)
+#define USIM_CONF2_CONFEDC_SHIFT                        (6U)
+#define USIM_CONF2_CONFEDC_MASK                         (0x00000040U)
+#define USIM_CONF2_CONFEDC_CONFEDC_VALUE_0               (0U)
+#define USIM_CONF2_CONFEDC_CONFEDC_VALUE_1               (1U)
+#define USIM_CONF2_CONFLRCCHECK_SHIFT                   (7U)
+#define USIM_CONF2_CONFLRCCHECK_MASK                    (0x00000080U)
+#define USIM_CONF2_CONFLRCCHECK_CONFLRCCHECK_VALUE_0     (0U)
+#define USIM_CONF2_CONFLRCCHECK_CONFLRCCHECK_VALUE_1     (1U)
+#define USIM_CONF2_CONFRESENT_SHIFT                     (8U)
+#define USIM_CONF2_CONFRESENT_MASK                      (0x00000700U)
+
+#define USIM_CONF2_CARD_POLARITY_SHIFT                  (11U)
+#define USIM_CONF2_CARD_POLARITY_MASK                   (0x00000800U)
+#define USIM_CONF2_CARD_POLARITY_CARD_POLARITY_VALUE_0     (0U)
+#define USIM_CONF2_CARD_POLARITY_CARD_POLARITY_VALUE_1     (1U)
+
+#define USIM_CONF2_HW_DEACTIV_EN_SHIFT                    (12U)
+#define USIM_CONF2_HW_DEACTIV_EN_MASK                     (0x00001000U)
+#define USIM_CONF2_HW_DEACTIV_EN_HW_DEACTIV_EN_VALUE_0     (0U)
+#define USIM_CONF2_HW_DEACTIV_EN_HW_DEACTIV_EN_VALUE_1     (1U)
+
+#define USIM_CONF2_DEBOUNCE_EN_SHIFT                      (13U)
+#define USIM_CONF2_DEBOUNCE_EN_MASK                       (0x00002000U)
+#define USIM_CONF2_DEBOUNCE_EN_DEBOUNCE_EN_VALUE0          (0U)
+#define USIM_CONF2_DEBOUNCE_EN_DEBOUNCE_EN_VALUE1          (1U)
+
+#define USIM_CONF2_PUT_ERR_IN_FIFO_SHIFT                  (14U)
+#define USIM_CONF2_PUT_ERR_IN_FIFO_MASK                   (0x00004000U)
+
+#define USIM_CONF2_NACKING_EN_SHIFT                       (15U)
+#define USIM_CONF2_NACKING_EN_MASK                        (0x00008000U)
+#define USIM_CONF2_NACKING_EN_DISABLED                     (0U)
+#define USIM_CONF2_NACKING_EN_RXFIFO_FULL_NACK             (1U)
+
+#define USIM_CONF2_PAR_ERR_LEVEL_SHIFT                    (16U)
+#define USIM_CONF2_PAR_ERR_LEVEL_MASK                     (0x00070000U)
+
+#define USIM_CONF2_CONFSCLKMODE_SHIFT                     (19U)
+#define USIM_CONF2_CONFSCLKMODE_MASK                      (0x00080000U)
+
+#define USIM_CONF2_STOP_RESEND_FAILURE_SHIFT              (20U)
+#define USIM_CONF2_STOP_RESEND_FAILURE_MASK               (0x00100000U)
+
+#define USIM_CONF2_STOP_RX_TIMEOUT_SHIFT                  (21U)
+#define USIM_CONF2_STOP_RX_TIMEOUT_MASK                   (0x00200000U)
+
+#define USIM_CONF3_TDUSIM_SHIFT                           (4U)
+#define USIM_CONF3_TDUSIM_MASK                            (0x000000f0U)
+
+#define USIM_CONF3_TFUSIM_SHIFT                           (0U)
+#define USIM_CONF3_TFUSIM_MASK                            (0x0000000fU)
+
+#define USIM_CONF3_RESERVED_8_31_SHIFT                    (8U)
+#define USIM_CONF3_RESERVED_8_31_MASK                     (0xffffff00U)
+
+#define USIM_DRX_USIMDRX_SHIFT                            (0U)
+#define USIM_DRX_USIMDRX_MASK                             (0x000000ffU)
+
+#define USIM_DRX_STATRXPAR_SHIFT                          (8U)
+#define USIM_DRX_STATRXPAR_MASK                           (0x00000100U)
+#define USIM_DRX_STATRXPAR_STATRXPAR_VALUE_1               (1U)
+#define USIM_DRX_STATRXPAR_STATRXPAR_VALUE_0               (0U)
+
+#define USIM_DRX_RESERVED_9_31_SHIFT                      (9U)
+#define USIM_DRX_RESERVED_9_31_MASK                       (0xfffffe00U)
+
+#define USIM_DTX_DTX_SHIFT                                (0U)
+#define USIM_DTX_DTX_MASK                                 (0x000000ffU)
+
+#define USIM_DTX_RESERVED_8_31_SHIFT                      (8U)
+#define USIM_DTX_RESERVED_8_31_MASK                       (0xffffff00U)
+
+#define USIM_FIFOS_DMA_MODE_SHIFT                         (0U)
+#define USIM_FIFOS_DMA_MODE_MASK                          (0x00000001U)
+#define USIM_FIFOS_DMA_MODE_DMA_MODE_VALUE_1               (1U)
+#define USIM_FIFOS_DMA_MODE_DMA_MODE_VALUE_0               (0U)
+
+#define USIM_FIFOS_FIFO_ENABLE_SHIFT                      (1U)
+#define USIM_FIFOS_FIFO_ENABLE_MASK                       (0x00000002U)
+#define USIM_FIFOS_FIFO_ENABLE_FIFO_ENABLE_VALUE_1         (1U)
+#define USIM_FIFOS_FIFO_ENABLE_FIFO_ENABLE_VALUE_0         (0U)
+
+#define USIM_FIFOS_FIFO_TX_TRIGGER_SHIFT                  (23U)
+#define USIM_FIFOS_FIFO_TX_TRIGGER_MASK                   (0xff800000U)
+
+#define USIM_FIFOS_FIFOTX_RESET_SHIFT                     (6U)
+#define USIM_FIFOS_FIFOTX_RESET_MASK                      (0x00000040U)
+#define USIM_FIFOS_FIFOTX_RESET_FIFOTX_RESET_VALUE_1       (1U)
+#define USIM_FIFOS_FIFOTX_RESET_FIFOTX_RESET_VALUE_0       (0U)
+
+#define USIM_FIFOS_FIFOTX_EMPTY_SHIFT                     (7U)
+#define USIM_FIFOS_FIFOTX_EMPTY_MASK                      (0x00000080U)
+#define USIM_FIFOS_FIFOTX_EMPTY_FIFOTX_EMPTY_VALUE_1       (1U)
+#define USIM_FIFOS_FIFOTX_EMPTY_FIFOTX_EMPTY_VALUE_0       (0U)
+
+#define USIM_FIFOS_FIFOTX_FULL_SHIFT                      (8U)
+#define USIM_FIFOS_FIFOTX_FULL_MASK                       (0x00000100U)
+#define USIM_FIFOS_FIFOTX_FULL_FIFOTX_FULL_VALUE_1         (1U)
+#define USIM_FIFOS_FIFOTX_FULL_FIFOTX_FULL_VALUE_0         (0U)
+
+#define USIM_FIFOS_FIFO_RX_TRIGGER_SHIFT                  (9U)
+#define USIM_FIFOS_FIFO_RX_TRIGGER_MASK                   (0x0003fe00U)
+
+#define USIM_FIFOS_FIFORX_RESET_SHIFT                     (18U)
+#define USIM_FIFOS_FIFORX_RESET_MASK                      (0x00040000U)
+#define USIM_FIFOS_FIFORX_RESET_FIFORX_RESET_VALUE_1       (1U)
+#define USIM_FIFOS_FIFORX_RESET_FIFORX_RESET_VALUE_0       (0U)
+
+#define USIM_FIFOS_FIFORX_EMPTY_SHIFT                     (19U)
+#define USIM_FIFOS_FIFORX_EMPTY_MASK                      (0x00080000U)
+#define USIM_FIFOS_FIFORX_EMPTY_FIFORX_EMPTY_VALUE_1       (1U)
+#define USIM_FIFOS_FIFORX_EMPTY_FIFORX_EMPTY_VALUE_0       (0U)
+
+#define USIM_FIFOS_FIFORX_FULL_SHIFT                      (20U)
+#define USIM_FIFOS_FIFORX_FULL_MASK                       (0x00100000U)
+#define USIM_FIFOS_FIFORX_FULL_FIFORX_FULL_VALUE_1         (1U)
+#define USIM_FIFOS_FIFORX_FULL_FIFORX_FULL_VALUE_0         (0U)
+
+#define USIM_FIFOS_RXDMA_TYPE_SHIFT                       (21U)
+#define USIM_FIFOS_RXDMA_TYPE_MASK                        (0x00600000U)
+#define USIM_FIFOS_RXDMA_TYPE_LEGACY                       (0U)
+#define USIM_FIFOS_RXDMA_TYPE_NEW1                         (2U)
+#define USIM_FIFOS_RXDMA_TYPE_NEW2                         (3U)
+
+#define USIM_FIFOS_RESERVED_SHIFT                         (2U)
+#define USIM_FIFOS_RESERVED_MASK                          (0x0000003cU)
+
+#define USIM_CGT_RESERVED_9_31_SHIFT                      (9U)
+#define USIM_CGT_RESERVED_9_31_MASK                       (0xfffffe00U)
+
+#define USIM_CGT_CGT_SHIFT                                (0U)
+#define USIM_CGT_CGT_MASK                                 (0x000001ffU)
+
+#define USIM_CWT_CWT_SHIFT                                (0U)
+#define USIM_CWT_CWT_MASK                                 (0xffffffffU)
+
+#define USIM_BWT_BWT_SHIFT                                (0U)
+#define USIM_BWT_BWT_MASK                                 (0xffffffffU)
+
+#define USIM_DEBUG_RESERVED_25_31_SHIFT                   (25U)
+#define USIM_DEBUG_RESERVED_25_31_MASK                    (0xfe000000U)
+
+#define USIM_DEBUG_MAIN_STATE_DEBUG_SHIFT                 (0U)
+#define USIM_DEBUG_MAIN_STATE_DEBUG_MASK                  (0x0000000fU)
+
+#define USIM_DEBUG_TX_STATE_MACHINE_SHIFT                 (4U)
+#define USIM_DEBUG_TX_STATE_MACHINE_MASK                  (0x00000030U)
+
+#define USIM_DEBUG_RX_STATE_MACHINE_SHIFT                 (6U)
+#define USIM_DEBUG_RX_STATE_MACHINE_MASK                  (0x000000c0U)
+
+#define USIM_DEBUG_RXFIFO_PEAK_SHIFT                      (8U)
+#define USIM_DEBUG_RXFIFO_PEAK_MASK                       (0x0003ff00U)
+
+#define USIM_DEBUG_RXDMA_SHIFT                            (18U)
+#define USIM_DEBUG_RXDMA_MASK                             (0x00040000U)
+
+#define USIM_DEBUG_TXDMA_SHIFT                            (19U)
+#define USIM_DEBUG_TXDMA_MASK                             (0x00080000U)
+
+#define USIM_DEBUG_EMV_MAIN_STATE_DEBUG_SHIFT             (20U)
+#define USIM_DEBUG_EMV_MAIN_STATE_DEBUG_MASK              (0x01f00000U)
+
+#define USIM_CONF_SAM1_DIV_RESERVED_12_31_SHIFT           (12U)
+#define USIM_CONF_SAM1_DIV_RESERVED_12_31_MASK            (0xfffff000U)
+
+#define USIM_CONF_SAM1_DIV_SAM1_DIV_SHIFT                 (0U)
+#define USIM_CONF_SAM1_DIV_SAM1_DIV_MASK                  (0x00000fffU)
+
+#define USIM_CONF4_RESERVED_16_31_SHIFT                   (16U)
+#define USIM_CONF4_RESERVED_16_31_MASK                    (0xffff0000U)
+
+#define USIM_CONF4_CONFWAITI_SHIFT                        (0U)
+#define USIM_CONF4_CONFWAITI_MASK                         (0x0000ffffU)
+
+#define USIM_ATR_CLK_PRD_NBS_RESERVED_16_31_SHIFT         (16U)
+#define USIM_ATR_CLK_PRD_NBS_RESERVED_16_31_MASK          (0xffff0000U)
+
+#define USIM_ATR_CLK_PRD_NBS_CLOCK_NUMBER_BEFORE_ATR_SHIFT   (0U)
+#define USIM_ATR_CLK_PRD_NBS_CLOCK_NUMBER_BEFORE_ATR_MASK    (0x0000ffffU)
+
+#define USIM_CONF_ETU_DIV_RESERVED_16_31_SHIFT       (16U)
+#define USIM_CONF_ETU_DIV_RESERVED_16_31_MASK        (0xffff0000U)
+
+#define USIM_CONF_ETU_DIV_ETU_DIV_SHIFT              (0U)
+#define USIM_CONF_ETU_DIV_ETU_DIV_MASK               (0x0000ffffU)
+
+#define USIM_CONF5_RESERVED_12_31_SHIFT              (9U)
+#define USIM_CONF5_RESERVED_12_31_MASK               (0xfffffe00U)
+
+#define USIM_CONF5_DI_SHIFT                          (0U)
+#define USIM_CONF5_DI_MASK                           (0x0000000fU)
+
+#define USIM_CONF5_FI_SHIFT                          (4U)
+#define USIM_CONF5_FI_MASK                           (0x000000f0U)
+
+#define USIM_CONF5_SOFT_NHARD_FIDI_PROG_SHIFT      (8U)
+#define USIM_CONF5_SOFT_NHARD_FIDI_PROG_MASK       (0x00000100U)
+#define USIM_CONF5_SOFT_NHARD_FIDI_PROG_HARDWARE    (0U)
+#define USIM_CONF5_SOFT_NHARD_FIDI_PROG_SOFTWARE    (1U)
+
+#define USIM_TC_GUARD_TIME_ADD_RESERVED_14_31_SHIFT  (14U)
+#define USIM_TC_GUARD_TIME_ADD_RESERVED_14_31_MASK   (0xffffc000U)
+
+#define USIM_TC_GUARD_TIME_ADD_SOFT_TC_GUARD_TIME_ADD_EN_SHIFT (13U)
+#define USIM_TC_GUARD_TIME_ADD_SOFT_TC_GUARD_TIME_ADD_EN_MASK  (0x00002000U)
+#define USIM_TC_GUARD_TIME_ADD_SOFT_TC_GUARD_TIME_ADD_EN_HW     (0U)
+#define USIM_TC_GUARD_TIME_ADD_SOFT_TC_GUARD_TIME_ADD_EN_SW     (1U)
+
+#define USIM_TC_GUARD_TIME_ADD_SOFT_TC_GUARD_TIME_ADD_SHIFT    (0U)
+#define USIM_TC_GUARD_TIME_ADD_SOFT_TC_GUARD_TIME_ADD_MASK     (0x00001fffU)
+
+#define USIM_RXFIFO_LEVEL_USIM_RXFIFO_LEVEL_SHIFT   (0U)
+#define USIM_RXFIFO_LEVEL_USIM_RXFIFO_LEVEL_MASK    (0x000003ffU)
+
+#define USIM_RXFIFO_LEVEL_RESERVED_SHIFT            (10U)
+#define USIM_RXFIFO_LEVEL_RESERVED_MASK             (0xfffffc00U)
+
+#define USIM_RXFIFO_BYTECNT_USIM_RXFIFO_BYTECNT_SHIFT   (0U)
+#define USIM_RXFIFO_BYTECNT_USIM_RXFIFO_BYTECNT_MASK    (0x000001ffU)
+
+#define USIM_RXFIFO_BYTECNT_RESERVED_SHIFT        (9U)
+#define USIM_RXFIFO_BYTECNT_RESERVED_MASK         (0xfffffe00U)
+
+#define USIM_WWT_WWT_SHIFT                        (0U)
+#define USIM_WWT_WWT_MASK                         (0xffffffffU)
+
+#define USIM_CONF6_MODE_SHIFT                     (0U)
+#define USIM_CONF6_MODE_MASK                      (0x00000007U)
+#define USIM_CONF6_MODE_NO_OVERRIDE                (0U)
+#define USIM_CONF6_MODE_FREEZE                     (1U)
+#define USIM_CONF6_MODE_RX_TX                      (2U)
+#define USIM_CONF6_MODE_ATR                        (3U)
+#define USIM_CONF6_MODE_ACTIVATE                   (4U)
+#define USIM_CONF6_MODE_DEACTIVATE                 (5U)
+#define USIM_CONF6_MODE_IDLE                       (6U)
+#define USIM_CONF6_MODE_RESERVED7                  (7U)
+
+#define USIM_CONF6_RST_POLARITY_SHIFT             (3U)
+#define USIM_CONF6_RST_POLARITY_MASK              (0x00000008U)
+#define USIM_CONF6_RST_POLARITY_ACTIVE_LOW         (0U)
+#define USIM_CONF6_RST_POLARITY_ACTIVE_HIGH        (1U)
+
+#define USIM_CONF6_RESERVED_SHIFT                 (12U)
+#define USIM_CONF6_RESERVED_MASK                  (0x0000f000U)
+
+#define USIM_CONF6_ATR_TIMER_BYPASS_SHIFT         (4U)
+#define USIM_CONF6_ATR_TIMER_BYPASS_MASK          (0x00000010U)
+
+#define USIM_CONF6_IO_BYPASS_SHIFT                (5U)
+#define USIM_CONF6_IO_BYPASS_MASK                 (0x00000060U)
+#define USIM_CONF6_IO_BYPASS_00                    (0U)
+#define USIM_CONF6_IO_BYPASS_10                    (2U)
+#define USIM_CONF6_IO_BYPASS_01                    (1U)
+#define USIM_CONF6_IO_BYPASS_11                    (3U)
+
+#define USIM_CONF6_SCLK0_BYPASS_SHIFT             (7U)
+#define USIM_CONF6_SCLK0_BYPASS_MASK              (0x00000080U)
+
+#define USIM_CONF6_LEN_BYPASS_MASK                (0x00000200U)
+
+#define USIM_CONF6_RST_BYPASS_SHIFT               (10U)
+#define USIM_CONF6_RST_BYPASS_MASK                (0x00000400U)
+
+#define USIM_CONF6_VCC_BYPASS_SHIFT               (11U)
+#define USIM_CONF6_VCC_BYPASS_MASK                (0x00000800U)
+
+#define USIM_CONF6_ATR_TIMEOUT_SHIFT              (16U)
+#define USIM_CONF6_ATR_TIMEOUT_MASK               (0xffff0000U)
+
+#define USIM_IO_DIRECT_SCLK0_SHIFT                (0U)
+#define USIM_IO_DIRECT_SCLK0_MASK                 (0x00000001U)
+
+#define USIM_IO_DIRECT_SIORX0_SHIFT               (2U)
+#define USIM_IO_DIRECT_SIORX0_MASK                (0x00000004U)
+
+#define USIM_IO_DIRECT_SIORX1_SHIFT               (3U)
+#define USIM_IO_DIRECT_SIORX1_MASK                (0x00000008U)
+
+#define USIM_IO_DIRECT_SIOTX0_SHIFT               (4U)
+#define USIM_IO_DIRECT_SIOTX0_MASK                (0x00000010U)
+
+#define USIM_IO_DIRECT_SIOEN0_SHIFT               (6U)
+#define USIM_IO_DIRECT_SIOEN0_MASK                (0x00000040U)
+
+#define USIM_IO_DIRECT_RST_SHIFT                  (8U)
+#define USIM_IO_DIRECT_RST_MASK                   (0x00000100U)
+
+#define USIM_IO_DIRECT_SVCC_SHIFT                 (9U)
+#define USIM_IO_DIRECT_SVCC_MASK                  (0x00000200U)
+
+#define USIM_IO_DIRECT_SINEX_SHIFT                (10U)
+#define USIM_IO_DIRECT_SINEX_MASK                 (0x00000400U)
+
+#define USIM_IO_DIRECT_LEN_SHIFT                  (11U)
+#define USIM_IO_DIRECT_LEN_MASK                   (0x00000800U)
+
+#define USIM_IO_DIRECT_RNW0_SHIFT                 (12U)
+#define USIM_IO_DIRECT_RNW0_MASK                  (0x00001000U)
+
+#define USIM_IO_DIRECT_RESERVED_SHIFT             (15U)
+#define USIM_IO_DIRECT_RESERVED_MASK              (0xffff8000U)
+
+#define USIM_IO_DIRECT_C4_SHIFT                   (14U)
+#define USIM_IO_DIRECT_C4_MASK                    (0x00004000U)
+
+#define USIM_TX_BLOCK_BLOCK_LENGTH_SHIFT          (0U)
+#define USIM_TX_BLOCK_BLOCK_LENGTH_MASK           (0x0000ffffU)
+
+#define USIM_TX_BLOCK_RESERVED_SHIFT              (16U)
+#define USIM_TX_BLOCK_RESERVED_MASK               (0xffff0000U)
+
+#endif /* __TI_USIM_HW_H__ */
diff --git a/drivers/char/ti-usim.c b/drivers/char/ti-usim.c
new file mode 100644
index 0000000..a2af409
--- /dev/null
+++ b/drivers/char/ti-usim.c
@@ -0,0 +1,1859 @@
+/*
+ * usim.c - USIM driver for Smart Card module
+ *
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/io.h>
+#include <linux/fs.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/i2c.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/ctype.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/debugfs.h>
+#include <linux/notifier.h>
+#include <linux/clk.h>
+/* for send_sig_info */
+#include <linux/rcupdate.h>
+#include <asm/siginfo.h>
+
+#include "ti-usim-hw.h"
+
+#define USIM_WRITEREG(base, offset, field, value)  \
+			usim_writereg(base+offset, offset##_##field##_MASK, \
+				offset##_##field##_SHIFT, value)
+
+#define USIM_READREG(base, offset, field)  \
+	usim_readreg(base+offset, offset##_##field##_MASK, \
+			offset##_##field##_SHIFT)
+
+#define USIM_SETFIELD(reg, offset, field, value)  \
+	usim_setfield(reg, offset##_##field##_MASK, \
+			offset##_##field##_SHIFT, value)
+
+/*
+ * phy states
+ */
+enum usim_phy_state {
+	USIM_PHY_NOT_PRESENT = 0x0,
+	USIM_PHY_PRESENT,
+	USIM_PHY_NOT_ATTACHED,
+};
+
+static struct miscdevice usim_dev;
+
+static DECLARE_WAIT_QUEUE_HEAD(rx_wait);
+static DECLARE_WAIT_QUEUE_HEAD(tx_wait);
+static DECLARE_WAIT_QUEUE_HEAD(atr_wait);
+
+static int usim_set_smartcardclock(struct usim *usim, u32 clock);
+
+static void usim_writereg(void __iomem *base, u32 mask, u32 shift, u32 value)
+{
+	u32 v = readl(base);
+
+	v &= ~mask;
+	v |= (value << shift) & mask;
+	writel(v, base);
+	v = readl(base);
+	return;
+}
+
+static u32 usim_readreg(void __iomem *base, u32 mask, u32 shift)
+{
+	u32 v = readl(base);
+
+	v &= mask;
+	v = (v >> shift);
+	return v;
+}
+
+static u32 usim_setfield(u32 reg, u32 mask, u32 shift, u32 value)
+{
+	reg &= ~mask;
+	reg |= (value << shift) & mask;
+	return reg;
+}
+
+
+static inline void usim_irq_enable(void __iomem *base, u32 irqs)
+{
+	u32 v = readl(base + USIM_IRQENABLE);
+
+	v |= irqs;
+	writel(v, base + USIM_IRQENABLE);
+}
+
+static inline void usim_irq_disable(void __iomem *base, u32 irqs)
+{
+	u32 v = readl(base + USIM_IRQENABLE);
+
+	v &= ~irqs;
+	writel(v, base + USIM_IRQENABLE);
+}
+
+static inline void usim_irq_get(void __iomem *base, u32 *irqs)
+{
+	*irqs = readl(base + USIM_IRQENABLE);
+}
+
+static inline u32 usim_irqstatus(void __iomem *base)
+{
+	return readl(base + USIM_IRQSTATUS);
+}
+
+static inline void usim_irqstatus_clear(void __iomem *base, u32 irqs)
+{
+	writel(irqs, base + USIM_IRQSTATUS);
+}
+
+static inline struct usim *dev_to_usim(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static int usim_send_signal(struct usim *usim, int event)
+{
+	struct siginfo info;
+	struct task_struct *tid;
+	int ret = 0;
+	int pid = usim->user_pid;
+
+	if (pid == 0)
+		return -EINVAL;
+	info.si_signo = USIM_SIGID;
+	info.si_code = SI_QUEUE;
+
+	info.si_int = event;
+	rcu_read_lock();
+
+	/* find task structure associated with this pid */
+	tid = pid_task(find_vpid(pid), PIDTYPE_PID);
+	if (tid == NULL) {
+		dev_err(usim->dev, "usim-err:no such pid :%d\n", pid);
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+
+	rcu_read_unlock();
+
+	/* send the signal */
+	ret = send_sig_info(USIM_SIGID, &info, tid);
+	if (ret < 0) {
+		dev_err(usim->dev, "error sending signal:%d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static void usim_getrx(struct usim *usim)
+{
+	u32 rxlen = 0;
+	u32 cnt = 0;
+
+	/* Check if FIFO contains some data */
+	rxlen = USIM_READREG(usim->base, USIM_RXFIFO_LEVEL,
+					USIM_RXFIFO_LEVEL);
+
+	usim->slot_ctx[usim->slot].rx_counter += rxlen;
+	if (rxlen > 0) {
+		for (cnt = 0; cnt < rxlen; cnt++) {
+			usim->slot_ctx[usim->slot].rxbuf[cnt] =
+				USIM_READREG(usim->base, USIM_DRX, USIMDRX);
+		}
+	}
+}
+
+static void usim_irq_atrhandler(struct usim *usim, u32 reg)
+{
+	u32 event = 0;
+	u32 val = 0;
+	u32 cnt = 0;
+	u32 rxval = 0;
+	if (usim->atrdone)
+		return;
+	do {
+		/* WWT would be used to identify end of ATR */
+		if (reg & (USIM_IRQ_WT | USIM_IRQ_EMV_ATR_LENGTH_TIME_OUT)) {
+			event |= USIM_EVENT_TIMEOUT;
+			val = USIM_READREG(usim->base, USIM_STAT,
+						ATRRX_AFTER_TIMEOUT);
+			if (val) {
+				/* do not store rx character if it comes after
+				 * ATR timeout
+				 */
+				dev_dbg(usim->dev, "Error: Rx after ATR Timeout");
+				break;
+			}
+		}
+		if (reg & USIM_IRQ_TS_ERR) {
+			event |= USIM_EVENT_ERR_FRAME;
+			break;
+		}
+
+		/* check the rx fifo and store available bytes in atrbuf */
+		val = USIM_READREG(usim->base, USIM_RXFIFO_LEVEL,
+						USIM_RXFIFO_LEVEL);
+		cnt = usim->slot_ctx[usim->slot].atr_length;
+
+		while (val > 0) {
+			if (cnt < USIM_MAX_ATRLENGTH) {
+				rxval = readl(usim->base + USIM_DRX);
+				usim->slot_ctx[usim->slot].atr[cnt++] = rxval &
+							USIM_DRX_USIMDRX_MASK;
+				/* check of parity */
+				if (!(rxval & USIM_DRX_STATRXPAR_MASK)) {
+					dev_dbg(usim->dev, "Error: incorrect parity:%0x", rxval);
+					event |= USIM_EVENT_ERR_PARITY;
+				}
+			}
+			val--;
+		}
+
+		usim->slot_ctx[usim->slot].atr_length = cnt;
+	} while (0);
+
+	if (event != 0) {
+		USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_IDLE);
+		usim->slot_ctx[usim->slot].state = USIM_MODE_IDLE;
+		usim->slot_ctx[usim->slot].event = event;
+		usim->atrdone = 1;
+	}
+
+	if (usim->atrdone)
+		wake_up(&atr_wait);
+
+	return;
+}
+
+static void usim_irq_txhandler(struct usim *usim, u32 reg)
+{
+	u32 protocol	= 0;
+	u32 event	= 0;
+
+	if (usim->txdone)
+		return;
+
+	protocol = usim->slot_ctx[usim->slot].protocol;
+	do {
+		if (reg & USIM_IRQ_FRAME_ERR) {
+			event |= USIM_EVENT_ERR_FRAME;
+			break;
+		}
+		if (!protocol && (reg & USIM_IRQ_RESENT)) {
+			event |= USIM_EVENT_ERR_TXRETRY;
+			break;
+		}
+		if (reg & USIM_IRQ_TX_BLOCK_REQ) {
+			/* TODO : As per EMV max tx block will be of 256 bytes
+			 * and USIM controller has sufficient place for this.
+			 * Need to implement this case when it is practially
+			 * required
+			 */
+			dev_dbg(usim->dev, "Error: TX_BLOCK_REQ - Not Implemented");
+		}
+		if (reg & USIM_IRQ_TX_BLOCK_DONE) {
+			usim_irq_disable(usim->base, USIM_IRQ_TX_BLOCK_REQ
+						| USIM_IRQ_TX_BLOCK_DONE
+						| USIM_IRQ_TX);
+			usim->txdone = 1;
+			usim_irq_enable(usim->base, USIM_IRQ_RX | USIM_IRQ_EOB
+						| USIM_IRQ_RXDMA_RDY);
+			break;
+		}
+	} while (0);
+
+	if (event != 0) {
+		USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_IDLE);
+		usim->slot_ctx[usim->slot].state = USIM_MODE_IDLE;
+		usim->slot_ctx[usim->slot].event = event;
+		usim->txdone = 1;
+		usim->rxdone = 1;
+	}
+	if (usim->txdone)
+		wake_up(&tx_wait);
+	return;
+}
+
+static void usim_irq_rxhandler(struct usim *usim, u32 reg)
+{
+	u32 event = 0;
+	u32 val	= 0;
+
+	u32 protocol = usim->slot_ctx[usim->slot].protocol;
+
+	/* if tx not done then do not check of any rx */
+	if (usim->rxdone || !usim->txdone)
+		return;
+
+	/* For T=0 protocol */
+	if (protocol == 0) {
+		do {
+			/* ignore interrupts if expected bytes recevied */
+			if (usim->slot_ctx[usim->slot].rx_counter >=
+					usim->slot_ctx[usim->slot].rx_explen) {
+				dev_dbg(usim->dev, "All bytes recvd,ignore this timeout\n");
+				usim->rxdone = 1;
+				break;
+			}
+
+			if (reg & USIM_IRQ_WT) {
+				dev_dbg(usim->dev, "Expected bytes not recvd counter = %d\n",
+					usim->slot_ctx[usim->slot].rx_counter);
+				usim_getrx(usim);
+				event |= USIM_EVENT_TIMEOUT;
+				break;
+			}
+
+			if (reg & USIM_IRQ_PAR_ERR_LEVEL_REACHED) {
+				dev_err(usim->dev, "Rx parity level reached:%x\n", reg);
+				usim_getrx(usim);
+				event |= USIM_EVENT_ERR_PARITY;
+				break;
+			}
+
+			if (reg & (USIM_IRQ_RX | USIM_IRQ_RXDMA_RDY)) {
+				/* Read number of bytes present in the FIFO */
+				usim_getrx(usim);
+				usim->rxdone = 1;
+				break;
+			}
+		} while (0);
+	} else {
+		/* T=1 protocol */
+		do {
+			if (reg & (USIM_IRQ_TOB | USIM_IRQ_TOC)) {
+				usim_getrx(usim);
+				event |= USIM_EVENT_TIMEOUT;
+				break;
+			}
+			if (reg & USIM_IRQ_EOB) {
+				usim_getrx(usim);
+				usim->rxdone = 1;
+				val = USIM_READREG(usim->base, USIM_STAT,
+								STATLRC);
+				if (val != 0)
+					event |= USIM_EVENT_ERR_LRC;
+				break;
+			}
+		} while (0);
+	}
+
+	if (event != 0 || usim->rxdone == 1) {
+		USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_IDLE);
+		usim->slot_ctx[usim->slot].state = USIM_MODE_IDLE;
+		usim->slot_ctx[usim->slot].event = event;
+		usim->rxdone = 1;
+	}
+
+	if (usim->rxdone)
+		wake_up(&rx_wait);
+
+	return;
+}
+
+static irqreturn_t usim_interrupt(int irq, void *_usim)
+{
+	u32 reg = 0;
+	u32 state = 0;
+	struct usim *usim = (struct usim *)_usim;
+
+	state = usim->slot_ctx[usim->slot].state;
+
+	spin_lock(&usim->lock);
+
+	reg = readl(usim->base + USIM_IRQSTATUS);
+
+	if (state == USIM_MODE_ATR)
+		usim_irq_atrhandler(usim, reg);
+
+	if (state == USIM_MODE_TXRX) {
+		usim_irq_txhandler(usim, reg);
+		usim_irq_rxhandler(usim, reg);
+	}
+
+	if (reg & USIM_IRQSTATUS_USIM_NATR_MASK)
+		dev_dbg(usim->dev, "NO ATR\n");
+
+	if (reg & USIM_IRQSTATUS_USIM_CD_MASK)
+		dev_dbg(usim->dev, "CARD Insert/Removed\n");
+
+	if (reg & USIM_IRQSTATUS_USIM_STOP_CLK_MASK)
+		dev_dbg(usim->dev, "SIM CLK STOPPED\n");
+
+	if (reg & USIM_IRQSTATUS_ACT_DONE_MASK)
+		dev_dbg(usim->dev, "Activation Sequence completed\n");
+
+	if (reg & USIM_IRQSTATUS_DEACT_DONE_MASK)
+		dev_dbg(usim->dev, "Deactivation Sequence complteted\n");
+
+	/* Clear the interrupt by writing the corresponding bit
+	 * in IRQ_STATUS register
+	 */
+	usim_irqstatus_clear(usim->base, reg);
+
+	spin_unlock(&usim->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int usim_configure(struct usim *usim)
+{
+	int reg = 0;
+
+	/* activate phy */
+	if (usim->phy_present)
+		usim->phy->set_config(usim->phy, usim->slot, SC_PHY_MODE,
+				SC_PHY_ACTIVE);
+
+	/* Disable Auto Idle and set NO IDLE config */
+	reg = readl(usim->base + USIM_SYSCONFIG);
+	reg = USIM_SETFIELD(reg, USIM_SYSCONFIG, AUTOIDLE, 0);
+	reg = USIM_SETFIELD(reg, USIM_SYSCONFIG, IDLEMODE, 1);
+	writel(reg, usim->base + USIM_SYSCONFIG);
+
+	if (usim->phy_present) {
+		USIM_WRITEREG(usim->base, USIM_STAT, STATNOCARD, 1);
+		USIM_WRITEREG(usim->base, USIM_CONF1, BYPASS_HW_AUTO, 0);
+	} else {
+		USIM_WRITEREG(usim->base, USIM_STAT, STATNOCARD, 0);
+		USIM_WRITEREG(usim->base, USIM_CONF1, BYPASS_HW_AUTO, 1);
+	}
+
+	/* Set default card type as EMV, Force SIO to low level */
+	reg = readl(usim->base + USIM_CONF1);
+	reg = USIM_SETFIELD(reg, USIM_CONF1, EMV_CONF, 1);
+	reg = USIM_SETFIELD(reg, USIM_CONF1, CONFSIOLOW, 1);
+	writel(reg, usim->base + USIM_CONF1);
+
+	/* Set parity level to 1, auto resent to 2 on parity error,  */
+	reg = readl(usim->base + USIM_CONF2);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, NACKING_EN, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CARD_POLARITY, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFEDC, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFPROTOCOL, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, ATR_ASYN_BYPASS, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFSCLKDIV, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFSCLKMODE, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, PAR_ERR_LEVEL, 1);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFRESENT, 2);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, PUT_ERR_IN_FIFO, 1);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFLRCCHECK, 2);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFSCLKDIV, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF2, CONFCHKPAR, 1);
+
+	if (usim->phy_present) {
+		reg = USIM_SETFIELD(reg, USIM_CONF2, HW_DEACTIV_EN, 0);
+		reg = USIM_SETFIELD(reg, USIM_CONF2, DEBOUNCE_EN, 0);
+	} else {
+		reg = USIM_SETFIELD(reg, USIM_CONF2, HW_DEACTIV_EN, 1);
+	}
+
+	writel(reg, usim->base + USIM_CONF2);
+
+	/* Reset Tx FIFO Pointer */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 0);
+
+	/* Reset Rx FIFO Pointer */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 0);
+
+	/* Configure FIFO settings */
+	/* Set Tx and Rx trigger to 1 byte */
+	reg = readl(usim->base + USIM_FIFOS);
+	reg = USIM_SETFIELD(reg, USIM_FIFOS, FIFO_TX_TRIGGER, 0);
+	reg = USIM_SETFIELD(reg, USIM_FIFOS, FIFO_RX_TRIGGER, 0);
+	reg = USIM_SETFIELD(reg, USIM_FIFOS, RXDMA_TYPE, 0x3);
+	reg = USIM_SETFIELD(reg, USIM_FIFOS, DMA_MODE, 0x0);
+	writel(reg, usim->base + USIM_FIFOS);
+
+	/* Enable FIFO access */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFO_ENABLE, 1);
+
+	/* Use HW mode for ETU calculation and set FI = 372 and DI = 1 */
+	reg = readl(usim->base + USIM_CONF5);
+	reg = USIM_SETFIELD(reg, USIM_CONF5, FI, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF5, DI, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF5, SOFT_NHARD_FIDI_PROG, 0);
+	writel(reg, usim->base + USIM_CONF5);
+
+	/* Configure CONF6 settings */
+	reg = readl(usim->base + USIM_CONF6);
+	reg = USIM_SETFIELD(reg, USIM_CONF6, VCC_BYPASS, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF6, RST_BYPASS, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF6, SCLK0_BYPASS, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF6, RST_POLARITY, 0);
+	reg = USIM_SETFIELD(reg, USIM_CONF6, ATR_TIMER_BYPASS, 1);
+	reg = USIM_SETFIELD(reg, USIM_CONF6, MODE, USIM_CONF6_MODE_FREEZE);
+	writel(reg, usim->base + USIM_CONF6);
+
+	/* Clear all bits in IO_DIRECT register */
+	writel(0, usim->base + USIM_IO_DIRECT);
+
+	/* Disable legacy bypass mode */
+	USIM_WRITEREG(usim->base, USIM_CONF1, CONFBYPASS, 0);
+
+	/* Enable required interrupts */
+	reg = readl(usim->base + USIM_IRQENABLE);
+	writel(reg, usim->base + USIM_IRQENABLE);
+
+	/* Toggling ATR length to ensure 'USIM_STAT_ATRRX_AFTER_TIMEOUT'
+	 * gets disable
+	 */
+	USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMEOUT, 1);
+	USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMEOUT,
+		      USIM_ATR_TIMEOUT_EMV);
+
+	/* Set STOP_RX_TIMEOUT */
+	/* Set STOP_RESEND_FAILURE */
+	USIM_WRITEREG(usim->base, USIM_CONF2, STOP_RX_TIMEOUT, 1);
+	USIM_WRITEREG(usim->base, USIM_CONF2, STOP_RESEND_FAILURE, 1);
+
+	/* set smartcard clock */
+	usim_set_smartcardclock(usim, usim->slot_ctx[usim->slot].clock);
+
+	return 0;
+}
+
+static int usim_set_voltage(struct usim *usim, u32 voltage)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+	/*
+	 * voltage = 0 for 5V,
+	 * voltage = 1 for 3V,
+	 * voltage = 2 for 1.8V,
+	 */
+	if (voltage > 3)
+		return -EINVAL;
+	if (usim->phy_present) {
+		ret = phy->set_config(phy, usim->slot,
+				SC_PHY_CARD_SUPPLY_VOLTAGE, voltage);
+	}
+	usim->slot_ctx[usim->slot].supply = voltage;
+	return ret;
+}
+
+static int usim_set_smartcardclock(struct usim *usim, u32 clock)
+{
+	int clkdiv;
+	int clkmode;
+	struct sc_phy *phy = usim->phy;
+
+	switch (clock) {
+	case USIM_SMARTCART_CLOCK_3_3MHZ:
+		clkmode	= USIM_CONFSCLKMODE_HF;
+		clkdiv	= 3;
+		break;
+
+	case USIM_SMARTCART_CLOCK_4MHZ:
+		clkmode	= USIM_CONFSCLKMODE_HF;
+		clkdiv	= 2;
+		break;
+
+	case USIM_SMARTCART_CLOCK_5MHZ:
+		clkmode	= USIM_CONFSCLKMODE_LEGACY;
+		clkdiv	= 3;
+		break;
+
+	case USIM_SMARTCART_CLOCK_6_6MHZ:
+		clkmode	= USIM_CONFSCLKMODE_LEGACY;
+		clkdiv	= 2;
+		break;
+
+	case USIM_SMARTCART_CLOCK_10MHZ:
+		clkmode	= USIM_CONFSCLKMODE_LEGACY;
+		clkdiv	= 1;
+		break;
+
+	case USIM_SMARTCART_CLOCK_20MHZ:
+		clkmode	= USIM_CONFSCLKMODE_LEGACY;
+		clkdiv	= 0;
+		break;
+
+	default:
+		dev_err(usim->dev, "Unsupported Clock configuration for smartcard\n");
+		return -EINVAL;
+		break;
+	}
+
+	USIM_WRITEREG(usim->base, USIM_CONF2, CONFSCLKMODE, clkmode);
+	USIM_WRITEREG(usim->base, USIM_CONF2, CONFSCLKDIV, clkdiv);
+
+	/* setting phy division to zero, as USIM samples smartcard clk line and
+	 * put the data in USIM fifo. Phy supply the clock to smartcard wihtout
+	 * furhter division
+	 */
+	if (usim->phy_present)
+		phy->set_config(phy, usim->slot, SC_PHY_CLKDIV, 0);
+
+	usim->slot_ctx[usim->slot].clock = clock;
+	return 0;
+}
+
+static int usim_set_etu(struct usim *usim, u32 fi, u32 di)
+{
+	USIM_WRITEREG(usim->base, USIM_CONF5, SOFT_NHARD_FIDI_PROG, 0);
+	USIM_WRITEREG(usim->base, USIM_CONF5, FI, fi);
+	USIM_WRITEREG(usim->base, USIM_CONF5, DI, di);
+	return 0;
+}
+
+static int usim_set_rxparitycount(struct usim *usim, u32 rxcount)
+{
+	if (rxcount > USIM_MAX_PARITY_RETRIES)
+		return -EINVAL;
+
+	/* Program fields required for RX retry in USIM IP */
+	USIM_WRITEREG(usim->base, USIM_CONF2, PAR_ERR_LEVEL, rxcount);
+
+	/* Enable rx parity check */
+	if (rxcount > 0) {
+		USIM_WRITEREG(usim->base, USIM_CONF2, CONFCHKPAR, 1);
+		usim_irq_enable(usim->base, USIM_IRQ_PAR_ERR_LEVEL_REACHED);
+	} else {
+		usim_irq_disable(usim->base, USIM_IRQ_PAR_ERR_LEVEL_REACHED);
+	}
+	return 0;
+}
+
+static int usim_set_txretrycount(struct usim *usim, u32 txcount)
+{
+	if (txcount > USIM_MAX_PARITY_RETRIES)
+		return -EINVAL;
+
+	USIM_WRITEREG(usim->base, USIM_CONF2, CONFRESENT, txcount);
+	if (txcount > 0)
+		usim_irq_enable(usim->base, USIM_IRQ_RESENT);
+	else
+		usim_irq_disable(usim->base, USIM_IRQ_RESENT);
+
+	return 0;
+}
+
+static int usim_set_c4(struct usim *usim, int state)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+	if (usim->phy_present)
+		ret = phy->set_config(phy, usim->slot, SC_PHY_PIN_C4, state);
+	else
+		 USIM_WRITEREG(usim->base, USIM_IO_DIRECT, C4, state);
+	return ret;
+}
+
+static int usim_set_c8(struct usim *usim, int state)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+
+	if (usim->phy_present)
+		ret = phy->set_config(phy, usim->slot, SC_PHY_PIN_C8, state);
+	return ret;
+}
+static int usim_get_version(struct usim *usim)
+{
+	int version = 0x0;
+
+	/* last 16 bytes represents controller version
+	 * and first 16 bytes represents phy version (if connected)
+	 */
+	version = USIM_READREG(usim->base, USIM_REVISION, REV);
+	if (usim->phy_present)
+		version |= ((usim->phy->get_config(usim->phy, 0,
+					SC_PHY_VERSION)) << 0x10);
+	return version;
+}
+static int usim_init_emvusercard(struct usim *usim)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+
+	USIM_WRITEREG(usim->base, USIM_CONF1, EMV_CONF, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, DMA_MODE, 0);
+
+	usim_set_etu(usim, 0, 0);
+
+	if (usim_set_txretrycount(usim, 5) != 0)
+		return -EINVAL;
+
+	if (usim_set_rxparitycount(usim, 5) != 0)
+		return -EINVAL;
+
+	usim_set_c4(usim, 0);
+	usim_set_c8(usim, 0);
+
+	if (usim->phy_present) {
+		/* Set early ATR and mute ATR in case of phy */
+		ret = phy->set_config(phy, usim->slot, SC_PHY_ATR_EARLY_TIME,
+				USIM_EMV_ATR_EARLY_TO);
+		if (ret != 0)
+			return ret;
+
+		ret = phy->set_config(phy, usim->slot, SC_PHY_ATR_MUTE_TIME,
+				USIM_EMV_ATR_MUTE_TO);
+		if (ret != 0)
+			return ret;
+
+		/* enable user slot */
+		ret = phy->set_config(phy, usim->slot, SC_PHY_IO, 1);
+		if (ret != 0)
+			return ret;
+	}
+	/* set cwt,wwt,cgt */
+	USIM_WRITEREG(usim->base, USIM_WWT, WWT, USIM_EMV_WWT);
+	USIM_WRITEREG(usim->base, USIM_CWT, CWT, USIM_EMV_WWT - 22);
+	USIM_WRITEREG(usim->base, USIM_CGT, CGT, USIM_EMV_CGT);
+
+	return 0;
+}
+
+static int usim_warmreset(struct usim *usim)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+
+	usim->slot_ctx[usim->slot].atr_length = 0;
+	USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_IDLE);
+	usim->slot_ctx[usim->slot].state = USIM_MODE_IDLE;
+
+	/* reset FIFO pointer */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 0);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 0);
+
+	USIM_WRITEREG(usim->base, USIM_CMD, STOP_EMV_ATR_LENGTH_TIMER, 0x1);
+	USIM_WRITEREG(usim->base, USIM_CMD, STOP_EMV_ATR_LENGTH_TIMER, 0x0);
+
+	/* Do store bytes with parity error in Rx FIFO */
+	USIM_WRITEREG(usim->base, USIM_CONF2, PUT_ERR_IN_FIFO, 0x1);
+
+	usim_irq_disable(usim->base, (USIM_IRQ_TX | USIM_IRQ_EOB));
+
+	usim->slot_ctx[usim->slot].state = USIM_MODE_ATR;
+
+	/* warm reset the card */
+	if (usim->phy_present) {
+		ret = phy->warm_reset(phy, usim->slot);
+		if (ret != 0)
+			return ret;
+	} else {
+		/* warm reset using USIM */
+		USIM_WRITEREG(usim->base, USIM_CMD, CMD_WARM_RST, 0x1);
+	}
+
+	USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_ATR);
+
+	return 0;
+}
+
+static int usim_activate_card(struct usim *usim)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+
+	usim->atrdone = 0;
+	usim->slot_ctx[usim->slot].atr_length = 0;
+
+	if (usim->slot_ctx[usim->slot].emv)
+		usim_init_emvusercard(usim);
+
+	USIM_WRITEREG(usim->base, USIM_CONF1, EMV_CONF, 1);
+	USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_IDLE);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 0);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 0);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFO_RX_TRIGGER, 0x103);
+
+	/* RXDMA_TYPE = 0x1 - USIM_RXFIFO_BYTECNT value is ignored */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, RXDMA_TYPE, 0x1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFO_ENABLE, 0x1);
+
+	/* Do store bytes with parity error in Rx FIFO */
+	USIM_WRITEREG(usim->base, USIM_CONF2, PUT_ERR_IN_FIFO, 0x1);
+	usim_irq_disable(usim->base, (USIM_IRQ_TX | USIM_IRQ_EOB));
+
+	USIM_WRITEREG(usim->base, USIM_CMD, STOP_EMV_ATR_LENGTH_TIMER, 0x1);
+	USIM_WRITEREG(usim->base, USIM_CMD, STOP_EMV_ATR_LENGTH_TIMER, 0x0);
+
+	/*
+	 * Toggling ATR length to ensure 'USIM_STAT_ATRRX_AFTER_TIMEOUT'
+	 * gets disable. EMVCo Test case ref#1703_21/22
+	 */
+	USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMEOUT, 0x1);
+	USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMEOUT,
+		      USIM_ATR_TIMEOUT_EMV);
+	USIM_WRITEREG(usim->base, USIM_CMD, MODULE_CLK_EN, 0x1);
+
+	usim->slot_ctx[usim->slot].state = USIM_MODE_ATR;
+
+	/* set smartcard clock */
+	usim_set_smartcardclock(usim, usim->slot_ctx[usim->slot].clock);
+
+	/* Activate card */
+	if (usim->phy_present) {
+		usim_irq_disable(usim->base, USIM_IRQ_TX|USIM_IRQ_ATR_START);
+		usim_irq_enable(usim->base, 0xFFFFFFF7);
+		usim_irq_disable(usim->base, USIM_IRQ_NATR);
+		usim_irq_enable(usim->base, USIM_IRQ_EMV_ATR_LENGTH_TIME_OUT);
+		usim_irq_disable(usim->base, USIM_IRQ_TX|USIM_IRQ_ATR_START);
+
+		/* do no bypass ATR length timer, also do not
+		 * disturb the bypass setting of other param
+		 */
+		USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMER_BYPASS, 0x1);
+
+		usim_irqstatus_clear(usim->base, usim_irqstatus(usim->base));
+
+		ret = phy->activate_card(phy, usim->slot);
+		if (ret != 0)
+			return ret;
+	} else {
+		/* Activate using USIM */
+		USIM_WRITEREG(usim->base, USIM_CMD, CMDSTOP, 0x0);
+		USIM_WRITEREG(usim->base, USIM_CMD, CMDSTOP, 0x1);
+	}
+	USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_ATR);
+	return 0;
+}
+
+static int usim_deactivate_card(struct usim *usim)
+{
+	int ret = 0;
+	struct sc_phy *phy = usim->phy;
+
+	/* Use USIM IP for deactivation if there is no phy */
+	if (usim->phy_present == USIM_PHY_PRESENT) {
+		ret = phy->deactivate_card(phy, usim->slot);
+		if (ret != 0)
+			return ret;
+	} else {
+		USIM_WRITEREG(usim->base, USIM_CMD, CMDSTART, 0x0);
+		USIM_WRITEREG(usim->base, USIM_CMD, CMDSTOP, 1);
+	}
+
+	USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_IDLE);
+	USIM_WRITEREG(usim->base, USIM_TX_BLOCK, BLOCK_LENGTH, 0);
+
+	/* Toggling ATR length to ensure 'USIM_STAT_ATRRX_AFTER_TIMEOUT'
+	 * gets disable TC Ref: 1703_21/22
+	 */
+	USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMEOUT, 1);
+	USIM_WRITEREG(usim->base, USIM_CONF6, ATR_TIMEOUT,
+		      USIM_ATR_TIMEOUT_EMV);
+
+	/* stop ATR length timeout */
+	USIM_WRITEREG(usim->base, USIM_CMD, STOP_EMV_ATR_LENGTH_TIMER, 1);
+	usim->slot_ctx[usim->slot].state = USIM_MODE_DEACT;
+
+	return 0;
+}
+
+static void usim_set_protocol(struct usim *usim, int protocol)
+{
+	u32 irq;
+
+	/* As per spec, mask all interrupts before switching
+	 * from one protocol to other.
+	 */
+	usim_irq_get(usim->base, &irq);
+
+	/* disable all interrupts */
+	usim_irq_disable(usim->base, 0xFFFFFFFF);
+
+	/* 0 for T=0 and 1 for T=1 protocol */
+	USIM_WRITEREG(usim->base, USIM_CONF2, CONFPROTOCOL, protocol);
+	usim->slot_ctx[usim->slot].protocol = protocol;
+
+	/* read and clear status */
+	usim_irqstatus_clear(usim->base, usim_irqstatus(usim->base));
+
+	/* now renable interrupts */
+	usim_irq_enable(usim->base, irq);
+	return;
+}
+
+static void usim_configure_rx_pio(struct usim *usim)
+{
+	/* Reset RX FIFO pointers */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFORX_RESET, 0);
+
+	/* read and clear any pending interrupt status */
+	usim_irqstatus_clear(usim->base, usim_irqstatus(usim->base));
+
+	/* Enable WWT underflow interupt,
+	 * RX FIFO full interrupt,
+	 * BWT, CWT and parity error level interrupts.
+	 */
+	usim_irq_enable(usim->base, USIM_IRQ_WT | USIM_IRQ_RXFULL |
+				USIM_IRQ_TOB |
+				USIM_IRQ_TOC |
+				USIM_IRQ_PAR_ERR_LEVEL_REACHED);
+
+	/* Lets disable key RX interrupts. We will enable them later
+	 * when we want to start RX
+	 */
+	usim_irq_disable(usim->base, USIM_IRQ_RX |
+			USIM_IRQ_RXDMA_RDY | USIM_IRQ_EOB);
+
+	/* We will use only RX FIFO threshold in RX */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, RXDMA_TYPE, 0x1);
+
+	if (usim->slot_ctx[usim->slot].protocol == 0) {
+		/* Set Rx FIFO Threshold to expected recv length
+		 * Subtract 1 from length as HW adds 1 to the trigger
+		 */
+		USIM_WRITEREG(usim->base, USIM_FIFOS, FIFO_RX_TRIGGER,
+			      usim->slot_ctx[usim->slot].rx_explen - 1);
+	} else {
+		/* T=1 protocol */
+		/* for T1 we should not use parity error level interrupt */
+		usim_irq_disable(usim->base, USIM_IRQ_PAR_ERR_LEVEL_REACHED);
+
+		/* set RX FIFO threshold to MAX_RX_FIFO size.
+		 * We will rely on End-Of-Block interrupt to
+		 * terminate reception in T1
+		 */
+		USIM_WRITEREG(usim->base, USIM_FIFOS, FIFO_RX_TRIGGER,
+			      USIM_MAX_RX_FIFO_SIZE - 1);
+	}
+	return;
+}
+
+static void usim_configure_tx_pio(struct usim *usim)
+{
+	/* Make sure TX is stopped first by programming
+	 * TX_BLOCK to zero and disabling TX_BLOCK_DONE
+	 * and USIM_IRQ_TX_BLOCK_REQ interrupts
+	 */
+	USIM_WRITEREG(usim->base, USIM_TX_BLOCK, BLOCK_LENGTH, 0);
+	usim_irq_disable(usim->base, USIM_IRQ_TX_BLOCK_DONE |
+							USIM_IRQ_TX_BLOCK_REQ);
+
+	/* We will use Tx Block length feature so clear TX_EN bit */
+	USIM_WRITEREG(usim->base, USIM_CONF2, TX_EN, 0);
+	/* We will not use USIM_TX interrupt for transmit operation */
+	usim_irq_disable(usim->base, USIM_IRQ_TX);
+	/* Reset TX FIFO pointers */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 1);
+	USIM_WRITEREG(usim->base, USIM_FIFOS, FIFOTX_RESET, 0);
+
+	/* Ensure PIO mode is programmed */
+	USIM_WRITEREG(usim->base, USIM_FIFOS, DMA_MODE, 0);
+}
+
+static int usim_send_data(struct usim *usim, char *txbuf, int len)
+{
+	u32 val;
+	int i;
+	int ret = 0;
+
+	usim->txdone = 0;
+	usim->rxdone = 0;
+
+	if (len == 0) {
+		dev_dbg(usim->dev, "Error: Invalid Tx length:%d", len);
+		return -EINVAL;
+	}
+
+	usim->slot_ctx[usim->slot].event = 0;
+
+	/* Configure Tx PIO mode patams */
+	usim_configure_tx_pio(usim);
+
+	/* Tx FIFO must be empty after reset */
+	val = USIM_READREG(usim->base, USIM_FIFOS, FIFOTX_EMPTY);
+	if (val == 0) {
+		dev_dbg(usim->dev, "Error: Tx FIFO is not empty");
+		return -EFAULT;
+	}
+
+	/* write data in Tx FIFO */
+	for (i = 0; i < len; i++) {
+		USIM_WRITEREG(usim->base, USIM_DTX, DTX, txbuf[i]);
+		dev_dbg(usim->dev, "txbyte %d = %x\n", i, txbuf[i]);
+	}
+
+	/* Finally re-enable TX_BLOCK_xxx interrupts and clear RX interrupts */
+	usim_irq_enable(usim->base, USIM_IRQ_TX_BLOCK_DONE |
+						USIM_IRQ_TX_BLOCK_REQ);
+
+	/* For T=0, stop re-tranmission after resend failure */
+	if (usim->slot_ctx[usim->slot].protocol == 0) {
+		USIM_WRITEREG(usim->base, USIM_CONF2, STOP_RESEND_FAILURE, 0);
+		USIM_WRITEREG(usim->base, USIM_CONF2, STOP_RESEND_FAILURE, 1);
+	}
+
+	/* Do not store bytes with parity error in Rx FIFO */
+	USIM_WRITEREG(usim->base, USIM_CONF2, PUT_ERR_IN_FIFO, 0);
+
+	usim_irq_enable(usim->base, USIM_IRQ_TOC);
+
+	if (usim->phy_present)
+		USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_TXRX);
+	else
+		USIM_WRITEREG(usim->base, USIM_CONF6, MODE, USIM_MODE_LEGACY);
+
+	usim->slot_ctx[usim->slot].state = USIM_MODE_TXRX;
+
+	/* Configure Rx settings before performing a Tx
+	 * As soon as we are done with Tx, card will send
+	 * data, which we should be ready to capture
+	 */
+	usim_configure_rx_pio(usim);
+	/* Start TX operation - program TX_BLOCK register to length
+	 * of the TX buffer to start the TX operation.
+	 */
+	USIM_WRITEREG(usim->base, USIM_TX_BLOCK, BLOCK_LENGTH, len);
+
+	/* We need to block the caller here */
+	ret = wait_event_interruptible(tx_wait, (usim->txdone == 1));
+	dev_dbg(usim->dev, "Tx WAIT OVER\n");
+	if (usim->slot_ctx[usim->slot].event == USIM_EVENT_TIMEOUT)
+		usim_send_signal(usim, USIM_EVENT_TIMEOUT);
+
+	return ret;
+}
+
+static int usim_set_config(struct usim *usim, struct usim_config *param)
+{
+	u32 ret = 0;
+	dev_dbg(usim->dev, "param:%d, value:%d\n", param->attr, param->value);
+
+	switch (param->attr) {
+	case USIM_PARAM_CWT:
+		USIM_WRITEREG(usim->base, USIM_CWT, CWT, param->value);
+		break;
+
+	case USIM_PARAM_WWT:
+		USIM_WRITEREG(usim->base, USIM_WWT, WWT, param->value);
+		break;
+
+	case USIM_PARAM_CGT:
+		USIM_WRITEREG(usim->base, USIM_CGT, CGT, param->value);
+		break;
+
+	case USIM_PARAM_BWT:
+		USIM_WRITEREG(usim->base, USIM_BWT, BWT, param->value);
+		break;
+
+	case USIM_PARAM_EDCTYPE:
+		/* 0 = LRC check, 1 = CRC check */
+		USIM_WRITEREG(usim->base, USIM_CONF2, CONFEDC, param->value);
+		break;
+
+	case USIM_PARAM_LRCCHECK:
+		/* 0 = No LRC check, 1 = LRC check */
+		USIM_WRITEREG(usim->base, USIM_CONF2, CONFLRCCHECK,
+			      param->value);
+		break;
+
+	case USIM_PARAM_C4:
+		usim_set_c4(usim, param->value);
+		break;
+
+	case USIM_PARAM_C8:
+		usim_set_c8(usim, param->value);
+		break;
+
+	case USIM_PARAM_PROTOCOL:
+		/* 0 for T=0 and 1 for T=1 */
+		usim_set_protocol(usim, param->value);
+		break;
+
+	case USIM_PARAM_VOLTAGE:
+		ret = usim_set_voltage(usim, param->value);
+		break;
+
+	case USIM_PARAM_EMV:
+		USIM_WRITEREG(usim->base, USIM_CONF1, EMV_CONF, param->value);
+		if (param->value)
+			usim->slot_ctx[usim->slot].emv = true;
+		else
+			usim->slot_ctx[usim->slot].emv = false;
+		break;
+
+	case USIM_PARAM_FI:
+		USIM_WRITEREG(usim->base, USIM_CONF5, SOFT_NHARD_FIDI_PROG, 0);
+		USIM_WRITEREG(usim->base, USIM_CONF5, FI, param->value);
+		break;
+
+	case USIM_PARAM_DI:
+		USIM_WRITEREG(usim->base, USIM_CONF5, SOFT_NHARD_FIDI_PROG, 0);
+		USIM_WRITEREG(usim->base, USIM_CONF5, DI, param->value);
+		break;
+
+	case USIM_PARAM_CODING_CONV:
+		USIM_WRITEREG(usim->base, USIM_STAT, CONFCODCONV, param->value);
+		break;
+
+	case USIM_PARAM_CLOCK_STOP:
+		USIM_WRITEREG(usim->base, USIM_CMD, CMD_CLOCK_STOP,
+			      param->value);
+		break;
+
+	case USIM_PARAM_SMARTCARD_CLOCK:
+		ret = usim_set_smartcardclock(usim, param->value);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int usim_get_config(struct usim *usim, struct usim_config *param)
+{
+	u32 ret = 0;
+	dev_dbg(usim->dev, "param:%d, value:%d\n", param->attr, param->value);
+
+	switch (param->attr) {
+	case USIM_PARAM_CWT:
+		param->value = USIM_READREG(usim->base, USIM_CWT, CWT);
+		break;
+
+	case USIM_PARAM_WWT:
+		param->value = USIM_READREG(usim->base, USIM_WWT, WWT);
+		break;
+
+	case USIM_PARAM_CGT:
+		param->value = USIM_READREG(usim->base, USIM_CGT, CGT);
+		break;
+
+	case USIM_PARAM_BWT:
+		param->value = USIM_READREG(usim->base, USIM_BWT, BWT);
+		break;
+
+	case USIM_PARAM_EDCTYPE:
+		param->value = USIM_READREG(usim->base, USIM_CONF2, CONFEDC);
+		break;
+
+	case USIM_PARAM_LRCCHECK:
+		param->value = USIM_READREG(usim->base, USIM_CONF2,
+				CONFLRCCHECK);
+		break;
+
+	case USIM_PARAM_PROTOCOL:
+		/* 0 for T=0 and 1 for T=1 */
+		param->value = USIM_READREG(usim->base, USIM_CONF2,
+				CONFPROTOCOL);
+		break;
+
+	case USIM_PARAM_VOLTAGE:
+		param->value = usim->slot_ctx[usim->slot].supply;
+		break;
+
+	case USIM_PARAM_EMV:
+		param->value = USIM_READREG(usim->base, USIM_CONF1, EMV_CONF);
+		break;
+
+	case USIM_PARAM_FI:
+		param->value = USIM_READREG(usim->base, USIM_CONF5, FI);
+		break;
+
+	case USIM_PARAM_DI:
+		param->value = USIM_READREG(usim->base, USIM_CONF5, DI);
+		break;
+
+	case USIM_PARAM_CODING_CONV:
+		param->value = USIM_READREG(usim->base, USIM_STAT, CONFCODCONV);
+		break;
+
+	case USIM_PARAM_CLOCK_STOP:
+		param->value = USIM_READREG(usim->base, USIM_CMD,
+					    CMD_CLOCK_STOP);
+		break;
+
+	case USIM_PARAM_SMARTCARD_CLOCK:
+		param->value = usim->slot_ctx[usim->slot].clock;
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static long usim_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct usim *usim = file->private_data;
+	struct usim_data data;
+	struct usim_config param;
+
+	int ret		= 0;
+	int cnt		= 0;
+	int version	= 0;
+	int u_pid	= 0;
+	int present	= 0;
+
+	if (usim->phy_present == USIM_PHY_NOT_ATTACHED)
+		return -ENXIO;
+
+	switch (cmd) {
+	case USIM_IOCTL_GET_PROVIDER_VERSION:
+		dev_dbg(usim->dev, "IOCTL: GET PROVIDER VERSION\n");
+		version = usim_get_version(usim);
+		ret = copy_to_user((unsigned int *)arg, &version,
+				sizeof(unsigned int));
+		if (ret != 0)
+			ret = -EFAULT;
+		break;
+
+	case USIM_IOCTL_ACTIVATE_CARD:
+		dev_dbg(usim->dev, "IOCTL: ACTIVATE CARD\n");
+		if (usim->phy_present) {
+			present = usim->phy->get_config(usim->phy, usim->slot,
+							SC_PHY_CARD_PRESENCE);
+			if (present)
+				ret = usim_activate_card(usim);
+			else
+				ret = -EFAULT;
+		}
+		break;
+
+	case USIM_IOCTL_DEACTIVATE_CARD:
+		dev_dbg(usim->dev, "IOCTL: DEACTIVATE CARD\n");
+		ret = usim_deactivate_card(usim);
+		break;
+
+	case USIM_IOCTL_WARM_RESET:
+		dev_dbg(usim->dev, "IOCTL: WARM RESET\n");
+		ret = usim_warmreset(usim);
+		break;
+
+	case USIM_IOCTL_GET_ATR:
+		dev_dbg(usim->dev, "IOCTL: GET ATR\n");
+		wait_event_interruptible(atr_wait, (usim->atrdone == 1));
+		ret = copy_to_user((char __user *)arg,
+					usim->slot_ctx[usim->slot].atr,
+					usim->slot_ctx[usim->slot].atr_length);
+		if (ret != 0)
+			ret = -EFAULT;
+		else
+			ret = usim->slot_ctx[usim->slot].atr_length;
+		break;
+
+	case USIM_IOCTL_SEND_DATA:
+		dev_dbg(usim->dev, "IOCTL: SEND DATA\n");
+		ret = copy_from_user(&data, (struct usim_data *)arg,
+						sizeof(struct usim_data));
+		if (ret != 0)
+			return -EFAULT;
+
+		usim->slot = data.slot;
+		usim->slot_ctx[usim->slot].rx_explen = data.rxexplen;
+		usim->slot_ctx[usim->slot].rx_counter = 0;
+		for (cnt = 0; cnt < data.txlen; cnt++)
+			dev_dbg(usim->dev, "apdu[%d] = %x\n", cnt,
+				data.apdu[cnt]);
+		ret = usim_send_data(usim, &data.apdu[0], data.txlen);
+		break;
+
+	case USIM_IOCTL_SET_CONFIG:
+		dev_dbg(usim->dev, "IOCTL: SET CONFIG\n");
+		ret = copy_from_user(&param, (struct usim_config *)arg,
+				sizeof(struct usim_config));
+		if (ret != 0)
+			return -EFAULT;
+
+		usim_set_config(usim, &param);
+		break;
+
+	case USIM_IOCTL_GET_CONFIG:
+		dev_dbg(usim->dev, "IOCTL: GET CONFIG\n");
+		ret = copy_from_user(&param, (struct usim_config *)arg,
+				sizeof(struct usim_config));
+		if (ret != 0)
+			return -EFAULT;
+
+		usim_get_config(usim, &param);
+		ret = copy_to_user((struct usim_config *)arg, &param,
+				sizeof(struct usim_config));
+		if (ret != 0)
+			ret = -EFAULT;
+		break;
+
+	case USIM_IOCTL_GET_CARD_PRESENCE:
+		dev_dbg(usim->dev, "IOCTL: CARD PRESENCE\n");
+		if (usim->phy_present) {
+			present = usim->phy->get_config(usim->phy, usim->slot,
+					SC_PHY_CARD_PRESENCE);
+			ret = copy_to_user((unsigned int *)arg, &present,
+					sizeof(unsigned int));
+			if (ret != 0)
+				ret = -EFAULT;
+		}
+		break;
+
+	case USIM_IOCTL_REGISTER_PID:
+		dev_dbg(usim->dev, "IOCTL: USIM_IOCTL_REGISTER_PID");
+		ret = copy_from_user(&u_pid, (int *)arg, sizeof(int));
+		if (ret != 0)
+			return -EFAULT;
+		usim->user_pid = u_pid;
+		break;
+	}
+	return ret;
+}
+
+static ssize_t usim_read(struct file *file, char *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct usim *usim = file->private_data;
+	if (usim->phy_present == USIM_PHY_NOT_ATTACHED)
+		return -ENXIO;
+
+	wait_event_interruptible(rx_wait, (usim->rxdone == 1));
+	dev_dbg(usim->dev, "RX WAIT over\n");
+
+	/* check for timeout and send signal if any */
+	if (usim->slot_ctx[usim->slot].event == USIM_EVENT_TIMEOUT)
+		usim_send_signal(usim, USIM_EVENT_TIMEOUT);
+
+	if (copy_to_user(user_buf, usim->slot_ctx[usim->slot].rxbuf,
+			 usim->slot_ctx[usim->slot].rx_counter)) {
+		dev_err(usim->dev, "Copy failed\n");
+		return -EFAULT;
+	}
+	*ppos = usim->slot_ctx[usim->slot].rx_counter;
+	dev_dbg(usim->dev, "Card response returning %d bytes\n",
+		usim->slot_ctx[usim->slot].rx_counter);
+
+	return usim->slot_ctx[usim->slot].rx_counter;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+#define DUMP_REG(r) seq_printf(s, "%-25s: %08x\n", #r, readl(usim->base + r));
+
+static int usim_regdump_show(struct seq_file *s, void *unused)
+{
+	struct usim	*usim = s->private;
+
+	seq_puts(s, "USIM Register Dump\n");
+
+	DUMP_REG(USIM_REVISION);
+	DUMP_REG(USIM_IDENT);
+	DUMP_REG(USIM_SYSCONFIG);
+	DUMP_REG(USIM_SYSSTATUS);
+	DUMP_REG(USIM_IRQSTATUS);
+	DUMP_REG(USIM_IRQENABLE);
+	DUMP_REG(USIM_WAKEUPEN);
+	DUMP_REG(USIM_CMD);
+	DUMP_REG(USIM_STAT);
+	DUMP_REG(USIM_CONF1);
+	DUMP_REG(USIM_CONF2);
+	DUMP_REG(USIM_CONF3);
+	DUMP_REG(USIM_DRX);
+	DUMP_REG(USIM_DTX);
+	DUMP_REG(USIM_FIFOS);
+	DUMP_REG(USIM_CGT);
+	DUMP_REG(USIM_BWT);
+	DUMP_REG(USIM_DEBUG);
+	DUMP_REG(USIM_CONF_SAM1_DIV);
+	DUMP_REG(USIM_CONF4);
+	DUMP_REG(USIM_ATR_CLK_PRD_NBS);
+	DUMP_REG(USIM_CONF_ETU_DIV);
+	DUMP_REG(USIM_CONF5);
+	DUMP_REG(USIM_TC_GUARD_TIME_ADD);
+	DUMP_REG(USIM_RXFIFO_LEVEL);
+	DUMP_REG(USIM_RXFIFO_BYTECNT);
+	DUMP_REG(USIM_WWT);
+	DUMP_REG(USIM_CONF6);
+	DUMP_REG(USIM_IO_DIRECT);
+	DUMP_REG(USIM_TX_BLOCK);
+
+	return 0;
+}
+
+static int usim_regdump_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, usim_regdump_show, inode->i_private);
+}
+
+static const struct file_operations usim_regdump_fops = {
+	.open		= usim_regdump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int usim_init_debugfs(struct usim *usim)
+{
+	int ret;
+	struct dentry	*root;
+	struct dentry	*file;
+
+	root = debugfs_create_dir("usim", NULL);
+	if (!root) {
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	file = debugfs_create_file("regdump", S_IRUGO, root, usim,
+							&usim_regdump_fops);
+	if (!file) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	usim->debugfs_root = root;
+
+	return 0;
+err1:
+	debugfs_remove_recursive(root);
+err0:
+	return ret;
+}
+#endif
+
+static int usim_pm_init(struct usim *usim)
+{
+	int ret = 0;
+
+	usim->usim0_fck  = clk_get(usim->dev, "usim0_fck");
+	if (IS_ERR(usim->usim0_fck)) {
+		ret = PTR_ERR(usim->usim0_fck);
+		dev_err(usim->dev, "usim0_fck failed error:%d\n", ret);
+		return -1;
+	}
+	usim->dpll_core_m4_ck  = clk_get(usim->dev, "dpll_core_m4_ck");
+	if (IS_ERR(usim->dpll_core_m4_ck)) {
+		ret = PTR_ERR(usim->dpll_core_m4_ck);
+		dev_err(usim->dev, "dpll_core_m4_ck failed error:%d\n", ret);
+		return -1;
+	}
+	ret = clk_set_parent(usim->usim0_fck, usim->dpll_core_m4_ck);
+	if (ret != 0)
+		dev_dbg(usim->dev, "clk set  parent failed: %d\n", ret);
+
+	usim->usim_dbclk  = clk_get(usim->dev, "usim_dbck");
+	if (IS_ERR(usim->usim_dbclk)) {
+		ret = PTR_ERR(usim->usim_dbclk);
+		dev_err(usim->dev, "usim_dbck failed error:%d\n", ret);
+		return -1;
+	}
+
+	usim->clkdiv32k_ick  = clk_get(usim->dev, "clkdiv32k_ick");
+	if (IS_ERR(usim->usim_dbclk)) {
+		ret = PTR_ERR(usim->clkdiv32k_ick);
+		dev_err(usim->dev, "clkdiv32k_ick failed error:%d\n", ret);
+		return -1;
+	}
+
+	ret = clk_set_parent(usim->usim_dbclk, usim->clkdiv32k_ick);
+	if (ret != 0)
+		dev_dbg(usim->dev, "usim_dbclk set parent failed: %d\n", ret);
+
+	usim->opt_fclk = devm_clk_get(usim->dev, "opt_fck");
+	if (IS_ERR(usim->opt_fclk))
+		dev_err(usim->dev, "unable to get fck\n");
+	else
+		clk_enable(usim->opt_fclk);
+
+	usim->opt_fclk32 = devm_clk_get(usim->dev, "opt_fck32");
+	if (IS_ERR(usim->opt_fclk32))
+		dev_err(usim->dev, "unable to get dbclk\n");
+	else
+		clk_enable(usim->opt_fclk32);
+
+	return 0;
+}
+static void usim_enable(struct usim *usim)
+{
+	if (usim->enable == 1)
+		return;
+
+	/* enable the clk */
+	pm_runtime_get_sync(usim->dev);
+
+	/* usim init */
+	usim_configure(usim);
+
+	usim->enable = 1;
+	return;
+}
+
+static void usim_disable(struct usim *usim)
+{
+	int cnt = 0;
+
+	if (usim->enable == 0)
+		return;
+
+	/* reset USIM state for deactivation */
+	for (cnt = 0; cnt < usim->max_slots; cnt++) {
+		usim->slot = cnt;
+		usim_deactivate_card(usim);
+	}
+
+	/* reset default slot and clock */
+	usim->slot = 0;
+	usim->slot_ctx[usim->slot].clock = USIM_SMARTCART_CLOCK_5MHZ;
+
+	/* shutdown phy */
+	if (usim->phy_present == USIM_PHY_PRESENT)
+		usim->phy->set_config(usim->phy, usim->slot, SC_PHY_MODE,
+				SC_PHY_SHUTDOWN);
+	/* disable clk */
+	pm_runtime_put_sync_autosuspend(usim->dev);
+	usim->enable = 0;
+	return;
+}
+
+static int usim_open(struct inode *inode, struct file *file)
+{
+	struct usim *usim = (struct usim *)dev_get_drvdata(usim_dev.parent);
+
+	if (usim->phy_present == USIM_PHY_NOT_ATTACHED)
+		return -ENXIO;
+
+	file->private_data = usim;
+	usim_enable(usim);
+	return 0;
+}
+
+static int usim_release(struct inode *inode, struct file *file)
+{
+	struct usim *usim = (struct usim *)dev_get_drvdata(usim_dev.parent);
+
+	usim_disable(usim);
+	usim->user_pid = 0;
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int usim_suspend(struct device *dev)
+{
+	/* struct usim *usim = dev_to_usim(dev); */
+	return 0;
+}
+
+static int usim_resume(struct device *dev)
+{
+	/* struct usim *usim = dev_to_usim(dev); */
+	return 0;
+}
+
+static const struct dev_pm_ops usim_pm_ops = {
+	.suspend = usim_suspend,
+	.resume = usim_resume,
+};
+
+#define USIM_PM_OPS (&usim_pm_ops)
+#else
+#define USIM_PM_OPS NULL
+#endif
+
+static int usim_notify(struct notifier_block *self, unsigned long action, void
+		*data)
+{
+	struct usim *usim = (struct usim *)data;
+	int event = action & SC_PHY_NOTIFICATION_ACTION_MASK;
+	int slot = (action & SC_PHY_NOTIFICATION_SLOT_MASK) >>
+		SC_PHY_NOTIFICATION_SLOT_SHIFT;
+	int t_slot = 0;
+
+	/* if phy is removed using rmmod or by some other mech..
+	   * then put phy state in unknown, at this point usim also required to
+	   * gets removed from the system, if it is inserted as module and
+	   * dependent on phy
+	   */
+	if (action == SC_PHY_REMOVED)
+		usim->phy_present = USIM_PHY_NOT_ATTACHED;
+
+	if (event & SC_PHY_CARD_INSERTED)
+		usim_send_signal(usim, USIM_EVENT_CARD_INSERT);
+
+	if (action & SC_PHY_CARD_REMOVED) {
+		usim_send_signal(usim, USIM_EVENT_CARD_REMOVE);
+		dev_dbg(usim->dev, "slot is:%d", slot);
+		 /* de-activate USIM & PHY state machine for the slot */
+		t_slot = usim->slot;
+		usim->slot = slot;
+		usim_deactivate_card(usim);
+		usim->slot = t_slot;
+	}
+
+	if (action & SC_PHY_CARD_OVERHEAT)
+		usim_send_signal(usim, USIM_EVENT_CARD_OVERHEAT);
+
+	if (action & SC_PHY_CARD_ATR_TIMEOUT)
+		usim_send_signal(usim, USIM_EVENT_TIMEOUT);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block usim_nb = {
+		 .notifier_call =	usim_notify,
+};
+
+static const struct file_operations usim_fops = {
+	.owner		= THIS_MODULE,
+	.read		= usim_read,
+	.open		= usim_open,
+	.unlocked_ioctl	= usim_ioctl,
+	.release	= usim_release,
+};
+
+static int usim_probe(struct platform_device *pdev)
+{
+	struct device_node *node		= pdev->dev.of_node;
+	struct device *dev			= &pdev->dev;
+
+	struct usim *usim			= NULL;
+	struct device_node *phy_node		= NULL;
+	struct resource *res			= NULL;
+	void __iomem	*base			= NULL;
+	const __be32 *parp			= NULL;
+	struct i2c_client *phy_i2c		= NULL;
+
+	int ret		= 0;
+	int version	= 0;
+	int cnt		= 0;
+	u32 prop	= 0;
+	int lenp	= 0;
+
+	if (!node) {
+		dev_err(dev, "device node not found\n");
+		return -EINVAL;
+	}
+
+	usim = devm_kzalloc(dev, sizeof(*usim), GFP_KERNEL);
+	if (!usim) {
+		dev_err(dev, "not enough memory\n");
+		return -ENOMEM;
+	}
+
+	usim->irq = platform_get_irq(pdev, 0);
+	if (usim->irq < 0) {
+		dev_err(dev, "missing IRQ resource\n");
+		ret = -EINVAL;
+		goto usim_err_ret;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "missing memory base resource\n");
+		ret = -EINVAL;
+		goto usim_err_ret;
+	}
+
+	base = devm_ioremap_nocache(dev, res->start, resource_size(res));
+	if (!base) {
+		dev_err(dev, "ioremap failed\n");
+		ret = -ENOMEM;
+		goto usim_err_ret;
+	}
+
+	usim->dev = &pdev->dev;
+	usim->base = base;
+	usim->max_slots = 1;
+	usim->phy_present = USIM_PHY_NOT_PRESENT;
+	usim->enable = 0;
+
+	/* default slot will be zero : user card */
+	usim->slot = 0;
+
+	ret = devm_request_irq(dev, usim->irq, usim_interrupt, 0,
+			"usim", usim);
+	if (ret) {
+		dev_err(dev, "fail request IRQ #%d --> %d\n", usim->irq, ret);
+		goto usim_err_ret;
+		return ret;
+	}
+
+	/*
+	 * Populate all the child nodes here...
+	 */
+	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
+
+	/* get phy details */
+	parp = of_get_property(node, "phy", &lenp);
+	if (parp == NULL || lenp != (sizeof(void *))) {
+		dev_dbg(usim->dev, "parp is null!,no phy");
+	} else {
+		/* get phy node */
+		phy_node = of_find_node_by_phandle(be32_to_cpup(parp));
+		if (phy_node == NULL) {
+			dev_err(usim->dev, "\n phy node is null");
+			ret = -EPROBE_DEFER;
+			goto usim_err_ret;
+		}
+		phy_i2c = of_find_i2c_device_by_node(phy_node);
+		if (phy_i2c == NULL) {
+			dev_err(usim->dev, "\n phy i2c is null");
+			ret = -EPROBE_DEFER;
+			goto usim_err_ret;
+		}
+		/* get phy interface */
+		usim->phy = (struct sc_phy *)i2c_get_clientdata(phy_i2c);
+		if (usim->phy == NULL) {
+			dev_err(usim->dev, "phy data is null");
+			ret = -EPROBE_DEFER;
+			goto usim_err_ret;
+		}
+		usim->phy_present = USIM_PHY_PRESENT;
+
+		ret = of_property_read_u32(node, "phy-slots", &prop);
+		/* if phy-slot is not declared then assume one phy slot */
+		usim->max_slots = prop > 0 ? prop : 1;
+	}
+
+	dev_dbg(usim->dev, "usim max slot:%d", usim->max_slots);
+	/* initialize slot context*/
+	if (usim->max_slots > USIM_MAX_SLOTS) {
+		ret = -EINVAL;
+		goto usim_err_ret;
+	}
+
+	usim->slot_ctx = kmalloc(usim->max_slots *
+				 sizeof(struct usim_slotcontext), GFP_KERNEL);
+	if (!usim->slot_ctx)
+		return -ENOMEM;
+
+	for (cnt = 0; cnt < usim->max_slots; cnt++) {
+		/* default protocol */
+		usim->slot_ctx[cnt].protocol = 0;
+		usim->slot_ctx[cnt].emv = true;
+	}
+
+	dev_set_drvdata(dev, usim);
+	usim_pm_init(usim);
+
+	/* enable the clock */
+	pm_runtime_enable(usim->dev);
+	pm_runtime_set_active(usim->dev);
+	spin_lock_init(&usim->lock);
+
+	usim_dev.minor = MISC_DYNAMIC_MINOR;
+	usim_dev.name = "usim";
+	usim_dev.fops = &usim_fops;
+	usim_dev.parent = &(pdev->dev);
+
+	ret = misc_register(&usim_dev);
+	if (ret) {
+		pr_err("unable to register a misc device\n");
+		goto usim_err_reg;
+	}
+#ifdef CONFIG_DEBUG_FS
+	ret = usim_init_debugfs(usim);
+	if (ret) {
+		dev_err(dev, "Debugfs init failed\n");
+		goto usim_err_reg;
+	}
+#endif
+	/* set default ICC clock : 5Mhz */
+	usim->slot_ctx[usim->slot].clock = USIM_SMARTCART_CLOCK_5MHZ;
+
+	/* get the clock & do usim configuration */
+	usim_enable(usim);
+	dev_info(usim->dev, "usim driver initialized\n");
+
+	/* register notifier */
+	if (usim->phy_present)
+		usim->phy->register_notify(usim->phy, &usim_nb, (void *)usim);
+
+	/* get usim version */
+	version = usim_get_version(usim);
+	dev_info(usim->dev, "version is:%0x", version);
+
+	usim_disable(usim);
+	return 0;
+
+usim_err_reg:
+	pm_runtime_set_suspended(usim->dev);
+	pm_runtime_disable(usim->dev);
+	misc_deregister(&usim_dev);
+
+usim_err_ret:
+	if (usim)
+		kfree(usim->slot_ctx);
+	return ret;
+}
+
+static int usim_remove(struct platform_device *pdev)
+{
+	struct device	*dev = &pdev->dev;
+	struct usim	*usim = dev_to_usim(dev);
+
+	usim_disable(usim);
+	/* unregister notifier, applicable only when phy present and phy state
+	 * is not unknown i.e. - phy has not been removed using rmmod */
+	if (usim->phy_present == USIM_PHY_PRESENT)
+		usim->phy->unregister_notify(usim->phy, &usim_nb);
+
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(usim->debugfs_root);
+#endif
+	/* disable pm runtime */
+	pm_runtime_set_suspended(usim->dev);
+	pm_runtime_disable(usim->dev);
+
+	kfree(usim->slot_ctx);
+	misc_deregister(&usim_dev);
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id usim_id_table[] = {
+	{ .compatible = "ti,usim" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, usim_id_table);
+#endif
+
+static struct platform_driver usim_driver = {
+	.driver = {
+		.name = "usim",
+		.owner	= THIS_MODULE,
+		.pm	= USIM_PM_OPS,
+		.of_match_table = of_match_ptr(usim_id_table),
+	},
+	.probe = usim_probe,
+	.remove = usim_remove,
+};
+
+static int __init usim_init(void)
+{
+	return platform_driver_register(&usim_driver);
+}
+
+static void __exit usim_exit(void)
+{
+	platform_driver_unregister(&usim_driver);
+}
+
+late_initcall(usim_init);
+module_exit(usim_exit);
+
+MODULE_AUTHOR("Maulik Mankad <maulik@ti.com>");
+MODULE_DESCRIPTION("USIM Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/ti-usim.h b/include/linux/ti-usim.h
new file mode 100644
index 0000000..f4b3ca8
--- /dev/null
+++ b/include/linux/ti-usim.h
@@ -0,0 +1,98 @@
+/*
+ * ti-usim.h - Header file for USIM SmartCard interface
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __TI_USIM_H__
+#define __TI_USIM_H__
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define USIM_IOCTL 0xFE
+
+enum usim_param {
+	USIM_PARAM_CWT = 0,
+	USIM_PARAM_WWT,
+	USIM_PARAM_CGT,
+	USIM_PARAM_BWT,
+	USIM_PARAM_EDCTYPE,
+	USIM_PARAM_LRCCHECK,
+	USIM_PARAM_C4,
+	USIM_PARAM_C8,
+	USIM_PARAM_PROTOCOL,
+	USIM_PARAM_VOLTAGE,
+	USIM_PARAM_EMV,
+	USIM_PARAM_FI,
+	USIM_PARAM_DI,
+	USIM_PARAM_CODING_CONV,
+	USIM_PARAM_CLOCK_STOP,
+	USIM_PARAM_SMARTCARD_CLOCK,
+};
+
+struct usim_data {
+	int slot;
+	int rxexplen;
+	int txlen;
+	unsigned char apdu[256];
+};
+
+struct usim_config {
+	enum usim_param attr;
+	unsigned int value;
+};
+
+#define USIM_SIGID	51
+
+#define USIM_IOCTL_GET_PROVIDER_VERSION	_IOR(USIM_IOCTL, 0, int)
+#define	USIM_IOCTL_ACTIVATE_CARD	_IO(USIM_IOCTL, 1)
+#define	USIM_IOCTL_DEACTIVATE_CARD	_IO(USIM_IOCTL, 2)
+#define USIM_IOCTL_WARM_RESET		_IO(USIM_IOCTL, 3)
+#define USIM_IOCTL_GET_ATR		_IOR(USIM_IOCTL, 4, char *)
+#define USIM_IOCTL_SEND_DATA		_IOW(USIM_IOCTL, 5, struct usim_data)
+#define USIM_IOCTL_SET_CONFIG		_IOW(USIM_IOCTL, 6, struct usim_config)
+#define USIM_IOCTL_GET_CONFIG		_IOW(USIM_IOCTL, 7, struct usim_config)
+#define USIM_IOCTL_GET_CARD_PRESENCE	_IOR(USIM_IOCTL, 8, int)
+#define USIM_IOCTL_REGISTER_PID		_IOW(USIM_IOCTL, 9, int)
+
+#define USIM_MAX_ATRLENGTH	0xFF
+#define USIM_MAX_APDU_LENGTH	0xFE
+
+enum usim_smartcard_clock {
+	USIM_SMARTCART_CLOCK_3_3MHZ	= 0x1,
+	USIM_SMARTCART_CLOCK_4MHZ	= 0x2,
+	USIM_SMARTCART_CLOCK_5MHZ	= 0x3,
+	USIM_SMARTCART_CLOCK_6_6MHZ	= 0x4,
+	USIM_SMARTCART_CLOCK_10MHZ	= 0x5,
+	USIM_SMARTCART_CLOCK_20MHZ	= 0x6,
+};
+
+enum usim_event {
+	USIM_EVENT_CARD_INSERT	= 0x1,
+	USIM_EVENT_CARD_REMOVE	= 0x2,
+	USIM_EVENT_TIMEOUT	= 0x4,
+	USIM_EVENT_ERR_TXRETRY	= 0x8,
+	USIM_EVENT_ERR_LRC	= 0x10,
+	USIM_EVENT_ERR_PARITY	= 0x20,
+	USIM_EVENT_ERR_FRAME	= 0x40,
+	USIM_EVENT_PHYERR	= 0x80,
+	USIM_EVENT_CARD_OVERHEAT = 0x100,
+};
+
+enum usim_card_voltage {
+	USIM_CARD_5V = 0,
+	USIM_CARD_3V,
+	USIM_CARD_1_8V
+};
+
+#endif /* __TI_USIM_H__ */
-- 
1.7.1

