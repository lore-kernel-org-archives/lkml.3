Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaA1MJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:09:55 -0500
Received: from goliath.siemens.de ([192.35.17.28]:40790 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaA1MJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:09:53 -0500
Message-ID: <52E79DEA.3010408@siemens.com>
Date: Tue, 28 Jan 2014 13:09:14 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
References: <52E6AFFE.3030004@siemens.com> <20140127202252.GA11821@two.firstfloor.org> <52E767C2.2090807@siemens.com> <20140128115549.GA26230@gmail.com>
In-Reply-To: <20140128115549.GA26230@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-28 12:55, Ingo Molnar wrote:
> 
> * Jan Kiszka <jan.kiszka@siemens.com> wrote:
> 
>> On 2014-01-27 21:22, Andi Kleen wrote:
>>> On Mon, Jan 27, 2014 at 08:14:06PM +0100, Jan Kiszka wrote:
>>>> apic_icr_write and its users in smpboot.c were apparently written under
>>>> the assumption that this code would only run during early boot. But
>>>> nowadays we also execute it when onlining a CPU later on while the
>>>> system is fully running. That will make wakeup_cpu_via_init_nmi and,
>>>> thus, also native_apic_icr_write run in plain process context. If we
>>>> migrate the caller to a different CPU at the wrong time or interrupt it
>>>> and write to ICR/ICR2 to send unrelated IPIs, we can end up sending
>>>> INIT, SIPI or NMIs to wrong CPUs.
>>>>
>>>> Fix this by disabling interrupts during the write to the ICR halves and
>>>> disable preemption around waiting for ICR availability and using it.
>>>
>>> If you just want to disable migration use get_cpu()/put_cpu()
>>
>> Fine with me if that is now preferred. Will that be the upstream way of
>> -rt's migrate_disable()?
> 
> Your original patch is fine, the suggestion to do ICR accesses with 
> just preemption disabled is crap and is really asking for trouble: if 
> some IRQ comes in at that point after all then it might cause all 
> sorts of hard to debug problems (hangs, delays, missed IPIs, etc.).

Of course, we still need irqs off during ICR writes. I thought Andi was
just suggesting to replace preempt_disable with get_cpu, maybe to
document why we are disabling preemption here.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
