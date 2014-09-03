Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935468AbaICXM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:12:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbaICWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>,
        Alan Cox <alan@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.16 053/125] serial: core: Preserve termios c_cflag for console resume
Date: Wed,  3 Sep 2014 15:06:50 -0700
Message-Id: <20140903220625.234840439@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -243,6 +243,9 @@ static void uart_shutdown(struct tty_str
 		/*
 		 * Turn off DTR and RTS early.
 		 */
+		if (uart_console(uport) && tty)
+			uport->cons->cflag = tty->termios.c_cflag;
+
 		if (!tty || (tty->termios.c_cflag & HUPCL))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 


