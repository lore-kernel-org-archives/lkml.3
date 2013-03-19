Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025Ab3CSUdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:33:07 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36824 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979Ab3CSUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:33:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Min Zhang <mzhang@mvista.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 03/18] tty: Simplify tty buffer/ldisc interface with helper function
Date: Tue, 19 Mar 2013 16:21:38 -0400
Message-Id: <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
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
 drivers/tty/tty_buffer.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6aa40f0..77e8115 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -403,6 +403,19 @@ int tty_prepare_flip_string_flags(struct tty_port *port,
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
 
 
+static int receive_buf(struct tty_struct *tty, const unsigned char *char_buf,
+		       char *flag_buf, int count)
+{
+	struct tty_ldisc *disc = tty->ldisc;
+
+	if (disc->ops->receive_room)
+		tty->receive_room = disc->ops->receive_room(tty);
+	if (count > tty->receive_room)
+		count = tty->receive_room;
+	if (count)
+		disc->ops->receive_buf(tty, char_buf, flag_buf, count);
+	return count;
+}
 
 /**
  *	flush_to_ldisc
@@ -454,19 +467,16 @@ static void flush_to_ldisc(struct work_struct *work)
 			   line discipline as we want to empty the queue */
 			if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
 				break;
-			if (disc->ops->receive_room)
-				tty->receive_room = disc->ops->receive_room(tty);
-			if (!tty->receive_room)
-				break;
-			if (count > tty->receive_room)
-				count = tty->receive_room;
 			char_buf = head->char_buf_ptr + head->read;
 			flag_buf = head->flag_buf_ptr + head->read;
-			head->read += count;
 			spin_unlock_irqrestore(&buf->lock, flags);
-			disc->ops->receive_buf(tty, char_buf,
-							flag_buf, count);
+
+			count = receive_buf(tty, char_buf, flag_buf, count);
+
 			spin_lock_irqsave(&buf->lock, flags);
+			if (!count)
+				break;
+			head->read += count;
 		}
 		clear_bit(TTYP_FLUSHING, &port->iflags);
 	}
-- 
1.8.1.2

