Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab3BEWIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:08:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3BEWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:08:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 13/93] 8250/16?50: Add support for Broadcom TruManage redirected serial port
Date: Tue,  5 Feb 2013 20:06:02 -0200
Message-Id: <1360102042-10732-14-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hurd <shurd@broadcom.com>

commit ebebd49a8eab5e9aa1b1f8f1614ccc3c2120f886 upstream.

Add support for the UART device present in Broadcom TruManage capable
NetXtreme chips (ie: 5761m 5762, and 5725).

This implementation has a hidden transmit FIFO, so running in single-byte
interrupt mode results in too many interrupts.  The UART_CAP_HFIFO
capability was added to track this.  It continues to reload the THR as long
as the THRE and TSRE bits are set in the LSR up to a specified limit (1024
is used here).

Signed-off-by: Stephen Hurd <shurd@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: include/uapi/linux/serial_core.h -> include/linux/serial_core.h,
  adjust context and port ID defines, adapted for usage of struct uart_port
  in pci_brcm_trumanage_setup ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/tty/serial/8250/8250.c     |   11 +++++++++++
 drivers/tty/serial/8250/8250.h     |    1 +
 drivers/tty/serial/8250/8250_pci.c |   38 ++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h        |    3 ++-
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 6e1958a..5074eb7 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -282,6 +282,12 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE | UART_CAP_EFR,
 	},
+	[PORT_BRCM_TRUMANAGE] = {
+		.name		= "TruManage",
+		.fifo_size	= 1,
+		.tx_loadsz	= 1024,
+		.flags		= UART_CAP_HFIFO,
+	},
 };
 
 /* Uart divisor latch read */
@@ -1427,6 +1433,11 @@ void serial8250_tx_chars(struct uart_8250_port *up)
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
index f9719d1..bb95259 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -73,6 +73,7 @@ struct serial8250_config {
 #define UART_CAP_AFE	(1 << 11)	/* MCR-based hw flow control */
 #define UART_CAP_UUE	(1 << 12)	/* UART needs IER bit 6 set (Xscale) */
 #define UART_CAP_RTOIE	(1 << 13)	/* UART needs IER bit 4 set (Xscale, Tegra) */
+#define UART_CAP_HFIFO	(1 << 14)	/* UART has a "hidden" FIFO */
 
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 6b8fcb4..e054448 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1078,6 +1078,18 @@ pci_omegapci_setup(struct serial_private *priv,
 	return setup_port(priv, port, 2, idx * 8, 0);
 }
 
+static int
+pci_brcm_trumanage_setup(struct serial_private *priv,
+			 const struct pciserial_board *board,
+			 struct uart_port *port, int idx)
+{
+	int ret = pci_default_setup(priv, board, port, idx);
+
+	port->type = PORT_BRCM_TRUMANAGE;
+	port->flags = (port->flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
+	return ret;
+}
+
 static int skip_tx_en_setup(struct serial_private *priv,
 			const struct pciserial_board *board,
 			struct uart_port *port, int idx)
@@ -1189,6 +1201,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
 #define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
+#define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1730,6 +1743,17 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.setup		= pci_omegapci_setup,
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
@@ -1918,6 +1942,7 @@ enum pci_board_num_t {
 	pbn_ce4100_1_115200,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
+	pbn_brcm_trumanage,
 };
 
 /*
@@ -2624,6 +2649,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
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
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -4184,6 +4215,13 @@ static struct pci_device_id serial_pci_tbl[] = {
 		pbn_omegapci },
 
 	/*
+	 * Broadcom TruManage
+	 */
+	{	PCI_VENDOR_ID_BROADCOM, PCI_DEVICE_ID_BROADCOM_TRUMANAGE,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_brcm_trumanage },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 65db992..a3fa4d5 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -47,7 +47,8 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
-#define PORT_MAX_8250	21	/* max port ID */
+#define PORT_BRCM_TRUMANAGE	22
+#define PORT_MAX_8250	22	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
1.7.9.5

