Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3CEPQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:16:16 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52036 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3CEPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:16:14 -0500
Date: Tue, 5 Mar 2013 23:16:48 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: paul.gortmaker@windriver.com, swarren@wwwdotorg.org, jslaby@suse.cz,
        alan@linux.intel.com, arnd@arndb.de, damm@opensource.se,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2]8250_pci: Add WCH CH352 quirk to avoid Xscale detection
Message-ID: <20130305151648.GA7482@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, paul.gortmaker@windriver.com,
	swarren@wwwdotorg.org, jslaby@suse.cz, alan@linux.intel.com,
	arnd@arndb.de, damm@opensource.se, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in 8250.c for detecting ARM/XScale UARTs says:

  * Try writing and reading the UART_IER_UUE bit (b6).
  * If it works, this is probably one of the Xscale platform's
  * internal UARTs.

If the above passes, it then goes on to:

     * It's an Xscale.
     * We'll leave the UART_IER_UUE bit set to 1 (enabled).

However, the CH352 uses the UART_IER_UUE as the LOWPOWER function,
so it is readable and writable.  According to the datasheet:

    "LOWPOWER:When the bit is 1, close the internal benchmark
     clock of serial port to set into low-power status.

So it essentially gets mis-detected as Xscale, and gets
powered down in the process.  The device in question where
this was seen is listed by lspci as:

 Serial controller: Device 4348:3253 (rev 10) (prog-if 02 [16550])

Re-using the 353 quirk which just sets flags to fixed and type
to 16550 is suitable for fixing the 352 as well.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Changes
 V1-V2:
 1: Use a better descriptive subject by Paul Gortmaker 
 2: Add more detail log by Paul Gortmaker 

 I resend this version, because it will make merge job easy, and I 
 will not owe gregkh juice :)

 Thanks, Paul Gortmaker and all
 drivers/tty/serial/8250/8250_pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 791c5a7..5805f89 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1554,6 +1554,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
 #define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 #define PCI_VENDOR_ID_WCH		0x4348
+#define PCI_DEVICE_ID_WCH_CH352_2S	0x3253
 #define PCI_DEVICE_ID_WCH_CH353_4S	0x3453
 #define PCI_DEVICE_ID_WCH_CH353_2S1PF	0x5046
 #define PCI_DEVICE_ID_WCH_CH353_2S1P	0x7053
@@ -2180,6 +2181,14 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch353_setup,
 	},
+	/* WCH CH352 2S card (16550 clone) */
+	{
+		.vendor		= PCI_VENDOR_ID_WCH,
+		.device		= PCI_DEVICE_ID_WCH_CH352_2S,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_wch_ch353_setup,
+	},
 	/*
 	 * ASIX devices with FIFO bug
 	 */
@@ -4869,6 +4878,10 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_b0_bt_2_115200 },
 
+	{	PCI_VENDOR_ID_WCH, PCI_DEVICE_ID_WCH_CH352_2S,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	/*
 	 * Commtech, Inc. Fastcom adapters
 	 */
-- 
1.7.12.4.dirty
