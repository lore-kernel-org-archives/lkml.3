Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaBUWqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:46:21 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35438 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaBUWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:46:19 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, gtdev@spearhead.de, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 1/1] serial: 8250_pci: fix support for MosChip 98xx boards
Date: Fri, 21 Feb 2014 14:46:17 -0800
Message-Id: <1393022777-5959-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.8.3.2
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (ovro.ovro.caltech.edu [0.0.0.0]); Fri, 21 Feb 2014 14:46:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

Commit 7808edcd306f22aeb23775d34e70b7fa2f58b852 "Basic support for
Moschip 9900 family I/O chips" broke support for the 98xx boards. This
is due to a missing check for the 99xx family inside the newly added
pci_netmos_9900_setup() function, which is now used for all boards in
the Moschip family.

The code for skipping BARs is incorrect for the 98xx boards. Using it
causes two serial ports to be left undetected on my 9865 board.

By checking for the 99xx boards and using the new code exclusively for
them, all of my serial ports are now detected.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---

Here is the lspci output for my 9865 board. On the 05:00.2 device, the
middle two serial ports (I/O ports 0x1010 and 0x1008) are left unused
and undetected without this patch.

After the patch, they work perfectly.

05:00.0 Serial controller: MosChip Semiconductor Technology Ltd. PCI 9865 Multi-I/O Controller (prog-if 02 [16550])
	Subsystem: Device a000:1000
	Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ 21
	I/O ports at 1028 [size=8]
	Memory at e0104000 (32-bit, non-prefetchable) [size=4K]
	Memory at e0103000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial
	Kernel modules: parport_pc

05:00.1 Serial controller: MosChip Semiconductor Technology Ltd. PCI 9865 Multi-I/O Controller (prog-if 02 [16550])
	Subsystem: Device a000:1000
	Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ 22
	I/O ports at 1020 [size=8]
	Memory at e0102000 (32-bit, non-prefetchable) [size=4K]
	Memory at e0101000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial
	Kernel modules: parport_pc

05:00.2 Communication controller: MosChip Semiconductor Technology Ltd. PCI 9865 Multi-I/O Controller
	Subsystem: Device a000:3004
	Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ 23
	I/O ports at 1018 [size=8]
	I/O ports at 1010 [size=8]
	I/O ports at 1008 [size=8]
	I/O ports at 1000 [size=8]
	Memory at e0100000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial

 drivers/tty/serial/8250/8250_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 50228eed3b6f..374551f196c5 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -783,7 +783,8 @@ static int pci_netmos_9900_setup(struct serial_private *priv,
 {
 	unsigned int bar;
 
-	if ((priv->dev->subsystem_device & 0xff00) == 0x3000) {
+	if ((priv->dev->subsystem_device & 0xff00) == 0x3000 &&
+		(priv->dev->device & 0xff00) == 0x9900) {
 		/* netmos apparently orders BARs by datasheet layout, so serial
 		 * ports get BARs 0 and 3 (or 1 and 4 for memmapped)
 		 */
-- 
1.8.3.2

