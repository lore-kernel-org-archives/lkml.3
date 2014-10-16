Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaJPTAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44772 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbaJPTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:06 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH -next 04/10] uml: Fix unsafe pid reference to foreground process group
Date: Thu, 16 Oct 2014 14:59:44 -0400
Message-Id: <1413485990-16855-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the tty core maintains a pid reference for the foreground
process group, if the foreground process group is changed that
pid reference is dropped. Thus, the pid reference used for signalling
could become stale.

Safely obtain a pid reference to the foreground process group and
release the reference after signalling is complete.

cc: Jeff Dike <jdike@addtoit.com>
cc: Richard Weinberger <richard@nod.at>
cc: user-mode-linux-devel@lists.sourceforge.net
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 arch/um/drivers/line.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 8035145..6208702 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -632,6 +632,7 @@ static irqreturn_t winch_interrupt(int irq, void *data)
 	int fd = winch->fd;
 	int err;
 	char c;
+	struct pid *pgrp;
 
 	if (fd != -1) {
 		err = generic_read(fd, &c, NULL);
@@ -657,7 +658,10 @@ static irqreturn_t winch_interrupt(int irq, void *data)
 		if (line != NULL) {
 			chan_window_size(line, &tty->winsize.ws_row,
 					 &tty->winsize.ws_col);
-			kill_pgrp(tty->pgrp, SIGWINCH, 1);
+			pgrp = tty_get_pgrp(tty);
+			if (pgrp)
+				kill_pgrp(pgrp, SIGWINCH, 1);
+			put_pid(pgrp);
 		}
 		tty_kref_put(tty);
 	}
-- 
2.1.1

