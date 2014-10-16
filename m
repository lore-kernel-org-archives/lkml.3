Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaJPTe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:34:58 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51580 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751472AbaJPTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 8/9] tty: Fix missed wakeup from packet mode status update
Date: Thu, 16 Oct 2014 15:33:29 -0400
Message-Id: <1413488010-16885-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty master read() can miss the wake up for a packet mode
status change. For example,

CPU 0                                   | CPU 1
n_tty_read()                            | n_tty_packet_mode_flush()
  ...                                   |   .
  if (packet & link->ctrl_status) {     |   .
    /* no new ctrl_status ATM */        |   .
                                        |   spin_lock
                                        |     ctrl_status |= TIOCPKT_FLUSHREAD
                                        |   spin_unlock
                                        |   wake_up(link->read_wait)
  }                                     |
  set_current_state(TASK_INTERRUPTIBLE) |
  ...                                   |

The pty master read() will now sleep (assuming there is no input) having
missed the read_wait wakeup.

Set the task state before the condition test.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 6a42204..602dbc2 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2168,6 +2168,11 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
+		/* This statement must be first before checking for input
+		   so that any interrupt will set the state back to
+		   TASK_RUNNING. */
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		/* First test for status change. */
 		if (packet && tty->link->ctrl_status) {
 			unsigned char cs;
@@ -2185,10 +2190,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			nr--;
 			break;
 		}
-		/* This statement must be first before checking for input
-		   so that any interrupt will set the state back to
-		   TASK_RUNNING. */
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (((minimum - (b - buf)) < ldata->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
-- 
2.1.1

