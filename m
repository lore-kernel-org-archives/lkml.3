Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaF1SZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:25:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbaF1RvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Chivers <schivers@csc.com>
Subject: [PATCH 3.15 008/139] printk/of_serial: fix serial console cessation part way through boot.
Date: Sat, 28 Jun 2014 10:46:09 -0700
Message-Id: <20140628174605.736260851@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Chivers <schivers@csc.com>

commit 7fa21dd8bd191564a195291161d6b43db5d9c350 upstream.

Commit 5f5c9ae56c38942623f69c3e6dc6ec78e4da2076
"serial_core: Unregister console in uart_remove_one_port()"
fixed a crash where a serial port was removed but
not deregistered as a console.

There is a side effect of that commit for platforms having serial consoles
and of_serial configured (CONFIG_SERIAL_OF_PLATFORM). The serial console
is disabled midway through the boot process.

This cessation of the serial console affects PowerPC computers
such as the MVME5100 and SAM440EP.

The sequence is:

	bootconsole [udbg0] enabled
	....
	serial8250/16550 driver initialises and registers its UARTS,
	one of these is the serial console.
	console [ttyS0] enabled
	....
	of_serial probes "platform" devices, registering them as it goes.
	One of these is the serial console.
	console [ttyS0] disabled.

The disabling of the serial console is due to:

	a.  unregister_console in printk not clearing the
	    CONS_ENABLED bit in the console flags,
	    even though it has announced that the console is disabled; and

	b.  of_platform_serial_probe in of_serial not setting the port type
	    before it registers with serial8250_register_8250_port.

This patch ensures that the serial console is re-enabled when of_serial
registers a serial port that corresponds to the designated console.

===
The above failure was identified in Linux-3.15-rc2.

Tested using MVME5100 and SAM440EP PowerPC computers with
kernels built from Linux-3.15-rc5 and tty-next.

The continued operation of the serial console is vital for computers
such as the MVME5100 as that Single Board Computer does not
have any grapical/display hardware.

Signed-off-by: Stephen Chivers <schivers@csc.com>
Tested-by: Stephen Chivers <schivers@csc.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> [unregister_console]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/of_serial.c |    1 +
 kernel/printk/printk.c         |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -173,6 +173,7 @@ static int of_platform_serial_probe(stru
 	{
 		struct uart_8250_port port8250;
 		memset(&port8250, 0, sizeof(port8250));
+		port.type = port_type;
 		port8250.port = port;
 
 		if (port.fifosize)
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2413,6 +2413,7 @@ int unregister_console(struct console *c
 	if (console_drivers != NULL && console->flags & CON_CONSDEV)
 		console_drivers->flags |= CON_CONSDEV;
 
+	console->flags &= ~CON_ENABLED;
 	console_unlock();
 	console_sysfs_notify();
 	return res;


