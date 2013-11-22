Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3KVRKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:10:32 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:34812 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3KVRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:10:24 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 3/5] tty: Rename tty buffer memory_used field
Date: Fri, 22 Nov 2013 12:09:56 -0500
Message-Id: <1385140198-5822-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
References: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trim up the memory_used field name to mem_used.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 12 ++++++------
 include/linux/tty.h      |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 57eb34b..e8f22f8 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -89,7 +89,7 @@ void tty_buffer_unlock_exclusive(struct tty_port *port)
 
 int tty_buffer_space_avail(struct tty_port *port)
 {
-	int space = port->buf.mem_limit - atomic_read(&port->buf.memory_used);
+	int space = port->buf.mem_limit - atomic_read(&port->buf.mem_used);
 	return max(space, 0);
 }
 
@@ -129,7 +129,7 @@ void tty_buffer_free_all(struct tty_port *port)
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
 
-	atomic_set(&buf->memory_used, 0);
+	atomic_set(&buf->mem_used, 0);
 }
 
 /**
@@ -162,7 +162,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 
 	/* Should possibly check if this fails for the largest buffer we
 	   have queued and recycle that ? */
-	if (atomic_read(&port->buf.memory_used) > port->buf.mem_limit)
+	if (atomic_read(&port->buf.mem_used) > port->buf.mem_limit)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
@@ -170,7 +170,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 
 found:
 	tty_buffer_reset(p, size);
-	atomic_add(size, &port->buf.memory_used);
+	atomic_add(size, &port->buf.mem_used);
 	return p;
 }
 
@@ -188,7 +188,7 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 	struct tty_bufhead *buf = &port->buf;
 
 	/* Dumb strategy for now - should keep some stats */
-	WARN_ON(atomic_sub_return(b->size, &buf->memory_used) < 0);
+	WARN_ON(atomic_sub_return(b->size, &buf->mem_used) < 0);
 
 	if (b->size > MIN_TTYB_SIZE)
 		kfree(b);
@@ -533,7 +533,7 @@ void tty_buffer_init(struct tty_port *port)
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
 	init_llist_head(&buf->free);
-	atomic_set(&buf->memory_used, 0);
+	atomic_set(&buf->mem_used, 0);
 	atomic_set(&buf->priority, 0);
 	INIT_WORK(&buf->work, flush_to_ldisc);
 	buf->mem_limit = TTYB_DEFAULT_MEM_LIMIT;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 58a34e7..ed9aedd 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -60,7 +60,7 @@ struct tty_bufhead {
 	atomic_t	   priority;
 	struct tty_buffer sentinel;
 	struct llist_head free;		/* Free queue head */
-	atomic_t	   memory_used; /* In-use buffers excluding free list */
+	atomic_t	   mem_used;    /* In-use buffers excluding free list */
 	int		   mem_limit;
 	struct tty_buffer *tail;	/* Active buffer */
 };
-- 
1.8.1.2

