Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab3GCSlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:41:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab3GCSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:53 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=cEmze3Jf8a0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=usMc6eKz12YA:10 a=pGLkceISAAAA:8 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=7iUa3dgDbkTuaE4EaWAA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=NBVLXdjV8owbLs_s:21 a=gk1KxzYni4G1UF8U:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184046.114491343@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wang YanQing <udknight@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [009/141] TTY: Fix tty miss restart after we turn off flow-control
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0009-TTY-Fix-tty-miss-restart-after-we-turn-off-flow-cont.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

[ Upstream commit dab73b4eb9ef924a2b90dab84e539076d82b256f ]

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/n_tty.c |    8 ++++++++
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
1.7.10.4


