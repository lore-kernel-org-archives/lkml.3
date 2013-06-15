Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3FONgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:36:50 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:39774 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3FONgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:36:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 06/16] tty: Use lockless flip buffer free list
Date: Sat, 15 Jun 2013 09:36:06 -0400
Message-Id: <1371303376-5028-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for lockless flip buffers, make the flip buffer
free list lockless.

NB: using llist is not the optimal solution, as the driver and
buffer work may contend over the llist head unnecessarily. However,
test measurements indicate this contention is low.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 29 ++++++++++++-----------------
 include/linux/llist.h    | 23 +++++++++++++++++++++++
 include/linux/tty.h      |  8 ++++++--
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 0259a76..069640e 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -44,16 +44,17 @@ static void tty_buffer_reset(struct tty_buffer *p, size_t size)
 void tty_buffer_free_all(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
-	struct tty_buffer *p;
+	struct tty_buffer *p, *next;
+	struct llist_node *llist;
 
 	while ((p = buf->head) != NULL) {
 		buf->head = p->next;
 		kfree(p);
 	}
-	while ((p = buf->free) != NULL) {
-		buf->free = p->next;
+	llist = llist_del_all(&buf->free);
+	llist_for_each_entry_safe(p, next, llist, free)
 		kfree(p);
-	}
+
 	buf->tail = NULL;
 	buf->memory_used = 0;
 }
@@ -68,22 +69,20 @@ void tty_buffer_free_all(struct tty_port *port)
  *	allocation behaviour.
  *	Return NULL if out of memory or the allocation would exceed the
  *	per device queue
- *
- *	Locking: Caller must hold tty->buf.lock
  */
 
 static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 {
-	struct tty_buffer **tbh = &port->buf.free;
+	struct llist_node *free;
 	struct tty_buffer *p;
 
 	/* Round the buffer size out */
 	size = __ALIGN_MASK(size, TTYB_ALIGN_MASK);
 
 	if (size <= MIN_TTYB_SIZE) {
-		if (*tbh) {
-			p = *tbh;
-			*tbh = p->next;
+		free = llist_del_first(&port->buf.free);
+		if (free) {
+			p = llist_entry(free, struct tty_buffer, free);
 			goto found;
 		}
 	}
@@ -109,8 +108,6 @@ found:
  *
  *	Free a tty buffer, or add it to the free list according to our
  *	internal strategy
- *
- *	Locking: Caller must hold tty->buf.lock
  */
 
 static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
@@ -123,10 +120,8 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 
 	if (b->size > MIN_TTYB_SIZE)
 		kfree(b);
-	else {
-		b->next = buf->free;
-		buf->free = b;
-	}
+	else
+		llist_add(&b->free, &buf->free);
 }
 
 /**
@@ -542,7 +537,7 @@ void tty_buffer_init(struct tty_port *port)
 	spin_lock_init(&buf->lock);
 	buf->head = NULL;
 	buf->tail = NULL;
-	buf->free = NULL;
+	init_llist_head(&buf->free);
 	buf->memory_used = 0;
 	INIT_WORK(&buf->work, flush_to_ldisc);
 }
diff --git a/include/linux/llist.h b/include/linux/llist.h
index a5199f6..97cf31d 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -125,6 +125,29 @@ static inline void init_llist_head(struct llist_head *list)
 	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
+ * llist_for_each_entry_safe - iterate over some deleted entries of lock-less list of given type
+ *			       safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @node:	the first entry of deleted list entries.
+ * @member:	the name of the llist_node with the struct.
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being removed from list, so start with an entry
+ * instead of list head.
+ *
+ * If being used on entries deleted from lock-less list directly, the
+ * traverse order is from the newest to the oldest added entry.  If
+ * you want to traverse from the oldest to the newest, you must
+ * reverse the order by yourself before traversing.
+ */
+#define llist_for_each_entry_safe(pos, n, node, member)			       \
+	for (pos = llist_entry((node), typeof(*pos), member);		       \
+	     &pos->member != NULL &&					       \
+	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
+	     pos = n)
+
+/**
  * llist_empty - tests whether a lock-less list is empty
  * @head:	the list to test
  *
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 87bbaa3..5043b12 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -11,6 +11,7 @@
 #include <linux/tty_flags.h>
 #include <uapi/linux/tty.h>
 #include <linux/rwsem.h>
+#include <linux/llist.h>
 
 
 
@@ -30,7 +31,10 @@
 #define __DISABLED_CHAR '\0'
 
 struct tty_buffer {
-	struct tty_buffer *next;
+	union {
+		struct tty_buffer *next;
+		struct llist_node free;
+	};
 	int used;
 	int size;
 	int commit;
@@ -65,7 +69,7 @@ struct tty_bufhead {
 	spinlock_t lock;
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */
-	struct tty_buffer *free;	/* Free queue head */
+	struct llist_head free;		/* Free queue head */
 	int memory_used;		/* Buffer space used excluding
 								free queue */
 };
-- 
1.8.1.2

