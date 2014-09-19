Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaISLsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:48:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaISLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:16 -0400
Date: Fri, 19 Sep 2014 04:46:58 -0700
From: tip-bot for Aaron Tomlin <tipbot@zytor.com>
Message-ID: <tip-0d9e26329b0c9263d4d9e0422d80a0e73268c52f@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        atomlin@redhat.com, viro@zeniv.linux.org.uk, ddstreet@ieee.org,
        akpm@linux-foundation.org, ak@linux.intel.com, tglx@linutronix.de,
        davidlohr@hp.com, lkundrak@v3.sk, linux-kernel@vger.kernel.org,
        hpa@zytor.com, davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        keescook@chromium.org, ast@plumgrid.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, atomlin@redhat.com, viro@zeniv.linux.org.uk,
        ddstreet@ieee.org, akpm@linux-foundation.org, ak@linux.intel.com,
        tglx@linutronix.de, davidlohr@hp.com, lkundrak@v3.sk,
        linux-kernel@vger.kernel.org, hpa@zytor.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, keescook@chromium.org, ast@plumgrid.com
In-Reply-To: <1410527779-8133-4-git-send-email-atomlin@redhat.com>
References: <1410527779-8133-4-git-send-email-atomlin@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add default-disabled option to BUG()
  when stack end location is overwritten
Git-Commit-ID: 0d9e26329b0c9263d4d9e0422d80a0e73268c52f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d9e26329b0c9263d4d9e0422d80a0e73268c52f
Gitweb:     http://git.kernel.org/tip/0d9e26329b0c9263d4d9e0422d80a0e73268c52f
Author:     Aaron Tomlin <atomlin@redhat.com>
AuthorDate: Fri, 12 Sep 2014 14:16:19 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:24 +0200

sched: Add default-disabled option to BUG() when stack end location is overwritten

Currently in the event of a stack overrun a call to schedule()
does not check for this type of corruption. This corruption is
often silent and can go unnoticed. However once the corrupted
region is examined at a later stage, the outcome is undefined
and often results in a sporadic page fault which cannot be
handled.

This patch checks for a stack overrun and takes appropriate
action since the damage is already done, there is no point
in continuing.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: aneesh.kumar@linux.vnet.ibm.com
Cc: dzickus@redhat.com
Cc: bmr@redhat.com
Cc: jcastillo@redhat.com
Cc: oleg@redhat.com
Cc: riel@redhat.com
Cc: prarit@redhat.com
Cc: jgh@redhat.com
Cc: minchan@kernel.org
Cc: mpe@ellerman.id.au
Cc: tglx@linutronix.de
Cc: rostedt@goodmis.org
Cc: hannes@cmpxchg.org
Cc: Alexei Starovoitov <ast@plumgrid.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1410527779-8133-4-git-send-email-atomlin@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |  3 +++
 lib/Kconfig.debug   | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4b1ddeb..61ee2b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2693,6 +2693,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
  */
 static inline void schedule_debug(struct task_struct *prev)
 {
+#ifdef CONFIG_SCHED_STACK_END_CHECK
+	BUG_ON(unlikely(task_stack_end_corrupted(prev)));
+#endif
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path. Otherwise whine
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a285900..e58163d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -824,6 +824,18 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config SCHED_STACK_END_CHECK
+	bool "Detect stack corruption on calls to schedule()"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option checks for a stack overrun on calls to schedule().
+	  If the stack end location is found to be over written always panic as
+	  the content of the corrupted region can no longer be trusted.
+	  This is to ensure no erroneous behaviour occurs which could result in
+	  data corruption or a sporadic crash at a later stage once the region
+	  is examined. The runtime overhead introduced is minimal.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
