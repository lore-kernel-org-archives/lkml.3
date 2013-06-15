Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3FONYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:24:31 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43153 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FONVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:21:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 19/24] tty: Only guarantee termios read safety for throttle/unthrottle
Date: Sat, 15 Jun 2013 09:14:31 -0400
Message-Id: <1371302076-4688-20-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No tty driver modifies termios during throttle() or unthrottle().
Therefore, only read safety is required.

However, tty_throttle_safe and tty_unthrottle_safe must still be
mutually exclusive; introduce throttle_mutex for that purpose.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c     | 4 ----
 drivers/tty/tty_io.c    | 1 +
 drivers/tty/tty_ioctl.c | 8 ++++----
 include/linux/tty.h     | 1 +
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d0c8805..b78ee464 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1518,9 +1518,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
 		if (receive_room(tty) >= TTY_THRESHOLD_THROTTLE)
 			break;
-		up_read(&tty->termios_rwsem);
 		throttled = tty_throttle_safe(tty);
-		down_read(&tty->termios_rwsem);
 		if (!throttled)
 			break;
 	}
@@ -2086,9 +2084,7 @@ do_it_again:
 			if (!tty->count)
 				break;
 			n_tty_set_room(tty);
-			up_read(&tty->termios_rwsem);
 			unthrottled = tty_unthrottle_safe(tty);
-			down_read(&tty->termios_rwsem);
 			if (!unthrottled)
 				break;
 		}
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1cec782..7dbea58 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3013,6 +3013,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	mutex_init(&tty->legacy_mutex);
+	mutex_init(&tty->throttle_mutex);
 	init_rwsem(&tty->termios_rwsem);
 	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 9ce20df..03ba081 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -151,7 +151,7 @@ int tty_throttle_safe(struct tty_struct *tty)
 {
 	int ret = 0;
 
-	down_write(&tty->termios_rwsem);
+	mutex_lock(&tty->throttle_mutex);
 	if (!test_bit(TTY_THROTTLED, &tty->flags)) {
 		if (tty->flow_change != TTY_THROTTLE_SAFE)
 			ret = 1;
@@ -161,7 +161,7 @@ int tty_throttle_safe(struct tty_struct *tty)
 				tty->ops->throttle(tty);
 		}
 	}
-	up_write(&tty->termios_rwsem);
+	mutex_unlock(&tty->throttle_mutex);
 
 	return ret;
 }
@@ -182,7 +182,7 @@ int tty_unthrottle_safe(struct tty_struct *tty)
 {
 	int ret = 0;
 
-	down_write(&tty->termios_rwsem);
+	mutex_lock(&tty->throttle_mutex);
 	if (test_bit(TTY_THROTTLED, &tty->flags)) {
 		if (tty->flow_change != TTY_UNTHROTTLE_SAFE)
 			ret = 1;
@@ -192,7 +192,7 @@ int tty_unthrottle_safe(struct tty_struct *tty)
 				tty->ops->unthrottle(tty);
 		}
 	}
-	up_write(&tty->termios_rwsem);
+	mutex_unlock(&tty->throttle_mutex);
 
 	return ret;
 }
diff --git a/include/linux/tty.h b/include/linux/tty.h
index d304207..57a70d1 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -244,6 +244,7 @@ struct tty_struct {
 
 	struct mutex atomic_write_lock;
 	struct mutex legacy_mutex;
+	struct mutex throttle_mutex;
 	struct rw_semaphore termios_rwsem;
 	spinlock_t ctrl_lock;
 	/* Termios values are protected by the termios rwsem */
-- 
1.8.1.2

