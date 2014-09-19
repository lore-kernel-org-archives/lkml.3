Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaISHoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:44:30 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:50090 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbaISHo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:44:29 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: gregkh@linuxfoundation.org, jslaby@suse.cz,
        heikki.krogerus@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
Date: Fri, 19 Sep 2014 08:43:49 +0100
Message-Id: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds PCI identifier for the X1000
Adds clocking and register size and register shift

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 drivers/tty/serial/8250/8250_pci.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 61830b1..5e72959 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1481,6 +1481,19 @@ byt_serial_setup(struct serial_private *priv,
 	return ret;
 }
 
+#define PCI_DEVICE_ID_INTEL_QRK_UART	0x0936
+
+static int
+pci_intel_qrk_setup(struct serial_private *priv,
+		const struct pciserial_board *board,
+		struct uart_8250_port *port, int idx)
+{
+	unsigned int bar, offset = board->first_offset;
+
+	bar = FL_GET_BASE(board->flags);
+
+	return setup_port(priv, port, bar, offset, board->reg_shift);
+}
 static int
 pci_omegapci_setup(struct serial_private *priv,
 		      const struct pciserial_board *board,
@@ -1898,6 +1911,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= byt_serial_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_QRK_UART,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_intel_qrk_setup,
+	},
 	/*
 	 * ITE
 	 */
@@ -2740,6 +2760,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_8_3906250,
 	pbn_ce4100_1_115200,
 	pbn_byt,
+	pbn_qrk,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
 	pbn_brcm_trumanage,
@@ -3490,6 +3511,12 @@ static struct pciserial_board pci_boards[] = {
 		.uart_offset	= 0x80,
 		.reg_shift      = 2,
 	},
+	[pbn_qrk] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 2764800,
+		.reg_shift	= 2,
+	},
 	[pbn_omegapci] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 8,
@@ -5192,6 +5219,12 @@ static struct pci_device_id serial_pci_tbl[] = {
 		pbn_byt },
 
 	/*
+	 * Intel Quark x1000
+	 */
+	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_QRK_UART,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_qrk },
+	/*
 	 * Cronyx Omega PCI
 	 */
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_CRONYX_OMEGA,
-- 
1.9.1

