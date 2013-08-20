Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3HTCri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:47:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58337 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3HTCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:47:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/9] nohz_full: Add testing information to documentation
Date: Mon, 19 Aug 2013 19:47:14 -0700
Message-Id: <1376966841-31774-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-5518-0000-0000-000011538F3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds information about testing nohz_full, and also emphasizes
the fact that you need a multi-CPU system to get any benefit from nohz_full.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/timers/NO_HZ.txt | 44 ++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
index 8869758..cca122f 100644
--- a/Documentation/timers/NO_HZ.txt
+++ b/Documentation/timers/NO_HZ.txt
@@ -24,8 +24,8 @@ There are three main ways of managing scheduling-clock interrupts
 	workloads, you will normally -not- want this option.
 
 These three cases are described in the following three sections, followed
-by a third section on RCU-specific considerations and a fourth and final
-section listing known issues.
+by a third section on RCU-specific considerations, a fourth section
+discussing testing, and a fifth and final section listing known issues.
 
 
 NEVER OMIT SCHEDULING-CLOCK TICKS
@@ -121,14 +121,15 @@ boot parameter specifies the adaptive-ticks CPUs.  For example,
 "nohz_full=1,6-8" says that CPUs 1, 6, 7, and 8 are to be adaptive-ticks
 CPUs.  Note that you are prohibited from marking all of the CPUs as
 adaptive-tick CPUs:  At least one non-adaptive-tick CPU must remain
-online to handle timekeeping tasks in order to ensure that system calls
-like gettimeofday() returns accurate values on adaptive-tick CPUs.
-(This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no
-running user processes to observe slight drifts in clock rate.)
-Therefore, the boot CPU is prohibited from entering adaptive-ticks
-mode.  Specifying a "nohz_full=" mask that includes the boot CPU will
-result in a boot-time error message, and the boot CPU will be removed
-from the mask.
+online to handle timekeeping tasks in order to ensure that system
+calls like gettimeofday() returns accurate values on adaptive-tick CPUs.
+(This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no running
+user processes to observe slight drifts in clock rate.)  Therefore, the
+boot CPU is prohibited from entering adaptive-ticks mode.  Specifying a
+"nohz_full=" mask that includes the boot CPU will result in a boot-time
+error message, and the boot CPU will be removed from the mask.  Note that
+this means that your system must have at least two CPUs in order for
+CONFIG_NO_HZ_FULL=y to do anything for you.
 
 Alternatively, the CONFIG_NO_HZ_FULL_ALL=y Kconfig parameter specifies
 that all CPUs other than the boot CPU are adaptive-ticks CPUs.  This
@@ -232,6 +233,29 @@ scheduler will decide where to run them, which might or might not be
 where you want them to run.
 
 
+TESTING
+
+So you enable all the OS-jitter features described in this document,
+but do not see any change in your workload's behavior.  Is this because
+your workload isn't affected that much by OS jitter, or is it because
+something else is in the way?  This section helps answer this question
+by providing a simple OS-jitter test suite, which is available on branch
+master of the following git archive:
+
+git://git.kernel.org/pub/scm/linux/kernel/git/frederic/dynticks-testing.git
+
+Clone this archive and follow the instructions in the README file.
+This test procedure will produce a trace that will allow you to evaluate
+whether or not you have succeeded in removing OS jitter from your system.
+If this trace shows that you have removed OS jitter as much as is
+possible, then you can conclude that your workload is not all that
+sensitive to OS jitter.
+
+Note: this test requires that your system have at least two CPUs.
+We do not currently have a good way to remove OS jitter from single-CPU
+systems.
+
+
 KNOWN ISSUES
 
 o	Dyntick-idle slows transitions to and from idle slightly.
-- 
1.8.1.5

