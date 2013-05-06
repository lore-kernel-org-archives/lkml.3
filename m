Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3EFUJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:09:23 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:40754 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab3EFUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130506194351.GH3501@linux.vnet.ibm.com>
References: <20130506175647.GA1309@redhat.com>
	<20130506190522.GD3501@linux.vnet.ibm.com>
	<20130506192653.GA16819@redhat.com>
	<20130506194351.GH3501@linux.vnet.ibm.com>
Date: Mon, 6 May 2013 13:09:22 -0700
X-Google-Sender-Auth: 4B4ndxbERI2Zm4jJaxIoJnE6Jkc
Message-ID: <CAE9FiQU6+eQ-e=mX9A8AG5cUn0DWPS9sg3DS=B+jH3ZbXq+1Cg@mail.gmail.com>
Subject: Re: rcu_init allocation failure trace on bootup
From: Yinghai Lu <yinghai@kernel.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 12:43 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, May 06, 2013 at 03:26:53PM -0400, Dave Jones wrote:
>> On Mon, May 06, 2013 at 12:05:22PM -0700, Paul E. McKenney wrote:
>>  > On Mon, May 06, 2013 at 01:56:47PM -0400, Dave Jones wrote:
>>  > > [    0.000000]  RCU debugfs-based tracing is enabled.
>>  > > [    0.000000]  RCU lockdep checking is enabled.
>>  > > [    0.000000] ------------[ cut here ]------------
>>  > > [    0.000000] WARNING: at mm/nobootmem.c:215 ___alloc_bootmem_nopanic+0x3a/0x7d()
>>  > > [    0.000000] Modules linked in:
>>  > > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0+ #128
>>  > > [    0.000000] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1209.2006.0601.1340 06/01/2006
>>  > > [    0.000000]  ffffffff819f4246 ffffffff81c01e68 ffffffff816a0db2 ffffffff81c01ea8
>>  > > [    0.000000]  ffffffff8104b1a0 ffffffff819e1078 0000000000000000 0000000000000008
>>  > > [    0.000000]  ffffffffffffffff 0000000000000040 0000000000000000 ffffffff81c01eb8
>>  > > [    0.000000] Call Trace:
>>  > > [    0.000000]  [<ffffffff816a0db2>] dump_stack+0x19/0x1b
>>  > > [    0.000000]  [<ffffffff8104b1a0>] warn_slowpath_common+0x70/0xa0
>>  > > [    0.000000]  [<ffffffff8104b1ea>] warn_slowpath_null+0x1a/0x20
>>  > > [    0.000000]  [<ffffffff81ef8914>] ___alloc_bootmem_nopanic+0x3a/0x7d
>>  > > [    0.000000]  [<ffffffff81ef8b87>] __alloc_bootmem+0x13/0x39
>>  > > [    0.000000]  [<ffffffff81f090ad>] alloc_bootmem_cpumask_var+0x1a/0x21
>>  > > [    0.000000]  [<ffffffff81ef1f5a>] rcu_init+0x7f/0x261
>>  > > [    0.000000]  [<ffffffff81ef4acb>] ? perf_event_init+0x178/0x181
>>  > > [    0.000000]  [<ffffffff81ed6c79>] start_kernel+0x232/0x3d3
>>  > > [    0.000000]  [<ffffffff81ed6846>] ? repair_env_string+0x5e/0x5e
>>  > > [    0.000000]  [<ffffffff81ed6577>] x86_64_start_reservations+0x2a/0x2c
>>  > > [    0.000000]  [<ffffffff81ed6646>] x86_64_start_kernel+0xcd/0xd1
>>  > > [    0.000000] ---[ end trace 0acfc82c197165dd ]---
>>  > > [    0.000000]  Experimental no-CBs for all CPUs
>>  > > [    0.000000]  Experimental no-CBs CPUs: 0-1.
>>  > > [    0.000000] NO_HZ: Full dynticks CPUs: 1.
>>  >
>>  > Do you have commit fa0f93cd6a (rcu: Don't allocate bootmem from rcu_init())?
>>  > If not, could you please try applying it?
>>
>> That commit isn't in Linus tree.
>
> You are quite right, I am getting ahead of myself.  Please see below
> for the patch.
>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Don't allocate bootmem from rcu_init()
>
> When rcu_init() is called we already have slab working, allocating
> bootmem at that point results in warnings and an allocation from
> slab.  This commit therefore changes alloc_bootmem_cpumask_var() to
> alloc_cpumask_var() in rcu_bootup_announce_oddness(), which is called
> from rcu_init().
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index ca6e39c..44b0998 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -86,7 +86,7 @@ static void __init rcu_bootup_announce_oddness(void)
>  #ifdef CONFIG_RCU_NOCB_CPU
>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>         if (!have_rcu_nocb_mask) {
> -               alloc_bootmem_cpumask_var(&rcu_nocb_mask);
> +               alloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);

Do you need to use zalloc_cpumask_var instead?


>                 have_rcu_nocb_mask = true;
>         }
>  #ifdef CONFIG_RCU_NOCB_CPU_ZERO
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
