Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3FONip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:38:45 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:39754 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3FONgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:36:35 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 01/16] tty: Compute flip buffer ptrs
Date: Sat, 15 Jun 2013 09:36:01 -0400
Message-Id: <1371303376-5028-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The char_buf_ptr and flag_buf_ptr values are trivially derived from
the .data field offset; compute values as needed.

Fixes a long-standing type-mismatch with the char and flag ptrs.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 22 ++++++++++------------
 include/linux/tty.h      | 12 ++++++++++--
 include/linux/tty_flip.h |  4 ++--
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index ff1b2e3..170674c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -71,8 +71,6 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 	p->next = NULL;
 	p->commit = 0;
 	p->read = 0;
-	p->char_buf_ptr = (char *)(p->data);
-	p->flag_buf_ptr = (unsigned char *)p->char_buf_ptr + size;
 	port->buf.memory_used += size;
 	return p;
 }
@@ -265,8 +263,8 @@ int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 		if (unlikely(space == 0)) {
 			break;
 		}
-		memcpy(tb->char_buf_ptr + tb->used, chars, space);
-		memset(tb->flag_buf_ptr + tb->used, flag, space);
+		memcpy(char_buf_ptr(tb, tb->used), chars, space);
+		memset(flag_buf_ptr(tb, tb->used), flag, space);
 		tb->used += space;
 		copied += space;
 		chars += space;
@@ -303,8 +301,8 @@ int tty_insert_flip_string_flags(struct tty_port *port,
 		if (unlikely(space == 0)) {
 			break;
 		}
-		memcpy(tb->char_buf_ptr + tb->used, chars, space);
-		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
+		memcpy(char_buf_ptr(tb, tb->used), chars, space);
+		memcpy(flag_buf_ptr(tb, tb->used), flags, space);
 		tb->used += space;
 		copied += space;
 		chars += space;
@@ -364,8 +362,8 @@ int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
 	int space = tty_buffer_request_room(port, size);
 	if (likely(space)) {
 		struct tty_buffer *tb = port->buf.tail;
-		*chars = tb->char_buf_ptr + tb->used;
-		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
+		*chars = char_buf_ptr(tb, tb->used);
+		memset(flag_buf_ptr(tb, tb->used), TTY_NORMAL, space);
 		tb->used += space;
 	}
 	return space;
@@ -394,8 +392,8 @@ int tty_prepare_flip_string_flags(struct tty_port *port,
 	int space = tty_buffer_request_room(port, size);
 	if (likely(space)) {
 		struct tty_buffer *tb = port->buf.tail;
-		*chars = tb->char_buf_ptr + tb->used;
-		*flags = tb->flag_buf_ptr + tb->used;
+		*chars = char_buf_ptr(tb, tb->used);
+		*flags = flag_buf_ptr(tb, tb->used);
 		tb->used += space;
 	}
 	return space;
@@ -407,8 +405,8 @@ static int
 receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
 {
 	struct tty_ldisc *disc = tty->ldisc;
-	char 	      *p = head->char_buf_ptr + head->read;
-	unsigned char *f = head->flag_buf_ptr + head->read;
+	unsigned char *p = char_buf_ptr(head, head->read);
+	char	      *f = flag_buf_ptr(head, head->read);
 
 	if (disc->ops->receive_buf2)
 		count = disc->ops->receive_buf2(tty, p, f, count);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 57a70d1..87bbaa3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -31,8 +31,6 @@
 
 struct tty_buffer {
 	struct tty_buffer *next;
-	char *char_buf_ptr;
-	unsigned char *flag_buf_ptr;
 	int used;
 	int size;
 	int commit;
@@ -41,6 +39,16 @@ struct tty_buffer {
 	unsigned long data[0];
 };
 
+static inline unsigned char *char_buf_ptr(struct tty_buffer *b, int ofs)
+{
+	return ((unsigned char *)b->data) + ofs;
+}
+
+static inline char *flag_buf_ptr(struct tty_buffer *b, int ofs)
+{
+	return (char *)char_buf_ptr(b, ofs) + b->size;
+}
+
 /*
  * We default to dicing tty buffer allocations to this many characters
  * in order to avoid multiple page allocations. We know the size of
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index e0f2526..ad03039 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -18,8 +18,8 @@ static inline int tty_insert_flip_char(struct tty_port *port,
 {
 	struct tty_buffer *tb = port->buf.tail;
 	if (tb && tb->used < tb->size) {
-		tb->flag_buf_ptr[tb->used] = flag;
-		tb->char_buf_ptr[tb->used++] = ch;
+		*flag_buf_ptr(tb, tb->used) = flag;
+		*char_buf_ptr(tb, tb->used++) = ch;
 		return 1;
 	}
 	return tty_insert_flip_string_flags(port, &ch, &flag, 1);
-- 
1.8.1.2

