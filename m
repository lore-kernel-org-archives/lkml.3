Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3AYHbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:31:45 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:41751 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AYHbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130125071933.GA17846@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
 <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
 <20130124141930.GA14881@gmail.com> <CAOMZO5CC76Md9T=2z3RWi4GrKsUuFcc8VYV1QfmZWF41vnOhVw@mail.gmail.com>
 <20130125071933.GA17846@gmail.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 24 Jan 2013 23:31:11 -0800
Message-ID: <CAPM31RKPZeNhUx5OCzE2+Rr=5qSL72=tgRpacZwFos9p-cajAg@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
To: Ingo Molnar <mingo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Fabio Estevam <festevam@gmail.com> wrote:
>
>> On Thu, Jan 24, 2013 at 12:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> > I suppose - is this patch warning-free both on 64-bit and 32-bit
>> > systems?
>>
>> Yes, just confirmed that this patch is warning-free on both 64-bit and
>> 32-bit machines.
>
> Apparently it's not all good, see the warning attached below.

Yeah this patch is broken; this is not properly fixable as is without
#ifdefs (or fixing the insanity that is atomic64_read).

Specifically:

On some architectures (e.g. x86_64) atomic64_read is typed long
On some others (e.g. x86-32) it's typed long long
On yet others (e.g. arm) it's typed u64

I think the easiest way to fix it would be instead to promote the read
into a local u64 and print that.

>
> Thanks,
>
>         Ingo
>
> ----- Forwarded message from kbuild test robot <fengguang.wu@intel.com> -----
>
> Date: Fri, 25 Jan 2013 14:02:05 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Subject: [next:akpm 188/817] kernel/sched/debug.c:225:2: warning: format '%llu' expects argument
>         of type 'long long unsigned int', but argument 4 has type 'long int'
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> head:   5d2ee7d8b03bfe3b90325d736d8e544d0394efa7
> commit: 2d58000fd2020255af63ee92c8d0ef615f6c4ade [188/817] sched: Fix print format for u64
> config: make ARCH=x86_64 allmodconfig
>
> All warnings:
>
>    kernel/sched/debug.c: In function 'print_cfs_rq':
>>> kernel/sched/debug.c:225:2: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 4 has type 'long int' [-Wformat]
>>> kernel/sched/debug.c:225:2: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 3 has type 'long int' [-Wformat]
>
> vim +225 kernel/sched/debug.c
>
>    209          spread = max_vruntime - MIN_vruntime;
>    210          SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread",
>    211                          SPLIT_NS(spread));
>    212          spread0 = min_vruntime - rq0_min_vruntime;
>    213          SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
>    214                          SPLIT_NS(spread0));
>    215          SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
>    216                          cfs_rq->nr_spread_over);
>    217          SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
>    218          SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
>    219  #ifdef CONFIG_FAIR_GROUP_SCHED
>    220  #ifdef CONFIG_SMP
>    221          SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
>    222                          cfs_rq->runnable_load_avg);
>    223          SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
>    224                          cfs_rq->blocked_load_avg);
>  > 225          SEQ_printf(m, "  .%-30s: %llu\n", "tg_load_avg",
>    226                          atomic64_read(&cfs_rq->tg->load_avg));
>    227          SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
>    228                          cfs_rq->tg_load_contrib);
>    229          SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
>    230                          cfs_rq->tg_runnable_contrib);
>    231          SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
>    232                          atomic_read(&cfs_rq->tg->runnable_avg));
>    233  #endif
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>
> ----- End forwarded message -----
>
