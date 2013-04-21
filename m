Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3DUS4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:56:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60343 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3DUS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:56:14 -0400
Date: Sun, 21 Apr 2013 11:56:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421185609.GD3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421181035.GC4559@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042118-2398-0000-0000-0000138DB001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 08:10:35PM +0200, Borislav Petkov wrote:
> On Sun, Apr 21, 2013 at 06:56:54PM +0200, Borislav Petkov wrote:
> > Ok, let me try to disable the soundcard in the BIOS.
> 
> Ok, there's no warning message anymore but maybe a dozen of seconds
> delay before the machine is actually powered off.

That is not so good...

> "...
> ACPI: Preparing to enter system sleep state S5
> [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> <a bunch of seconds of doing nothing>
> ...
> <machine powers off>"
> 
> So could it be that some RCU cleanup stuff is going on during that time?

CONFIG_RCU_FAST_NO_HZ will definitely change the timing, for example,
increasing grace-period durations by up to a factor of four.

One way to figure out if this is the problem would be to either (1) apply
the following patch (assuming you have no more than a few tens of CPUs)
or (2) setting the sysfs rcutree.rcu_expedited variable to 1 just before
suspending the system.

Either approach will force RCU to always use the faster expedited
grace periods for synchronize_rcu() and friends.  They will -not- help
if someone has open-coded synchronize_rcu() in terms of call_rcu(),
though.

> I mean, the issue is not that big of a deal - when the box resumes, the
> sound card works just fine so...

Fair point.  perhaps we should wait for Takashi to weigh in.

							Thanx, Paul

> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --


------------------------------------------------------------------------

rcu: Not for inclusion: Force expedited grace periods

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a9610d1..55c5ef6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2420,7 +2420,7 @@ void synchronize_sched(void)
 			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	if (rcu_expedited)
+	if (1)
 		synchronize_sched_expedited();
 	else
 		wait_rcu_gp(call_rcu_sched);
@@ -2447,7 +2447,7 @@ void synchronize_rcu_bh(void)
 			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	if (rcu_expedited)
+	if (1)
 		synchronize_rcu_bh_expedited();
 	else
 		wait_rcu_gp(call_rcu_bh);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 46b93b0..190a199 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -711,7 +711,7 @@ void synchronize_rcu(void)
 			   "Illegal synchronize_rcu() in RCU read-side critical section");
 	if (!rcu_scheduler_active)
 		return;
-	if (rcu_expedited)
+	if (1)
 		synchronize_rcu_expedited();
 	else
 		wait_rcu_gp(call_rcu);

