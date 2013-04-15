Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3DOOBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:01:37 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:44874 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3DOOBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:01:35 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH] serial_core.c: add put_device() after device_find_child()
Date: Mon, 15 Apr 2013 16:01:07 +0200
Message-Id: <1366034468-6911-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serial core uses device_find_child() but does not drop the reference to
the retrieved child after using it. This patch add the missing put_device().

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---

What I have done to test this issue.

I used a machine with an AMBA PL011 serial driver. I tested the patch on
next-20120408 because the last branch [next-20120415] does not boot on this
board.

For test purpose, I added some pr_info() messages to print the refcount
after device_find_child() (lines: 1937,2009), and after put_device()
(lines: 1947, 2021).


Boot the machine *without* put_device(). Then:

echo reboot > /sys/power/disk
echo disk > /sys/power/state
[   87.058575] uart_suspend_port:1937 refcount 4
[   87.058582] uart_suspend_port:1947 refcount 4
[   87.098083] uart_resume_port:2009refcount 5
[   87.098088] uart_resume_port:2021 refcount 5

echo disk > /sys/power/state
[  103.055574] uart_suspend_port:1937 refcount 6
[  103.055580] uart_suspend_port:1947 refcount 6
[  103.095322] uart_resume_port:2009 refcount 7
[  103.095327] uart_resume_port:2021 refcount 7

echo disk > /sys/power/state
[  252.459580] uart_suspend_port:1937 refcount 8
[  252.459586] uart_suspend_port:1947 refcount 8
[  252.499611] uart_resume_port:2009 refcount 9
[  252.499616] uart_resume_port:2021 refcount 9

The refcount continuously increased.


Boot the machine *with* this patch. Then:

echo reboot > /sys/power/disk
echo disk > /sys/power/state
[  159.333559] uart_suspend_port:1937 refcount 4
[  159.333566] uart_suspend_port:1947 refcount 3
[  159.372751] uart_resume_port:2009 refcount 4
[  159.372755] uart_resume_port:2021 refcount 3

echo disk > /sys/power/state
[  185.713614] uart_suspend_port:1937 refcount 4
[  185.713621] uart_suspend_port:1947 refcount 3
[  185.752935] uart_resume_port:2009 refcount 4
[  185.752940] uart_resume_port:2021 refcount 3

echo disk > /sys/power/state
[  207.458584] uart_suspend_port:1937 refcount 4
[  207.458591] uart_suspend_port:1947 refcount 3
[  207.498598] uart_resume_port:2009 refcount 4
[  207.498605] uart_resume_port:2021 refcount 3

The refcount correctly handled.

 drivers/tty/serial/serial_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 19cc749..f87dbfd 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1941,6 +1941,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
+
 	if (console_suspend_enabled || !uart_console(uport))
 		uport->suspended = 1;
 
@@ -2006,9 +2008,11 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 			disable_irq_wake(uport->irq);
 			uport->irq_wake = 0;
 		}
+		put_device(tty_dev);
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
 	uport->suspended = 0;
 
 	/*
-- 
1.8.1.4

