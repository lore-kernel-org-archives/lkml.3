Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3CGO5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:57:06 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:65065 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3CGO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:57:03 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 2/6] TTY: wake up processes last at hangup
Date: Thu,  7 Mar 2013 15:55:49 +0100
Message-Id: <1362668153-10972-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362668153-10972-1-git-send-email-jhovold@gmail.com>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move wake up of processes on blocked-open and modem-status wait queues
to after port shutdown at hangup.

This way the woken up processes can use the ASYNC_INITIALIZED flag to
detect port shutdown.

Note that this is the order currently used by serial-core.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/tty/tty_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 57a061e..3de5918 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -231,9 +231,9 @@ void tty_port_hangup(struct tty_port *port)
 	}
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
+	tty_port_shutdown(port);
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->delta_msr_wait);
-	tty_port_shutdown(port);
 }
 EXPORT_SYMBOL(tty_port_hangup);
 
-- 
1.8.1.1

