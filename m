Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3LRQzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:55:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52369 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3LRQzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:55:48 -0500
Date: Wed, 18 Dec 2013 17:55:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131218165508.GB30183@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123353.180539582@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217123353.180539582@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 01:27:29PM +0100, Peter Zijlstra wrote:
> @@ -4381,6 +4592,13 @@ static int __migrate_task(struct task_st
>  		goto fail;
>  
>  	/*
> +	 * If p is -deadline, proceed only if there is enough
> +	 * bandwidth available on dest_cpu
> +	 */
> +	if (unlikely(dl_task(p)) && !set_task_cpu_dl(p, dest_cpu))
> +		goto fail;
> +
> +	/*
>  	 * If we're not on a rq, the next wake-up will ensure we're
>  	 * placed properly.
>  	 */

I just noticed this one.. we can't do this.

The reason we cannot do this is because:

  CPU_DYING -> migration_call() -> migrate_tasks() -> __migrate_task()

cannot fail and hard assumes it _will_ move all tasks off of the dying
cpu, failing this will break hotplug.

Also, I'm not entirely sure why this hunk exists. For GEDF we don't need
this constraints AFAIK, as long as we guarantee we run the N earliest
deadlines, it only matters what the total utilization (root domain wide)
is, the per-cpu utilization is irrelevant.

If the purpose is to fail hotplug because taking out the CPU would end
up in over-subscription, then we need a DOWN_PREPARE handler.

Dario, Juri?
