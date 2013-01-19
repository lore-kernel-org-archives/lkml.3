Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3ASBSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:18:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:56595 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab3ASBSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:18:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Huang Shijie <b32955@freescale.com>
Subject: [ 32/33] mxs: uart: fix setting RTS from software
Date: Fri, 18 Jan 2013 17:16:57 -0800
Message-Id: <20130119010356.983356057@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

commit a6833214cfc6fa8a7c59426af77794cc190c6cfc upstream.

With the patch "serial: mxs-auart: fix the wrong RTS hardware flow control" the
mainline mxs-uart driver now sets RTSEN only when hardware flow control is
enabled via software. It is not possible any longer to set RTS manually via
software. However, the manual modification is a valid operation.
Regain the possibility to set RTS via software and only set RTSEN when hardware
flow control is explicitly enabled via settermios cflag CRTSCTS.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/mxs-auart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -260,10 +260,12 @@ static void mxs_auart_set_mctrl(struct u
 
 	u32 ctrl = readl(u->membase + AUART_CTRL2);
 
-	ctrl &= ~AUART_CTRL2_RTSEN;
+	ctrl &= ~(AUART_CTRL2_RTSEN | AUART_CTRL2_RTS);
 	if (mctrl & TIOCM_RTS) {
 		if (tty_port_cts_enabled(&u->state->port))
 			ctrl |= AUART_CTRL2_RTSEN;
+		else
+			ctrl |= AUART_CTRL2_RTS;
 	}
 
 	s->ctrl = mctrl;


