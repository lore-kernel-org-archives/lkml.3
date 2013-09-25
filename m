Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3IYBQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3IYAQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Karel Srot <ksrot@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 024/110] tty: disassociate_ctty() sends the extra SIGCONT
Date: Tue, 24 Sep 2013 17:14:22 -0700
Message-Id: <20130925001326.032644514@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 03e1261778cca782d41a3d8e3945ca88cf93e01e upstream.

Starting from v3.10 (probably commit f91e2590410b: "tty: Signal
foreground group processes in hangup") disassociate_ctty() sends SIGCONT
if tty && on_exit.  This breaks LSB test-suite, in particular test8 in
_exit.c and test40 in sigcon5.c.

Put the "!on_exit" check back to restore the old behaviour.

Review by Peter Hurley:
 "Yes, this regression was introduced by me in that commit.  The effect
  of the regression is that ptys will receive a SIGCONT when, in similar
  circumstances, ttys would not.

  The fact that two test vectors accidentally tripped over this
  regression suggests that some other apps may as well.

  Thanks for catching this"

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Karel Srot <ksrot@redhat.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -850,7 +850,8 @@ void disassociate_ctty(int on_exit)
 			struct pid *tty_pgrp = tty_get_pgrp(tty);
 			if (tty_pgrp) {
 				kill_pgrp(tty_pgrp, SIGHUP, on_exit);
-				kill_pgrp(tty_pgrp, SIGCONT, on_exit);
+				if (!on_exit)
+					kill_pgrp(tty_pgrp, SIGCONT, on_exit);
 				put_pid(tty_pgrp);
 			}
 		}


