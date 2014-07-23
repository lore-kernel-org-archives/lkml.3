Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbaGWOpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:45:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37852 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaGWOpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:45:13 -0400
Date: Wed, 23 Jul 2014 07:45:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] rcu: Some minor fixes and cleanups
Message-ID: <20140723144509.GW11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072314-6688-0000-0000-000003809B18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:37AM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> This is a series of minor fixes and cleanup patches which I found while studying
> the code. All my previous pending (but not rejected ;) patches are superseded by
> this series, expect the rcutorture snprintf changes. I am still waiting for you
> to decide on that one :)
> 
> These changes have been tested by the kvm rcutorture test setup. Some tests give
> me stall warnings, but otherwise have SUCCESS messages in the logs.

For patches 1, 3, 5, 8, 12, and 13, once you get a Reviewed-by from one
of the co-maintainers or designated reviewers, I will queue them.
The other patches I have responded to.

>                                                                     But those
> are occuring even without these changes with the tip paul/rcu/dev. May be it is
> because I am running them for a duration of 4 minutes each only?

When you say "stall warnings", do you mean RCU CPU stall warnings?
I don't see those.  They might be due to your having fewer CPUs than
some of the tests call for.  It might be worth trying to tell the test
to leave one or two of your CPUs alone.  One way to do this is to give
the script a maxcpus= boot argument.

If you instead mean the "BAD SEQ" warning out of the kvm.sh script,
this can happen due to KVM/qemu losing IPIs.  I have been holding off
making RCU tolerate IPI lossage on the grounds that this is a KVM/qemu
bug that needs fixing.

On run duration...  It depends:

o	If you are changing boot-time-only code, it is best to use very
	short test times (such as your four minutes).  If there is any
	non-determistic aspect to the change, you should of course run
	the test several times.

o	For deterministic changes to code paths, running each test for
	30 minutes might suffice.

o	For changes subject to concurrency effects, the test duration
	depends on the probabilities.  Typical run length might be
	four hours per test.  I have reason to believe that there have
	been some bugs that occurred roughly once per hundred hours
	of test time.

	This means that in general, pure testing is insufficient for RCU.

Of course, for many bugs, the more CPUs you throw at it, the more likely
the bug.  It would be good to enhance rcutorture to make these sorts
of bugs more likely to occur on smaller systems.  Or for the formal
validation guys to raise their game so as to be able to deal with RCU.  ;-)

							Thanx, Paul

> --
> Pranith.
> 
> Pranith Kumar (16):
>   rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
>   rcu: Check return value for cpumask allocation
>   rcu: Fix comment for gp_state field values
>   rcu: Remove redundant check for an online CPU
>   rcu: Add noreturn attribute to boost kthread
>   rcu: Clear gp_flags only when actually starting new gp
>   rcu: Save and restore irq flags in rcu_gp_cleanup()
>   rcu: Clean up rcu_spawn_one_boost_kthread()
>   rcu: Remove redundant check for online cpu
>   rcu: Check for RCU_FLAG_GP_INIT bit in gp_flags for spurious wakeup
>   rcu: Check for spurious wakeup using return value
>   rcu: Rename rcu_spawn_gp_kthread() to rcu_spawn_kthreads()
>   rcu: Spawn nocb kthreads from rcu_prepare_kthreads()
>   rcu: Remove redundant checks for rcu_scheduler_fully_active
>   rcu: Check for a nocb cpu before trying to spawn nocb threads
>   rcu: kvm.sh: Fix error when you pass --cpus argument
> 
>  kernel/rcu/tree.c                             | 42 ++++++++++++++-------------
>  kernel/rcu/tree.h                             |  4 +--
>  kernel/rcu/tree_plugin.h                      | 40 +++++++++++++------------
>  tools/testing/selftests/rcutorture/bin/kvm.sh |  4 +--
>  4 files changed, 47 insertions(+), 43 deletions(-)
> 
> -- 
> 2.0.0.rc2
> 

