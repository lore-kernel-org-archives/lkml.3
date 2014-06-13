Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaFMXfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:35:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:64354 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbaFMXfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,474,1400050800"; 
   d="scan'208";a="557317665"
Message-ID: <539B8AA5.90907@intel.com>
Date: Fri, 13 Jun 2014 16:35:01 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
References: <539B594C.8070004@intel.com> <20140613224519.GV4581@linux.vnet.ibm.com>
In-Reply-To: <20140613224519.GV4581@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------020200020109020605020209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020200020109020605020209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/13/2014 03:45 PM, Paul E. McKenney wrote:
> On Fri, Jun 13, 2014 at 01:04:28PM -0700, Dav
>> So, I bisected it down to this:
>>
>>> commit ac1bea85781e9004da9b3e8a4b097c18492d857c
>>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Date:   Sun Mar 16 21:36:25 2014 -0700
>>>
>>>     sched,rcu: Make cond_resched() report RCU quiescent states
>>
>> Specifically, if I raise RCU_COND_RESCHED_LIM, things get back to their
>> 3.15 levels.
>>
>> Could the additional RCU quiescent states be causing us to be doing more
>> RCU frees that we were before, and getting less benefit from the lock
>> batching that RCU normally provides?
> 
> Quite possibly.  One way to check would be to use the debugfs files
> rcu/*/rcugp, which give a count of grace periods since boot for each
> RCU flavor.  Here "*" is rcu_preempt for CONFIG_PREEMPT and rcu_sched
> for !CONFIG_PREEMPT.
> 
> Another possibility is that someone is invoking cond_reched() in an
> incredibly tight loop.

open() does at least a couple of allocations in getname(),
get_empty_filp() and apparmor_file_alloc_security() in my kernel, and
each of those does a cond_resched() via the might_sleep() in the slub
code.  This test is doing ~400k open/closes per second per CPU, so
that's ~1.2M cond_resched()/sec/CPU, but that's still hundreds of ns
between calls on average.

I'll do some more ftraces and dig in to those debugfs files early next week.

> But please feel free to send along your patch, CCing LKML.  Longer
> term, I probably need to take a more algorithmic approach, but what
> you have will be useful to benchmarkers until then.

With the caveat that I exerted approximately 15 seconds of brainpower to
code it up...patch attached.

--------------020200020109020605020209
Content-Type: text/x-patch;
 name="dirty-rcu-hack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dirty-rcu-hack.patch"



---

 b/arch/x86/kernel/nmi.c    |    3 +++
 b/include/linux/rcupdate.h |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/nmi.c~dirty-rcu-hack arch/x86/kernel/nmi.c
--- a/arch/x86/kernel/nmi.c~dirty-rcu-hack	2014-06-13 16:00:30.257183228 -0700
+++ b/arch/x86/kernel/nmi.c	2014-06-13 16:00:30.261183407 -0700
@@ -88,10 +88,13 @@ __setup("unknown_nmi_panic", setup_unkno
 
 static u64 nmi_longest_ns = 1 * NSEC_PER_MSEC;
 
+u64 RCU_COND_RESCHED_LIM = 256;
 static int __init nmi_warning_debugfs(void)
 {
 	debugfs_create_u64("nmi_longest_ns", 0644,
 			arch_debugfs_dir, &nmi_longest_ns);
+	debugfs_create_u64("RCU_COND_RESCHED_LIM", 0644,
+			arch_debugfs_dir, &RCU_COND_RESCHED_LIM);
 	return 0;
 }
 fs_initcall(nmi_warning_debugfs);
diff -puN include/linux/rcupdate.h~dirty-rcu-hack include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~dirty-rcu-hack	2014-06-13 16:00:35.578421426 -0700
+++ b/include/linux/rcupdate.h	2014-06-13 16:00:49.863060683 -0700
@@ -303,7 +303,7 @@ bool __rcu_is_watching(void);
  * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
  */
 
-#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
+extern u64 RCU_COND_RESCHED_LIM	/* ms vs. 100s of ms. */
 DECLARE_PER_CPU(int, rcu_cond_resched_count);
 void rcu_resched(void);
 
_

--------------020200020109020605020209--
