Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3FONPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:15:05 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42759 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3FONPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:15:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 02/24] tty: Simplify tty buffer/ldisc interface with helper function
Date: Sat, 15 Jun 2013 09:14:14 -0400
Message-Id: <1371302076-4688-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ldisc interface functions must be called with interrupts enabled.
Separating the ldisc calls into a helper function simplies the
eventual removal of the spinlock.

Note that access to the buf->head ptr outside the spinlock is
safe here because;
* __tty_buffer_flush() is prevented from running while buffer work
  performs i/o,
* tty_buffer_find() only assigns buf->head if the flip buffer list
  is empty (which is never the case in flush_to_ldisc() since at
  least one buffer is always left in the list after use)
Access to the read index outside the spinlock is safe here for the
same reasons.

Update the buffer's read index _after_ the data has been received
by the ldisc.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index a42a028..6c7a1d0 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -403,6 +403,18 @@ int tty_prepare_flip_string_flags(struct tty_port *port,
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
 
 
+static int
+receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
+{
+	struct tty_ldisc *disc = tty->ldisc;
+
+	count = min_t(int, count, tty->receive_room);
+	if (count)
+		disc->ops->receive_buf(tty, head->char_buf_ptr + head->read,
+				       head->flag_buf_ptr + head->read, count);
+	head->read += count;
+	return count;
+}
 
 /**
  *	flush_to_ldisc
@@ -438,8 +450,6 @@ static void flush_to_ldisc(struct work_struct *work)
 		struct tty_buffer *head;
 		while ((head = buf->head) != NULL) {
 			int count;
-			char *char_buf;
-			unsigned char *flag_buf;
 
 			count = head->commit - head->read;
 			if (!count) {
@@ -449,16 +459,10 @@ static void flush_to_ldisc(struct work_struct *work)
 				tty_buffer_free(port, head);
 				continue;
 			}
-			if (!tty->receive_room)
-				break;
-			if (count > tty->receive_room)
-				count = tty->receive_room;
-			char_buf = head->char_buf_ptr + head->read;
-			flag_buf = head->flag_buf_ptr + head->read;
-			head->read += count;
 			spin_unlock_irqrestore(&buf->lock, flags);
-			disc->ops->receive_buf(tty, char_buf,
-							flag_buf, count);
+
+			count = receive_buf(tty, head, count);
+
 			spin_lock_irqsave(&buf->lock, flags);
 			/* Ldisc or user is trying to flush the buffers.
 			   We may have a deferred request to flush the
@@ -469,7 +473,8 @@ static void flush_to_ldisc(struct work_struct *work)
 				clear_bit(TTYP_FLUSHPENDING, &port->iflags);
 				wake_up(&tty->read_wait);
 				break;
-			}
+			} else if (!count)
+				break;
 		}
 		clear_bit(TTYP_FLUSHING, &port->iflags);
 	}
-- 
1.8.1.2

