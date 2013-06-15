Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3FONgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:36:44 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:39765 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3FONgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:36:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 04/16] tty: Merge tty_buffer_find() into tty_buffer_alloc()
Date: Sat, 15 Jun 2013 09:36:04 -0400
Message-Id: <1371303376-5028-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_buffer_find() implements a simple free list lookaside cache.
Merge this functionality into tty_buffer_alloc() to reflect the
more traditional alloc/free symmetry.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 50 +++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 56d4602..a428fa2 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -64,6 +64,8 @@ void tty_buffer_free_all(struct tty_port *port)
  *	@size: desired size (characters)
  *
  *	Allocate a new tty buffer to hold the desired number of characters.
+ *	We round our buffers off in 256 character chunks to get better
+ *	allocation behaviour.
  *	Return NULL if out of memory or the allocation would exceed the
  *	per device queue
  *
@@ -72,14 +74,29 @@ void tty_buffer_free_all(struct tty_port *port)
 
 static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 {
+	struct tty_buffer **tbh = &port->buf.free;
 	struct tty_buffer *p;
 
+	/* Round the buffer size out */
+	size = __ALIGN_MASK(size, TTYB_ALIGN_MASK);
+
+	if (size <= MIN_TTYB_SIZE) {
+		if (*tbh) {
+			p = *tbh;
+			*tbh = p->next;
+			goto found;
+		}
+	}
+
+	/* Should possibly check if this fails for the largest buffer we
+	   have queued and recycle that ? */
 	if (port->buf.memory_used + size > 65536)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
 		return NULL;
 
+found:
 	tty_buffer_reset(p, size);
 	port->buf.memory_used += size;
 	return p;
@@ -172,37 +189,6 @@ void tty_buffer_flush(struct tty_struct *tty)
 }
 
 /**
- *	tty_buffer_find		-	find a free tty buffer
- *	@tty: tty owning the buffer
- *	@size: characters wanted
- *
- *	Locate an existing suitable tty buffer or if we are lacking one then
- *	allocate a new one. We round our buffers off in 256 character chunks
- *	to get better allocation behaviour.
- *
- *	Locking: Caller must hold tty->buf.lock
- */
-
-static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
-{
-	struct tty_buffer **tbh = &port->buf.free;
-	if (size <= MIN_TTYB_SIZE) {
-		if (*tbh) {
-			struct tty_buffer *t = *tbh;
-
-			*tbh = t->next;
-			tty_buffer_reset(t, t->size);
-			port->buf.memory_used += t->size;
-			return t;
-		}
-	}
-	/* Round the buffer size out */
-	size = __ALIGN_MASK(size, TTYB_ALIGN_MASK);
-	return tty_buffer_alloc(port, size);
-	/* Should possibly check if this fails for the largest buffer we
-	   have queued and recycle that ? */
-}
-/**
  *	tty_buffer_request_room		-	grow tty buffer if needed
  *	@tty: tty structure
  *	@size: size desired
@@ -230,7 +216,7 @@ int tty_buffer_request_room(struct tty_port *port, size_t size)
 
 	if (left < size) {
 		/* This is the slow path - looking for new buffers to use */
-		if ((n = tty_buffer_find(port, size)) != NULL) {
+		if ((n = tty_buffer_alloc(port, size)) != NULL) {
 			if (b != NULL) {
 				b->next = n;
 				b->commit = b->used;
-- 
1.8.1.2

