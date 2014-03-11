Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaCKMhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:37:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbaCKMhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:37:38 -0400
Date: Tue, 11 Mar 2014 05:36:58 -0700
From: tip-bot for Fernando Luis Vazquez Cao <tipbot@zytor.com>
Message-ID: <tip-96b3d28bf4b00f62fc8386ff5d487d1830793a3d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rostedt@goodmis.org, akpm@linux-foundation.org, fernando@oss.ntt.co.jp,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rostedt@goodmis.org, akpm@linux-foundation.org, fernando@oss.ntt.co.jp,
        tglx@linutronix.de
In-Reply-To: <1394083528.4524.3.camel@nexus>
References: <1394083528.4524.3.camel@nexus>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock:
  Prevent tracing recursion in sched_clock_cpu()
Git-Commit-ID: 96b3d28bf4b00f62fc8386ff5d487d1830793a3d
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

Commit-ID:  96b3d28bf4b00f62fc8386ff5d487d1830793a3d
Gitweb:     http://git.kernel.org/tip/96b3d28bf4b00f62fc8386ff5d487d1830793a3d
Author:     Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
AuthorDate: Thu, 6 Mar 2014 14:25:28 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:33:48 +0100

sched/clock: Prevent tracing recursion in sched_clock_cpu()

Prevent tracing of preempt_disable/enable() in sched_clock_cpu().
When CONFIG_DEBUG_PREEMPT is enabled, preempt_disable/enable() are
traced and this causes trace_clock() users (and probably others) to
go into an infinite recursion. Systems with a stable sched_clock()
are not affected.

This problem is similar to that fixed by upstream commit 95ef1e52922
("KVM guest: prevent tracing recursion with kvmclock").

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1394083528.4524.3.camel@nexus
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 43c2bcc..b30a292 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -301,14 +301,14 @@ u64 sched_clock_cpu(int cpu)
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
-	preempt_disable();
+	preempt_disable_notrace();
 	scd = cpu_sdc(cpu);
 
 	if (cpu != smp_processor_id())
 		clock = sched_clock_remote(scd);
 	else
 		clock = sched_clock_local(scd);
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return clock;
 }
