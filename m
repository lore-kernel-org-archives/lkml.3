Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab3JQRoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:44:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab3JQRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:44:27 -0400
Date: Thu, 17 Oct 2013 10:44:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amanda Ying <amanda_ying@fintek.com.tw>,
        Felix Shih <felix_shih@fintek.com.tw>
Subject: [PATCH]: serial: 8250_pci: add support for Fintek 4, 8, and 12 port
 cards
Message-ID: <20131017174426.GA12494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This adds support for Fintek's 4, 8, and 12 port PCIE serial cards.

Thanks to Fintek for the sample devices, and the spec needed in order to
implement this.

Cc: Amanda Ying <amanda_ying@fintek.com.tw>
Cc: Felix Shih <felix_shih@fintek.com.tw>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |  112 +++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1343,6 +1343,71 @@ pci_brcm_trumanage_setup(struct serial_p
 	return ret;
 }
 
+static int pci_fintek_setup(struct serial_private *priv,
+			    const struct pciserial_board *board,
+			    struct uart_8250_port *port, int idx)
+{
+	struct pci_dev *pdev = priv->dev;
+	unsigned long base;
+	unsigned long iobase;
+	unsigned long ciobase = 0;
+	u8 config_base;
+
+	/*
+	 * We are supposed to be able to read these from the PCI config space,
+	 * but the values there don't seem to match what we need to use, so
+	 * just use these hard-coded values for now, as they are correct.
+	 */
+	switch (idx) {
+	case 0: iobase = 0xe000; config_base = 0x40; break;
+	case 1: iobase = 0xe008; config_base = 0x48; break;
+	case 2: iobase = 0xe010; config_base = 0x50; break;
+	case 3: iobase = 0xe018; config_base = 0x58; break;
+	case 4: iobase = 0xe020; config_base = 0x60; break;
+	case 5: iobase = 0xe028; config_base = 0x68; break;
+	case 6: iobase = 0xe030; config_base = 0x70; break;
+	case 7: iobase = 0xe038; config_base = 0x78; break;
+	case 8: iobase = 0xe040; config_base = 0x80; break;
+	case 9: iobase = 0xe048; config_base = 0x88; break;
+	case 10: iobase = 0xe050; config_base = 0x90; break;
+	case 11: iobase = 0xe058; config_base = 0x98; break;
+	default:
+		/* Unknown number of ports, get out of here */
+		return -EINVAL;
+	}
+
+	if (idx < 4) {
+		base = pci_resource_start(priv->dev, 3);
+		ciobase = (int)(base + (0x8 * idx));
+	}
+
+	dev_dbg(&pdev->dev, "%s: idx=%d iobase=0x%lx ciobase=0x%lx config_base=0x%2x\n",
+		__func__, idx, iobase, ciobase, config_base);
+
+	/* Enable UART I/O port */
+	pci_write_config_byte(pdev, config_base + 0x00, 0x01);
+
+	/* Select 128-byte FIFO and 8x FIFO threshold */
+	pci_write_config_byte(pdev, config_base + 0x01, 0x33);
+
+	/* LSB UART */
+	pci_write_config_byte(pdev, config_base + 0x04, (u8)(iobase & 0xff));
+
+	/* MSB UART */
+	pci_write_config_byte(pdev, config_base + 0x05, (u8)((iobase & 0xff00) >> 8));
+
+	/* irq number, this usually fails, but the spec says to do it anyway. */
+	pci_write_config_byte(pdev, config_base + 0x06, pdev->irq);
+
+	port->port.iotype = UPIO_PORT;
+	port->port.iobase = iobase;
+	port->port.mapbase = 0;
+	port->port.membase = NULL;
+	port->port.regshift = 0;
+
+	return 0;
+}
+
 static int skip_tx_en_setup(struct serial_private *priv,
 			const struct pciserial_board *board,
 			struct uart_8250_port *port, int idx)
@@ -2252,6 +2317,27 @@ static struct pci_serial_quirk pci_seria
 		.subdevice	= PCI_ANY_ID,
 		.setup		= pci_brcm_trumanage_setup,
 	},
+	{
+		.vendor		= 0x1c29,
+		.device		= 0x1104,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_fintek_setup,
+	},
+	{
+		.vendor		= 0x1c29,
+		.device		= 0x1108,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_fintek_setup,
+	},
+	{
+		.vendor		= 0x1c29,
+		.device		= 0x1112,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_fintek_setup,
+	},
 
 	/*
 	 * Default "match everything" terminator entry
@@ -2449,6 +2535,9 @@ enum pci_board_num_t {
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
 	pbn_brcm_trumanage,
+	pbn_fintek_4,
+	pbn_fintek_8,
+	pbn_fintek_12,
 };
 
 /*
@@ -3199,6 +3288,24 @@ static struct pciserial_board pci_boards
 		.reg_shift	= 2,
 		.base_baud	= 115200,
 	},
+	[pbn_fintek_4] = {
+		.num_ports	= 4,
+		.uart_offset	= 8,
+		.base_baud	= 115200,
+		.first_offset	= 0x40,
+	},
+	[pbn_fintek_8] = {
+		.num_ports	= 8,
+		.uart_offset	= 8,
+		.base_baud	= 115200,
+		.first_offset	= 0x40,
+	},
+	[pbn_fintek_12] = {
+		.num_ports	= 12,
+		.uart_offset	= 8,
+		.base_baud	= 115200,
+		.first_offset	= 0x40,
+	},
 };
 
 static const struct pci_device_id blacklist[] = {
@@ -4916,6 +5023,11 @@ static struct pci_device_id serial_pci_t
 		0,
 		0, pbn_exar_XR17V358 },
 
+	/* Fintek PCI serial cards */
+	{ PCI_DEVICE(0x1c29, 0x1104), .driver_data = pbn_fintek_4 },
+	{ PCI_DEVICE(0x1c29, 0x1108), .driver_data = pbn_fintek_8 },
+	{ PCI_DEVICE(0x1c29, 0x1112), .driver_data = pbn_fintek_12 },
+
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
