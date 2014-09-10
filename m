Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaIJTp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:45:28 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37839 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753462AbaIJTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:45:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 11/14] tty: Serialize tcflow() with other tty flow control changes
Date: Wed, 10 Sep 2014 15:06:33 -0400
Message-Id: <1410375996-4693-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use newly-introduced tty->flow_lock to serialize updates to
tty->flow_stopped (via tcflow()) and with concurrent tty flow
control changes from other sources.

Merge the storage for ->stopped and ->flow_stopped, now that both
flags are serialized by ->flow_lock.

The padding bits are necessary to force the compiler to allocate the
type specified; otherwise, gcc will ignore the type specifier and
allocate the minimum number of bytes necessary to store the bitfield.
In turn, this would allow Alpha EV4 and EV5 cpus to corrupt adjacent
byte storage because those cpus use RMW to store byte and short data.

gcc versions < 4.7.2 will also corrupt storage adjacent to bitfields
smaller than unsigned long on ia64, ppc64, hppa64 and sparc64, thus
requiring more than unsigned int storage (which would otherwise be
sufficient to workaround the Alpha non-atomic byte/short storage problem).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ioctl.c | 8 ++++++--
 include/linux/tty.h     | 5 +++--
 2 files changed, 9 insertions(+), 4 deletions(-)

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
index af26171..377896d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -262,8 +262,9 @@ struct tty_struct {
 	unsigned long flags;
 	int count;
 	struct winsize winsize;		/* winsize_mutex */
-	int stopped;			/* flow_lock */
-	int flow_stopped;
+	unsigned long stopped:1,	/* flow_lock */
+		      flow_stopped:1,
+		      unused:62;
 	int hw_stopped;
 	int packet;
 	unsigned char ctrl_status;	/* ctrl_lock */
-- 
2.1.0

