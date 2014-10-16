Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaJPUGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:06:55 -0400
Received: from endruntechnologies.com ([64.142.115.26]:57172 "EHLO
	mail.endruntechnologies.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbaJPUGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:06:54 -0400
Message-ID: <54402619.8080703@endruntechnologies.com>
Date: Thu, 16 Oct 2014 13:10:01 -0700
From: Mike Skoog <mskoog@endruntechnologies.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: greg KH <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Add EndRun PCIe PTP card to 8250_pci.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8b670622745c137892109ee93429d08564a1ddbb Mon Sep 17 00:00:00 2001
From: Mike Skoog <mskoog.endruntechnologies.com>
Date: Thu, 16 Oct 2014 07:47:56 -0700
Subject: [PATCH] 8250_pci: Added driver for Endrun Technologies PTP PCIe card.

Added recognition of EndRun Technologies PCIe PTP slave card
and setup two ttySx ports for communication with the card for
retrieval of PTP based time and to communicate with the card's
Linux OS.

Signed-off-by: Mike Skoog <mskoog@endruntechnologies.com>
Signed-off-by: Mike Korreng <mkorreng@endruntechnologies.com>
---
 drivers/tty/serial/8250/8250_pci.c |   67 ++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 61830b1..9047aba 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1000,6 +1000,40 @@ static void pci_ite887x_exit(struct pci_dev *dev)
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
+			number_uarts);
+	}
+	pci_iounmap(dev, p);
+	return number_uarts;
+}
+
+/*
  * Oxford Semiconductor Inc.
  * Check that device is part of the Tornado range of devices, then determine
  * the number of ports available on the device.
@@ -2303,6 +2337,17 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
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
@@ -3255,6 +3301,20 @@ static struct pciserial_board pci_boards[] = {
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
@@ -4121,6 +4181,13 @@ static struct pci_device_id serial_pci_tbl[] = {
 		0x10b5, 0x106a, 0, 0,
 		pbn_plx_romulus },
 	/*
+	* EndRun Technologies. PCI express device range.
+	*    EndRun PTP/1588 has 2 Native UARTs.
+	*/
+	{	PCI_VENDOR_ID_ENDRUN, PCI_DEVICE_ID_ENDRUN_1588,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_endrun_2_4000000 },
+	/*
 	 * Quatech cards. These actually have configurable clocks but for
 	 * now we just use the default.
 	 *
-- 
1.7.1

