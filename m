Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbaKTXai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:30:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:53690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbaKTXah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:30:37 -0500
Date: Fri, 21 Nov 2014 00:30:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, patches@linaro.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to
 one SPI
In-Reply-To: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1411210016360.6439@nanos>
References: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Daniel Thompson wrote:
> +/*
> + * The PMU IRQ lines of all cores are muxed onto a single interrupt.
> + * Rotate the interrupt around the cores if the current CPU cannot
> + * figure out why the interrupt has been triggered.
> + */
> +static irqreturn_t imx6q_pmu_handler(int irq, void *dev, irq_handler_t handler)
> +{
> +	irqreturn_t ret = handler(irq, dev);
> +	int next;
> +
> +	if (ret == IRQ_NONE && num_online_cpus() > 1) {

What guarantees that ret == IRQ_HANDLED is a sign for 'this is only
for this particular core' interrupt ?

> +		next = cpumask_next(smp_processor_id(), cpu_online_mask);
> +		if (next > nr_cpu_ids)
> +			next = cpumask_next(-1, cpu_online_mask);
> +		irq_set_affinity(irq, cpumask_of(next));
> +	}

Aside of the fact, that the hardware designers who came up with such a
brainfart should be put on sane drugs, this is just silly.

Rotating that thing around will introduce arbitrary latencies and
dependencies on other interrupts to be handled.

So if there is really no way to figure out which of the cores is the
actual target of the PMU interrupt then you should simply broadcast
that interrupt to a designated per cpu vector async from the one which
handles it in the first place and be done with it. That's the only
sane option you have.

Until now I assumed that on the core components side only timers and
interrupt controllers are supposed to be designed by janitors, but
there seems to be some more evil efforts underway.

Thanks,

	tglx
