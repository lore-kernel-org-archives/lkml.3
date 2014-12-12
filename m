Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbaLLG2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:28:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759364AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Mathias Krause" <minipli@googlemail.com>,
        "PaX Team" <pageexec@freemail.hu>,
        "Brad Spengler" <spender@grsecurity.net>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.578008802@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 083/164] posix-timers: Fix stack info leak in
 timer_create()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 6891c4509c792209c44ced55a60f13954cb50ef4 upstream.

If userland creates a timer without specifying a sigevent info, we'll
create one ourself, using a stack local variable. Particularly will we
use the timer ID as sival_int. But as sigev_value is a union containing
a pointer and an int, that assignment will only partially initialize
sigev_value on systems where the size of a pointer is bigger than the
size of an int. On such systems we'll copy the uninitialized stack bytes
from the timer_create() call to userland when the timer actually fires
and we're going to deliver the signal.

Initialize sigev_value with 0 to plug the stack info leak.

Found in the PaX patch, written by the PaX Team.

Fixes: 5a9fa7307285 ("posix-timers: kill ->it_sigev_signo and...")
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Link: http://lkml.kernel.org/r/1412456799-32339-1-git-send-email-minipli@googlemail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -589,6 +589,7 @@ SYSCALL_DEFINE3(timer_create, const cloc
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;

