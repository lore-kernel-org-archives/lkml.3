Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbbAVQwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:52:54 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:32859 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbbAVQwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:52:50 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 2/2] serial: 8250_pnp: Enable PNP_CONSOLE for console ports
Date: Thu, 22 Jan 2015 11:50:25 -0500
Message-Id: <1421945425-5326-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421945425-5326-1-git-send-email-peter@hurleysoftware.com>
References: <1421945425-5326-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel command line parameter, no_console_suspend, is used,
the console should continue to output console messages during and
after system suspend. For a serial console, the serial core ensures
that the device is not shutdown when no_console_suspend is specified.
However, the default operation of the pnp bus will disable and suspend
the device and no further output occurs.

When registering the 8250 port, if the serial device is a console
set the PNP_CONSOLE capability, which prevents device power-off
if consoles are not suspending.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_pnp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 682a2fb..50a09cd 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -426,7 +426,7 @@ static int serial_pnp_guess_board(struct pnp_dev *dev)
 static int
 serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
-	struct uart_8250_port uart;
+	struct uart_8250_port uart, *port;
 	int ret, line, flags = dev_id->driver_data;
 
 	if (flags & UNKNOWN_DEV) {
@@ -471,6 +471,10 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	if (line < 0 || (flags & CIR_PORT))
 		return -ENODEV;
 
+	port = serial8250_get_port(line);
+	if (uart_console(&port->port))
+		dev->capabilities |= PNP_CONSOLE;
+
 	pnp_set_drvdata(dev, (void *)((long)line + 1));
 	return 0;
 }
@@ -478,6 +482,8 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 static void serial_pnp_remove(struct pnp_dev *dev)
 {
 	long line = (long)pnp_get_drvdata(dev);
+
+	dev->capabilities &= ~PNP_CONSOLE;
 	if (line)
 		serial8250_unregister_port(line - 1);
 }
-- 
2.2.2

