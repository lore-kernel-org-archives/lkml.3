Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaLHSGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:06:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaLHSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:06:03 -0500
Date: Mon, 8 Dec 2014 10:06:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH wq/for-3.19 3/3] workqueue: dump workqueues on sysrq-t
Message-Id: <20141208100613.ecc66d89.akpm@linux-foundation.org>
In-Reply-To: <20141208174733.GD12274@htj.dyndns.org>
References: <20141208174326.GB12274@htj.dyndns.org>
	<20141208174406.GC12274@htj.dyndns.org>
	<20141208174733.GD12274@htj.dyndns.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014 12:47:33 -0500 Tejun Heo <tj@kernel.org> wrote:

>
> ...
>
> This patch implements show_workqueue_state() which dumps all busy
> workqueues and pools and is called from the sysrq-t handler.  At the
> end of sysrq-t dump, something like the following is printed.

Seems sensible.

sysrq-t already produces thousands of lines of output.  Maybe create a
new keycode for this?

>
> ...
>
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4419,6 +4419,174 @@ void print_worker_info(const char *log_l
>  	}
>  }
>  
> +static void pr_cont_pool_info(struct worker_pool *pool)
> +{
> +	if (pool->cpu >= 0)
> +		pr_cont(" cpu=%d", pool->cpu);
> +	else if (pool->node != NUMA_NO_NODE)
> +		pr_cont(" node=%d", pool->node);
> +
> +	if (pool->cpu < 0) {
> +		static char cpus_buf[PAGE_SIZE];

Ouch.  This could be [NR_CPUS + epsilon]?

> +		cpumask_scnprintf(cpus_buf, sizeof(cpus_buf),
> +				  pool->attrs->cpumask);
> +		pr_cont(" cpumask=%s", cpus_buf);
> +	}
> +	pr_cont(" flags=0x%x nice=%d", pool->flags, pool->attrs->nice);
> +}
> +
> +static void pr_cont_work(bool comma, struct work_struct *work)
> +{
> +	if (work->func == wq_barrier_func) {
> +		struct wq_barrier *barr =
> +			container_of(work, struct wq_barrier, work);

Can avoid the 80-col contortions with

		struct wq_barrier *barr;

		barr = container_of(work, struct wq_barrier, work);

> +		pr_cont("%s BAR(%d)", comma ? "," : "",
> +			task_pid_nr(barr->task));
> +	} else {
> +		pr_cont("%s %pf", comma ? "," : "", work->func);
> +	}
> +}
> +
> +static void show_pwq(struct pool_workqueue *pwq)
> +{
> +	struct worker_pool *pool = pwq->pool;
> +	struct work_struct *work;
> +	struct worker *worker;
> +	bool has_in_flight = false, has_pending = false;
> +	int bkt;
> +
> +	printk("  pwq %d:", pool->id);
> +	pr_cont_pool_info(pool);
> +
> +	pr_cont(" active=%d/%d%s\n", pwq->nr_active, pwq->max_active,
> +		!list_empty(&pwq->mayday_node) ? " MAYDAY" : "");
> +
> +	hash_for_each(pool->busy_hash, bkt, worker, hentry) {
> +		if (worker->current_pwq == pwq) {
> +			has_in_flight = true;
> +			break;
> +		}
> +	}
> +	if (has_in_flight) {
> +		bool comma = false;
> +
> +		printk("    in-flight:");

pr_something?  show_state() uses KERN_INFO, which may or may not be
appropriate.

> +		hash_for_each(pool->busy_hash, bkt, worker, hentry) {
> +			if (worker->current_pwq != pwq)
> +				continue;
> +
> +			pr_cont("%s %d%s:%pf", comma ? "," : "",
> +				task_pid_nr(worker->task),
> +				worker == pwq->wq->rescuer ? "(RESCUER)" : "",
> +				worker->current_func);
> +			list_for_each_entry(work, &worker->scheduled, entry)
> +				pr_cont_work(false, work);
> +			comma = true;
> +		}
> +		pr_cont("\n");
> +	}
> +
> +	list_for_each_entry(work, &pool->worklist, entry) {
> +		if (get_work_pwq(work) == pwq) {
> +			has_pending = true;
> +			break;
> +		}
> +	}
> +	if (has_pending) {
> +		bool comma = false;
> +
> +		printk("    pending:");

ditto

> +		list_for_each_entry(work, &pool->worklist, entry) {
> +			if (get_work_pwq(work) != pwq)
> +				continue;
> +
> +			pr_cont_work(comma, work);
> +			comma = !(*work_data_bits(work) & WORK_STRUCT_LINKED);
> +		}
> +		pr_cont("\n");
> +	}
> +
> +	if (!list_empty(&pwq->delayed_works)) {
> +		bool comma = false;
> +
> +		printk("    delayed:");

ditto

> +		list_for_each_entry(work, &pwq->delayed_works, entry) {
> +			pr_cont_work(comma, work);
> +			comma = !(*work_data_bits(work) & WORK_STRUCT_LINKED);
> +		}
> +		pr_cont("\n");
> +	}
> +}
> +
>
> ...
