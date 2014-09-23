Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaIWAW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:22:59 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:41602 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaIWAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:22:58 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: gregkh@linuxfoundation.org, jslaby@suse.cz,
        heikki.krogerus@linux.intel.com, andriy.shevchenko@linux.intel.com,
        kean.ho.chew@intel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH v3] serial: 8250: Add Quark X1000 to 8250_pci.c
Date: Tue, 23 Sep 2014 01:21:11 +0100
Message-Id: <1411431671-26540-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark X1000 contains two designware derived 8250 serial ports.
Each port has a unique PCI configuration space consisting of
BAR0:UART BAR1:DMA respectively.

Unlike the standard 8250 the register width is 32 bits for RHR,IER etc
The Quark UART has a fundamental clock @ 44.2368 MHz allowing for a
bitrate of up to about 2.76 megabits per second.

This patch enables standard 8250 mode

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 drivers/tty/serial/8250/8250_pci.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 61830b1..14d3e6b 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1788,6 +1788,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_COMMTECH_4222PCIE	0x0022
 #define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
 #define PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800 0x818e
+#define PCI_DEVICE_ID_INTEL_QRK_UART	0x0936
 
 #define PCI_VENDOR_ID_SUNIX		0x1fd4
 #define PCI_DEVICE_ID_SUNIX_1999	0x1999
@@ -1898,6 +1899,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= byt_serial_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_QRK_UART,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_default_setup,
+	},
 	/*
 	 * ITE
 	 */
@@ -2740,6 +2748,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_8_3906250,
 	pbn_ce4100_1_115200,
 	pbn_byt,
+	pbn_qrk,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
 	pbn_brcm_trumanage,
@@ -3490,6 +3499,12 @@ static struct pciserial_board pci_boards[] = {
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
@@ -5192,6 +5207,12 @@ static struct pci_device_id serial_pci_tbl[] = {
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

