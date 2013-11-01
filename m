Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3KALIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:08:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3KALIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:08:31 -0400
Date: Fri, 1 Nov 2013 11:08:25 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: peterz@infradead.org, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
Message-ID: <20131101110825.GX2400@suse.de>
References: <20131031163144.0fd27457@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131031163144.0fd27457@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 04:31:44PM -0400, Rik van Riel wrote:
> There is a race between stop_two_cpus, and the global stop_cpus.
> 

What was the trigger for this? I want to see what was missing from my own
testing. I'm going to go out on a limb and guess that CPU hotplug was also
running in the background to specifically stress this sort of rare condition.
Something like running a standard test with the monitors/watch-cpuoffline.sh
from mmtests running in parallel.

> It is possible for two CPUs to get their stopper functions queued
> "backwards" from one another, resulting in the stopper threads
> getting stuck, and the system hanging. This can happen because
> queuing up stoppers is not synchronized.
> 
> This patch adds synchronization between stop_cpus (a rare operation),
> and stop_two_cpus.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> Prarit is running a test with this patch. By now the kernel would have
> crashed already, yet it is still going. I expect Prarit will add his
> Tested-by: some time tomorrow morning.
> 
>  kernel/stop_machine.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 32a6c44..46cb4c2 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -40,8 +40,10 @@ struct cpu_stopper {
>  };
>  
>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
> +static DEFINE_PER_CPU(bool, stop_two_cpus_queueing);
>  static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
>  static bool stop_machine_initialized = false;
> +static bool stop_cpus_queueing = false;
>  
>  static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
>  {
> @@ -261,16 +263,37 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
>  	cpu_stop_init_done(&done, 2);
>  	set_state(&msdata, MULTI_STOP_PREPARE);
>  
> + wait_for_global:
> +	/* If a global stop_cpus is queuing up stoppers, wait. */
> +	while (unlikely(stop_cpus_queueing))
> +		cpu_relax();
> +

This partially serialises callers to migrate_swap() while it is checked
if the pair of CPUs are being affected at the moment. It's two-stage
locking. The global lock is short-lived while the per-cpu data is updated
and the per-cpu values allow a degree of parallelisation on call_cpu which
could not be done with a spinlock held anyway.  Why not make protection
of the initial update a normal spinlock? i.e.

spin_lock(&stop_cpus_queue_lock);
this_cpu_write(stop_two_cpus_queueing, true);
spin_unlock(&stop_cpus_queue_lock);

and get rid of the barriers and gogo wait_for_global loop entirely? I'm not
seeing the hidden advantage. The this_cpu_write(stop_two_cpus_queueing, false)
would also need to be within the lock as would the checks in queue_stop_cpus_work.

The locks look bad but it's not clear to me why the barriers and retries
are better.

-- 
Mel Gorman
SUSE Labs
