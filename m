Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3CREbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33599 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab3CREaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:46 -0400
Message-Id: <20130318042149.951317076@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Scott Ashcroft <scott.ashcroft@talk21.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 59/82] Fix 4 port and add support for 8 port Unknown PCI serial port
 cards
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Ashcroft <scott.ashcroft@talk21.com>

commit d13402a4a944e72612a9ec5c9190e35717c02a9d upstream.

I've managed to find an 8 port version of the card 4 port card which was discussed here:

http://marc.info/?l=linux-serial&m=120760744205314&w=2

Looking back at that thread there were two issues in the original patch.

1) The I/O ports for the UARTs are within BAR2 not BAR0. This can been seen in the original post.
2) A serial quirk isn't needed as these cards have no memory in BAR0 which makes pci_plx9050_init just return.

This patch fixes the 4 port support to use BAR2, removes the bogus quirk and adds support for the 8 port card.

$ lspci -vvv -n -s 00:08.0
00:08.0 0780: 10b5:9050 (rev 01)
	Subsystem: 10b5:1588
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 1: I/O ports at ff00 [size=128]
	Region 2: I/O ports at fe00 [size=64]
	Region 3: I/O ports at fd00 [size=8]
	Capabilities: <access denied>
	Kernel driver in use: serial

$ dmesg | grep 0000:00:08.0:
[    0.083320] pci 0000:00:08.0: [10b5:9050] type 0 class 0x000780
[    0.083355] pci 0000:00:08.0: reg 14: [io  0xff00-0xff7f]
[    0.083369] pci 0000:00:08.0: reg 18: [io  0xfe00-0xfe3f]
[    0.083382] pci 0000:00:08.0: reg 1c: [io  0xfd00-0xfd07]
[    0.083460] pci 0000:00:08.0: PME# supported from D0 D3hot
[    1.212867] 0000:00:08.0: ttyS4 at I/O 0xfe00 (irq = 17) is a 16550A
[    1.233073] 0000:00:08.0: ttyS5 at I/O 0xfe08 (irq = 17) is a 16550A
[    1.253270] 0000:00:08.0: ttyS6 at I/O 0xfe10 (irq = 17) is a 16550A
[    1.273468] 0000:00:08.0: ttyS7 at I/O 0xfe18 (irq = 17) is a 16550A
[    1.293666] 0000:00:08.0: ttyS8 at I/O 0xfe20 (irq = 17) is a 16550A
[    1.313863] 0000:00:08.0: ttyS9 at I/O 0xfe28 (irq = 17) is a 16550A
[    1.334061] 0000:00:08.0: ttyS10 at I/O 0xfe30 (irq = 17) is a 16550A
[    1.354258] 0000:00:08.0: ttyS11 at I/O 0xfe38 (irq = 17) is a 16550A

Signed-off-by: Scott Ashcroft <scott.ashcroft@talk21.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250_pci.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1154,6 +1154,7 @@ pci_xr17c154_setup(struct serial_private
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
+#define PCI_SUBDEVICE_ID_UNKNOWN_0x1588	0x1588
 
 /*
  * Master list of serial port init/setup/exit quirks.
@@ -1418,15 +1419,6 @@ static struct pci_serial_quirk pci_seria
 	},
 	{
 		.vendor		= PCI_VENDOR_ID_PLX,
-		.device		= PCI_DEVICE_ID_PLX_9050,
-		.subvendor	= PCI_VENDOR_ID_PLX,
-		.subdevice	= PCI_SUBDEVICE_ID_UNKNOWN_0x1584,
-		.init		= pci_plx9050_init,
-		.setup		= pci_default_setup,
-		.exit		= __devexit_p(pci_plx9050_exit),
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_PLX,
 		.device		= PCI_DEVICE_ID_PLX_ROMULUS,
 		.subvendor	= PCI_VENDOR_ID_PLX,
 		.subdevice	= PCI_DEVICE_ID_PLX_ROMULUS,
@@ -3120,7 +3112,12 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_VENDOR_ID_PLX,
 		PCI_SUBDEVICE_ID_UNKNOWN_0x1584, 0, 0,
-		pbn_b0_4_115200 },
+		pbn_b2_4_115200 },
+	/* Unknown card - subdevice 0x1588 */
+	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
+		PCI_VENDOR_ID_PLX,
+		PCI_SUBDEVICE_ID_UNKNOWN_0x1588, 0, 0,
+		pbn_b2_8_115200 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_KEYSPAN,
 		PCI_SUBDEVICE_ID_KEYSPAN_SX2, 0, 0,


