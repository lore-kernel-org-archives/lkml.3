Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3FONgi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:36:38 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:39758 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3FONgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:36:36 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 02/16] tty: Fix flip buffer free list
Date: Sat, 15 Jun 2013 09:36:02 -0400
Message-Id: <1371303376-5028-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since flip buffers are size-aligned to 256 bytes and all flip
buffers 512-bytes or larger are not added to the free list, the
free list only contains 256-byte flip buffers.

Remove the list search when allocating a new flip buffer.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 170674c..a5e3962 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -18,6 +18,10 @@
 #include <linux/module.h>
 #include <linux/ratelimit.h>
 
+
+#define MIN_TTYB_SIZE	256
+#define TTYB_ALIGN_MASK	255
+
 /**
  *	tty_buffer_free_all		-	free buffers used by a tty
  *	@tty: tty to free from
@@ -94,7 +98,7 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 	buf->memory_used -= b->size;
 	WARN_ON(buf->memory_used < 0);
 
-	if (b->size >= 512)
+	if (b->size > MIN_TTYB_SIZE)
 		kfree(b);
 	else {
 		b->next = buf->free;
@@ -176,9 +180,10 @@ void tty_buffer_flush(struct tty_struct *tty)
 static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
 {
 	struct tty_buffer **tbh = &port->buf.free;
-	while ((*tbh) != NULL) {
-		struct tty_buffer *t = *tbh;
-		if (t->size >= size) {
+	if (size <= MIN_TTYB_SIZE) {
+		if (*tbh) {
+			struct tty_buffer *t = *tbh;
+
 			*tbh = t->next;
 			t->next = NULL;
 			t->used = 0;
@@ -187,10 +192,9 @@ static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
 			port->buf.memory_used += t->size;
 			return t;
 		}
-		tbh = &((*tbh)->next);
 	}
 	/* Round the buffer size out */
-	size = (size + 0xFF) & ~0xFF;
+	size = __ALIGN_MASK(size, TTYB_ALIGN_MASK);
 	return tty_buffer_alloc(port, size);
 	/* Should possibly check if this fails for the largest buffer we
 	   have queued and recycle that ? */
-- 
1.8.1.2

