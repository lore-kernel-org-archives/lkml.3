Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3IWUPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:15:13 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53714 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3IWUPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:15:10 -0400
Date: Mon, 23 Sep 2013 13:14:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH] rcu: Fix CONFIG_RCU_NOCB_CPU_ALL panic on machines with
 sparse CPU mask
Message-ID: <20130923201449.GT9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <191071379163800@web12j.yandex.ru>
 <20130914184801.GL3966@linux.vnet.ibm.com>
 <13641379251757@web21g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13641379251757@web21g.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092320-3532-0000-0000-000001A60F2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 05:29:17PM +0400, Kirill Tkhai wrote:
> 14.09.2013, 22:48, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>:
> > On Sat, Sep 14, 2013 at 05:03:20PM +0400, Kirill Tkhai wrote:
> >
> >>  When a system has a sparse cpumask and CONFIG_RCU_NOCB_CPU_ALL is enabled,
> >>  rcu_spawn_nocb_kthreads() creates nocb threads for nonexistent CPUS.
> >>
> >>  The problem is in rcu_bootup_announce_oddness(). cpumask_setall() sets all
> >>  bits from 0 to nr_cpu_ids existent and nonexistent CPUs both.
> >>
> >>  The sample. My cpuinfo(sparc64):
> >>
> >>  CPU0: online
> >>  CPU2: online
> >>
> >>  I get these oopses every boot:
> >>
> >>  Unable to handle kernel NULL pointer dereference
> >>  CPU: 0 PID: 23 Comm: rcuos/1 Not tainted 3.11.0+ #103
> >>  task: fffff800be9792c0 ti: fffff800be98c000 task.ti: fffff800be98c000
> >>  TSTATE: 0000004480e01604 TPC: 000000000047cffc TNPC: 000000000047d000 Y: 00000000    Not tainted
> >>  TPC: <prepare_to_wait+0x38/0x5c>
> >>  g0: 0000000000000000 g1: 0000000000000000 g2: fffff800be98fd58 g3: 0000000000acb718
> >>  g4: fffff800be9792c0 g5: fffff800be536000 g6: fffff800be98c000 g7: 0000000000000000
> >>  o0: 0000000000000000 o1: 0000000000a33d34 o2: 0000000000000001 o3: 0000000000000000
> >>  o4: 0000000000000000 o5: 0000000000000000 sp: fffff800be98f3d1 ret_pc: 000000000047cfd8
> >>  RPC: <prepare_to_wait+0x14/0x5c>
> >>  l0: 0000000000a33ce8 l1: 0000000000000001 l2: 0000000000a7d800 l3: fffff800bf004dc0
> >>  l4: fffff800be880310 l5: 0000000000a33ce8 l6: 0000000000ad0000 l7: 0000000000a33800
> >>  i0: 0000000000acb710 i1: fffff800be98fd40 i2: 0000000000000001 i3: fffff800be98fd40
> >>  i4: 0000000000000000 i5: 0000000000000000 i6: fffff800be98f491 i7: 00000000004d3f50
> >>  I7: <rcu_nocb_kthread+0x5c/0x224>
> >>  Call Trace:
> >>   [00000000004d3f50] rcu_nocb_kthread+0x5c/0x224
> >>   [000000000047c604] kthread+0x88/0x9c
> >>   [0000000000406084] ret_from_fork+0x1c/0x2c
> >>   [0000000000000000]           (null)
> >>
> >>  So, not possible CPUs have to be cleared.
> >
> > Good catch!
> >
> > I am hoping that your setup always has CPU 0 defined.  If not, there are
> > many other problems in addition to CONFIG_RCU_NOCB_CPU_ZERO=y!
> 
> I've never seen machines like you said, but it seem they are possible. boot_cpu_init() accounts
> the fact kernel may boot from not zero CPU:
> 
> static void __init boot_cpu_init(void)
> {
>         int cpu = smp_processor_id();
>         /* Mark the boot cpu "present", "online" etc for SMP and UP case */
>         set_cpu_online(cpu, true);
>         set_cpu_active(cpu, true);
>         set_cpu_present(cpu, true);
>         set_cpu_possible(cpu, true);
> }
> 
> >>  Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> >>  CC: Dipankar Sarma <dipankar@in.ibm.com>
> >>  CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>  ---
> >>   kernel/rcutree_plugin.h |    1 +
> >>   1 files changed, 1 insertions(+), 0 deletions(-)
> >>  diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> >>  index 130c97b..1f17e99 100644
> >>  --- a/kernel/rcutree_plugin.h
> >>  +++ b/kernel/rcutree_plugin.h
> >>  @@ -97,6 +97,7 @@ static void __init rcu_bootup_announce_oddness(void)
> >>   #ifdef CONFIG_RCU_NOCB_CPU_ALL
> >>           pr_info("\tOffload RCU callbacks from all CPUs\n");
> >>           cpumask_setall(rcu_nocb_mask);
> >>  + cpumask_and(rcu_nocb_mask, cpu_possible_mask, rcu_nocb_mask);
> >
> > Would it make sense to combine the cpumask_setall() and the cpumask_and()
> > into a single cpumask_copy()?
> >
> >>   #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> >>   #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
> >>           if (have_rcu_nocb_mask) {
> >
> > Do we need a cpumask_and() within this "if" statement to handle the
> > case where the kernel's rcu_nocbs= boot parameter specified a CPU
> > that is not present?  (If so, probably also giving a warning about the
> > non-present CPUs specified.)
> >
> > I believe that the answer to both questions is "yes", and I would
> > welcome an updated patch that covered these cases.
> 
> Yes and yes. New patch is below.
> 
> > All that said...  Why does the system have a sparse cpu_possible_mask?
> > This does cause overallocation of memory in a number of areas, including
> > RCU's combining tree of rcu_node structures, to say nothing of the
> > cpumasks themselves.
> 
> In case of sparc64 the cpu number is configured by boot/openprom. Kernel
> doesn't change it. I have not touched inside of them, so I don't know.
> 
> [PATCH] rcu: Fix CONFIG_RCU_NOCB_CPU_ALL panic on machines with sparse CPU mask
> 
> Some architectures have sparse cpu mask. UltraSparc's cpuinfo for example:
> 
> CPU0: online
> CPU2: online
> 
> So, set only possible CPUs when CONFIG_RCU_NOCB_CPU_ALL is enabled.
> 
> Also, check that user passes right 'rcu_nocbs=' option.
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Dipankar Sarma <dipankar@in.ibm.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Queued for 3.13 with modification called out by scripts/checkpatch.pl.
Please run scripts/checkpatch.pl on future patches before submitting.

							Thanx, Paul

> ---
>  kernel/rcutree_plugin.h |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 130c97b..0b5d673 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -96,10 +96,16 @@ static void __init rcu_bootup_announce_oddness(void)
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
>  #ifdef CONFIG_RCU_NOCB_CPU_ALL
>  	pr_info("\tOffload RCU callbacks from all CPUs\n");
> -	cpumask_setall(rcu_nocb_mask);
> +	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
>  #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
>  	if (have_rcu_nocb_mask) {
> +		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
> +			pr_info("\tNote: kernel parameter 'rcu_nocbs=' "
> +				"contains nonexistent CPUs.\n");
> +			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
> +				    rcu_nocb_mask);
> +		}
>  		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
>  		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
>  		if (rcu_nocb_poll)
> 

