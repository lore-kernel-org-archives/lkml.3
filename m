Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3DOP0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:26:45 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45251 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab3DOP0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:26:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 07/16] tty: Simplify flip buffer list with 0-sized sentinel
Date: Mon, 15 Apr 2013 11:25:58 -0400
Message-Id: <1366039567-8620-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a 0-sized sentinel to avoid assigning the head ptr from
the driver side thread. This also eliminates testing head/tail
for NULL.

When the sentinel is first 'consumed' by the buffer work
(or by tty_buffer_flush()), it is detached from the list but not
freed nor added to the free list. Both buffer work and
tty_buffer_flush() continue to preserve at least 1 flip buffer
to which head & tail is pointed.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 49 ++++++++++++++++++------------------------------
 include/linux/tty.h      |  1 +
 2 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 069640e..231b7a8 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -49,13 +49,16 @@ void tty_buffer_free_all(struct tty_port *port)
 
 	while ((p = buf->head) != NULL) {
 		buf->head = p->next;
-		kfree(p);
+		if (p->size > 0)
+			kfree(p);
 	}
 	llist = llist_del_all(&buf->free);
 	llist_for_each_entry_safe(p, next, llist, free)
 		kfree(p);
 
-	buf->tail = NULL;
+	tty_buffer_reset(&buf->sentinel, 0);
+	buf->head = &buf->sentinel;
+	buf->tail = &buf->sentinel;
 	buf->memory_used = 0;
 }
 
@@ -120,7 +123,7 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 
 	if (b->size > MIN_TTYB_SIZE)
 		kfree(b);
-	else
+	else if (b->size > 0)
 		llist_add(&b->free, &buf->free);
 }
 
@@ -140,8 +143,6 @@ static void __tty_buffer_flush(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *next;
 
-	if (unlikely(buf->head == NULL))
-		return;
 	while ((next = buf->head->next) != NULL) {
 		tty_buffer_free(port, buf->head);
 		buf->head = next;
@@ -200,23 +201,14 @@ int tty_buffer_request_room(struct tty_port *port, size_t size)
 	int left;
 	unsigned long flags;
 	spin_lock_irqsave(&buf->lock, flags);
-	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
-	   remove this conditional if its worth it. This would be invisible
-	   to the callers */
 	b = buf->tail;
-	if (b != NULL)
-		left = b->size - b->used;
-	else
-		left = 0;
+	left = b->size - b->used;
 
 	if (left < size) {
 		/* This is the slow path - looking for new buffers to use */
 		if ((n = tty_buffer_alloc(port, size)) != NULL) {
-			if (b != NULL) {
-				b->next = n;
-				b->commit = b->used;
-			} else
-				buf->head = n;
+			b->next = n;
+			b->commit = b->used;
 			buf->tail = n;
 		} else
 			size = left;
@@ -247,10 +239,8 @@ int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(port, goal);
 		struct tty_buffer *tb = port->buf.tail;
-		/* If there is no space then tb may be NULL */
-		if (unlikely(space == 0)) {
+		if (unlikely(space == 0))
 			break;
-		}
 		memcpy(char_buf_ptr(tb, tb->used), chars, space);
 		memset(flag_buf_ptr(tb, tb->used), flag, space);
 		tb->used += space;
@@ -285,10 +275,8 @@ int tty_insert_flip_string_flags(struct tty_port *port,
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(port, goal);
 		struct tty_buffer *tb = port->buf.tail;
-		/* If there is no space then tb may be NULL */
-		if (unlikely(space == 0)) {
+		if (unlikely(space == 0))
 			break;
-		}
 		memcpy(char_buf_ptr(tb, tb->used), chars, space);
 		memcpy(flag_buf_ptr(tb, tb->used), flags, space);
 		tb->used += space;
@@ -322,8 +310,7 @@ void tty_schedule_flip(struct tty_port *port)
 	WARN_ON(port->low_latency);
 
 	spin_lock_irqsave(&buf->lock, flags);
-	if (buf->tail != NULL)
-		buf->tail->commit = buf->tail->used;
+	buf->tail->commit = buf->tail->used;
 	spin_unlock_irqrestore(&buf->lock, flags);
 	schedule_work(&buf->work);
 }
@@ -438,8 +425,8 @@ static void flush_to_ldisc(struct work_struct *work)
 	spin_lock_irqsave(&buf->lock, flags);
 
 	if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
-		struct tty_buffer *head;
-		while ((head = buf->head) != NULL) {
+		while (1) {
+			struct tty_buffer *head = buf->head;
 			int count;
 
 			count = head->commit - head->read;
@@ -509,8 +496,7 @@ void tty_flip_buffer_push(struct tty_port *port)
 	unsigned long flags;
 
 	spin_lock_irqsave(&buf->lock, flags);
-	if (buf->tail != NULL)
-		buf->tail->commit = buf->tail->used;
+	buf->tail->commit = buf->tail->used;
 	spin_unlock_irqrestore(&buf->lock, flags);
 
 	if (port->low_latency)
@@ -535,8 +521,9 @@ void tty_buffer_init(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;
 
 	spin_lock_init(&buf->lock);
-	buf->head = NULL;
-	buf->tail = NULL;
+	tty_buffer_reset(&buf->sentinel, 0);
+	buf->head = &buf->sentinel;
+	buf->tail = &buf->sentinel;
 	init_llist_head(&buf->free);
 	buf->memory_used = 0;
 	INIT_WORK(&buf->work, flush_to_ldisc);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index a01fda7..5fe2f68 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -67,6 +67,7 @@ static inline char *flag_buf_ptr(struct tty_buffer *b, int ofs)
 struct tty_bufhead {
 	struct work_struct work;
 	spinlock_t lock;
+	struct tty_buffer sentinel;
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */
 	struct llist_head free;		/* Free queue head */
-- 
1.8.1.2

