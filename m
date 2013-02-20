Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab3BTJnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:43:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55263 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab3BTJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:43:01 -0500
Message-ID: <1361353360.10155.9.camel@laptop>
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in
 fork/exec/wake
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 10:42:40 +0100
In-Reply-To: <1361164062-20111-10-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	 <1361164062-20111-10-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 13:07 +0800, Alex Shi wrote:
> +/*
> + * Try to collect the task running number and capacity of the group.
> + */
> +static void get_sg_power_stats(struct sched_group *group,
> +       struct sched_domain *sd, struct sg_lb_stats *sgs)
> +{
> +       int i;
> +
> +       for_each_cpu(i, sched_group_cpus(group)) {
> +               struct rq *rq = cpu_rq(i);
> +
> +               sgs->group_utils += rq->nr_running;
> +       }
> +
> +       sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
> +                                               SCHED_POWER_SCALE);
> +       if (!sgs->group_capacity)
> +               sgs->group_capacity = fix_small_capacity(sd, group);
> +       sgs->group_weight = group->group_weight;
> +}

So you're trying to compute the group utilization, but what does that
have to do with nr_running? In an earlier patch you introduced the
per-cpu utilization, so why not avg that to compute the group
utilization?

