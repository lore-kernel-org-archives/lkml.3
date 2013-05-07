Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab3EGSrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:47:46 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:49519 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755Ab3EGSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:47:45 -0400
Date: Wed, 8 May 2013 02:47:34 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
Message-ID: <20130507184734.GA2459@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz,
	linux-kernel@vger.kernel.org
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
But after search the emacs's startup codes, I find they use TCXONC
to workaround this situation:

  /* This code added to insure that, if flow-control is not to be used,
     we have an unlocked terminal at the start. */
  if (!tty_out->flow_control) ioctl (fileno (tty_out->input), TCXONC, 1);
  ioctl (fileno (tty_out->input), TCXONC, 1);

But this workaround never work due the kernel's current code.
This patch fix it.

Below is the ChangeLog introduce the tty->flow_stopped flag:

Thu Nov 21 10:05:22 1996  Theodre Ts'o  <tytso@localhost.mit.edu>

       * tty_ioctl.c (tty_wait_until_sent): Always check the driver
               wait_until_ready routine, even if there are no characters
               in the xmit buffer.  (There may be charactes in the device
               FIFO.)
               (n_tty_ioctl): Add new flag tty->flow_stopped which
               indicates whether the tty is stopped due to a request by
               the TCXONC ioctl (used by tcflow).  If so, don't let an
               incoming XOFF character restart the tty.  The tty can only
               be restarted by another TCXONC request.

So I think this patch make TCXONC can restart tty which stopped by
STOP_CHAR don't break the original meaning.

This patch will fix some strange tty relation hang problem,
I believe I meet it with vim in ssh, and also see below bug report:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=465823

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/tty_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index e4455e0..42e08e5 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1129,11 +1129,12 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		case TCOOFF:
 			if (!tty->flow_stopped) {
 				tty->flow_stopped = 1;
-				stop_tty(tty);
+				if (!tty->stopped)
+					stop_tty(tty);
 			}
 			break;
 		case TCOON:
-			if (tty->flow_stopped) {
+			if (tty->flow_stopped || tty->stopped) {
 				tty->flow_stopped = 0;
 				start_tty(tty);
 			}
-- 
1.7.12.4.dirty
