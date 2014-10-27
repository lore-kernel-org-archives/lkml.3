Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaJ0T0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:26:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaJ0S7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:59:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 064/105] serial: 8250: Add Quark X1000 to 8250_pci.c
Date: Mon, 27 Oct 2014 11:56:39 -0700
Message-Id: <1414436240-13879-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

commit 1ede7dcca3c4fa15a518ab0473126f9c3e621e4c upstream.

Quark X1000 contains two designware derived 8250 serial ports.
Each port has a unique PCI configuration space consisting of
BAR0:UART BAR1:DMA respectively.

Unlike the standard 8250 the register width is 32 bits for RHR,IER etc
The Quark UART has a fundamental clock @ 44.2368 MHz allowing for a
bitrate of up to about 2.76 megabits per second.

This patch enables standard 8250 mode

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/8250/8250_pci.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 77d0aca..4ba3ee1 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1766,6 +1766,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_COMMTECH_4222PCIE	0x0022
 #define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
 #define PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800 0x818e
+#define PCI_DEVICE_ID_INTEL_QRK_UART	0x0936
 
 #define PCI_VENDOR_ID_SUNIX		0x1fd4
 #define PCI_DEVICE_ID_SUNIX_1999	0x1999
@@ -1876,6 +1877,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
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
@@ -2710,6 +2718,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_8_3906250,
 	pbn_ce4100_1_115200,
 	pbn_byt,
+	pbn_qrk,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
 	pbn_brcm_trumanage,
@@ -3456,6 +3465,12 @@ static struct pciserial_board pci_boards[] = {
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
@@ -5150,6 +5165,12 @@ static struct pci_device_id serial_pci_tbl[] = {
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

