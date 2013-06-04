Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab3FDOYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:24:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3FDOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang YanQing <udknight@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 19/70] TTY: Fix tty miss restart after we turn off flow-control
Date: Tue,  4 Jun 2013 15:06:35 +0100
Message-Id: <1370354846-14213-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

commit dab73b4eb9ef924a2b90dab84e539076d82b256f upstream.

I meet emacs hang in start if I do the operation below:
  1: echo 3 > /proc/sys/vm/drop_caches
  2: emacs BigFile
  3: Press CTRL-S follow 2 immediately

Then emacs hang on, CTRL-Q can't resume, the terminal
hang on, you can do nothing with this terminal except
close it.

The reason is before emacs takeover control the tty,
we use CTRL-S to XOFF it. Then when emacs takeover the
control, it may don't use the flow-control, so emacs hang.
This patch fix it.

This patch will fix a kind of strange tty relation hang problem,
I believe I meet it with vim in ssh, and also see below bug report:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=465823

Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/n_tty.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26f0d0e..72d3ff8 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1529,6 +1529,14 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 			tty->real_raw = 0;
 	}
 	n_tty_set_room(tty);
+	/*
+	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
+	 * been stopped by STOP_CHAR(tty) before it.
+	 */
+	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped) {
+		start_tty(tty);
+	}
+
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
-- 
1.8.1.2

