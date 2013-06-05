Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab3FEUxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:53:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab3FEUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang YanQing <udknight@gmail.com>
Subject: [ 08/33] TTY: Fix tty miss restart after we turn off flow-control
Date: Wed,  5 Jun 2013 13:52:46 -0700
Message-Id: <20130605204704.420271012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/n_tty.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1531,6 +1531,14 @@ static void n_tty_set_termios(struct tty
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


