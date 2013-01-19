Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3ASOQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 09:16:33 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:57265 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab3ASOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 09:16:31 -0500
Message-ID: <50FAAAB4.9040408@ilyx.ru>
Date: Sat, 19 Jan 2013 18:16:20 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] tty: Correct tty buffer flush.
References: <50BDF661.30303@ilyx.ru> <20121204141223.2ecb0f76@pyramind.ukuu.org.uk> <50F66AE4.2030408@ilyx.ru> <20130119000708.GA32591@kroah.com>
In-Reply-To: <20130119000708.GA32591@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
when another thread can use it. It can be cause of "NULL pointer dereference".
  Main idea of the patch, this is never free last (struct tty_buffer) in the active buffer.
Only flush the data for ldisc(buf->head->read = buf->head->commit).
At that moment driver can collect(write) data in buffer without conflict.
It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.

Also revert:
  commit c56a00a165712fd73081f40044b1e64407bb1875
  tty: hold lock across tty buffer finding and buffer filling
In order to delete the unneeded locks any more.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>

---
 drivers/tty/tty_buffer.c |   92 +++++++++++-----------------------------------
 1 files changed, 22 insertions(+), 70 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index d6969f6..61ec4dd 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -119,11 +119,14 @@ static void __tty_buffer_flush(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *thead;
 
-	while ((thead = buf->head) != NULL) {
-		buf->head = thead->next;
-		tty_buffer_free(port, thead);
+	if (unlikely(buf->head == NULL))
+		return;
+	while ((thead = buf->head->next) != NULL) {
+		tty_buffer_free(port, buf->head);
+		buf->head = thead;
 	}
-	buf->tail = NULL;
+	WARN_ON(buf->head != buf->tail);
+	buf->head->read = buf->head->commit;
 }
 
 /**
@@ -194,19 +197,22 @@ static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
 	   have queued and recycle that ? */
 }
 /**
- *	__tty_buffer_request_room		-	grow tty buffer if needed
+ *	tty_buffer_request_room		-	grow tty buffer if needed
  *	@tty: tty structure
  *	@size: size desired
  *
  *	Make at least size bytes of linear space available for the tty
  *	buffer. If we fail return the size we managed to find.
- *      Locking: Caller must hold port->buf.lock
+ *
+ *	Locking: Takes port->buf.lock
  */
-static int __tty_buffer_request_room(struct tty_port *port, size_t size)
+int tty_buffer_request_room(struct tty_port *port, size_t size)
 {
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *b, *n;
 	int left;
+	unsigned long flags;
+	spin_lock_irqsave(&buf->lock, flags);
 	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
 	   remove this conditional if its worth it. This would be invisible
 	   to the callers */
@@ -228,31 +234,9 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size)
 		} else
 			size = left;
 	}
-
+	spin_unlock_irqrestore(&buf->lock, flags);
 	return size;
 }
-
-
-/**
- *	tty_buffer_request_room		-	grow tty buffer if needed
- *	@port: tty port structure
- *	@size: size desired
- *
- *	Make at least size bytes of linear space available for the tty
- *	buffer. If we fail return the size we managed to find.
- *
- *	Locking: Takes port->buf.lock
- */
-int tty_buffer_request_room(struct tty_port *port, size_t size)
-{
-	unsigned long flags;
-	int length;
-
-	spin_lock_irqsave(&port->buf.lock, flags);
-	length = __tty_buffer_request_room(port, size);
-	spin_unlock_irqrestore(&port->buf.lock, flags);
-	return length;
-}
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
 /**
@@ -271,26 +255,18 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 		const unsigned char *chars, char flag, size_t size)
 {
-	struct tty_bufhead *buf = &port->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space;
-		unsigned long flags;
-		struct tty_buffer *tb;
-
-		spin_lock_irqsave(&buf->lock, flags);
-		space = __tty_buffer_request_room(port, goal);
-		tb = buf->tail;
+		int space = tty_buffer_request_room(port, goal);
+		struct tty_buffer *tb = port->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&buf->lock, flags);
 			break;
 		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memset(tb->flag_buf_ptr + tb->used, flag, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&buf->lock, flags);
 		copied += space;
 		chars += space;
 		/* There is a small chance that we need to split the data over
@@ -317,26 +293,18 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
 int tty_insert_flip_string_flags(struct tty_port *port,
 		const unsigned char *chars, const char *flags, size_t size)
 {
-	struct tty_bufhead *buf = &port->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space;
-		unsigned long __flags;
-		struct tty_buffer *tb;
-
-		spin_lock_irqsave(&buf->lock, __flags);
-		space = __tty_buffer_request_room(port, goal);
-		tb = buf->tail;
+		int space = tty_buffer_request_room(port, goal);
+		struct tty_buffer *tb = port->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&buf->lock, __flags);
 			break;
 		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&buf->lock, __flags);
 		copied += space;
 		chars += space;
 		flags += space;
@@ -392,21 +360,13 @@ EXPORT_SYMBOL(tty_schedule_flip);
 int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
 		size_t size)
 {
-	struct tty_bufhead *buf = &port->buf;
-	int space;
-	unsigned long flags;
-	struct tty_buffer *tb;
-
-	spin_lock_irqsave(&buf->lock, flags);
-	space = __tty_buffer_request_room(port, size);
-
-	tb = buf->tail;
+	int space = tty_buffer_request_room(port, size);
 	if (likely(space)) {
+		struct tty_buffer *tb = port->buf.tail;
 		*chars = tb->char_buf_ptr + tb->used;
 		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
 		tb->used += space;
 	}
-	spin_unlock_irqrestore(&buf->lock, flags);
 	return space;
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
@@ -430,21 +390,13 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
 int tty_prepare_flip_string_flags(struct tty_port *port,
 			unsigned char **chars, char **flags, size_t size)
 {
-	struct tty_bufhead *buf = &port->buf;
-	int space;
-	unsigned long __flags;
-	struct tty_buffer *tb;
-
-	spin_lock_irqsave(&buf->lock, __flags);
-	space = __tty_buffer_request_room(port, size);
-
-	tb = buf->tail;
+	int space = tty_buffer_request_room(port, size);
 	if (likely(space)) {
+		struct tty_buffer *tb = port->buf.tail;
 		*chars = tb->char_buf_ptr + tb->used;
 		*flags = tb->flag_buf_ptr + tb->used;
 		tb->used += space;
 	}
-	spin_unlock_irqrestore(&buf->lock, __flags);
 	return space;
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
