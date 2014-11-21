Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbaKUJuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:50:20 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41458 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbaKUJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:50:16 -0500
Message-ID: <546F0ACA.7010007@linaro.org>
Date: Fri, 21 Nov 2014 09:50:02 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, patches@linaro.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to
 one SPI
References: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411210016360.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411210016360.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/14 23:30, Thomas Gleixner wrote:
> On Thu, 20 Nov 2014, Daniel Thompson wrote:
>> +/*
>> + * The PMU IRQ lines of all cores are muxed onto a single interrupt.
>> + * Rotate the interrupt around the cores if the current CPU cannot
>> + * figure out why the interrupt has been triggered.
>> + */
>> +static irqreturn_t imx6q_pmu_handler(int irq, void *dev, irq_handler_t handler)
>> +{
>> +	irqreturn_t ret = handler(irq, dev);
>> +	int next;
>> +
>> +	if (ret == IRQ_NONE && num_online_cpus() > 1) {
> 
> What guarantees that ret == IRQ_HANDLED is a sign for 'this is only
> for this particular core' interrupt ?

It isn't guaranteed. We rely on re-entering the interrupt handler if
more than one PMU is raising the interrupt simultaneously.

> 
>> +		next = cpumask_next(smp_processor_id(), cpu_online_mask);
>> +		if (next > nr_cpu_ids)
>> +			next = cpumask_next(-1, cpu_online_mask);
>> +		irq_set_affinity(irq, cpumask_of(next));
>> +	}
> 
> Aside of the fact, that the hardware designers who came up with such a
> brainfart should be put on sane drugs, this is just silly.
> 
> Rotating that thing around will introduce arbitrary latencies and
> dependencies on other interrupts to be handled.

To be honest I viewed the only real merits of the rotation workaround to
be that it is simple and minimally invasive. I am in total agreement
that there are profiling use cases that it will handle badly (although
there are a useful set which this workaround is sufficient to support).

> So if there is really no way to figure out which of the cores is the
> actual target of the PMU interrupt

PMU is only accessible via the bus if you are a external debugger
(signals external to the cluster control the register windowing). From
the kernel we have to use the co-processor interface and can only see
our own PMU.

> then you should simply broadcast
> that interrupt to a designated per cpu vector async from the one which
> handles it in the first place and be done with it. That's the only
> sane option you have.

As it happens I was planning to do some work on rebroadcasting next
anyway regardless of this discussion because I can't call
irq_set_affinity() from a FIQ handler...

Options I considered to rebroadcast are either direct use of an (new and
ARM specific?) IPI or use of smp_call_function() from a tasklet. I was
inclined to rule out the tasklet because it has the potential for far
greater timing jitter than rotating the affinity (doesn't it?).

> Until now I assumed that on the core components side only timers and
> interrupt controllers are supposed to be designed by janitors, but
> there seems to be some more evil efforts underway.

For now I have been assuming that problems like that are early teething
troubles for the SoC integrators rather than a class of problem that
will keep re-emerging over and over again. We've seen newer designs that
use PPIs to hook up the PMU and systems integrated that way can never
exhibit this problem.

Anyhow on that basis I'm hopeful (but not certain) that we won't see 8-
or 16- core systems that exhibit this issue.

