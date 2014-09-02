Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaIBWLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:11:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51929 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755078AbaIBWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:11:45 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 24/26] tty: Serialize tcflow() with other tty flow control changes
Date: Tue,  2 Sep 2014 17:39:33 -0400
Message-Id: <1409693975-1028-25-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use newly-introduced tty->flow_lock to serialize updates to
tty->flow_stopped (via tcflow()) and with concurrent tty flow
control changes from other sources.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ioctl.c | 8 ++++++--
 include/linux/tty.h     | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 6fd60fe..ffed466 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1177,16 +1177,20 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 			return retval;
 		switch (arg) {
 		case TCOOFF:
+			spin_lock_irq(&tty->flow_lock);
 			if (!tty->flow_stopped) {
 				tty->flow_stopped = 1;
-				stop_tty(tty);
+				__stop_tty(tty);
 			}
+			spin_unlock_irq(&tty->flow_lock);
 			break;
 		case TCOON:
+			spin_lock_irq(&tty->flow_lock);
 			if (tty->flow_stopped) {
 				tty->flow_stopped = 0;
-				start_tty(tty);
+				__start_tty(tty);
 			}
+			spin_unlock_irq(&tty->flow_lock);
 			break;
 		case TCIOFF:
 			if (STOP_CHAR(tty) != __DISABLED_CHAR)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 19ce455..0a457c9 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -264,7 +264,7 @@ struct tty_struct {
 	struct winsize winsize;		/* winsize_mutex */
 	bool stopped;			/* flow_lock */
 	bool hw_stopped;
-	bool flow_stopped;
+	bool flow_stopped;		/* flow_lock */
 	bool packet;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
-- 
2.1.0

