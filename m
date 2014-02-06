Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaBFL1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:27:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbaBFL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:27:37 -0500
Date: Thu, 6 Feb 2014 12:27:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Message-ID: <20140206112731.GH4941@twins.programming.kicks-ass.net>
References: <20140206095646.GE17971@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206095646.GE17971@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 05:56:46PM +0800, Fengguang Wu wrote:
> Hi Peter,
> 
> We noticed the below RCU stalls which will block the system.
> The problem is bisected to
> 
> commit 8cb75e0c4ec9786b81439761eac1d18d4a931af3
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Wed Nov 20 12:22:37 2013 +0100
> Commit:     Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon Jan 13 17:38:55 2014 +0100
> 
>     sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
>     
>  arch/x86/include/asm/mwait.h |  2 +-
>  include/linux/preempt.h      | 15 +++++++++++++++
>  include/linux/sched.h        | 15 +++++++++++++++
>  kernel/cpu/idle.c            | 17 ++++++++++-------
>  kernel/sched/core.c          |  3 +--
>  5 files changed, 42 insertions(+), 10 deletions(-)
> 
> [   85.786775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=15000 jiffies g=233 c=232 q=1940)

Did the initial kernel contain the below?

---
commit 215393bc1fab3d61a5a296838bdffce22f27ffda
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Jan 22 11:24:35 2014 +0100

    sched/preempt/x86: Fix voluntary preempt for x86
    
    The #ifdef CONFIG_PREEMPT is both not needed and wrong.
    
    Its not required because asm/preempt.h should provide
    {set,clear}_preempt_need_resched() regardless and its wrong because
    for voluntary preempt we still rely on PREEMPT_NEED_RESCHED.
    
    Reported-and-Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Fixes: 8cb75e0c4ec9 ("sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding")
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Dipankar Sarma <dipankar@in.ibm.com>
    Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Link: http://lkml.kernel.org/r/20140122102435.GH31570@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 59749fc..de83b4e 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -134,7 +134,6 @@ do { \
 #undef preempt_check_resched
 #endif
 
-#ifdef CONFIG_PREEMPT
 #define preempt_set_need_resched() \
 do { \
 	set_preempt_need_resched(); \
@@ -144,10 +143,6 @@ do { \
 	if (tif_need_resched()) \
 		set_preempt_need_resched(); \
 } while (0)
-#else
-#define preempt_set_need_resched() do { } while (0)
-#define preempt_fold_need_resched() do { } while (0)
-#endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
