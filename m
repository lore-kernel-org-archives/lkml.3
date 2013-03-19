Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3CSO1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:27:39 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43347 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3CSO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:27:36 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 6/7] n_tty: Fix unsafe update of available buffer space
Date: Tue, 19 Mar 2013 10:26:57 -0400
Message-Id: <1363703218-32333-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363703218-32333-1-git-send-email-peter@hurleysoftware.com>
References: <20130319141017.GB24900@kroah.com>
 <1363703218-32333-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

receive_room is used to control the amount of data the flip
buffer work can push to the read buffer. This update is unsafe:

  CPU 0                        |  CPU 1
                               |
                               | n_tty_read()
                               |   n_tty_set_room()
                               |     left = <calc of space>
n_tty_receive_buf()            |
  <push data to buffer>        |
  n_tty_set_room()             |
    left = <calc of space>     |
    tty->receive_room = left   |
                               |     tty->receive_room = left

receive_room is now updated with a stale calculation of the
available buffer space, and the subsequent work loop will likely
overwrite unread data in the input buffer.

Update receive_room atomically with the calculation of the
available buffer space.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index b2f621f..61a55f4 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -115,13 +115,14 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 }
 
 /**
- *	n_tty_set__room	-	receive space
+ *	n_tty_set_room	-	receive space
  *	@tty: terminal
  *
- *	Called by the driver to find out how much data it is
- *	permitted to feed to the line discipline without any being lost
- *	and thus to manage flow control. Not serialized. Answers for the
- *	"instant".
+ *	Sets tty->receive_room to reflect the currently available space
+ *	in the input buffer, and re-schedules the flip buffer work if space
+ *	just became available.
+ *
+ *	Locks: Concurrent update is protected with read_lock
  */
 
 static void n_tty_set_room(struct tty_struct *tty)
@@ -129,8 +130,10 @@ static void n_tty_set_room(struct tty_struct *tty)
 	struct n_tty_data *ldata = tty->disc_data;
 	int left;
 	int old_left;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 
-	/* ldata->read_cnt is not read locked ? */
 	if (I_PARMRK(tty)) {
 		/* Multiply read_cnt by 3, since each byte might take up to
 		 * three times as many spaces when PARMRK is set (depending on
@@ -150,6 +153,8 @@ static void n_tty_set_room(struct tty_struct *tty)
 	old_left = tty->receive_room;
 	tty->receive_room = left;
 
+	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+
 	/* Did this open up the receive buffer? We may need to flip */
 	if (left && !old_left) {
 		WARN_RATELIMIT(tty->port->itty == NULL,
@@ -1885,7 +1890,6 @@ do_it_again:
 				retval = -ERESTARTSYS;
 				break;
 			}
-			/* FIXME: does n_tty_set_room need locking ? */
 			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
 			continue;
-- 
1.8.1.2

