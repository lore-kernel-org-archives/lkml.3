Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaGINWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:22:11 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48585 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755550AbaGINV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:21:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v2] serial: core: Preserve termios c_cflag for console resume
Date: Wed,  9 Jul 2014 09:21:14 -0400
Message-Id: <1404912074-9729-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404912074-9729-1-git-send-email-peter@hurleysoftware.com>
References: <1404912074-9729-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a tty is opened for the serial console, the termios c_cflag
settings are inherited from the console line settings.
However, if the tty is subsequently closed, the termios settings
are lost. This results in a garbled console if the console is later
suspended and resumed.

Preserve the termios c_cflag for the serial console when the tty
is shutdown; this reflects the most recent line settings.

Fixes: Bugzilla #69751, 'serial console does not wake from S3'
Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b68550d..aab7190 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -239,6 +239,9 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
+		if (uart_console(uport) && tty)
+			uport->cons->cflag = tty->termios.c_cflag;
+
 		if (!tty || (tty->termios.c_cflag & HUPCL))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 
-- 
2.0.0

