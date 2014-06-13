Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaFMUEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:04:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:45052 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaFMUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:04:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,473,1400050800"; 
   d="scan'208";a="557172616"
Message-ID: <539B594C.8070004@intel.com>
Date: Fri, 13 Jun 2014 13:04:28 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: [bisected] pre-3.16 regression on open() scalability
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I'm seeing a regression when comparing 3.15 to Linus's current tree.
I'm using Anton Blanchard's will-it-scale "open1" test which creates a
bunch of processes and does open()/close() in a tight loop:

> https://github.com/antonblanchard/will-it-scale/blob/master/tests/open1.c

At about 50 cores worth of processes, 3.15 and the pre-3.16 code start
to diverge, with 3.15 scaling better:

	http://sr71.net/~dave/intel/3.16-open1regression-0.png

Some profiles point to a big increase in contention inside slub.c's
get_partial_node() (the allocation side of the slub code) causing the
regression.  That particular open() test is known to do a lot of slab
operations.  But, the odd part is that the slub code hasn't been touched
much.

So, I bisected it down to this:

> commit ac1bea85781e9004da9b3e8a4b097c18492d857c
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Sun Mar 16 21:36:25 2014 -0700
> 
>     sched,rcu: Make cond_resched() report RCU quiescent states

Specifically, if I raise RCU_COND_RESCHED_LIM, things get back to their
3.15 levels.

Could the additional RCU quiescent states be causing us to be doing more
RCU frees that we were before, and getting less benefit from the lock
batching that RCU normally provides?

The top RCU functions in the profiles are as follows:

> 3.15.0-xxx:     2.58%  open1_processes  [kernel.kallsyms]   [k] file_free_rcu                             
> 3.15.0-xxx:     2.45%  open1_processes  [kernel.kallsyms]   [k] __d_lookup_rcu                            
> 3.15.0-xxx:     2.41%  open1_processes  [kernel.kallsyms]   [k] rcu_process_callbacks                     
> 3.15.0-xxx:     1.87%  open1_processes  [kernel.kallsyms]   [k] __call_rcu.constprop.10                   

> 3.16.0-rc0:     2.68%  open1_processes  [kernel.kallsyms]  [k] rcu_process_callbacks                     
> 3.16.0-rc0:     2.68%  open1_processes  [kernel.kallsyms]  [k] file_free_rcu                             
> 3.16.0-rc0:     1.55%  open1_processes  [kernel.kallsyms]  [k] __call_rcu.constprop.10                   
> 3.16.0-rc0:     1.28%  open1_processes  [kernel.kallsyms]  [k] __d_lookup_rcu                     

With everything else equal, we'd expect to see all of these _higher_ in
the profiles on a the faster kernel (3.15) since it has more RCU work to do.

But, they're all _roughly_ the same.  __d_lookup_rcu went up in the
profile on the fast one (3.15) probably because there _were_ more
lookups happening there.

rcu_process_callbacks makes me syspicious.  It went up slightly
(probably in the noise), but it _should_ have dropped due to there being
less RCU work to do.

This supports the theory that there are more callbacks happening than
before, causing more slab lock contention, which is the actual trigger
for the performance drop.

I also hacked in an interface to make RCU_COND_RESCHED_LIM a tunable.
Making it huge instantly makes my test go fast, and dropping it to 256
instantly makes it slow.  Some brief toying with it shows that
RCU_COND_RESCHED_LIM has to be about 100,000 before performance gets
back to where it was before.
