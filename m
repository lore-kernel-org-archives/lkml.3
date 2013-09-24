Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750775Ab3IXHn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:43:57 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60889 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:43:56 -0400
Date: Tue, 24 Sep 2013 09:43:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 3/4] Use raw_cpu_ops for refresh_cpu_vm_stats()
Message-ID: <20130924074351.GF28538@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c47a1ab-17a7541e-54ac-4c15-8a02-66c83c358cbd-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001414c47a1ab-17a7541e-54ac-4c15-8a02-66c83c358cbd-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> We do not care about races for the expiration logic in
> refresh_cpu_vm_stats(). Draining is a rare act after all.
> No need to create too much overhead for that.
> 
> Use raw_cpu_ops there.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/mm/vmstat.c
> ===================================================================
> --- linux.orig/mm/vmstat.c	2013-09-23 10:20:31.742262228 -0500
> +++ linux/mm/vmstat.c	2013-09-23 10:20:31.738262268 -0500
> @@ -439,6 +439,10 @@ static inline void fold_diff(int *diff)
>   * statistics in the remote zone struct as well as the global cachelines
>   * with the global counters. These could cause remote node cache line
>   * bouncing and will have to be only done when necessary.
> + *
> + * Note that we have to use raw_cpu ops here. The thread is pinned
> + * to a specific processor but the preempt checking logic does not
> + * know about this.

That's not actually true - debug_smp_processor_id() does a check for the 
pinning status of the current task:

        /*
         * Kernel threads bound to a single CPU can safely use
         * smp_processor_id():
         */
        if (cpumask_equal(tsk_cpus_allowed(current), cpumask_of(this_cpu)))
                goto out;

You should factor out those existing debug checks and reuse them, instead 
of using inferior ones.

Note that debug_smp_processor_id() can probably be optimized a bit: today 
we have p->nr_cpus_allowed which tracks the pinning status, so instead of 
the above line we could write this cheaper form:

	if (current->nr_cpus_allowed == 1)
		goto out;

(This should help on kernels configured for larger systems where the 
cpumask is non-trivial.)

What we cannot do is to hide the weakness of the debug check you added by 
adding various workarounds to core code.

Thanks,

	Ingo
