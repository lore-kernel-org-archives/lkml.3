Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaDOSi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbaDOShd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:33 -0400
Date: Tue, 15 Apr 2014 20:37:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND2 08/11] signals: kill the obsolete sigdelset() and
	recalc_sigpending() in allow_signal()
Message-ID: <20140415183706.GA13426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow_signal() does sigdelset(current->blocked) due to historic
reason, previously it could be called by a daemonize()'ed kthread,
and daemonize() played with current->blocked.

Now that daemonize() has gone away we can remove sigdelset() and
recalc_sigpending(). If a user really wants to unblock a signal,
it must use sigprocmask() or set_current_block() explicitely.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8a7ee44..3eec27b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3071,16 +3071,13 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
  */
 void allow_signal(int sig)
 {
-	spin_lock_irq(&current->sighand->siglock);
-	/* This is only needed for daemonize()'ed kthreads */
-	sigdelset(&current->blocked, sig);
 	/*
 	 * Kernel threads handle their own signals. Let the signal code
 	 * know it'll be handled, so that they don't get converted to
 	 * SIGKILL or just silently dropped.
 	 */
+	spin_lock_irq(&current->sighand->siglock);
 	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 }
 EXPORT_SYMBOL(allow_signal);
-- 
1.5.5.1

