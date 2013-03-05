Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3CEOVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:21:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:35594 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3CEOVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:21:02 -0500
Date: Tue, 5 Mar 2013 09:19:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Wang YanQing <udknight@gmail.com>, <gregkh@linuxfoundation.org>,
        <swarren@wwwdotorg.org>, <jslaby@suse.cz>, <alan@linux.intel.com>,
        <arnd@arndb.de>, <damm@opensource.se>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]8250_pci: Add additional WCH CH352 device
Message-ID: <20130305141952.GA20799@windriver.com>
References: <20130302094555.GA9572@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130302094555.GA9572@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH]8250_pci: Add additional WCH CH352 device] On 02/03/2013 (Sat 17:45) Wang YanQing wrote:

> This patch fix a problem XScale port
> detect code in autoconfig_16550a treat
> 16550A port as XScale port, caused by
> CH352 device use the 6th bit(UART_IER_UUE)
> in IER as a enhance function make this bit
> w/r.
> 

Maybe we should add a bit more data to the short log and long log,
based on what you said in the other thread.  And also lets put the
352 entry before the existing 353 entries, instead of after it,
something like the below...

Paul.
--

>From d92be6ffc95c5947cc7d22d5f0c1382bfb4f0a52 Mon Sep 17 00:00:00 2001
From: Wang YanQing <udknight@gmail.com>
Date: Sat, 2 Mar 2013 17:45:55 +0800
Subject: [PATCH] 8250_pci: Add WCH CH352 quirk to avoid Xscale detection

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
1.8.1.2
