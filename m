Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3FON57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:57:59 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40055 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3FON5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 15/16] tty: Fix unsafe vt paste_selection()
Date: Sat, 15 Jun 2013 09:36:15 -0400
Message-Id: <1371303376-5028-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the tty_buffer_flush() exclusion mechanism to a
public interface - tty_buffer_lock/unlock_exclusive() - and use
the interface to safely write the paste selection to the line
discipline.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c   | 61 ++++++++++++++++++++++++++++++++++++----------
 drivers/tty/vt/selection.c |  4 ++-
 include/linux/tty.h        |  4 +--
 include/linux/tty_flip.h   |  3 +++
 4 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index dbe4a71..f22e116 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -30,6 +30,42 @@
 
 
 /**
+ *	tty_buffer_lock_exclusive	-	gain exclusive access to buffer
+ *	tty_buffer_unlock_exclusive	-	release exclusive access
+ *
+ *	@port - tty_port owning the flip buffer
+ *
+ *	Guarantees safe use of the line discipline's receive_buf() method by
+ *	excluding the buffer work and any pending flush from using the flip
+ *	buffer. Data can continue to be added concurrently to the flip buffer
+ *	from the driver side.
+ *
+ *	On release, the buffer work is restarted if there is data in the
+ *	flip buffer
+ */
+
+void tty_buffer_lock_exclusive(struct tty_port *port)
+{
+	struct tty_bufhead *buf = &port->buf;
+
+	atomic_inc(&buf->priority);
+	mutex_lock(&buf->lock);
+}
+
+void tty_buffer_unlock_exclusive(struct tty_port *port)
+{
+	struct tty_bufhead *buf = &port->buf;
+	int restart;
+
+	restart = buf->head->commit != buf->head->read;
+
+	atomic_dec(&buf->priority);
+	mutex_unlock(&buf->lock);
+	if (restart)
+		queue_work(system_unbound_wq, &buf->work);
+}
+
+/**
  *	tty_buffer_space_avail	-	return unused buffer space
  *	@port - tty_port owning the flip buffer
  *
@@ -158,7 +194,7 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
  *	being processed by flush_to_ldisc then we defer the processing
  *	to that function
  *
- *	Locking: takes flush_mutex to ensure single-threaded flip buffer
+ *	Locking: takes buffer lock to ensure single-threaded flip buffer
  *		 'consumer'
  */
 
@@ -168,16 +204,16 @@ void tty_buffer_flush(struct tty_struct *tty)
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *next;
 
-	buf->flushpending = 1;
+	atomic_inc(&buf->priority);
 
-	mutex_lock(&buf->flush_mutex);
+	mutex_lock(&buf->lock);
 	while ((next = buf->head->next) != NULL) {
 		tty_buffer_free(port, buf->head);
 		buf->head = next;
 	}
 	buf->head->read = buf->head->commit;
-	buf->flushpending = 0;
-	mutex_unlock(&buf->flush_mutex);
+	atomic_dec(&buf->priority);
+	mutex_unlock(&buf->lock);
 }
 
 /**
@@ -383,7 +419,7 @@ receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
  *
  *	The receive_buf method is single threaded for each tty instance.
  *
- *	Locking: takes flush_mutex to ensure single-threaded flip buffer
+ *	Locking: takes buffer lock to ensure single-threaded flip buffer
  *		 'consumer'
  */
 
@@ -402,14 +438,14 @@ static void flush_to_ldisc(struct work_struct *work)
 	if (disc == NULL)
 		return;
 
-	mutex_lock(&buf->flush_mutex);
+	mutex_lock(&buf->lock);
 
 	while (1) {
 		struct tty_buffer *head = buf->head;
 		int count;
 
-		/* Ldisc or user is trying to flush the buffers. */
-		if (buf->flushpending)
+		/* Ldisc or user is trying to gain exclusive access */
+		if (atomic_read(&buf->priority))
 			break;
 
 		count = head->commit - head->read;
@@ -426,7 +462,7 @@ static void flush_to_ldisc(struct work_struct *work)
 			break;
 	}
 
-	mutex_unlock(&buf->flush_mutex);
+	mutex_unlock(&buf->lock);
 
 	tty_ldisc_deref(disc);
 }
@@ -482,13 +518,12 @@ void tty_buffer_init(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
 
-	mutex_init(&buf->flush_mutex);
+	mutex_init(&buf->lock);
 	tty_buffer_reset(&buf->sentinel, 0);
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
 	init_llist_head(&buf->free);
 	atomic_set(&buf->memory_used, 0);
-	buf->flushpending = 0;
+	atomic_set(&buf->priority, 0);
 	INIT_WORK(&buf->work, flush_to_ldisc);
 }
-
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 2ca8d6b..ea27804 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -24,6 +24,7 @@
 #include <linux/selection.h>
 #include <linux/tiocl.h>
 #include <linux/console.h>
+#include <linux/tty_flip.h>
 
 /* Don't take this from <ctype.h>: 011-015 on the screen aren't spaces */
 #define isspace(c)	((c) == ' ')
@@ -346,8 +347,8 @@ int paste_selection(struct tty_struct *tty)
 	console_unlock();
 
 	ld = tty_ldisc_ref_wait(tty);
+	tty_buffer_lock_exclusive(&vc->port);
 
-	/* FIXME: this is completely unsafe */
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -363,6 +364,7 @@ int paste_selection(struct tty_struct *tty)
 	remove_wait_queue(&vc->paste_wait, &wait);
 	__set_current_state(TASK_RUNNING);
 
+	tty_buffer_unlock_exclusive(&vc->port);
 	tty_ldisc_deref(ld);
 	return 0;
 }
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 991575f..7a9a3b0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -67,8 +67,8 @@ static inline char *flag_buf_ptr(struct tty_buffer *b, int ofs)
 struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct work_struct work;
-	struct mutex flush_mutex;
-	unsigned int flushpending:1;
+	struct mutex	   lock;
+	atomic_t	   priority;
 	struct tty_buffer sentinel;
 	struct llist_head free;		/* Free queue head */
 	atomic_t	   memory_used; /* In-use buffers excluding free list */
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 6944ed2..21ddd7d 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -32,4 +32,7 @@ static inline int tty_insert_flip_string(struct tty_port *port,
 	return tty_insert_flip_string_fixed_flag(port, chars, TTY_NORMAL, size);
 }
 
+extern void tty_buffer_lock_exclusive(struct tty_port *port);
+extern void tty_buffer_unlock_exclusive(struct tty_port *port);
+
 #endif /* _LINUX_TTY_FLIP_H */
-- 
1.8.1.2

