Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaIBWNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:13:25 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36617 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752374AbaIBWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:13:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 12/26] serial: core: Unwrap tertiary assignment in uart_handle_dcd_change()
Date: Tue,  2 Sep 2014 17:39:21 -0400
Message-Id: <1409693975-1028-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for spin lock assertion; move non-trivial assignment into
function body.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 11c8fe6..732d386 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2736,12 +2736,15 @@ void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 {
 	struct tty_port *port = &uport->state->port;
 	struct tty_struct *tty = port->tty;
-	struct tty_ldisc *ld = tty ? tty_ldisc_ref(tty) : NULL;
+	struct tty_ldisc *ld;
 
-	if (ld) {
-		if (ld->ops->dcd_change)
-			ld->ops->dcd_change(tty, status);
-		tty_ldisc_deref(ld);
+	if (tty) {
+		ld = tty_ldisc_ref(tty);
+		if (ld) {
+			if (ld->ops->dcd_change)
+				ld->ops->dcd_change(tty, status);
+			tty_ldisc_deref(ld);
+		}
 	}
 
 	uport->icount.dcd++;
-- 
2.1.0

