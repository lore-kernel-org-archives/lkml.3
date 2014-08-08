Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaHHUxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:53:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaHHUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, Bin Gao <bin.gao@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stefani Seibold <stefani@seibold.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 110/259] x86, tsc: Fix cpufreq lockup
Date: Fri,  8 Aug 2014 13:38:53 -0700
Message-Id: <1407530482-4483-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 3896c329df8092661dac80f55a8c3f60136fd61a upstream.

Mauro reported that his AMD X2 using the powernow-k8 cpufreq driver
locked up when doing cpu hotplug.

Because we called set_cyc2ns_scale() from the time_cpufreq_notifier()
unconditionally, it gets called multiple times for each freq change,
instead of only the once, when the tsc_khz value actually changes.

Because it gets called more than once, we run out of cyc2ns data slots
and stall, waiting for a free one, but because we're half way offline,
there's no consumers to free slots.

By placing the call inside the condition that actually changes tsc_khz
we avoid superfluous calls and avoid the problem.

Reported-by: Mauro <registosites@hotmail.com>
Tested-by: Mauro <registosites@hotmail.com>
Fixes: 20d1c86a5776 ("sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs")
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Bin Gao <bin.gao@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/tsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d4..66af9af 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -722,9 +722,9 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
 			mark_tsc_unstable("cpufreq changes");
-	}
 
-	set_cyc2ns_scale(tsc_khz, freq->cpu);
+		set_cyc2ns_scale(tsc_khz, freq->cpu);
+	}
 
 	return 0;
 }
-- 
1.9.1

