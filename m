Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3LTX3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:29:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:3162 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751259Ab3LTX3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:29:49 -0500
Date: Fri, 20 Dec 2013 18:29:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131220182946.09ca0f04@gandalf.local.home>
In-Reply-To: <20131220214413.GF7959@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
	<20131217123353.180539582@infradead.org>
	<20131218165508.GB30183@twins.programming.kicks-ass.net>
	<20131220171343.GL2480@laptop.programming.kicks-ass.net>
	<20131220123707.44fb7192@gandalf.local.home>
	<20131220174200.GX16438@laptop.programming.kicks-ass.net>
	<20131220132323.524cf2b1@gandalf.local.home>
	<20131220214413.GF7959@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 22:44:13 +0100
Peter Zijlstra <peterz@infradead.org> wrote:


> @@ -5056,10 +5018,28 @@ static int sched_cpu_inactive(struct not
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_DOWN_PREPARE:
>  		set_cpu_active((long)hcpu, false);
> -		return NOTIFY_OK;
> -	default:
> -		return NOTIFY_DONE;
> +		break;
>  	}
> +
> +	switch (action) {
> +	case CPU_DOWN_PREPARE: /* explicitly allow suspend */

Instead of the double switch (which is quite confusing), what about
just adding:

	if (!(action & CPU_TASKS_FROZEN))

I mean, the above switch gets called for both cases, this only gets
called for the one case. This case is a subset of the above. I don't
see why an if () would not be better than a double (confusing) switch().

Also, it seems that this change also does not return NOTIFY_DONE if
something other than CPU_DOWN_PREPARE is passed in.

-- Steve

> +		{
> +			struct dl_bw *dl_b = dl_bw_of(cpu);
> +			bool overflow;
> +			int cpus;
> +
> +			raw_spin_lock_irqsave(&dl_b->lock, flags);
> +		       	cpus = dl_bw_cpus(cpu);
> +			overflow = __dl_overflow(dl_b, cpus, 0, 0);
> +			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
> +
> +			if (overflow)
> +				return notifier_from_errno(-EBUSY);
> +		}
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
>  }
>  
>  static int __init migration_init(void)

