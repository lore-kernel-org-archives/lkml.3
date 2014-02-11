Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBKKSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:18:42 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35908 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaBKKSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:18:36 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] serial: 8250_pci: unbreak last serial ports on NetMos 9865 cards
Date: Tue, 11 Feb 2014 14:18:13 +0400
Message-Id: <1392113893-8269-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aparently 9865 uses standard BAR encoding scheme (unlike 99xx cards).
Current pci_netmos_9900_setup() uses wrong BAR indices for the 9865 PCI
device, function 2. Using standard BAR indices makes all 6 ports work
for me. Thus disable the NetMos 9900 quirk for NetMos 9865 pci device.

For the reference, here is the relevant part of lspci for my device:

02:07.0 Serial controller: MosChip Semiconductor Technology Ltd. PCI
9865 Multi-I/O Controller (prog-if 02 [16550])
	Subsystem: Device a000:1000
	Flags: bus master, medium devsel, latency 32, IRQ 17
	I/O ports at ac00 [size=8]
	Memory at fcfff000 (32-bit, non-prefetchable) [size=4K]
	Memory at fcffe000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [48] Power Management version 2
	Kernel driver in use: serial

02:07.1 Serial controller: MosChip Semiconductor Technology Ltd. PCI
9865 Multi-I/O Controller (prog-if 02 [16550])
	Subsystem: Device a000:1000
	Flags: bus master, medium devsel, latency 32, IRQ 18
	I/O ports at a800 [size=8]
	Memory at fcffd000 (32-bit, non-prefetchable) [size=4K]
	Memory at fcffc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [48] Power Management version 2
	Kernel driver in use: serial

02:07.2 Communication controller: MosChip Semiconductor Technology Ltd.
PCI 9865 Multi-I/O Controller
	Subsystem: Device a000:3004
	Flags: bus master, medium devsel, latency 32, IRQ 19
	I/O ports at a400 [size=8]
	I/O ports at a000 [size=8]
	I/O ports at 9c00 [size=8]
	I/O ports at 9800 [size=8]
	Memory at fcffb000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [48] Power Management version 2
	Kernel driver in use: serial

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/tty/serial/8250/8250_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 4697a51..143a381 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -784,7 +784,8 @@ static int pci_netmos_9900_setup(struct serial_private *priv,
 {
 	unsigned int bar;
 
-	if ((priv->dev->subsystem_device & 0xff00) == 0x3000) {
+	if ((priv->dev->device != PCI_DEVICE_ID_NETMOS_9865) &&
+	    (priv->dev->subsystem_device & 0xff00) == 0x3000) {
 		/* netmos apparently orders BARs by datasheet layout, so serial
 		 * ports get BARs 0 and 3 (or 1 and 4 for memmapped)
 		 */
-- 
1.8.5.2

