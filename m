Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3AQV6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:58:31 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2615 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab3AQV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:58:30 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Michael Chan" <mchan@broadcom.com>
To: gregkh@linuxfoundation.org
cc: linux-kernel@vger.kernel.org, shurd@broadcom.com, mchan@broadcom.com
Subject: [PATCH] 8250/16?50: Add support for Broadcom TruManage
 redirected serial port
Date: Thu, 17 Jan 2013 14:14:53 -0800
Message-ID: <1358460893-11098-1-git-send-email-mchan@broadcom.com>
X-Mailer: git-send-email 1.5.5.GIT
MIME-Version: 1.0
X-WSS-ID: 7CE6AC0D1ZS8385297-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hurd <shurd@broadcom.com>

Add support for the UART device present in Broadcom TruManage capable
NetXtreme chips (ie: 5761m 5762, and 5725).

This implementation has a hidden transmit FIFO, so running in single-byte
interrupt mode results in too many interrupts.  The UART_CAP_HFIFO
capability was added to track this.  It continues to reload the THR as long
as the THRE and TSRE bits are set in the LSR up to a specified limit (1024
is used here).

Signed-off-by: Stephen Hurd <shurd@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/tty/serial/8250/8250.c     |   11 ++++++++++
 drivers/tty/serial/8250/8250.h     |    1 +
 drivers/tty/serial/8250/8250_pci.c |   38 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/serial_core.h   |    3 +-
 4 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index d085e3a..f932043 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -300,6 +300,12 @@ static const struct serial8250_config uart_config[] = {
 				  UART_FCR_R_TRIG_00 | UART_FCR_T_TRIG_00,
 		.flags		= UART_CAP_FIFO,
 	},
+	[PORT_BRCM_TRUMANAGE] = {
+		.name		= "TruManage",
+		.fifo_size	= 1,
+		.tx_loadsz	= 1024,
+		.flags		= UART_CAP_HFIFO,
+	},
 	[PORT_8250_CIR] = {
 		.name		= "CIR port"
 	}
@@ -1490,6 +1496,11 @@ void serial8250_tx_chars(struct uart_8250_port *up)
 		port->icount.tx++;
 		if (uart_circ_empty(xmit))
 			break;
+		if (up->capabilities & UART_CAP_HFIFO) {
+			if ((serial_port_in(port, UART_LSR) & BOTH_EMPTY) !=
+			    BOTH_EMPTY)
+				break;
+		}
 	} while (--count > 0);
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 3b4ea84..12caa12 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -40,6 +40,7 @@ struct serial8250_config {
 #define UART_CAP_AFE	(1 << 11)	/* MCR-based hw flow control */
 #define UART_CAP_UUE	(1 << 12)	/* UART needs IER bit 6 set (Xscale) */
 #define UART_CAP_RTOIE	(1 << 13)	/* UART needs IER bit 4 set (Xscale, Tegra) */
+#define UART_CAP_HFIFO	(1 << 14)	/* UART has a "hidden" FIFO */
 
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 26b9dc0..c6777b5 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1085,6 +1085,18 @@ pci_omegapci_setup(struct serial_private *priv,
 	return setup_port(priv, port, 2, idx * 8, 0);
 }
 
+static int
+pci_brcm_trumanage_setup(struct serial_private *priv,
+			 const struct pciserial_board *board,
+			 struct uart_8250_port *port, int idx)
+{
+	int ret = pci_default_setup(priv, board, port, idx);
+
+	port->port.type = PORT_BRCM_TRUMANAGE;
+	port->port.flags = (port->port.flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
+	return ret;
+}
+
 static int skip_tx_en_setup(struct serial_private *priv,
 			const struct pciserial_board *board,
 			struct uart_8250_port *port, int idx)
@@ -1304,6 +1316,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_COMMTECH_4222PCIE 0x0019
 #define PCI_DEVICE_ID_COMMTECH_4224PCIE	0x0020
 #define PCI_DEVICE_ID_COMMTECH_4228PCIE	0x0021
+#define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
 
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
@@ -1954,6 +1967,17 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.setup		= pci_xr17v35x_setup,
 	},
 	/*
+	 * Broadcom TruManage (NetXtreme)
+	 */
+	{
+		.vendor		= PCI_VENDOR_ID_BROADCOM,
+		.device		= PCI_DEVICE_ID_BROADCOM_TRUMANAGE,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_brcm_trumanage_setup,
+	},
+
+	/*
 	 * Default "match everything" terminator entry
 	 */
 	{
@@ -2148,6 +2172,7 @@ enum pci_board_num_t {
 	pbn_ce4100_1_115200,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
+	pbn_brcm_trumanage,
 };
 
 /*
@@ -2892,6 +2917,12 @@ static struct pciserial_board pci_boards[] = {
 		.num_ports	= 2,
 		.base_baud	= 115200,
 	},
+	[pbn_brcm_trumanage] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.reg_shift	= 2,
+		.base_baud	= 115200,
+	},
 };
 
 static const struct pci_device_id blacklist[] = {
@@ -4471,6 +4502,13 @@ static struct pci_device_id serial_pci_tbl[] = {
 		pbn_omegapci },
 
 	/*
+	 * Broadcom TruManage
+	 */
+	{	PCI_VENDOR_ID_BROADCOM, PCI_DEVICE_ID_BROADCOM_TRUMANAGE,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_brcm_trumanage },
+
+	/*
 	 * AgeStar as-prs2-009
 	 */
 	{	PCI_VENDOR_ID_AGESTAR, PCI_DEVICE_ID_AGESTAR_9375,
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index 78f99d9..2c6c85f 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -50,7 +50,8 @@
 #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
 #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
 #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
-#define PORT_MAX_8250	24	/* max port ID */
+#define PORT_BRCM_TRUMANAGE	24
+#define PORT_MAX_8250	25	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
1.7.1


