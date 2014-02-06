Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbaBFLq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:46:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:4115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbaBFLq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:46:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="470775467"
Date: Thu, 6 Feb 2014 19:46:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Message-ID: <20140206114635.GA27429@localhost>
References: <20140206095646.GE17971@localhost>
 <20140206112731.GH4941@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206112731.GH4941@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 12:27:31PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2014 at 05:56:46PM +0800, Fengguang Wu wrote:
> > Hi Peter,
> > 
> > We noticed the below RCU stalls which will block the system.
> > The problem is bisected to
> > 
> > commit 8cb75e0c4ec9786b81439761eac1d18d4a931af3
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Wed Nov 20 12:22:37 2013 +0100
> > Commit:     Ingo Molnar <mingo@kernel.org>
> > CommitDate: Mon Jan 13 17:38:55 2014 +0100
> > 
> >     sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
> >     
> >  arch/x86/include/asm/mwait.h |  2 +-
> >  include/linux/preempt.h      | 15 +++++++++++++++
> >  include/linux/sched.h        | 15 +++++++++++++++
> >  kernel/cpu/idle.c            | 17 ++++++++++-------
> >  kernel/sched/core.c          |  3 +--
> >  5 files changed, 42 insertions(+), 10 deletions(-)
> > 
> > [   85.786775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=15000 jiffies g=233 c=232 q=1940)
> 
> Did the initial kernel contain the below?

Nope, so I was testing some old tip sched/core..  Bisect log is

# good: [v3.13-rc1] Linux 3.13-rc1
git bisect good v3.13-rc1
# bad: [130816ce4d5f69167324f7272e70aa3d641677c6] sched, thermal: Clean up preempt_enable_no_resched() abuse
git bisect bad 130816ce4d5f69167324f7272e70aa3d641677c6
# good: [v3.13-rc1] Linux 3.13-rc1
git bisect good v3.13-rc1
# bad: [130816ce4d5f69167324f7272e70aa3d641677c6] sched, thermal: Clean up preempt_enable_no_resched() abuse
git bisect bad 130816ce4d5f69167324f7272e70aa3d641677c6
# skip: [fb00aca474405f4fa8a8519c3179fed722eabd83] rtmutex: Turn the plist into an rb-tree
git bisect skip fb00aca474405f4fa8a8519c3179fed722eabd83
# good: [c9c8986847d2f4fc474c10ee08afa57e7474096d] Merge branch 'x86/idle' into sched/core
git bisect good c9c8986847d2f4fc474c10ee08afa57e7474096d
# bad: [1774e9f3e5c8b38de3b3bc8bd0eacd280f655baf] sched, net: Clean up preempt_enable_no_resched() abuse
git bisect bad 1774e9f3e5c8b38de3b3bc8bd0eacd280f655baf
# bad: [8cb75e0c4ec9786b81439761eac1d18d4a931af3] sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
git bisect bad 8cb75e0c4ec9786b81439761eac1d18d4a931af3
# first bad commit: [8cb75e0c4ec9786b81439761eac1d18d4a931af3] sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding

Thanks,
Fengguang

> ---
> commit 215393bc1fab3d61a5a296838bdffce22f27ffda
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Jan 22 11:24:35 2014 +0100
> 
>     sched/preempt/x86: Fix voluntary preempt for x86
>     
>     The #ifdef CONFIG_PREEMPT is both not needed and wrong.
>     
>     Its not required because asm/preempt.h should provide
>     {set,clear}_preempt_need_resched() regardless and its wrong because
>     for voluntary preempt we still rely on PREEMPT_NEED_RESCHED.
>     
>     Reported-and-Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
>     Fixes: 8cb75e0c4ec9 ("sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding")
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Cc: Dipankar Sarma <dipankar@in.ibm.com>
>     Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>     Link: http://lkml.kernel.org/r/20140122102435.GH31570@twins.programming.kicks-ass.net
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index 59749fc..de83b4e 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -134,7 +134,6 @@ do { \
>  #undef preempt_check_resched
>  #endif
>  
> -#ifdef CONFIG_PREEMPT
>  #define preempt_set_need_resched() \
>  do { \
>  	set_preempt_need_resched(); \
> @@ -144,10 +143,6 @@ do { \
>  	if (tif_need_resched()) \
>  		set_preempt_need_resched(); \
>  } while (0)
> -#else
> -#define preempt_set_need_resched() do { } while (0)
> -#define preempt_fold_need_resched() do { } while (0)
> -#endif
>  
>  #ifdef CONFIG_PREEMPT_NOTIFIERS
>  
