Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936015Ab3BTUTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:19:51 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54869 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935999Ab3BTUP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:57 -0500
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
Subject: [PATCH v4 28/32] tty: Clarify ldisc variable
Date: Wed, 20 Feb 2013 15:03:15 -0500
Message-Id: <1361390599-15195-29-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename o_ldisc to avoid confusion with the ldisc of the
'other' tty.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index a150f95..9ace119 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -516,7 +516,7 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
 	int retval;
-	struct tty_ldisc *o_ldisc, *new_ldisc;
+	struct tty_ldisc *old_ldisc, *new_ldisc;
 	struct tty_struct *o_tty = tty->link;
 
 	new_ldisc = tty_ldisc_get(tty, ldisc);
@@ -540,7 +540,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	/* FIXME: why 'shutoff' input if the ldisc is locked? */
 	tty->receive_room = 0;
 
-	o_ldisc = tty->ldisc;
+	old_ldisc = tty->ldisc;
 	tty_lock(tty);
 
 	/* FIXME: for testing only */
@@ -555,8 +555,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		return -EIO;
 	}
 
-	/* Shutdown the current discipline. */
-	tty_ldisc_close(tty, o_ldisc);
+	/* Shutdown the old discipline. */
+	tty_ldisc_close(tty, old_ldisc);
 
 	/* Now set up the new line discipline. */
 	tty->ldisc = new_ldisc;
@@ -566,17 +566,17 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (retval < 0) {
 		/* Back to the old one or N_TTY if we can't */
 		tty_ldisc_put(new_ldisc);
-		tty_ldisc_restore(tty, o_ldisc);
+		tty_ldisc_restore(tty, old_ldisc);
 	}
 
 	/* At this point we hold a reference to the new ldisc and a
 	   a reference to the old ldisc. If we ended up flipping back
 	   to the existing ldisc we have two references to it */
 
-	if (tty->ldisc->ops->num != o_ldisc->ops->num && tty->ops->set_ldisc)
+	if (tty->ldisc->ops->num != old_ldisc->ops->num && tty->ops->set_ldisc)
 		tty->ops->set_ldisc(tty);
 
-	tty_ldisc_put(o_ldisc);
+	tty_ldisc_put(old_ldisc);
 
 	/*
 	 *	Allow ldisc referencing to occur again
-- 
1.8.1.2

