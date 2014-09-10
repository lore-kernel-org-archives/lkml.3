Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaIJV2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:28:34 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56411 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbaIJV2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:28:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
Date: Wed, 10 Sep 2014 17:28:19 -0400
Message-Id: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes user-space behavior (for the better) but I'm not sure
that it's consequence-free. Also, it might not be enough to unwedge the
terminal if the driver got its own flow control state mangled.

Thoughts?

--- >% ---
Subject: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal

If terminal flow has been stopped, the terminal can be unwedged
by:
	tcflow(fd, TCOOFF);
	tcflow(fd, TCOON);
This works because tcflow(TCOOFF) ensures that ->flow_stopped is set,
which allows tcflow(TCOON) to override the terminal flow state in
__start_tty().

Instead, allow unwedging with only:
        tcflow(fd, TCOON);
by disregarding the existing ->flow_stopped state.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 32cee97..c792088 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1157,10 +1157,8 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 			break;
 		case TCOON:
 			spin_lock_irq(&tty->flow_lock);
-			if (tty->flow_stopped) {
-				tty->flow_stopped = 0;
-				__start_tty(tty);
-			}
+			tty->flow_stopped = 0;
+			__start_tty(tty);
 			spin_unlock_irq(&tty->flow_lock);
 			break;
 		case TCIOFF:
-- 
2.1.0

