Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBJCWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:22:38 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39690 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaBJCWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:22:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 04/24] tty: Fix ref counting for port krefs
Date: Sun,  9 Feb 2014 20:59:04 -0500
Message-Id: <1391997564-1805-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty core supports two models for handling tty_port lifetimes;
the tty_port can use the kref supplied by tty_port (which will
automatically destruct the tty_port when the ref count drops to
zero) or it can destruct the tty_port manually.

For tty drivers that choose to use the port kref to manage the
tty_port lifetime, it is not possible to safely acquire a port
reference conditionally. If the last reference is released after
evaluating the condition but before acquiring the reference, a
bogus reference will be held while the tty_port destruction
commences.

Rather, only acquire a port reference if the ref count is non-zero
and allow the caller to distinguish if a reference has successfully
been acquired.

Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 90b4fdc..4781d7b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -518,9 +518,9 @@ extern void tty_port_put(struct tty_port *port);
 
 static inline struct tty_port *tty_port_get(struct tty_port *port)
 {
-	if (port)
-		kref_get(&port->kref);
-	return port;
+	if (port && kref_get_unless_zero(&port->kref))
+		return port;
+	return NULL;
 }
 
 /* If the cts flow control is enabled, return true. */
-- 
1.8.1.2

