Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaGZTX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:23:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaGZTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro <registosites@hotmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, Bin Gao <bin.gao@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stefani Seibold <stefani@seibold.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.15 092/109] x86, tsc: Fix cpufreq lockup
Date: Sat, 26 Jul 2014 12:02:54 -0700
Message-Id: <20140726190226.626324865@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -920,9 +920,9 @@ static int time_cpufreq_notifier(struct
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
 			mark_tsc_unstable("cpufreq changes");
-	}
 
-	set_cyc2ns_scale(tsc_khz, freq->cpu);
+		set_cyc2ns_scale(tsc_khz, freq->cpu);
+	}
 
 	return 0;
 }


