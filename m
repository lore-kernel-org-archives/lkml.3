Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab3LIOYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:24:12 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:41745 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab3LIOYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:24:09 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next v3 5/5] tty: Halve flip buffer GFP_ATOMIC memory consumption
Date: Mon,  9 Dec 2013 09:23:52 -0500
Message-Id: <1386599032-4817-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20131209010112.GA31052@kroah.com>
References: <20131209010112.GA31052@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty flip buffers use GFP_ATOMIC allocations for received data
which is to be processed by the line discipline. For each byte
received, an extra byte is used to indicate the error status of
that byte.

Instead, if the received data is error-free, encode the entire
buffer without status bytes.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---

v3 - Make __tty_buffer_request_room static; don't export symbol. duh.

 drivers/tty/tty_buffer.c | 45 +++++++++++++++++++++++++++++++++++----------
 include/linux/tty.h      |  4 ++++
 include/linux/tty_flip.h |  8 ++++++--
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6a3620e..7ba69b6 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -100,6 +100,7 @@ static void tty_buffer_reset(struct tty_buffer *p, size_t size)
 	p->next = NULL;
 	p->commit = 0;
 	p->read = 0;
+	p->flags = 0;
 }
 
 /**
@@ -230,31 +231,49 @@ void tty_buffer_flush(struct tty_struct *tty)
  *	tty_buffer_request_room		-	grow tty buffer if needed
  *	@tty: tty structure
  *	@size: size desired
+ *	@flags: buffer flags if new buffer allocated (default = 0)
  *
  *	Make at least size bytes of linear space available for the tty
  *	buffer. If we fail return the size we managed to find.
+ *
+ *	Will change over to a new buffer if the current buffer is encoded as
+ *	TTY_NORMAL (so has no flags buffer) and the new buffer requires
+ *	a flags buffer.
  */
-int tty_buffer_request_room(struct tty_port *port, size_t size)
+static int __tty_buffer_request_room(struct tty_port *port, size_t size,
+				     int flags)
 {
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *b, *n;
-	int left;
+	int left, change;
 
 	b = buf->tail;
-	left = b->size - b->used;
+	if (b->flags & TTYB_NORMAL)
+		left = 2 * b->size - b->used;
+	else
+		left = b->size - b->used;
 
-	if (left < size) {
+	change = (b->flags & TTYB_NORMAL) && (~flags & TTYB_NORMAL);
+	if (change || left < size) {
 		/* This is the slow path - looking for new buffers to use */
 		if ((n = tty_buffer_alloc(port, size)) != NULL) {
+			n->flags = flags;
 			buf->tail = n;
 			b->commit = b->used;
 			smp_mb();
 			b->next = n;
-		} else
+		} else if (change)
+			size = 0;
+		else
 			size = left;
 	}
 	return size;
 }
+
+int tty_buffer_request_room(struct tty_port *port, size_t size)
+{
+	return __tty_buffer_request_room(port, size, 0);
+}
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
 /**
@@ -274,12 +293,14 @@ int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space = tty_buffer_request_room(port, goal);
+		int flags = (flag == TTY_NORMAL) ? TTYB_NORMAL : 0;
+		int space = __tty_buffer_request_room(port, goal, flags);
 		struct tty_buffer *tb = port->buf.tail;
 		if (unlikely(space == 0))
 			break;
 		memcpy(char_buf_ptr(tb, tb->used), chars, space);
-		memset(flag_buf_ptr(tb, tb->used), flag, space);
+		if (~tb->flags & TTYB_NORMAL)
+			memset(flag_buf_ptr(tb, tb->used), flag, space);
 		tb->used += space;
 		copied += space;
 		chars += space;
@@ -362,11 +383,12 @@ EXPORT_SYMBOL(tty_schedule_flip);
 int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
 		size_t size)
 {
-	int space = tty_buffer_request_room(port, size);
+	int space = __tty_buffer_request_room(port, size, TTYB_NORMAL);
 	if (likely(space)) {
 		struct tty_buffer *tb = port->buf.tail;
 		*chars = char_buf_ptr(tb, tb->used);
-		memset(flag_buf_ptr(tb, tb->used), TTY_NORMAL, space);
+		if (~tb->flags & TTYB_NORMAL)
+			memset(flag_buf_ptr(tb, tb->used), TTY_NORMAL, space);
 		tb->used += space;
 	}
 	return space;
@@ -379,7 +401,10 @@ receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
 {
 	struct tty_ldisc *disc = tty->ldisc;
 	unsigned char *p = char_buf_ptr(head, head->read);
-	char	      *f = flag_buf_ptr(head, head->read);
+	char	      *f = NULL;
+
+	if (~head->flags & TTYB_NORMAL)
+		f = flag_buf_ptr(head, head->read);
 
 	if (disc->ops->receive_buf2)
 		count = disc->ops->receive_buf2(tty, p, f, count);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index ed9aedd..9d234dc 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -39,10 +39,14 @@ struct tty_buffer {
 	int size;
 	int commit;
 	int read;
+	int flags;
 	/* Data points here */
 	unsigned long data[0];
 };
 
+/* Values for .flags field of tty_buffer */
+#define TTYB_NORMAL	1	/* buffer has no flags buffer */
+
 static inline unsigned char *char_buf_ptr(struct tty_buffer *b, int ofs)
 {
 	return ((unsigned char *)b->data) + ofs;
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 3f821e9..c28dd52 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -17,8 +17,12 @@ static inline int tty_insert_flip_char(struct tty_port *port,
 					unsigned char ch, char flag)
 {
 	struct tty_buffer *tb = port->buf.tail;
-	if (tb && tb->used < tb->size) {
-		*flag_buf_ptr(tb, tb->used) = flag;
+	int change;
+
+	change = (tb->flags & TTYB_NORMAL) && (flag != TTY_NORMAL);
+	if (!change && tb->used < tb->size) {
+		if (~tb->flags & TTYB_NORMAL)
+			*flag_buf_ptr(tb, tb->used) = flag;
 		*char_buf_ptr(tb, tb->used++) = ch;
 		return 1;
 	}
-- 
1.8.1.2

