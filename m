Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3EBLCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:02:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40697
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab3EBLCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:02:52 -0400
Date: Thu, 2 May 2013 13:01:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 2/6] sched: set initial value of runnable avg for
 new forked task
Message-ID: <20130502110108.GA13494@dyad.programming.kicks-ass.net>
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
 <1367040344-14485-3-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367040344-14485-3-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 01:25:40PM +0800, Alex Shi wrote:
> We need initialize the se.avg.{decay_count, load_avg_contrib} for a
> new forked task.
> Otherwise random values of above variables cause mess when do new task
> enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
> 
> and make forking balancing imbalance since incorrect load_avg_contrib.
> 
> set avg.decay_count = 0, and avg.load_avg_contrib = se->load.weight to
> resolve such issues.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

This patch seems sensible enough.. 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/sched/core.c | 6 ++++++
>  kernel/sched/fair.c | 4 ++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 86e87f1..e0c003a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c

> +	/* New forked task assumed with full utilization */
> +#if defined(CONFIG_SMP)
> +	p->se.avg.load_avg_contrib = p->se.load.weight;
> +#endif

We'd typically write: #ifdef CONFIG_SMP
we only use the #if defined() form for multiple CONFIG tests.
