Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3HRBtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 21:49:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41150 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3HRBty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 21:49:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/9] nohz_full: Add Kconfig parameter for scalable detection of all-idle state
Date: Sat, 17 Aug 2013 18:49:38 -0700
Message-Id: <1376790584-28120-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818014918.GA27827@linux.vnet.ibm.com>
 <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081801-4834-0000-0000-00000A45104D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

At least one CPU must keep the scheduling-clock tick running for
timekeeping purposes whenever there is a non-idle CPU.  However, with
the new nohz_full adaptive-idle machinery, it is difficult to distinguish
between all CPUs really being idle as opposed to all non-idle CPUs being
in adaptive-ticks mode.  This commit therefore adds a Kconfig parameter
as a first step towards enabling a scalable detection of full-system
idle state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
[ paulmck: Update help text per Frederic Weisbecker. ]
---
 kernel/time/Kconfig | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 70f27e8..c7d2fd6 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -134,6 +134,29 @@ config NO_HZ_FULL_ALL
 	 Note the boot CPU will still be kept outside the range to
 	 handle the timekeeping duty.
 
+config NO_HZ_FULL_SYSIDLE
+	bool "Detect full-system idle state for full dynticks system"
+	depends on NO_HZ_FULL
+	default n
+	help
+	 At least one CPU must keep the scheduling-clock tick running for
+	 timekeeping purposes whenever there is a non-idle CPU, where
+	 "non-idle" also includes dynticks CPUs as long as they are
+	 running non-idle tasks.  Because the underlying adaptive-tick
+	 support cannot distinguish between all CPUs being idle and
+	 all CPUs each running a single task in dynticks mode, the
+	 underlying support simply ensures that there is always a CPU
+	 handling the scheduling-clock tick, whether or not all CPUs
+	 are idle.  This Kconfig option enables scalable detection of
+	 the all-CPUs-idle state, thus allowing the scheduling-clock
+	 tick to be disabled when all CPUs are idle.  Note that scalable
+	 detection of the all-CPUs-idle state means that larger systems
+	 will be slower to declare the all-CPUs-idle state.
+
+	 Say Y if you would like to help debug all-CPUs-idle detection.
+
+	 Say N if you are unsure.
+
 config NO_HZ
 	bool "Old Idle dynticks config"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-- 
1.8.1.5

