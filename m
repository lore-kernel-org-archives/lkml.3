Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaK0KrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:47:19 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40584 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbaK0KrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:47:17 -0500
Message-ID: <5477011F.5020509@linux.vnet.ibm.com>
Date: Thu, 27 Nov 2014 16:16:55 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, peterz@infradead.org,
        mingo@kernel.org
CC: linux-kernel@vger.kernel.org, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, riel@redhat.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com, vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Shilpa Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 6/7] sched: cfs: cpu frequency scaling based on task
 placement
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org> <1413958051-7103-7-git-send-email-mturquette@linaro.org>
In-Reply-To: <1413958051-7103-7-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112710-0025-0000-0000-0000014146D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 11:37 AM, Mike Turquette wrote:
> {en,de}queue_task_fair are updated to track which cpus will have changed
> utilization values as function of task queueing. The affected cpus are
> passed on to arch_eval_cpu_freq for further machine-specific processing
> based on a selectable policy.
> 
> arch_scale_cpu_freq is called from run_rebalance_domains as a way to
> kick off the scaling process (via wake_up_process), so as to prevent
> re-entering the {en,de}queue code.
> 
> All of the call sites in this patch are up for discussion. Does it make
> sense to track which cpus have updated statistics in enqueue_fair_task?
> I chose this because I wanted to gather statistics for all cpus affected
> in the event CONFIG_FAIR_GROUP_SCHED is enabled. As agreed at LPC14 the
> next version of this patch will focus on the simpler case of not using
> scheduler cgroups, which should remove a good chunk of this code,
> including the cpumask stuff.
> 
> Also discussed at LPC14 is that fact that load_balance is a very
> interesting place to do this as frequency can be considered in concert
> with task placement. Please put forth any ideas on a sensible way to do
> this.

I believe load balancing would be the right place to evaluate the
frequency at which CPUs must run. find_busiest_group() is already
iterating through all the CPUs and calculating the load on them. So this
information is readily available and that which remains to be seen is
which of the CPUs in the group have their load > some_threshold and
queue a kthread on that cpu to scale its frequency, while the current
cpu continues with its load balancing.

There is another positive I see in evaluating cpu frequency in load
balancing. The frequency at which load balancing is run is already
optimized for scalability. One of the factors that is considered is if
any sibling cpus has carried out load balancing in the recent past, the
current cpu defers doing the same. This means it is naturally ensured
that only one cpu in the power domain takes care of frequency scaling
each time and there is no need of explicit synchronization between the
policy cpus to do this.

Regards
Preeti U Murthy

