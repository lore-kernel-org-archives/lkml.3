Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235Ab3BTUEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:04:47 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:53920 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935190Ab3BTUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:04:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 01/32] tty: Add diagnostic for halted line discipline
Date: Wed, 20 Feb 2013 15:02:48 -0500
Message-Id: <1361390599-15195-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flip buffer work must not be scheduled by the line discipline
after the line discipline has been halted; issue warning.

Note: drivers can still schedule flip buffer work.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c     | 8 ++++++++
 drivers/tty/tty_ldisc.c | 7 ++++++-
 include/linux/tty.h     | 1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 05e72be..9c18e37 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -153,6 +153,12 @@ static void n_tty_set_room(struct tty_struct *tty)
 	if (left && !old_left) {
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
+		/* see if ldisc has been killed - if so, this means that
+		 * even though the ldisc has been halted and ->buf.work
+		 * cancelled, ->buf.work is about to be rescheduled
+		 */
+		WARN_RATELIMIT(test_bit(TTY_LDISC_HALTED, &tty->flags),
+			       "scheduling buffer work for halted ldisc\n");
 		schedule_work(&tty->port->buf.work);
 	}
 }
@@ -1645,6 +1651,8 @@ static int n_tty_open(struct tty_struct *tty)
 		goto err_free_bufs;
 
 	tty->disc_data = ldata;
+	/* indicate buffer work may resume */
+	clear_bit(TTY_LDISC_HALTED, &tty->flags);
 	reset_buffer_flags(tty);
 	tty_unthrottle(tty);
 	ldata->column = 0;
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index d794087..c641321 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -375,6 +375,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
 
 void tty_ldisc_enable(struct tty_struct *tty)
 {
+	clear_bit(TTY_LDISC_HALTED, &tty->flags);
 	set_bit(TTY_LDISC, &tty->flags);
 	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 	wake_up(&tty_ldisc_wait);
@@ -513,8 +514,11 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 
 static int tty_ldisc_halt(struct tty_struct *tty)
 {
+	int scheduled;
 	clear_bit(TTY_LDISC, &tty->flags);
-	return cancel_work_sync(&tty->port->buf.work);
+	scheduled = cancel_work_sync(&tty->port->buf.work);
+	set_bit(TTY_LDISC_HALTED, &tty->flags);
+	return scheduled;
 }
 
 /**
@@ -820,6 +824,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	clear_bit(TTY_LDISC, &tty->flags);
 	tty_unlock(tty);
 	cancel_work_sync(&tty->port->buf.work);
+	set_bit(TTY_LDISC_HALTED, &tty->flags);
 	mutex_unlock(&tty->ldisc_mutex);
 retry:
 	tty_lock(tty);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index c75d886..7aa4be6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -315,6 +315,7 @@ struct tty_file_private {
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_HUPPING 		21	/* ->hangup() in progress */
+#define TTY_LDISC_HALTED	22	/* Line discipline is halted */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
-- 
1.8.1.2

