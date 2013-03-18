Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3CRWAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:00:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3CRVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vincent Deffontaines <vincent@gryzor.com>, Sean Young <sean@mess.org>
Subject: [ 19/75] tty/8250_pnp: serial port detection regression since v3.7
Date: Mon, 18 Mar 2013 14:06:42 -0700
Message-Id: <20130318210511.628163756@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 77e372a3d82e5e4878ce1962207edd766773cc76 upstream.

The InsydeH2O BIOS (version dated 09/12/2011) has the following in
its pnp resouces for its serial ports:

$ cat /sys/bus/pnp/devices/00:0b/resources
state = active
io disabled
irq disabled

We do not check if the resources are disabled, and create a bogus
ttyS* device. Since commit 835d844d1a28e (8250_pnp: do pnp probe
before legacy probe) we get a bogus ttyS0, which prevents the legacy
probe from detecting it.

Note, the BIOS can also be upgraded, fixing this problem, but for people
who can't do that, this fix is needed.

Reported-by: Vincent Deffontaines <vincent@gryzor.com>
Tested-by: Vincent Deffontaines <vincent@gryzor.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pnp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -429,6 +429,7 @@ serial_pnp_probe(struct pnp_dev *dev, co
 {
 	struct uart_8250_port uart;
 	int ret, line, flags = dev_id->driver_data;
+	struct resource *res = NULL;
 
 	if (flags & UNKNOWN_DEV) {
 		ret = serial_pnp_guess_board(dev);
@@ -439,11 +440,12 @@ serial_pnp_probe(struct pnp_dev *dev, co
 	memset(&uart, 0, sizeof(uart));
 	if (pnp_irq_valid(dev, 0))
 		uart.port.irq = pnp_irq(dev, 0);
-	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2)) {
-		uart.port.iobase = pnp_port_start(dev, 2);
-		uart.port.iotype = UPIO_PORT;
-	} else if (pnp_port_valid(dev, 0)) {
-		uart.port.iobase = pnp_port_start(dev, 0);
+	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2))
+		res = pnp_get_resource(dev, IORESOURCE_IO, 2);
+	else if (pnp_port_valid(dev, 0))
+		res = pnp_get_resource(dev, IORESOURCE_IO, 0);
+	if (pnp_resource_enabled(res)) {
+		uart.port.iobase = res->start;
 		uart.port.iotype = UPIO_PORT;
 	} else if (pnp_mem_valid(dev, 0)) {
 		uart.port.mapbase = pnp_mem_start(dev, 0);


