Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3C0Lon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:44:43 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54256 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3C0Lol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:44:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 03/18] tty: Simplify tty buffer/ldisc interface with helper function
Date: Wed, 27 Mar 2013 07:43:53 -0400
Message-Id: <1364384648-6636-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ldisc interface functions must be called with interrupts enabled.
Separating the ldisc calls into a helper function simplies the
spin lock management.

Update the buffer's read index _after_ the data has been received
by the ldisc.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index f294631..f508a71 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -403,6 +403,21 @@ int tty_prepare_flip_string_flags(struct tty_port *port,
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
 
 
+static int receive_buf(struct tty_struct *tty, struct tty_buffer *head,
+		       int count)
+{
+	struct tty_ldisc *disc = tty->ldisc;
+
+	if (disc->ops->receive_room)
+		tty->receive_room = disc->ops->receive_room(tty);
+	if (count > tty->receive_room)
+		count = tty->receive_room;
+	if (count)
+		disc->ops->receive_buf(tty, head->char_buf_ptr + head->read,
+				       head->flag_buf_ptr + head->read, count);
+	head->read += count;
+	return count;
+}
 
 /**
  *	flush_to_ldisc
@@ -438,8 +453,6 @@ static void flush_to_ldisc(struct work_struct *work)
 		struct tty_buffer *head;
 		while ((head = buf->head) != NULL) {
 			int count;
-			char *char_buf;
-			unsigned char *flag_buf;
 
 			count = head->commit - head->read;
 			if (!count) {
@@ -450,18 +463,10 @@ static void flush_to_ldisc(struct work_struct *work)
 				continue;
 			}
 
-			if (disc->ops->receive_room)
-				tty->receive_room = disc->ops->receive_room(tty);
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
@@ -472,7 +477,8 @@ static void flush_to_ldisc(struct work_struct *work)
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

