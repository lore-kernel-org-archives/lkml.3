Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaKERkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:40:49 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57118 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754949AbaKERkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:40:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 3/3] tty: Flush tty buffers after hardware shutdown
Date: Wed,  5 Nov 2014 12:40:05 -0500
Message-Id: <1415209205-16309-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
References: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line discipline buffer and the tty buffers must be flushed again
after hardware shutdown; otherwise, a brief window exists between the
ldisc flush in tty_port_close_start() and the subsequent
tty_port_shutdown(), during which more data could be received into the
tty buffers. A racing open might then be able to receive data from the
previous session.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 3b641d1..4d9abaa 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -520,6 +520,7 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 {
 	unsigned long flags;
 
+	tty_ldisc_flush(tty);
 	tty->closing = 0;
 
 	spin_lock_irqsave(&port->lock, flags);
-- 
2.1.3

