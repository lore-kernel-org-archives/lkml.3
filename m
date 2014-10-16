Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaJPTAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:43 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34461 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752417AbaJPTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:06 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 05/10] tty: Replace open-coded tty_get_pgrp()
Date: Thu, 16 Oct 2014 14:59:45 -0400
Message-Id: <1413485990-16855-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded instances of tty_get_pgrp().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c    | 24 ++++++------------------
 drivers/tty/tty_io.c |  8 ++------
 2 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 7c4447a..4c0218d 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -207,15 +207,12 @@ static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
-	unsigned long flags;
 	struct pid *pgrp;
 
 	if (tty->link) {
-		spin_lock_irqsave(&tty->link->ctrl_lock, flags);
-		pgrp = get_pid(tty->link->pgrp);
-		spin_unlock_irqrestore(&tty->link->ctrl_lock, flags);
-
-		kill_pgrp(pgrp, sig, 1);
+		pgrp = tty_get_pgrp(tty->link);
+		if (pgrp)
+			kill_pgrp(pgrp, sig, 1);
 		put_pid(pgrp);
 	}
 	return 0;
@@ -278,7 +275,6 @@ static void pty_set_termios(struct tty_struct *tty,
 static int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 {
 	struct pid *pgrp, *rpgrp;
-	unsigned long flags;
 	struct tty_struct *pty = tty->link;
 
 	/* For a PTY we need to lock the tty side */
@@ -286,17 +282,9 @@ static int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 
-	/* Get the PID values and reference them so we can
-	   avoid holding the tty ctrl lock while sending signals.
-	   We need to lock these individually however. */
-
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	pgrp = get_pid(tty->pgrp);
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-
-	spin_lock_irqsave(&pty->ctrl_lock, flags);
-	rpgrp = get_pid(pty->pgrp);
-	spin_unlock_irqrestore(&pty->ctrl_lock, flags);
+	/* Signal the foreground process group of both ptys */
+	pgrp = tty_get_pgrp(tty);
+	rpgrp = tty_get_pgrp(pty);
 
 	if (pgrp)
 		kill_pgrp(pgrp, SIGWINCH, 1);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 272d977..c224488 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2331,18 +2331,14 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 int tty_do_resize(struct tty_struct *tty, struct winsize *ws)
 {
 	struct pid *pgrp;
-	unsigned long flags;
 
 	/* Lock the tty */
 	mutex_lock(&tty->winsize_mutex);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
-	/* Get the PID values and reference them so we can
-	   avoid holding the tty ctrl lock while sending signals */
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	pgrp = get_pid(tty->pgrp);
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
+	/* Signal the foreground process group */
+	pgrp = tty_get_pgrp(tty);
 	if (pgrp)
 		kill_pgrp(pgrp, SIGWINCH, 1);
 	put_pid(pgrp);
-- 
2.1.1

