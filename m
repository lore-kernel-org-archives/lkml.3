Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbbASRsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:48:35 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:38967 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbASRse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:48:34 -0500
Date: Mon, 19 Jan 2015 17:48:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [RFC PATCH 5/5] arm: perf: Use FIQ to handle PMU events.
Message-ID: <20150119174818.GD26493@n2100.arm.linux.org.uk>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
 <1421166931-14134-6-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421166931-14134-6-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:35:31PM +0000, Daniel Thompson wrote:
> +/*
> + * This handler is called *unconditionally* from the default NMI/FIQ
> + * handler. The irq may not be anything to do with us so the main
> + * job of this function is to figure out if the irq passed in is ours
> + * or not.
> + */
> +void cpu_pmu_handle_fiq(int irq)
> +{
> +	int cpu = smp_processor_id();

This can be either debug_smp_processor_id() or raw_smp_processor_id().
raw_smp_processor_id() is fine from FIQ contexts, as seems to be
debug_smp_processor_id(), but only because we guarantee that
irqs_disabled() in there will be true.

> +
> +	if (irq != get_cpu_var(cpu_pmu_irqs))
> +		return;

get_cpu_var() needs put_cpu_var() to undo its effects.  get_cpu_var()
calls preempt_disable(), which calls into lockdep...  I think we
determined that was fine last time we went digging?  put_cpu_var()
would call preempt_enable() which I'd hope would be safe in FIQ/NMI
contexts?

> +
> +	(void)armpmu_dispatch_irq(irq,
> +				  get_cpu_ptr(&cpu_pmu->hw_events->percpu_pmu));

Again, get_cpu_xxx() needs to be balanced with a put_cpu_xxx().


-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
