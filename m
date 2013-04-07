Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab3DGTrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 15:47:23 -0400
Received: from pequod.mess.org ([46.65.169.142]:51451 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168Ab3DGTrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 15:47:22 -0400
From: Sean Young <sean@mess.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Deffontaines <vincent@gryzor.com>, tkil@scrye.com,
        stable@vger.kernel.org
Subject: [PATCH] Revert "tty/8250_pnp: serial port detection regression since v3.7"
Date: Sun,  7 Apr 2013 20:47:18 +0100
Message-Id: <1365364038-3959-1-git-send-email-sean@mess.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 77e372a3d82e5e4878ce1962207edd766773cc76.

Checking for disabled resources board breaks detection pnp on another
board "AMI UEFI implementation (Version: 0406 Release Date: 06/06/2012)".
I'm working with the reporter of the original bug to write and test
a better fix.

https://bugzilla.redhat.com/show_bug.cgi?id=928246

Signed-off-by: Sean Young <sean@mess.org>
Cc: stable <stable@kernel.org>
---
 drivers/tty/serial/8250/8250_pnp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index b3455a9..35d9ab9 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -429,7 +429,6 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	struct uart_8250_port uart;
 	int ret, line, flags = dev_id->driver_data;
-	struct resource *res = NULL;
 
 	if (flags & UNKNOWN_DEV) {
 		ret = serial_pnp_guess_board(dev);
@@ -440,12 +439,11 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	memset(&uart, 0, sizeof(uart));
 	if (pnp_irq_valid(dev, 0))
 		uart.port.irq = pnp_irq(dev, 0);
-	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2))
-		res = pnp_get_resource(dev, IORESOURCE_IO, 2);
-	else if (pnp_port_valid(dev, 0))
-		res = pnp_get_resource(dev, IORESOURCE_IO, 0);
-	if (pnp_resource_enabled(res)) {
-		uart.port.iobase = res->start;
+	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2)) {
+		uart.port.iobase = pnp_port_start(dev, 2);
+		uart.port.iotype = UPIO_PORT;
+	} else if (pnp_port_valid(dev, 0)) {
+		uart.port.iobase = pnp_port_start(dev, 0);
 		uart.port.iotype = UPIO_PORT;
 	} else if (pnp_mem_valid(dev, 0)) {
 		uart.port.mapbase = pnp_mem_start(dev, 0);
-- 
1.8.1.4

