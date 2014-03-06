Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaCFFcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:32:35 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:37816 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaCFFce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:32:34 -0500
Message-ID: <1394083528.4524.3.camel@nexus>
Subject: [PATCH] sched/clock: prevent tracing recursion in sched_clock_cpu()
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, StevenRostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 14:25:28 +0900
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Prevent tracing of preempt_disable/enable() in sched_clock_cpu().
When CONFIG_DEBUG_PREEMPT is enabled, preempt_disable/enable() are
traced and this causes trace_clock() users (and probably others) to
go into an infinite recursion. Systems with a stable sched_clock()
are not affected.

This problem is similar to that fixed by upstream commit 95ef1e52922
("KVM guest: prevent tracing recursion with kvmclock").

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.14-rc5-orig/kernel/sched/clock.c linux-3.14-rc5/kernel/sched/clock.c
--- linux-3.14-rc5-orig/kernel/sched/clock.c	2014-03-06 13:37:43.567720550 +0900
+++ linux-3.14-rc5/kernel/sched/clock.c	2014-03-06 13:41:56.937100949 +0900
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


