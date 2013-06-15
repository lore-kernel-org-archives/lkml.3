Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3FOLFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:05:52 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37115 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3FOLFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:05:22 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/6] tty: Clarify ldisc variable
Date: Sat, 15 Jun 2013 07:04:49 -0400
Message-Id: <1371294291-3807-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
References: <20130603192436.GB22733@kroah.com>
 <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
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
index a4fd3a1..6c63b73 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -517,7 +517,7 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
 	int retval;
-	struct tty_ldisc *o_ldisc, *new_ldisc;
+	struct tty_ldisc *old_ldisc, *new_ldisc;
 	struct tty_struct *o_tty = tty->link;
 
 	new_ldisc = tty_ldisc_get(tty, ldisc);
@@ -543,7 +543,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	/* FIXME: why 'shutoff' input if the ldisc is locked? */
 	tty->receive_room = 0;
 
-	o_ldisc = tty->ldisc;
+	old_ldisc = tty->ldisc;
 	tty_lock(tty);
 
 	/* FIXME: for testing only */
@@ -558,8 +558,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		return -EIO;
 	}
 
-	/* Shutdown the current discipline. */
-	tty_ldisc_close(tty, o_ldisc);
+	/* Shutdown the old discipline. */
+	tty_ldisc_close(tty, old_ldisc);
 
 	/* Now set up the new line discipline. */
 	tty->ldisc = new_ldisc;
@@ -569,17 +569,17 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
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

