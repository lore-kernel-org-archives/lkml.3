Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3ISAnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 20:43:15 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:34114 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3ISAnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 20:43:10 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 1/1] tty: Prevent tty_port destruction if tty not released
Date: Wed, 18 Sep 2013 20:42:39 -0400
Message-Id: <1379551359-15000-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379551359-15000-1-git-send-email-peter@hurleysoftware.com>
References: <1379551359-15000-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the tty driver mistakenly drops the last port reference
before the tty has been released, issue a diagnostic and
abort the port destruction.

This will leak memory and may zombify the port, but might
otherwise keep the machine in runnable state.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 9857f7e..c94d234 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -140,6 +140,10 @@ EXPORT_SYMBOL(tty_port_destroy);
 static void tty_port_destructor(struct kref *kref)
 {
 	struct tty_port *port = container_of(kref, struct tty_port, kref);
+
+	/* check if last port ref was dropped before tty release */
+	if (WARN_ON(port->itty))
+		return;
 	if (port->xmit_buf)
 		free_page((unsigned long)port->xmit_buf);
 	tty_port_destroy(port);
-- 
1.8.1.2

