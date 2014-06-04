Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaFDOQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:16:33 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41354 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753565AbaFDOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:16:31 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/2] serial: core: Don't drop DTR if system console
Date: Wed,  4 Jun 2014 10:16:10 -0400
Message-Id: <1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a tty is opened on a serial console, don't drop DTR on
last tty close, on tty hangup, or when resetting port hardware
via TIOCSSERIAL and TIOCSERCONFIG ioctls.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b68550d..498b149 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -239,7 +239,8 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
-		if (!tty || (tty->termios.c_cflag & HUPCL))
+		if (!uart_console(uport) &&
+		    (!tty || (tty->termios.c_cflag & HUPCL)))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 
 		uart_port_shutdown(port);
-- 
1.9.1

