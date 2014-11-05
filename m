Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaKERk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:40:26 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33685 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754771AbaKERkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:40:18 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 1/3] tty: Move tty hung up check from port->lock critical section
Date: Wed,  5 Nov 2014 12:40:03 -0500
Message-Id: <1415209205-16309-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
References: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port->lock does not protect the filp->f_op field; move
the tty_hung_up_p() test outside the port->lock critical section
in tty_port_close_start().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 1b93357..3b641d1 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -473,12 +473,10 @@ int tty_port_close_start(struct tty_port *port,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
-	if (tty_hung_up_p(filp)) {
-		spin_unlock_irqrestore(&port->lock, flags);
+	if (tty_hung_up_p(filp))
 		return 0;
-	}
 
+	spin_lock_irqsave(&port->lock, flags);
 	if (tty->count == 1 && port->count != 1) {
 		printk(KERN_WARNING
 		    "tty_port_close_start: tty->count = 1 port count = %d.\n",
-- 
2.1.3

