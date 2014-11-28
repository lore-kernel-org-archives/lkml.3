Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaK1JV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:21:58 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44022 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaK1JVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:21:53 -0500
Message-ID: <54783EA8.9080409@linaro.org>
Date: Fri, 28 Nov 2014 09:21:44 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3.18-rc4 v11 3/6] irqchip: gic: Make gic_raise_softirq
 FIQ-safe
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-4-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411272238190.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411272238190.3961@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/14 21:45, Thomas Gleixner wrote:
> On Thu, 27 Nov 2014, Daniel Thompson wrote:
>> It is currently possible for FIQ handlers to re-enter gic_raise_softirq()
>> and lock up.
>>
>>     	gic_raise_softirq()
>> 	   lock(x);
>> -~-> FIQ
>>         handle_fiq()
>> 	   gic_raise_softirq()
>> 	      lock(x);		<-- Lockup
>>
>> Calling printk() from a FIQ handler can trigger this problem because
>> printk() raises an IPI when it needs to wake_up_klogd(). More generally,
>> IPIs are the only means for FIQ handlers to safely defer work to less
>> restrictive calling context so the function to raise them really needs
>> to be FIQ-safe.
> 
> That's not really true. irq_work can be used from FIQ/NMI context and
> it was specifically designed for that purpose.

Actually we cannot currently issue irq_work used from FIQ context;
that's exactly what this patch fixes and is why wake_up_klogd()
currently locks up. ARM implements arch_irq_work_raise() using IPIs (at
least on SMP).

I'll fix the wording to make this more explicit.


> Now printk is a different issue, but there is work in progress to make
> printk safe from FIQ/NMI context as well. This is not an ARM specific
> issue. Any architecture which has NMI like facilities has the problem
> of doing printk from that context. Steven is working on a mitigation
> for that. https://lkml.org/lkml/2014/11/18/1146

Thanks. I'll watch that with interest.

In that case I'll drop the printk() rationale entirely. The rationale
above shoudl be enough motivation because the only other thing likely to
printk() from interrupt is the hard lockup detector and, because that
uses perf events, it requires irq_work be be free from lockups way
before it ever thinks about calling printk().

