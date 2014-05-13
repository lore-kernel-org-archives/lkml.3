Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaEMWIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:08:23 -0400
Received: from mail87.messagelabs.com ([216.82.250.19]:45403 "EHLO
	mail87.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789AbaEMWHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:07:00 -0400
X-Env-Sender: schivers@csc.com
X-Msg-Ref: server-10.tower-87.messagelabs.com!1400018817!15662045!1
X-Originating-IP: [20.137.2.87]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Date: Wed, 14 May 2014 08:04:39 +1000
To: geert@linux-m68k.org, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: [PATCH] printk/of_serial: fix serial console cessation part way
 through boot.
Cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        devicetree@vger.kernel.org, rob+dt@kernel.org, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, cproctor@csc.com,
        linux-serial@vger.kernel.org, schivers@csc.com
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20140513220439.5A063E0692@canberra.localdomain>
From: schivers@csc.com (Stephen Chivers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Stephen Chivers <schivers@csc.com>
Tested-by: Stephen Chivers <schivers@csc.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> [unregister_console]

===
The above failure was identified in Linux-3.15-rc2.

Tested using MVME5100 and SAM440EP PowerPC computers with
kernels built from Linux-3.15-rc5 and tty-next.

The continued operation of the serial console is vital for computers
such as the MVME5100 as that Single Board Computer does not
have any grapical/display hardware.

---
 drivers/tty/serial/of_serial.c |    1 +
 kernel/printk/printk.c         |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 9924660..27981e2 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -173,6 +173,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 	{
 		struct uart_8250_port port8250;
 		memset(&port8250, 0, sizeof(port8250));
+		port.type = port_type;
 		port8250.port = port;
 
 		if (port.fifosize)
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7228258..221229c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2413,6 +2413,7 @@ int unregister_console(struct console *console)
 	if (console_drivers != NULL && console->flags & CON_CONSDEV)
 		console_drivers->flags |= CON_CONSDEV;
 
+	console->flags &= ~CON_ENABLED;
 	console_unlock();
 	console_sysfs_notify();
 	return res;
