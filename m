Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3EIBq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 21:46:29 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43515 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3EIBq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 21:46:27 -0400
Date: Thu, 9 May 2013 09:46:10 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v2] TTY: Fix tty miss restart after we turn off flow-control
Message-ID: <20130509014610.GA2070@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, peter@hurleysoftware.com,
	jslaby@suse.cz, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 Changes v1-v2:
 1: move the fix into n_tty_set_termios instead of change TCXONC's behavior suggested by Peter Hurley
 2: rewrite some ChangeLog and use more reasonable subject.

 drivers/tty/n_tty.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 05e72be..5510b32 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1588,6 +1588,14 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 			ldata->real_raw = 0;
 	}
 	n_tty_set_room(tty);
+	/*
+	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
+	 * been stopped by STOP_CHAR(tty) before it.
+	 */
+	if (!I_IXON(tty) && (old->c_iflag & IXON) && !tty->flow_stopped) {
+		start_tty(tty);
+	}
+
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
-- 
1.7.12.4.dirty
