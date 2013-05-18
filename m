Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3ERC1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:27:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab3ERCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:50 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vLkvbMPUPvwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AX8LkvjFxbQA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=31FYUmqyeZ1yupaIOyYA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021645.737244852@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Federico Vaga <federico.vaga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 025/136 ] serial_core.c: add put_device() after device_find_child()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0025-serial_core.c-add-put_device-after-device_find_child.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Federico Vaga <federico.vaga@gmail.com>

[ Upstream commit 5a65dcc04cda41f4122aacc37a5a348454645399 ]

The serial core uses device_find_child() but does not drop the reference to
the retrieved child after using it. This patch add the missing put_device().

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

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/serial_core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..9d2c26c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1877,6 +1877,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
+
 	if (console_suspend_enabled || !uart_console(uport))
 		uport->suspended = 1;
 
@@ -1942,9 +1944,11 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
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
1.7.10.4


