Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbbA1EQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:16:40 -0500
Received: from mail.kernel.org ([198.145.29.136]:37810 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbbA1EQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:16:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 035/177] serial: 8250: Add Quark X1000 to 8250_pci.c
Date: Wed, 28 Jan 2015 12:07:16 +0800
Message-Id: <1422418236-12852-69-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/tty/serial/8250/8250_pci.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index d53f396..6f8f985 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1164,6 +1164,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
 #define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 #define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
+#define PCI_DEVICE_ID_INTEL_QRK_UART	0x0936
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1686,6 +1687,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.init		= pci_eg20t_init,
 		.setup		= pci_default_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_QRK_UART,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_default_setup,
+	},
 	/*
 	 * Cronyx Omega PCI (PLX-chip based)
 	 */
@@ -1894,6 +1902,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_4_3906250,
 	pbn_ADDIDATA_PCIe_8_3906250,
 	pbn_ce4100_1_115200,
+	pbn_qrk,
 	pbn_omegapci,
 	pbn_NETMOS9900_2s_115200,
 	pbn_brcm_trumanage,
@@ -2592,6 +2601,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 921600,
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
@@ -4164,6 +4179,12 @@ static struct pci_device_id serial_pci_tbl[] = {
 		pbn_ce4100_1_115200 },
 
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

