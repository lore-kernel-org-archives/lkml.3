Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbaFCQ3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:29:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42530 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaFCQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:29:10 -0400
Message-ID: <1401812947.3645.231.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Date: Tue, 03 Jun 2014 09:29:07 -0700
In-Reply-To: <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
	 <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 16:40 +0200, Frederic Weisbecker wrote:
> irq work currently only supports local callbacks. However its code
> is mostly ready to run remote callbacks and we have some potential user.
> 
> The full nohz subsystem currently open codes its own remote irq work
> on top of the scheduler ipi when it wants a CPU to reevaluate its next
> tick. However this ad hoc solution bloats the scheduler IPI.
> 
> Lets just extend the irq work subsystem to support remote queuing on top
> of the generic SMP IPI to handle this kind of user. This shouldn't add
> noticeable overhead.



>   */
> +bool irq_work_queue_on(struct irq_work *work, int cpu)
> +{
> +	/* All work should have been flushed before going offline */
> +	WARN_ON_ONCE(cpu_is_offline(cpu));
> +
> +	/* Arch remote IPI send/receive backend aren't NMI safe */
> +	WARN_ON_ONCE(in_nmi());
> +
> +	/* Only queue if not already pending */
> +	if (!irq_work_claim(work))
> +		return false;
> +
> +	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
> +		native_send_call_func_single_ipi(cpu);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
> +

I am curious, this should only compile on x86, right ?



