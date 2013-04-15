Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635Ab3DOPjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:39:10 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45916 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab3DOPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:32:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 14/16] tty: Merge __tty_flush_buffer() into lone call site
Date: Mon, 15 Apr 2013 11:26:05 -0400
Message-Id: <1366039567-8620-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
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

