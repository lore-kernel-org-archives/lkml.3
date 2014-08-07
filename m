Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaHGLOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:14:30 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33130 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932089AbaHGLO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:14:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Fix spurious poll() wakeups
Date: Thu,  7 Aug 2014 07:14:10 -0400
Message-Id: <1407410050-32198-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.4
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the N_TTY line discipline receives data and wakes readers to
process the input, polling writers are also mistakenly woken. This
is because, although readers and writers are differentiated by
different wait queues (tty->read_wait & tty->write_wait), both
wait queues are polled together. Thus, reader wakeups without poll
flags still cause poll(POLLOUT) to wakeup.

For received data, wakeup readers with POLLIN. Preserve the
unspecific wakeup in n_tty_packet_mode_flush(), as this action
should flag both POLLIN and POLLOUT.

Fixes epoll_wait() for edge-triggered EPOLLOUT.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f44f1ba..89c4cee 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1166,7 +1166,7 @@ static void n_tty_receive_break(struct tty_struct *tty)
 	}
 	put_tty_queue('\0', ldata);
 	if (waitqueue_active(&tty->read_wait))
-		wake_up_interruptible(&tty->read_wait);
+		wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 }
 
 /**
@@ -1226,7 +1226,7 @@ static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
 	} else
 		put_tty_queue(c, ldata);
 	if (waitqueue_active(&tty->read_wait))
-		wake_up_interruptible(&tty->read_wait);
+		wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 }
 
 static void
@@ -1378,7 +1378,7 @@ handle_newline:
 			ldata->canon_head = ldata->read_head;
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))
-				wake_up_interruptible(&tty->read_wait);
+				wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 			return 0;
 		}
 	}
@@ -1679,7 +1679,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
-			wake_up_interruptible(&tty->read_wait);
+			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 	}
 }
 
-- 
2.0.4

