Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaFPNY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:24:29 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53018 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752144AbaFPNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:24:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 12/22] tty: serial: Fix termios/port flags mismatch
Date: Mon, 16 Jun 2014 09:17:09 -0400
Message-Id: <1402924639-5164-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uart port drivers may reconfigure termios settings based on available
hardware support; set/clear ASYNC_CTS_FLOW and ASYNC_CHECK_CD _after_
calling the port driver's .set_termios method.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c8879ce..f64cf45 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -443,6 +443,7 @@ static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 		return;
 
 	termios = &tty->termios;
+	uport->ops->set_termios(uport, termios, old_termios);
 
 	/*
 	 * Set flags based on termios cflag
@@ -456,8 +457,6 @@ static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 		clear_bit(ASYNCB_CHECK_CD, &port->flags);
 	else
 		set_bit(ASYNCB_CHECK_CD, &port->flags);
-
-	uport->ops->set_termios(uport, termios, old_termios);
 }
 
 static inline int __uart_put_char(struct uart_port *port,
@@ -1270,6 +1269,8 @@ static void uart_set_termios(struct tty_struct *tty,
 	}
 
 	uart_change_speed(tty, state, old_termios);
+	/* reload cflag from termios; port driver may have overriden flags */
+	cflag = tty->termios.c_cflag;
 
 	/* Handle transition to B0 status */
 	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
-- 
2.0.0

