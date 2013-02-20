Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab3BTUPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:15:39 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54739 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934914Ab3BTUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:29 -0500
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
Subject: [PATCH v4 18/32] tty: Add ldisc hangup debug messages
Date: Wed, 20 Feb 2013 15:03:05 -0500
Message-Id: <1361390599-15195-19-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expected typical debug log:
[  582.721965] tty_open: opening pts3...
[  582.721970] tty_open: opening pts3...
[  582.721977] tty_release: pts3 (tty count=3)...
[  582.721980] tty_release: ptm3 (tty count=1)...
[  582.722015] pts3 vhangup...
[  582.722020] tty_ldisc_hangup: pts3: closing ldisc: ffff88007a920540
[  582.724128] tty_release: pts3 (tty count=2)...
[  582.724217] tty_ldisc_hangup: pts3: re-opened ldisc: ffff88007a920580
[  582.724221] tty_release: ptm3: final close
[  582.724234] tty_ldisc_release: ptm3: closing ldisc: ffff88007a920a80
[  582.724238] tty_ldisc_release: ptm3: ldisc closed
[  582.724241] tty_release: ptm3: freeing structure...
[  582.724741] tty_open: opening pts3...

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 0030d55..328ff5b 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -20,6 +20,17 @@
 #include <linux/uaccess.h>
 #include <linux/ratelimit.h>
 
+#undef LDISC_DEBUG_HANGUP
+
+#ifdef LDISC_DEBUG_HANGUP
+#define tty_ldisc_debug(tty, f, args...) ({				       \
+	char __b[64];							       \
+	printk(KERN_DEBUG "%s: %s: " f, __func__, tty_name(tty, __b), ##args); \
+})
+#else
+#define tty_ldisc_debug(tty, f, args...)
+#endif
+
 /*
  *	This guards the refcounted line discipline lists. The lock
  *	must be taken with irqs off because there are hangup path
@@ -822,6 +833,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	int reset = tty->driver->flags & TTY_DRIVER_RESET_TERMIOS;
 	int err = 0;
 
+	tty_ldisc_debug(tty, "closing ldisc: %p\n", tty->ldisc);
+
 	/*
 	 * FIXME! What are the locking issues here? This may me overdoing
 	 * things... This question is especially important now that we've
@@ -878,6 +891,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	mutex_unlock(&tty->ldisc_mutex);
 	if (reset)
 		tty_reset_termios(tty);
+
+	tty_ldisc_debug(tty, "re-opened ldisc: %p\n", tty->ldisc);
 }
 
 /**
@@ -944,6 +959,8 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * it does not race with the set_ldisc code path.
 	 */
 
+	tty_ldisc_debug(tty, "closing ldisc: %p\n", tty->ldisc);
+
 	tty_ldisc_halt(tty, o_tty, MAX_SCHEDULE_TIMEOUT);
 
 	tty_lock_pair(tty, o_tty);
@@ -955,6 +972,8 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_unlock_pair(tty, o_tty);
 	/* And the memory resources remaining (buffers, termios) will be
 	   disposed of when the kref hits zero */
+
+	tty_ldisc_debug(tty, "ldisc closed\n");
 }
 
 /**
-- 
1.8.1.2

