Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3KVRLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:11:14 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:34809 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3KVRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:10:22 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 2/5] tty: Enable configurable tty flip buffer limit
Date: Fri, 22 Nov 2013 12:09:55 -0500
Message-Id: <1385140198-5822-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
References: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow driver to configure its maximum flip buffer memory
consumption/limit. This is necessary for very-high speed line
rates (in excess of 10MB/sec) because the flip buffers can
be saturated before the line discipline has a chance to
throttle the input.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 24 +++++++++++++++++++++---
 include/linux/tty.h      |  1 +
 include/linux/tty_flip.h |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index c043136f..57eb34b 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -26,7 +26,7 @@
  * Byte threshold to limit memory consumption for flip buffers.
  * The actual memory limit is > 2x this amount.
  */
-#define TTYB_MEM_LIMIT	65536
+#define TTYB_DEFAULT_MEM_LIMIT	65536
 
 /*
  * We default to dicing tty buffer allocations to this many characters
@@ -89,7 +89,7 @@ void tty_buffer_unlock_exclusive(struct tty_port *port)
 
 int tty_buffer_space_avail(struct tty_port *port)
 {
-	int space = TTYB_MEM_LIMIT - atomic_read(&port->buf.memory_used);
+	int space = port->buf.mem_limit - atomic_read(&port->buf.memory_used);
 	return max(space, 0);
 }
 
@@ -162,7 +162,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 
 	/* Should possibly check if this fails for the largest buffer we
 	   have queued and recycle that ? */
-	if (atomic_read(&port->buf.memory_used) > TTYB_MEM_LIMIT)
+	if (atomic_read(&port->buf.memory_used) > port->buf.mem_limit)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
@@ -536,4 +536,22 @@ void tty_buffer_init(struct tty_port *port)
 	atomic_set(&buf->memory_used, 0);
 	atomic_set(&buf->priority, 0);
 	INIT_WORK(&buf->work, flush_to_ldisc);
+	buf->mem_limit = TTYB_DEFAULT_MEM_LIMIT;
 }
+
+/**
+ *	tty_buffer_set_limit	-	change the tty buffer memory limit
+ *	@port: tty port to change
+ *
+ *	Change the tty buffer memory limit.
+ *	Must be called before the other tty buffer functions are used.
+ */
+
+int tty_buffer_set_limit(struct tty_port *port, int limit)
+{
+	if (limit < MIN_TTYB_SIZE)
+		return -EINVAL;
+	port->buf.mem_limit = limit;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tty_buffer_set_limit);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 2f47989..58a34e7 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -61,6 +61,7 @@ struct tty_bufhead {
 	struct tty_buffer sentinel;
 	struct llist_head free;		/* Free queue head */
 	atomic_t	   memory_used; /* In-use buffers excluding free list */
+	int		   mem_limit;
 	struct tty_buffer *tail;	/* Active buffer */
 };
 /*
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 21ddd7d..2da8bc2 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_TTY_FLIP_H
 #define _LINUX_TTY_FLIP_H
 
+extern int tty_buffer_set_limit(struct tty_port *port, int limit);
 extern int tty_buffer_space_avail(struct tty_port *port);
 extern int tty_buffer_request_room(struct tty_port *port, size_t size);
 extern int tty_insert_flip_string_flags(struct tty_port *port,
-- 
1.8.1.2

