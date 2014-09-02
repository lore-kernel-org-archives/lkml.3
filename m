Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaIBVm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:42:59 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41859 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755311AbaIBVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:40:06 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 05/26] serial: core: Remove unsafe x_char optimization
Date: Tue,  2 Sep 2014 17:39:14 -0400
Message-Id: <1409693975-1028-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uart_unthrottle() attempts to avoid sending START and the previous
x_char if the previous x_char has not yet been sent. However, this
optimization could leave the sender in a throttled state; for example,
if the sender is throttled and this unthrottle coincides with a manual
tcflow(TCION) from user-space, then neither START would be sent.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a68bff0..11c8fe6 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -643,12 +643,8 @@ static void uart_unthrottle(struct tty_struct *tty)
 		mask &= ~port->flags;
 	}
 
-	if (mask & UPF_SOFT_FLOW) {
-		if (port->x_char)
-			port->x_char = 0;
-		else
-			uart_send_xchar(tty, START_CHAR(tty));
-	}
+	if (mask & UPF_SOFT_FLOW)
+		uart_send_xchar(tty, START_CHAR(tty));
 
 	if (mask & UPF_HARD_FLOW)
 		uart_set_mctrl(port, TIOCM_RTS);
-- 
2.1.0

