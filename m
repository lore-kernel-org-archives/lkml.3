Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbbAPUW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:22:26 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62631 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbAPUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:22:24 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] pty: Fix overlimit memory use
Date: Fri, 16 Jan 2015 15:22:14 -0500
Message-Id: <1421439734-17335-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty_space() computation is broken; the space already consumed
in the tty buffer is not accounted for.

Use tty_buffer_set_limit(), which enforces the limit automatically.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index a9d256d..2cf2567 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -88,19 +88,6 @@ static void pty_unthrottle(struct tty_struct *tty)
 }
 
 /**
- *	pty_space	-	report space left for writing
- *	@to: tty we are writing into
- *
- *	Limit the buffer space used by ptys to 8k.
- */
-
-static int pty_space(struct tty_struct *to)
-{
-	int n = tty_buffer_space_avail(to->port);
-	return min(n, 8192);
-}
-
-/**
  *	pty_write		-	write to a pty
  *	@tty: the tty we write from
  *	@buf: kernel buffer of data
@@ -141,7 +128,7 @@ static int pty_write_room(struct tty_struct *tty)
 {
 	if (tty->stopped)
 		return 0;
-	return pty_space(tty->link);
+	return tty_buffer_space_avail(tty->link->port);
 }
 
 /**
@@ -429,6 +416,8 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	o_tty->link = tty;
 	tty_port_init(ports[0]);
 	tty_port_init(ports[1]);
+	tty_buffer_set_limit(ports[0], 8192);
+	tty_buffer_set_limit(ports[1], 8192);
 	o_tty->port = ports[0];
 	tty->port = ports[1];
 	o_tty->port->itty = o_tty;
-- 
2.2.2

