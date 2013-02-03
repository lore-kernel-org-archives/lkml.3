Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3BCO4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34326 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab3BCO4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:24 -0500
Message-Id: <20130203144649.567373910@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Stephen Hurd <shurd@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 062/128] 8250/16?50: Add support for Broadcom TruManage redirected serial
 port
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust filenames
 - Adjust context
 - First available port type number is 23 not 24
 - s/uart_8250_port/uart_port/
 - Use serial_in() not serial_port_in()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250.c     |   11 +++++++++++
 drivers/tty/serial/8250.h     |    1 +
 drivers/tty/serial/8250_pci.c |   38 ++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h   |    3 ++-
 4 files changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -316,6 +316,12 @@ static const struct serial8250_config ua
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE | UART_CAP_EFR,
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
@@ -1514,6 +1520,11 @@ static void transmit_chars(struct uart_8
 		up->port.icount.tx++;
 		if (uart_circ_empty(xmit))
 			break;
+		if (up->capabilities & UART_CAP_HFIFO) {
+			if ((serial_in(up, UART_LSR) & BOTH_EMPTY) !=
+			    BOTH_EMPTY)
+				break;
+		}
 	} while (--count > 0);
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
--- a/drivers/tty/serial/8250.h
+++ b/drivers/tty/serial/8250.h
@@ -43,6 +43,7 @@ struct serial8250_config {
 #define UART_CAP_AFE	(1 << 11)	/* MCR-based hw flow control */
 #define UART_CAP_UUE	(1 << 12)	/* UART needs IER bit 6 set (Xscale) */
 #define UART_CAP_RTOIE	(1 << 13)	/* UART needs IER bit 4 set (Xscale, Tegra) */
+#define UART_CAP_HFIFO	(1 << 14)	/* UART has a "hidden" FIFO */
 
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1077,6 +1077,18 @@ pci_omegapci_setup(struct serial_private
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
@@ -1138,6 +1150,7 @@ pci_xr17c154_setup(struct serial_private
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
+#define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1672,6 +1685,17 @@ static struct pci_serial_quirk pci_seria
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
@@ -1860,6 +1884,7 @@ enum pci_board_num_t {
 	pbn_ce4100_1_115200,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
+	pbn_brcm_trumanage,
 };
 
 /*
@@ -2566,6 +2591,12 @@ static struct pciserial_board pci_boards
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
@@ -4108,6 +4139,13 @@ static struct pci_device_id serial_pci_t
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
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -48,7 +48,8 @@
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
 #define PORT_8250_CIR	22	/* CIR infrared port, has its own driver */
-#define PORT_MAX_8250	22	/* max port ID */
+#define PORT_BRCM_TRUMANAGE	23
+#define PORT_MAX_8250	23	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed


