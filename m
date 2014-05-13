Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaEMP5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:57:35 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55633 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaEMP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:57:25 -0400
Date: Tue, 13 May 2014 17:57:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140513155717.GE13828@localhost.localdomain>
References: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com>
 <20140511203657.17152.79234.stgit@srivatsabhat.in.ibm.com>
 <20140512205757.GA18959@mtj.dyndns.org>
 <5371DF88.7020409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371DF88.7020409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 02:32:00PM +0530, Srivatsa S. Bhat wrote:
> 
>  kernel/stop_machine.c |   39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 01fbae5..288f7fe 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -130,8 +130,10 @@ enum multi_stop_state {
>  	MULTI_STOP_NONE,
>  	/* Awaiting everyone to be scheduled. */
>  	MULTI_STOP_PREPARE,
> -	/* Disable interrupts. */
> -	MULTI_STOP_DISABLE_IRQ,
> +	/* Disable interrupts on CPUs not in ->active_cpus mask. */
> +	MULTI_STOP_DISABLE_IRQ_INACTIVE,
> +	/* Disable interrupts on CPUs in ->active_cpus mask. */
> +	MULTI_STOP_DISABLE_IRQ_ACTIVE,
>  	/* Run the function */
>  	MULTI_STOP_RUN,
>  	/* Exit */
> @@ -189,12 +191,39 @@ static int multi_cpu_stop(void *data)
>  	do {
>  		/* Chill out and ensure we re-read multi_stop_state. */
>  		cpu_relax();
> +
> +		/*
> +		 * We use 2 separate stages to disable interrupts, namely
> +		 * _INACTIVE and _ACTIVE, to ensure that the inactive CPUs
> +		 * disable their interrupts first, followed by the active CPUs.
> +		 *
> +		 * This is done to avoid a race in the CPU offline path, which
> +		 * can lead to receiving IPIs on the outgoing CPU *after* it
> +		 * has gone offline.
> +		 *
> +		 * During CPU offline, we don't want the other CPUs to send
> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
> +		 * disabled interrupts (because, then it will notice the IPIs
> +		 * only after it has gone offline). We can prevent this by
> +		 * making the other CPUs disable their interrupts first - that
> +		 * way, they will run the stop-machine code with interrupts
> +		 * disabled, and hence won't send IPIs after that point.
> +		 */
> +
>  		if (msdata->state != curstate) {
>  			curstate = msdata->state;
>  			switch (curstate) {
> -			case MULTI_STOP_DISABLE_IRQ:
> -				local_irq_disable();
> -				hard_irq_disable();
> +			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
> +				if (!is_active) {
> +					local_irq_disable();
> +					hard_irq_disable();
> +				}
> +				break;
> +			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
> +				if (is_active) {
> +					local_irq_disable();
> +					hard_irq_disable();

I have no idea about possible IPI latencies due to hardware. But are we sure that a stop
machine transition state is enough to make sure we get a pending IPI? Shouldn't we have
some sort of IPI flush in between, like polling on call_single_queue?
