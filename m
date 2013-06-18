Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab3FRST3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:19:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33648 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab3FRST2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:19:28 -0400
Date: Tue, 18 Jun 2013 11:17:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <liljegren.mats2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Full dynticks selftests 0.0.1
Message-ID: <20130618181733.GS5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130612151915.GD5332@somewhere>
 <0000013f57a89d51-89f08a58-65d0-41f5-aaaa-b31d60c72a8e-000000@email.amazonses.com>
 <20130618151520.GP5146@linux.vnet.ibm.com>
 <20130618162256.GH17619@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618162256.GH17619@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061818-7182-0000-0000-000007637C05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:22:57PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 18, 2013 at 08:15:20AM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 18, 2013 at 02:20:35PM +0000, Christoph Lameter wrote:
> > > On Wed, 12 Jun 2013, Frederic Weisbecker wrote:
> > > 
> > > > Here it is, a very basic test that runs a userspace loop for ten seconds and dumps a trace
> > > > of the tick, scheduler, workqueue, and other kind of kernel noise.
> > > 
> > > Excellent. Ticks are finally off here. Also has useful instructions on how
> > > to figure out if something was wrong. The number of >1 microsecond
> > > disturbances went down from 110 per second to 2.
> > 
> > Very cool!
> > 
> > Frederic, is the git tree mentioned in your email permanent?  If so, I
> > will add it to the documentation.
> 
> Yep, it should be permanent.

How about the following?

							Thanx, Paul

------------------------------------------------------------------------

nohz_full: Add testing information to documentation

This commit adds information about testing nohz_full, and also emphasizes
the fact that you need a multi-CPU system to get any benefit from nohz_full.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

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

