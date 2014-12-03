Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaLCLhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:37:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaLCL1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:42 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/101] parport: Add support for the WCH353 1S/1P multi-IO card
Date: Wed,  3 Dec 2014 12:26:42 +0100
Message-Id: <8d6960fa02a523485d20ae8bd4bf3b6731f00937.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit feb5814254094c306429fe6d7b9c534fa0250f4c upstream.

This Multi-IO card has one serial 16550-like and one parallel port connector.
Here's the lspci output, after this commit is applied:

03:07.0 Serial controller: Device 4348:5053 (rev 10) (prog-if 02 [16550])
	Subsystem: Device 4348:5053
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at cf00 [size=8]
	Region 1: I/O ports at ce00 [size=8]
	Kernel driver in use: parport_serial
	Kernel modules: 8250_pci, parport_serial

This commit adds an entry with the device ID to the blacklist declared in
8250_pci to prevent the driver from taking ownership. Also, and as was done
for the 2S/1P variant, add a quirk to skip autodetection and set the correct
type to 16550A clone.

Proper entries are added to parport_serial, to support the device parallel
and serial ports.

Cc: Gianluca Anzolin <gianluca@sottospazio.it>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/parport/parport_serial.c   |  9 +++++++++
 drivers/tty/serial/8250/8250_pci.c | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index 1b8bdb7e9bf4..72b73657576b 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -62,6 +62,7 @@ enum parport_pc_pci_cards {
 	timedia_9079a,
 	timedia_9079b,
 	timedia_9079c,
+	wch_ch353_1s1p,
 	wch_ch353_2s1p,
 	sunix_2s1p,
 };
@@ -148,6 +149,7 @@ static struct parport_pc_pci cards[] = {
 	/* timedia_9079a */             { 1, { { 2, 3 }, } },
 	/* timedia_9079b */             { 1, { { 2, 3 }, } },
 	/* timedia_9079c */             { 1, { { 2, 3 }, } },
+	/* wch_ch353_1s1p*/             { 1, { { 1, -1}, } },
 	/* wch_ch353_2s1p*/             { 1, { { 2, -1}, } },
 	/* sunix_2s1p */                { 1, { { 3, -1 }, } },
 };
@@ -253,6 +255,7 @@ static struct pci_device_id parport_serial_pci_tbl[] = {
 	{ 0x1409, 0x7168, 0x1409, 0xd079, 0, 0, timedia_9079c },
 
 	/* WCH CARDS */
+	{ 0x4348, 0x5053, PCI_ANY_ID, PCI_ANY_ID, 0, 0, wch_ch353_1s1p},
 	{ 0x4348, 0x7053, 0x4348, 0x3253, 0, 0, wch_ch353_2s1p},
 
 	/*
@@ -479,6 +482,12 @@ static struct pciserial_board pci_parport_serial_boards[] = {
 		.base_baud	= 921600,
 		.uart_offset	= 8,
 	},
+	[wch_ch353_1s1p] = {
+		.flags          = FL_BASE0|FL_BASE_BARS,
+		.num_ports      = 1,
+		.base_baud      = 115200,
+		.uart_offset    = 8,
+	},
 	[wch_ch353_2s1p] = {
 		.flags          = FL_BASE0|FL_BASE_BARS,
 		.num_ports      = 2,
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 6d402cf84cf1..ee1f7c52bd52 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1558,6 +1558,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_WCH_CH352_2S	0x3253
 #define PCI_DEVICE_ID_WCH_CH353_4S	0x3453
 #define PCI_DEVICE_ID_WCH_CH353_2S1PF	0x5046
+#define PCI_DEVICE_ID_WCH_CH353_1S1P	0x5053
 #define PCI_DEVICE_ID_WCH_CH353_2S1P	0x7053
 #define PCI_VENDOR_ID_AGESTAR		0x5372
 #define PCI_DEVICE_ID_AGESTAR_9375	0x6872
@@ -2159,6 +2160,14 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= pci_omegapci_setup,
 	},
+	/* WCH CH353 1S1P card (16550 clone) */
+	{
+		.vendor         = PCI_VENDOR_ID_WCH,
+		.device         = PCI_DEVICE_ID_WCH_CH353_1S1P,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = pci_wch_ch353_setup,
+	},
 	/* WCH CH353 2S1P card (16550 clone) */
 	{
 		.vendor         = PCI_VENDOR_ID_WCH,
@@ -3228,6 +3237,7 @@ static const struct pci_device_id blacklist[] = {
 
 	/* multi-io cards handled by parport_serial */
 	{ PCI_DEVICE(0x4348, 0x7053), }, /* WCH CH353 2S1P */
+	{ PCI_DEVICE(0x4348, 0x5053), }, /* WCH CH353 1S1P */
 };
 
 /*
-- 
2.1.3

