Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaJPUug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:50:36 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53642 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913AbaJPUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:50:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 15/27] tty: Simplify tty_ldisc_release() interface
Date: Thu, 16 Oct 2014 16:25:13 -0400
Message-Id: <1413491125-20134-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing the 'other' tty to tty_ldisc_release() only makes sense
for a pty pair; make o_tty function local instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    |  2 +-
 drivers/tty/tty_ldisc.c | 15 +++++++--------
 include/linux/tty.h     |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6a3be01..5c782dc 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1900,7 +1900,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	/*
 	 * Ask the line discipline code to release its structures
 	 */
-	tty_ldisc_release(tty, o_tty);
+	tty_ldisc_release(tty);
 
 	/* Wait for pending work before tty destruction commmences */
 	tty_flush_works(tty);
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 49001fa..1c4d7b6 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -756,18 +756,17 @@ static void tty_ldisc_kill(struct tty_struct *tty)
 
 /**
  *	tty_ldisc_release		-	release line discipline
- *	@tty: tty being shut down
- *	@o_tty: pair tty for pty/tty pairs
- *
- *	Called during the final close of a tty/pty pair in order to shut down
- *	the line discpline layer. On exit the ldisc assigned is N_TTY and the
- *	ldisc has not been opened.
+ *	@tty: tty being shut down (or one end of pty pair)
  *
- *	Holding ldisc_sem write lock serializes tty->ldisc changes.
+ *	Called during the final close of a tty or a pty pair in order to shut
+ *	down the line discpline layer. On exit, each ldisc assigned is N_TTY and
+ *	each ldisc has not been opened.
  */
 
-void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
+void tty_ldisc_release(struct tty_struct *tty)
 {
+	struct tty_struct *o_tty = tty->link;
+
 	/*
 	 * Shutdown this line discipline. As this is the final close,
 	 * it does not race with the set_ldisc code path.
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 35b29f0..af1a7f3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -557,7 +557,7 @@ extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);
 extern int tty_set_ldisc(struct tty_struct *tty, int ldisc);
 extern int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty);
-extern void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty);
+extern void tty_ldisc_release(struct tty_struct *tty);
 extern void tty_ldisc_init(struct tty_struct *tty);
 extern void tty_ldisc_deinit(struct tty_struct *tty);
 extern void tty_ldisc_begin(void);
-- 
2.1.1

