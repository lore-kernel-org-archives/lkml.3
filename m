Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3GBPl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:41:59 -0400
Received: from cpc6-farn7-2-0-cust119.6-2.cable.virginmedia.com ([81.110.26.120]:42313
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056Ab3GBPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:41:58 -0400
From: Dean Jenkins <Dean_Jenkins@mentor.com>
To: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/5] SLIP: Prevent recursion stack overflow and scheduler crash
Date: Tue,  2 Jul 2013 16:31:32 +0100
Message-Id: <1372779094-11730-4-git-send-email-Dean_Jenkins@mentor.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an issue when SLIP is bound to a PTY/TTY. If
TTY_DO_WRITE_WAKEUP is set, pty_write() calls tty_wakeup()
then slip_write_wakeup() can be called. slip_write_wakeup() can
be called by pty_write(). This is a recursion loop.

pty_write() is called in sl_encaps().
slip_write_wakeup() can be called by the TTY wakeup event.

The pty_write() call in sl_encaps() will also call
slip_write_wakeup() but xleft has not been updated and contains
the value from the previous SLIP frame transmission. xleft is zero
unless the previous SLIP frame failed to be fully transmitted in
which case xleft has a positive value. A failed transmission causes
the next SLIP frame pending transmission to cause a crash.

In the failure case when xleft is positive in slip_write_wakeup(),
recursion causes the stack to overflow and task structures located
near the stack are corrupted by the stack overflow. The corrupted
task structures crash the kernel's scheduler and the system
crashes with exception handlers crashing and the emergency reboot
fails.

The recursion loop is:
slip_write_wakeup()-->pty_write()-->tty_wakeup()-->slip_write_wakeup()
etc.

Therefore ensure xleft is zero before writing the SLIP frame to the
PTY/TTY layers. This prevents the xleft value of the previous SLIP
frame from interfering with the slip_write_wakeup() execution when
SLIP is bound to a PTY/TTY.

Note the transmission segmentation mechanism is broken and only a
single call to the write() function pointer will take place per
SLIP frame. This could cause missing or truncated SLIP frames to
be transmitted when the write() function fails to write the complete
frame. In other words the TTY wakeup event does nothing because
the TTY_DO_WRITE_WAKEUP flag has been cleared.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
---
 drivers/net/slip/slip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index bed819f..f7303e0 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -395,6 +395,11 @@ static void sl_encaps(struct slip *sl, unsigned char *icp, int len)
 #endif
 		count = slip_esc(p, sl->xbuff, len);
 
+	/* ensure xleft set by the previous SLIP frame is zero for this frame
+	 * otherwise slip_write_wakeup() can cause a recursive loop.
+	 */
+	sl->xleft = 0;
+
 	/* Order of next two lines is *very* important.
 	 * When we are sending a little amount of data,
 	 * the transfer may be completed inside the ops->write()
-- 
1.8.1.5

