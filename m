Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaDOShg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:37:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbaDOSha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:30 -0400
Date: Tue, 15 Apr 2014 20:36:59 +0200
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
Subject: [PATCH RESEND2 07/11] signals: jffs2: fix the wrong usage of
	disallow_signal()
Message-ID: <20140415183659.GA13419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jffs2_garbage_collect_thread() does disallow_signal(SIGHUP) around
jffs2_garbage_collect_pass() and the comment says "We don't want
SIGHUP to interrupt us".

But disallow_signal() can't ensure that jffs2_garbage_collect_pass()
won't be interrupted by SIGHUP, the problem is that SIGHUP can be
already pending when disallow_signal() is called, and in this case
any interruptible sleep won't block.

Note: this is in fact because disallow_signal() is buggy and should
be fixed, see the next changes.

But there is another reason why disallow_signal() is wrong: SIG_IGN
set by disallow_signal() silently discards any SIGHUP which can be
sent before the next allow_signal(SIGHUP).

Change this code to use sigprocmask(SIG_UNBLOCK/SIG_BLOCK, SIGHUP).
This even matches the old (and wrong) semantics allow/disallow had
when this logic was written.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/jffs2/background.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 2b60ce1..bb9cebc 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -75,10 +75,13 @@ void jffs2_stop_garbage_collect_thread(struct jffs2_sb_info *c)
 static int jffs2_garbage_collect_thread(void *_c)
 {
 	struct jffs2_sb_info *c = _c;
+	sigset_t hupmask;
 
+	siginitset(&hupmask, sigmask(SIGHUP));
 	allow_signal(SIGKILL);
 	allow_signal(SIGSTOP);
 	allow_signal(SIGCONT);
+	allow_signal(SIGHUP);
 
 	c->gc_task = current;
 	complete(&c->gc_thread_start);
@@ -87,7 +90,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 
 	set_freezable();
 	for (;;) {
-		allow_signal(SIGHUP);
+		sigprocmask(SIG_UNBLOCK, &hupmask, NULL);
 	again:
 		spin_lock(&c->erase_completion_lock);
 		if (!jffs2_thread_should_wake(c)) {
@@ -95,10 +98,9 @@ static int jffs2_garbage_collect_thread(void *_c)
 			spin_unlock(&c->erase_completion_lock);
 			jffs2_dbg(1, "%s(): sleeping...\n", __func__);
 			schedule();
-		} else
+		} else {
 			spin_unlock(&c->erase_completion_lock);
-			
-
+		}
 		/* Problem - immediately after bootup, the GCD spends a lot
 		 * of time in places like jffs2_kill_fragtree(); so much so
 		 * that userspace processes (like gdm and X) are starved
@@ -150,7 +152,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 			}
 		}
 		/* We don't want SIGHUP to interrupt us. STOP and KILL are OK though. */
-		disallow_signal(SIGHUP);
+		sigprocmask(SIG_BLOCK, &hupmask, NULL);
 
 		jffs2_dbg(1, "%s(): pass\n", __func__);
 		if (jffs2_garbage_collect_pass(c) == -ENOSPC) {
-- 
1.5.5.1

