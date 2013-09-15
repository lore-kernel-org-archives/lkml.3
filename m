Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3IOP4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab3IOP4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:56:44 -0400
Date: Sun, 15 Sep 2013 17:50:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tty: disassociate_ctty() sends the extra SIGCONT
Message-ID: <20130915155026.GA11917@redhat.com>
References: <20130915155006.GA11913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130915155006.GA11913@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from v3.10 (probably f91e2590 "tty: Signal foreground
group processes in hangup") disassociate_ctty() sends SIGCONT
if tty && on_exit. This breaks LSB test-suite, in particular
test8 in _exit.c and test40 in sigcon5.c.

Put the "!on_exit" check back to restore the old behaviour.

Cc: stable@vger.kernel.org # v3.10+
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Karel Srot <ksrot@redhat.com>
---
 drivers/tty/tty_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index a9355ce..3a1a01a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -854,7 +854,8 @@ void disassociate_ctty(int on_exit)
 			struct pid *tty_pgrp = tty_get_pgrp(tty);
 			if (tty_pgrp) {
 				kill_pgrp(tty_pgrp, SIGHUP, on_exit);
-				kill_pgrp(tty_pgrp, SIGCONT, on_exit);
+				if (!on_exit)
+					kill_pgrp(tty_pgrp, SIGCONT, on_exit);
 				put_pid(tty_pgrp);
 			}
 		}
-- 
1.5.5.1


