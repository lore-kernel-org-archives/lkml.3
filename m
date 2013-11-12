Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3KLKc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:32:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55172 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:32:57 -0500
Date: Tue, 12 Nov 2013 11:32:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        l.majewski@samsung.com
Subject: Re: [RFC][PATCH v5 05/14] sched: add a packing level knob
Message-ID: <20131112103228.GE4971@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382097147-30088-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:52:18PM +0200, Vincent Guittot wrote:
> +int sched_proc_update_packing(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos)
> +{
> +	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +	if (ret || !write)
> +		return ret;
> +
> +	if (sysctl_sched_packing_level)
> +		sd_pack_threshold = (100 * 1024) / sysctl_sched_packing_level;
> +
> +	return 0;
> +}

> +#ifdef CONFIG_SCHED_PACKING_TASKS
> +static int min_sched_packing_level;
> +static int max_sched_packing_level = 100;
> +#endif /* CONFIG_SMP */

> +#ifdef CONFIG_SCHED_PACKING_TASKS
> +	{
> +		.procname	= "sched_packing_level",
> +		.data		= &sysctl_sched_packing_level,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= sched_proc_update_packing,
> +		.extra1		= &min_sched_packing_level,
> +		.extra2		= &max_sched_packing_level,
> +	},
> +#endif

Shouldn't min_sched_packing_level be 1? Userspace can now write 0 and
expect something; but then we don't update sd_pack_threshold so nothing
really changed.
