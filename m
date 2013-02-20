Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935980Ab3BTUPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:15:43 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54782 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3BTUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:36 -0500
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
Subject: [PATCH v4 22/32] tty: Fold one-line assign function into callers
Date: Wed, 20 Feb 2013 15:03:09 -0500
Message-Id: <1361390599-15195-23-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that tty_ldisc_assign() is a one-line file-scoped function,
remove it and perform the simple assignment at its call sites.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 5ee0b2b..f26ef1a 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -228,24 +228,6 @@ const struct file_operations tty_ldiscs_proc_fops = {
 };
 
 /**
- *	tty_ldisc_assign	-	set ldisc on a tty
- *	@tty: tty to assign
- *	@ld: line discipline
- *
- *	Install an instance of a line discipline into a tty structure. The
- *	ldisc must have a reference count above zero to ensure it remains.
- *	The tty instance refcount starts at zero.
- *
- *	Locking:
- *		Caller must hold references
- */
-
-static void tty_ldisc_assign(struct tty_struct *tty, struct tty_ldisc *ld)
-{
-	tty->ldisc = ld;
-}
-
-/**
  *	tty_ldisc_try		-	internal helper
  *	@tty: the tty
  *
@@ -488,7 +470,7 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 	/* There is an outstanding reference here so this is safe */
 	old = tty_ldisc_get(old->ops->num);
 	WARN_ON(IS_ERR(old));
-	tty_ldisc_assign(tty, old);
+	tty->ldisc = old;
 	tty_set_termios_ldisc(tty, old->ops->num);
 	if (tty_ldisc_open(tty, old) < 0) {
 		tty_ldisc_put(old);
@@ -496,7 +478,7 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 		new_ldisc = tty_ldisc_get(N_TTY);
 		if (IS_ERR(new_ldisc))
 			panic("n_tty: get");
-		tty_ldisc_assign(tty, new_ldisc);
+		tty->ldisc = new_ldisc;
 		tty_set_termios_ldisc(tty, N_TTY);
 		r = tty_ldisc_open(tty, new_ldisc);
 		if (r < 0)
@@ -725,7 +707,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	tty_ldisc_close(tty, o_ldisc);
 
 	/* Now set up the new line discipline. */
-	tty_ldisc_assign(tty, new_ldisc);
+	tty->ldisc = new_ldisc;
 	tty_set_termios_ldisc(tty, ldisc);
 
 	retval = tty_ldisc_open(tty, new_ldisc);
@@ -799,11 +781,10 @@ static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
-	tty->ldisc = NULL;
 	/*
 	 *	Switch the line discipline back
 	 */
-	tty_ldisc_assign(tty, ld);
+	tty->ldisc = ld;
 	tty_set_termios_ldisc(tty, ldisc);
 
 	return 0;
@@ -986,7 +967,7 @@ void tty_ldisc_init(struct tty_struct *tty)
 	struct tty_ldisc *ld = tty_ldisc_get(N_TTY);
 	if (IS_ERR(ld))
 		panic("n_tty: init_tty");
-	tty_ldisc_assign(tty, ld);
+	tty->ldisc = ld;
 }
 
 /**
@@ -999,7 +980,7 @@ void tty_ldisc_init(struct tty_struct *tty)
 void tty_ldisc_deinit(struct tty_struct *tty)
 {
 	tty_ldisc_put(tty->ldisc);
-	tty_ldisc_assign(tty, NULL);
+	tty->ldisc = NULL;
 }
 
 void tty_ldisc_begin(void)
-- 
1.8.1.2

