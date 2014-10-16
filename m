Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaJPTfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:35:00 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42722 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752636AbaJPTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 6/9] pty: Fix packet mode setting race
Date: Thu, 16 Oct 2014 15:33:27 -0400
Message-Id: <1413488010-16885-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because pty_set_pktmode() does not claim the slave's ctrl_lock
to clear ->ctrl_status (to avoid unnecessary lock nesting),
pty_set_pktmode() may accidentally erase new ->ctrl_status updates.
For example,

CPU 0                             | CPU 1
pty_set_pktmode()                 | pty_start()
  spin_lock(master's ctrl_lock)   |
  tty->packet = 1                 |
                                  |   if (tty->link->packet)
                                  |     spin_lock(slave's ctrl_lock)
                                  |     tty->ctrl_status = TIOCPKT_START
  tty->link->ctrl_status = 0      |

Ensure the clear of ->ctrl_status occurs before packet mode is set
(and observable on another cpu).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index e554393..bcec4c7 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -186,8 +186,9 @@ static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 	spin_lock_irq(&tty->ctrl_lock);
 	if (pktmode) {
 		if (!tty->packet) {
-			tty->packet = 1;
 			tty->link->ctrl_status = 0;
+			smp_mb();
+			tty->packet = 1;
 		}
 	} else
 		tty->packet = 0;
-- 
2.1.1

