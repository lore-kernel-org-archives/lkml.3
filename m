Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaICJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:59:58 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57477 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932611AbaICJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:59:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 41/56] serial: core: Preserve termios c_cflag for console resume
Date: Wed,  3 Sep 2014 11:27:00 +0200
Message-Id: <8c97d63679fc0f7e1456003b16f625a804d9d68b.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ae84db9661cafc63d179e1d985a2c5b841ff0ac4 upstream.

When a tty is opened for the serial console, the termios c_cflag
settings are inherited from the console line settings.
However, if the tty is subsequently closed, the termios settings
are lost. This results in a garbled console if the console is later
suspended and resumed.

Preserve the termios c_cflag for the serial console when the tty
is shutdown; this reflects the most recent line settings.

Fixes: Bugzilla #69751, 'serial console does not wake from S3'
Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/serial_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0f02351c9239..b5180c10f71d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -235,6 +235,9 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
+		if (uart_console(uport) && tty)
+			uport->cons->cflag = tty->termios.c_cflag;
+
 		if (!tty || (tty->termios.c_cflag & HUPCL))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 
-- 
2.1.0

