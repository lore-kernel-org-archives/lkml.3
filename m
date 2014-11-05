Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaKESMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:12:08 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34740 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbaKESMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:12:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 4/5] serial: Take uart port lock for direct *_enable_ms()
Date: Wed,  5 Nov 2014 13:11:44 -0500
Message-Id: <1415211105-16668-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
References: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three UART drivers (8250, atmel & amba-pl010) directly call their
enable_ms() method; the uart port lock must be acquired before
any h/w programming.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 2 ++
 drivers/tty/serial/amba-pl010.c     | 2 ++
 drivers/tty/serial/atmel_serial.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 6cfdb7b..8eb0654 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2607,7 +2607,9 @@ serial8250_set_ldisc(struct uart_port *port, struct ktermios *termios)
 {
 	if (termios->c_line == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
+		spin_lock_irq(&port->lock);
 		serial8250_enable_ms(port);
+		spin_unlock_irq(&port->lock);
 	} else
 		port->flags &= ~UPF_HARDPPS_CD;
 }
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 76e40b3..04b83bf 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -472,7 +472,9 @@ static void pl010_set_ldisc(struct uart_port *port, struct ktermios *termios)
 {
 	if (termios->c_line == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
+		spin_lock_irq(&port->lock);
 		pl010_enable_ms(port);
+		spin_unlock_irq(&port->lock);
 	} else
 		port->flags &= ~UPF_HARDPPS_CD;
 }
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a2374d9..b68dfa5 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2046,7 +2046,9 @@ static void atmel_set_ldisc(struct uart_port *port, struct ktermios *termios)
 {
 	if (termios->c_line == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
+		spin_lock_irq(&port->lock);
 		atmel_enable_ms(port);
+		spin_unlock_irq(&port->lock);
 	} else {
 		port->flags &= ~UPF_HARDPPS_CD;
 	}
-- 
2.1.3

