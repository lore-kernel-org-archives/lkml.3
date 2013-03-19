Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3CSO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:27:52 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43389 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3CSO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:27:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 7/7] n_tty: Buffer work should not reschedule itself
Date: Tue, 19 Mar 2013 10:26:58 -0400
Message-Id: <1363703218-32333-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363703218-32333-1-git-send-email-peter@hurleysoftware.com>
References: <20130319141017.GB24900@kroah.com>
 <1363703218-32333-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the driver-side input path must update the available
buffer space, it should not reschedule itself. If space is still
available and the flip buffers are not empty, flush_to_ldisc()
will loop again.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 61a55f4..6f9694d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -118,14 +118,14 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
  *	n_tty_set_room	-	receive space
  *	@tty: terminal
  *
- *	Sets tty->receive_room to reflect the currently available space
+ *	Updates tty->receive_room to reflect the currently available space
  *	in the input buffer, and re-schedules the flip buffer work if space
  *	just became available.
  *
  *	Locks: Concurrent update is protected with read_lock
  */
 
-static void n_tty_set_room(struct tty_struct *tty)
+static int set_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int left;
@@ -155,8 +155,13 @@ static void n_tty_set_room(struct tty_struct *tty)
 
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 
+	return left && !old_left;
+}
+
+static void n_tty_set_room(struct tty_struct *tty)
+{
 	/* Did this open up the receive buffer? We may need to flip */
-	if (left && !old_left) {
+	if (set_room(tty)) {
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
 		/* see if ldisc has been killed - if so, this means that
@@ -1475,7 +1480,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	n_tty_set_room(tty);
+	set_room(tty);
 
 	if ((!ldata->icanon && (ldata->read_cnt >= ldata->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
-- 
1.8.1.2

