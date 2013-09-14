Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3INSsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:48:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37845 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab3INSsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:48:07 -0400
Date: Sat, 14 Sep 2013 11:48:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH] rcu: Fix CONFIG_RCU_NOCB_CPU_ALL panic on machines with
 sparse CPU mask
Message-ID: <20130914184801.GL3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <191071379163800@web12j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <191071379163800@web12j.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091418-5806-0000-0000-000022BCF815
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 05:03:20PM +0400, Kirill Tkhai wrote:
> When a system has a sparse cpumask and CONFIG_RCU_NOCB_CPU_ALL is enabled,
> rcu_spawn_nocb_kthreads() creates nocb threads for nonexistent CPUS.
> 
> The problem is in rcu_bootup_announce_oddness(). cpumask_setall() sets all
> bits from 0 to nr_cpu_ids existent and nonexistent CPUs both.
> 
> The sample. My cpuinfo(sparc64):
> 
> CPU0:		online
> CPU2:		online
> 
> I get these oopses every boot:
> 
> Unable to handle kernel NULL pointer dereference
> CPU: 0 PID: 23 Comm: rcuos/1 Not tainted 3.11.0+ #103
> task: fffff800be9792c0 ti: fffff800be98c000 task.ti: fffff800be98c000
> TSTATE: 0000004480e01604 TPC: 000000000047cffc TNPC: 000000000047d000 Y: 00000000    Not tainted
> TPC: <prepare_to_wait+0x38/0x5c>
> g0: 0000000000000000 g1: 0000000000000000 g2: fffff800be98fd58 g3: 0000000000acb718
> g4: fffff800be9792c0 g5: fffff800be536000 g6: fffff800be98c000 g7: 0000000000000000
> o0: 0000000000000000 o1: 0000000000a33d34 o2: 0000000000000001 o3: 0000000000000000
> o4: 0000000000000000 o5: 0000000000000000 sp: fffff800be98f3d1 ret_pc: 000000000047cfd8
> RPC: <prepare_to_wait+0x14/0x5c>
> l0: 0000000000a33ce8 l1: 0000000000000001 l2: 0000000000a7d800 l3: fffff800bf004dc0
> l4: fffff800be880310 l5: 0000000000a33ce8 l6: 0000000000ad0000 l7: 0000000000a33800
> i0: 0000000000acb710 i1: fffff800be98fd40 i2: 0000000000000001 i3: fffff800be98fd40
> i4: 0000000000000000 i5: 0000000000000000 i6: fffff800be98f491 i7: 00000000004d3f50
> I7: <rcu_nocb_kthread+0x5c/0x224>
> Call Trace:
>  [00000000004d3f50] rcu_nocb_kthread+0x5c/0x224
>  [000000000047c604] kthread+0x88/0x9c
>  [0000000000406084] ret_from_fork+0x1c/0x2c
>  [0000000000000000]           (null)
> 
> So, not possible CPUs have to be cleared.

Good catch!

I am hoping that your setup always has CPU 0 defined.  If not, there are
many other problems in addition to CONFIG_RCU_NOCB_CPU_ZERO=y!

> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Dipankar Sarma <dipankar@in.ibm.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_plugin.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 130c97b..1f17e99 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -97,6 +97,7 @@ static void __init rcu_bootup_announce_oddness(void)
>  #ifdef CONFIG_RCU_NOCB_CPU_ALL
>  	pr_info("\tOffload RCU callbacks from all CPUs\n");
>  	cpumask_setall(rcu_nocb_mask);
> +	cpumask_and(rcu_nocb_mask, cpu_possible_mask, rcu_nocb_mask);

Would it make sense to combine the cpumask_setall() and the cpumask_and()
into a single cpumask_copy()?  

>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
>  #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
>  	if (have_rcu_nocb_mask) {

Do we need a cpumask_and() within this "if" statement to handle the
case where the kernel's rcu_nocbs= boot parameter specified a CPU
that is not present?  (If so, probably also giving a warning about the
non-present CPUs specified.)

I believe that the answer to both questions is "yes", and I would
welcome an updated patch that covered these cases.

All that said...  Why does the system have a sparse cpu_possible_mask?
This does cause overallocation of memory in a number of areas, including
RCU's combining tree of rcu_node structures, to say nothing of the
cpumasks themselves.

							Thanx, Paul

