Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaJJWAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:00:24 -0400
Received: from endruntechnologies.com ([64.142.115.26]:37695 "EHLO
	mail.endruntechnologies.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbaJJV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:59:58 -0400
X-Greylist: delayed 2500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2014 17:59:58 EDT
Message-ID: <54384D73.5020004@endruntechnologies.com>
Date: Fri, 10 Oct 2014 14:19:47 -0700
From: Mike Skoog <mskoog@endruntechnologies.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mkorreng <mkorreng@endruntechnologies.com>
Subject: Kernel Patch to add Endrun PCIe PTP card v1 (1/2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=====================================================
Subject: [PATCHv1 1/2] 8250_pci: pci.ids: EndRun Technologies PTP PCIe
card recognition.
From: Michael Skoog, EndRun Technologies, Inc.

Add recognition of EndRun Technologies PCIe PTP slave card
and setups two ttySx ports to communicate to the card for
retrieval of PTP based time and to communicate with the card's
Linux OS.

Signed-off-by: Michael Skoog <mskoog@endruntechnologies.com>
Signed-off-by: Mike Korreng <mkorreng@endruntechnologies.com>

---

The kernel patch is currently against linux 3.17 kernel, for the x86
architecture.

The pci.ids patch is against the Slackware 13 distribution.

diffstat:
 8250_pci.c |   66
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

Please let me know any feedback you have on this patch or the approach used.

Thanks,

=====================
Michael Skoog
Software Engineer
EndRun Technologies
=====================


--------------------------------------------------------------------------------
diff -up linux-3.16.3/drivers/tty/serial/8250/8250_pci.c{.orig,} >
/tmp/8250_pci.c.patch

--- linux-3.17/drivers/tty/serial/8250/8250_pci.c.orig	2014-10-09
09:29:31.083013764 -0700
+++ linux-3.17/drivers/tty/serial/8250/8250_pci.c	2014-10-09
13:20:34.817731134 -0700
@@ -1000,6 +1000,40 @@ static void pci_ite887x_exit(struct pci_
 }

 /*
+ * EndRun Technologies.
+ * Determine the number of ports available on the device.
+ */
+#define PCI_VENDOR_ID_ENDRUN			0x7401
+#define PCI_DEVICE_ID_ENDRUN_1588	0xe100
+
+static int pci_endrun_init(struct pci_dev *dev)
+{
+	u8 __iomem *p;
+	unsigned long deviceID;
+	unsigned int  number_uarts = 0;
+
+	/* EndRun device is all 0xexxx */
+	if (dev->vendor == PCI_VENDOR_ID_ENDRUN &&
+		(dev->device & 0xf000) != 0xe000)
+		return 0;
+
+	p = pci_iomap(dev, 0, 5);
+	if (p == NULL)
+		return -ENOMEM;
+
+	deviceID = ioread32(p);
+	/* EndRun device */
+	if (deviceID == 0x07000200) {
+		number_uarts = ioread8(p + 4);
+		dev_dbg(&dev->dev,
+			"%d ports detected on EndRun PCI Express device\n",
+								number_uarts);
+	}
+	pci_iounmap(dev, p);
+	return number_uarts;
+}
+
+/*
  * Oxford Semiconductor Inc.
  * Check that device is part of the Tornado range of devices, then
determine
  * the number of ports available on the device.
@@ -2303,6 +2337,17 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_netmos_9900_setup,
 	},
 	/*
+	 * EndRun Technologies
+	*/
+	{
+		.vendor		= PCI_VENDOR_ID_ENDRUN,
+		.device		= PCI_ANY_ID,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_endrun_init,
+		.setup		= pci_default_setup,
+	},
+	/*
 	 * For Oxford Semiconductor Tornado based devices
 	 */
 	{
@@ -2711,6 +2756,7 @@ enum pci_board_num_t {
 	pbn_panacom2,
 	pbn_panacom4,
 	pbn_plx_romulus,
+	pbn_endrun_2_4000000,
 	pbn_oxsemi,
 	pbn_oxsemi_1_4000000,
 	pbn_oxsemi_2_4000000,
@@ -3255,6 +3301,20 @@ static struct pciserial_board pci_boards
 	},

 	/*
+	 * EndRun Technologies
+	* Uses the size of PCI Base region 0 to
+	* signal now many ports are available
+	* 2 port 952 Uart support
+	*/
+	[pbn_endrun_2_4000000] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 2,
+		.base_baud	= 4000000,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+
+	/*
 	 * This board uses the size of PCI Base region 0 to
 	 * signal now many ports are available
 	 */
@@ -4121,6 +4181,12 @@ static struct pci_device_id serial_pci_t
 		0x10b5, 0x106a, 0, 0,
 		pbn_plx_romulus },
 	/*
+	* EndRun Technologies. PCI express device range.
+	*/
+	{	PCI_VENDOR_ID_ENDRUN, PCI_DEVICE_ID_ENDRUN_1588, /* EndRun PTP/1588
2 Native UART */
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_endrun_2_4000000 },
+	/*
 	 * Quatech cards. These actually have configurable clocks but for
 	 * now we just use the default.
 	 *
