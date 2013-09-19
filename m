Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3ISArk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 20:47:40 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:35468 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3ISAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 20:47:38 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next] tty: Remove unused drop() method from tty_port interface
Date: Wed, 18 Sep 2013 20:47:06 -0400
Message-Id: <1379551626-15063-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although originally conceived as a hook for port drivers to know
when a port reference is dropped, no driver uses this method.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 6 +-----
 include/linux/tty.h    | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index f597e88..9857f7e 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -480,8 +480,6 @@ int tty_port_close_start(struct tty_port *port,
 
 	if (port->count) {
 		spin_unlock_irqrestore(&port->lock, flags);
-		if (port->ops->drop)
-			port->ops->drop(port);
 		return 0;
 	}
 	set_bit(ASYNCB_CLOSING, &port->flags);
@@ -500,9 +498,7 @@ int tty_port_close_start(struct tty_port *port,
 	/* Flush the ldisc buffering */
 	tty_ldisc_flush(tty);
 
-	/* Don't call port->drop for the last reference. Callers will want
-	   to drop the last active reference in ->shutdown() or the tty
-	   shutdown path */
+	/* Report to caller this is the last port reference */
 	return 1;
 }
 EXPORT_SYMBOL(tty_port_close_start);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 64f8646..2f47989 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -180,7 +180,6 @@ struct tty_port_operations {
 	   IFF the port was initialized. Do not use to free resources. Called
 	   under the port mutex to serialize against activate/shutdowns */
 	void (*shutdown)(struct tty_port *port);
-	void (*drop)(struct tty_port *port);
 	/* Called under the port mutex from tty_port_open, serialized using
 	   the port mutex */
         /* FIXME: long term getting the tty argument *out* of this would be
-- 
1.8.1.2

