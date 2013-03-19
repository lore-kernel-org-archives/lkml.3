Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab3CSUdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:33:09 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36826 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933980Ab3CSUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:33:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Min Zhang <mzhang@mvista.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 02/18] tty: Make ldisc input flow control concurrency-friendly
Date: Tue, 19 Mar 2013 16:21:37 -0400
Message-Id: <1363724513-15604-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although line discipline receiving is single-producer/single-consumer,
using tty->receive_room to manage flow control creates unnecessary
critical regions requiring additional lock use.

Instead, introduce the optional .receive_room() ldisc method which
returns the maximum # of bytes the .receive_buf() ldisc method can
accept. Serialization is guaranteed by the caller.

In turn, the line discipline should schedule the buffer work item
whenever space becomes available; ie., when there is room to receive
data and receive_room() previously returned 0 (the buffer work
item stops processing if receive_room() is 0).

Add n_tty_receive_room() as the receive_room() method for N_TTY
and remove tty->receive_room references in N_TTY.

Line disciplines not using input flow control can continue to set
tty->receive_room to a fixed value.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c       | 68 ++++++++++++++++++++++++++++++-----------------
 drivers/tty/tty_buffer.c  |  2 ++
 include/linux/tty_ldisc.h |  8 ++++++
 3 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 9b7f571..a185aff 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -74,11 +74,17 @@
 #define ECHO_OP_SET_CANON_COL 0x81
 #define ECHO_OP_ERASE_TAB 0x82
 
+/* Bit values for flags field
+ */
+#define NO_ROOM		0
+
 struct n_tty_data {
 	unsigned int column;
 	unsigned long overrun_time;
 	int num_overrun;
 
+	unsigned long flags;
+
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 	unsigned char echo_overrun:1;
 
@@ -114,25 +120,10 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 	return put_user(x, ptr);
 }
 
-/**
- *	n_tty_set_room	-	receive space
- *	@tty: terminal
- *
- *	Updates tty->receive_room to reflect the currently available space
- *	in the input buffer, and re-schedules the flip buffer work if space
- *	just became available.
- *
- *	Locks: Concurrent update is protected with read_lock
- */
-
-static int set_room(struct tty_struct *tty)
+static ssize_t receive_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int left;
-	int old_left;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 
 	if (I_PARMRK(tty)) {
 		/* Multiply read_cnt by 3, since each byte might take up to
@@ -150,18 +141,25 @@ static int set_room(struct tty_struct *tty)
 	 */
 	if (left <= 0)
 		left = ldata->icanon && !ldata->canon_data;
-	old_left = tty->receive_room;
-	tty->receive_room = left;
-
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 
-	return left && !old_left;
+	return left;
 }
 
+/**
+ *	n_tty_set_room	-	receive space
+ *	@tty: terminal
+ *
+ *	Re-schedules the flip buffer work if space just became available.
+ *
+ *	Locks: Concurrent update is protected with read_lock
+ */
+
 static void n_tty_set_room(struct tty_struct *tty)
 {
+	struct n_tty_data *ldata = tty->disc_data;
+
 	/* Did this open up the receive buffer? We may need to flip */
-	if (set_room(tty)) {
+	if (receive_room(tty) && test_and_clear_bit(NO_ROOM, &ldata->flags)) {
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
 		/* see if ldisc has been killed - if so, this means that
@@ -174,6 +172,27 @@ static void n_tty_set_room(struct tty_struct *tty)
 	}
 }
 
+/**
+ *	n_tty_receive_room	-	receive space
+ *	@tty: terminal
+ *
+ *	Called by flush_to_ldisc() to determine the currently
+ *	available space in the input buffer.
+ *
+ *	Locks: Concurrent update is protected with read_lock
+ */
+
+static ssize_t n_tty_receive_room(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+
+	ssize_t room = receive_room(tty);
+	if (!room)
+		__set_bit(NO_ROOM, &ldata->flags);
+
+	return room;
+}
+
 static void put_tty_queue_nolock(unsigned char c, struct n_tty_data *ldata)
 {
 	if (ldata->read_cnt < N_TTY_BUF_SIZE) {
@@ -1465,8 +1484,6 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	set_room(tty);
-
 	if ((!ldata->icanon && (ldata->read_cnt >= ldata->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
@@ -1481,7 +1498,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 */
 	while (1) {
 		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
-		if (tty->receive_room >= TTY_THRESHOLD_THROTTLE)
+		if (receive_room(tty) >= TTY_THRESHOLD_THROTTLE)
 			break;
 		if (!tty_throttle_safe(tty))
 			break;
@@ -2201,6 +2218,7 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup,
 	.fasync		 = n_tty_fasync,
+	.receive_room	 = n_tty_receive_room,
 };
 
 /**
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 8e8d730..6aa40f0 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -454,6 +454,8 @@ static void flush_to_ldisc(struct work_struct *work)
 			   line discipline as we want to empty the queue */
 			if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
 				break;
+			if (disc->ops->receive_room)
+				tty->receive_room = disc->ops->receive_room(tty);
 			if (!tty->receive_room)
 				break;
 			if (count > tty->receive_room)
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 23bdd9d..6a8cb18 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -109,6 +109,13 @@
  *
  *	Tells the discipline that the DCD pin has changed its status.
  *	Used exclusively by the N_PPS (Pulse-Per-Second) line discipline.
+ *
+ * ssize_t (*receive_room)(struct tty_struct *tty)
+ *
+ *	If defined, returns the current # of bytes the receive_buf()
+ *	method can accept. If not defined, this value is determined by
+ *	the tty->receive_room value (which may be static if the line
+ *	discipline does not perform flow control).
  */
 
 #include <linux/fs.h>
@@ -195,6 +202,7 @@ struct tty_ldisc_ops {
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int);
 	void	(*fasync)(struct tty_struct *tty, int on);
+	ssize_t	(*receive_room)(struct tty_struct *tty);
 
 	struct  module *owner;
 
-- 
1.8.1.2

