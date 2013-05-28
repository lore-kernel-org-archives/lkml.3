Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab3E1ESE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:18:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758853Ab3E1Dy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Wang YanQing" <udknight@gmail.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.507907947@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [53/94] TTY: Fix tty miss restart after we turn off flow-control
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_tty.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1530,6 +1530,14 @@ static void n_tty_set_termios(struct tty
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

