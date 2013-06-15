Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3FON7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:59:23 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40052 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3FON5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 14/16] tty: Merge __tty_flush_buffer() into lone call site
Date: Sat, 15 Jun 2013 09:36:14 -0400
Message-Id: <1371303376-5028-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__tty_flush_buffer() is now only called by tty_flush_buffer();
merge functions.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index fb042b9..dbe4a71 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -151,28 +151,6 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 }
 
 /**
- *	__tty_buffer_flush		-	flush full tty buffers
- *	@tty: tty to flush
- *
- *	flush all the buffers containing receive data. Caller must
- *	hold the buffer lock and must have ensured no parallel flush to
- *	ldisc is running.
- */
-
-static void __tty_buffer_flush(struct tty_port *port)
-{
-	struct tty_bufhead *buf = &port->buf;
-	struct tty_buffer *next;
-
-	while ((next = buf->head->next) != NULL) {
-		tty_buffer_free(port, buf->head);
-		buf->head = next;
-	}
-	WARN_ON(buf->head != buf->tail);
-	buf->head->read = buf->head->commit;
-}
-
-/**
  *	tty_buffer_flush		-	flush full tty buffers
  *	@tty: tty to flush
  *
@@ -188,11 +166,16 @@ void tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_port *port = tty->port;
 	struct tty_bufhead *buf = &port->buf;
+	struct tty_buffer *next;
 
 	buf->flushpending = 1;
 
 	mutex_lock(&buf->flush_mutex);
-	__tty_buffer_flush(port);
+	while ((next = buf->head->next) != NULL) {
+		tty_buffer_free(port, buf->head);
+		buf->head = next;
+	}
+	buf->head->read = buf->head->commit;
 	buf->flushpending = 0;
 	mutex_unlock(&buf->flush_mutex);
 }
-- 
1.8.1.2

