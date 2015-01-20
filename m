Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbbATKJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:09:42 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:39183 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbATKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:04:49 -0500
Message-ID: <54BE2842.5000205@linaro.org>
Date: Tue, 20 Jan 2015 10:04:50 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [RFC PATCH 5/5] arm: perf: Use FIQ to handle PMU events.
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org> <1421166931-14134-6-git-send-email-daniel.thompson@linaro.org> <20150119174818.GD26493@n2100.arm.linux.org.uk>
In-Reply-To: <20150119174818.GD26493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/01/15 17:48, Russell King - ARM Linux wrote:
> On Tue, Jan 13, 2015 at 04:35:31PM +0000, Daniel Thompson wrote:
>> +/*
>> + * This handler is called *unconditionally* from the default NMI/FIQ
>> + * handler. The irq may not be anything to do with us so the main
>> + * job of this function is to figure out if the irq passed in is ours
>> + * or not.
>> + */
>> +void cpu_pmu_handle_fiq(int irq)
>> +{
>> +	int cpu = smp_processor_id();
> 
> This can be either debug_smp_processor_id() or raw_smp_processor_id().
> raw_smp_processor_id() is fine from FIQ contexts, as seems to be
> debug_smp_processor_id(), but only because we guarantee that
> irqs_disabled() in there will be true.

Curiously I was looking at exactly this yesterday (because I was
intrigued why the NMI-safe bits of kgdb use raw_smp_processor_id() but
the x86 arch_trigger_all_cpu_backtrace() implementation uses
smp_processor_id()).

Given the comments make clear smp_processor_id() is the preferred
variant except for false positives I concluded I would continue with
smp_processor_id() for any code I write hanging off the default FIQ
handler. No objections?


>> +
>> +	if (irq != get_cpu_var(cpu_pmu_irqs))
>> +		return;
> 
> get_cpu_var() needs put_cpu_var() to undo its effects.  get_cpu_var()
> calls preempt_disable(), which calls into lockdep...  I think we
> determined that was fine last time we went digging?

Yes. We reviewed lockdep from the point-of-view of RCU and found that
lockdep disabled most of itself when in_nmi() is true.

> put_cpu_var()
> would call preempt_enable() which I'd hope would be safe in FIQ/NMI
> contexts?

Yes.

preempt_count_add/sub form part of the work done by nmi_enter() and
nmi_exit().

However this code gets no benefit from calling get_cpu_var(). I think it
would be better to switch it to this_cpu_ptr.


>> +
>> +	(void)armpmu_dispatch_irq(irq,
>> +				  get_cpu_ptr(&cpu_pmu->hw_events->percpu_pmu));
> 
> Again, get_cpu_xxx() needs to be balanced with a put_cpu_xxx().
> 
> 

