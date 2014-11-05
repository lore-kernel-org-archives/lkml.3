Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaKESN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:13:29 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41987 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbaKESMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:12:01 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 2/5] serial: core: Claim port mutex for set_ldisc()
Date: Wed,  5 Nov 2014 13:11:42 -0500
Message-Id: <1415211105-16668-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
References: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three UART drivers (8250, atmel & amba-pl010) enable modem status
interrupts if the line discipline is changed to N_PPS. However,
the uart port flags may only be safely modified while holding the
port mutex.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 1a2d90f..5209eaa 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1245,8 +1245,11 @@ static void uart_set_ldisc(struct tty_struct *tty)
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport = state->uart_port;
 
-	if (uport->ops->set_ldisc)
+	if (uport->ops->set_ldisc) {
+		mutex_lock(&state->port.mutex);
 		uport->ops->set_ldisc(uport, tty->termios.c_line);
+		mutex_unlock(&state->port.mutex);
+	}
 }
 
 static void uart_set_termios(struct tty_struct *tty,
-- 
2.1.3

