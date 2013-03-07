Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab3CGO6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:58:23 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:45142 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3CGO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:57:03 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 1/6] TTY: clean up port shutdown
Date: Thu,  7 Mar 2013 15:55:48 +0100
Message-Id: <1362668153-10972-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362668153-10972-1-git-send-email-jhovold@gmail.com>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untangle port-shutdown logic and make sure the initialised flag is
always cleared for non-console ports.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/tty/tty_port.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index b7ff59d..57a061e 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -199,9 +199,14 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	mutex_lock(&port->mutex);
-	if (port->ops->shutdown && !port->console &&
-		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
+	if (port->console)
+		goto out;
+
+	if (test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags)) {
+		if (port->ops->shutdown)
 			port->ops->shutdown(port);
+	}
+out:
 	mutex_unlock(&port->mutex);
 }
 
-- 
1.8.1.1

