Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3FON66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:58:58 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40061 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3FON5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 13/16] tty: Use non-atomic state to signal flip buffer flush pending
Date: Sat, 15 Jun 2013 09:36:13 -0400
Message-Id: <1371303376-5028-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomic bit ops are no longer required to indicate a flip buffer
flush is pending, as the flush_mutex is sufficient barrier.

Remove the unnecessary port .iflags field and localize flip buffer
state to struct tty_bufhead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 7 ++++---
 include/linux/tty.h      | 3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 39cae61..fb042b9 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -189,11 +189,11 @@ void tty_buffer_flush(struct tty_struct *tty)
 	struct tty_port *port = tty->port;
 	struct tty_bufhead *buf = &port->buf;
 
-	set_bit(TTYP_FLUSHPENDING, &port->iflags);
+	buf->flushpending = 1;
 
 	mutex_lock(&buf->flush_mutex);
 	__tty_buffer_flush(port);
-	clear_bit(TTYP_FLUSHPENDING, &port->iflags);
+	buf->flushpending = 0;
 	mutex_unlock(&buf->flush_mutex);
 }
 
@@ -426,7 +426,7 @@ static void flush_to_ldisc(struct work_struct *work)
 		int count;
 
 		/* Ldisc or user is trying to flush the buffers. */
-		if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
+		if (buf->flushpending)
 			break;
 
 		count = head->commit - head->read;
@@ -505,6 +505,7 @@ void tty_buffer_init(struct tty_port *port)
 	buf->tail = &buf->sentinel;
 	init_llist_head(&buf->free);
 	atomic_set(&buf->memory_used, 0);
+	buf->flushpending = 0;
 	INIT_WORK(&buf->work, flush_to_ldisc);
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index b8e8adf..991575f 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -68,6 +68,7 @@ struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct work_struct work;
 	struct mutex flush_mutex;
+	unsigned int flushpending:1;
 	struct tty_buffer sentinel;
 	struct llist_head free;		/* Free queue head */
 	atomic_t	   memory_used; /* In-use buffers excluding free list */
@@ -212,8 +213,6 @@ struct tty_port {
 	wait_queue_head_t	close_wait;	/* Close waiters */
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
-	unsigned long		iflags;		/* TTYP_ internal flags */
-#define TTYP_FLUSHPENDING		2  /* Queued buffer flush pending */
 	unsigned char		console:1,	/* port is a console */
 				low_latency:1;	/* direct buffer flush */
 	struct mutex		mutex;		/* Locking */
-- 
1.8.1.2

