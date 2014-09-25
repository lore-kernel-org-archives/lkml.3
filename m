Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIYJUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:20:12 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:59008 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaIYJUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:20:06 -0400
X-ASG-Debug-ID: 1411636795-0759e70b7317db60002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, Frans Klaver <frans.klaver@xsens.com>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH resend 1/2] tty: omap-serial: fix division by zero
Date: Thu, 25 Sep 2014 11:19:51 +0200
X-ASG-Orig-Subj: [PATCH resend 1/2] tty: omap-serial: fix division by zero
Message-ID: <1411636791-24116-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140924080852.GA28215@kroah.com>
References: <20140924080852.GA28215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411636795
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9857
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the chosen baud rate is large enough (e.g. 3.5 megabaud), the
calculated n values in serial_omap_is_baud_mode16() may become 0. This
causes a division by zero when calculating the difference between
calculated and desired baud rates. To prevent this, cap the n13 and n16
values on 1.

Division by zero in kernel.
[<c00132e0>] (unwind_backtrace) from [<c00112ec>] (show_stack+0x10/0x14)
[<c00112ec>] (show_stack) from [<c01ed7bc>] (Ldiv0+0x8/0x10)
[<c01ed7bc>] (Ldiv0) from [<c023805c>] (serial_omap_baud_is_mode16+0x4c/0x68)
[<c023805c>] (serial_omap_baud_is_mode16) from [<c02396b4>] (serial_omap_set_termios+0x90/0x8d8)
[<c02396b4>] (serial_omap_set_termios) from [<c0230a0c>] (uart_change_speed+0xa4/0xa8)
[<c0230a0c>] (uart_change_speed) from [<c0231798>] (uart_set_termios+0xa0/0x1fc)
[<c0231798>] (uart_set_termios) from [<c022bb44>] (tty_set_termios+0x248/0x2c0)
[<c022bb44>] (tty_set_termios) from [<c022c17c>] (set_termios+0x248/0x29c)
[<c022c17c>] (set_termios) from [<c022c3e4>] (tty_mode_ioctl+0x1c8/0x4e8)
[<c022c3e4>] (tty_mode_ioctl) from [<c0227e70>] (tty_ioctl+0xa94/0xb18)
[<c0227e70>] (tty_ioctl) from [<c00cf45c>] (do_vfs_ioctl+0x4a0/0x560)
[<c00cf45c>] (do_vfs_ioctl) from [<c00cf568>] (SyS_ioctl+0x4c/0x74)
[<c00cf568>] (SyS_ioctl) from [<c000e480>] (ret_fast_syscall+0x0/0x30)

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
Resend to add stable@vger.kernel.org to CC. As far as I know, this applies to
v3.9 and up.

Thanks,
Frans

 drivers/tty/serial/omap-serial.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d017cec..e454b7c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -254,8 +254,16 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 {
 	unsigned int n13 = port->uartclk / (13 * baud);
 	unsigned int n16 = port->uartclk / (16 * baud);
-	int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
-	int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
+	int baudAbsDiff13;
+	int baudAbsDiff16;
+
+	if (n13 == 0)
+		n13 = 1;
+	if (n16 == 0)
+		n16 = 1;
+
+	baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
+	baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
 	if (baudAbsDiff13 < 0)
 		baudAbsDiff13 = -baudAbsDiff13;
 	if (baudAbsDiff16 < 0)
-- 
2.1.0

