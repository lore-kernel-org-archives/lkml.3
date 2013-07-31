Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab3GaN6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:58:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18279 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab3GaN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:58:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Jul 2013 06:58:27 -0700
Message-ID: <51F91AEE.1030900@nvidia.com>
Date: Wed, 31 Jul 2013 19:40:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] irq: enable suspended EARLY_RESUME irqs forcefully if
 not resumed
References: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com> <alpine.DEB.2.02.1307191649080.4089@ionos.tec.linutronix.de> <20130722154934.GD30300@phenom.dumpdata.com> <20130722193208.GA22334@phenom.dumpdata.com>
In-Reply-To: <20130722193208.GA22334@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 July 2013 01:02 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 22, 2013 at 11:49:34AM -0400, Konrad Rzeszutek Wilk wrote:
>> On Fri, Jul 19, 2013 at 05:29:16PM +0200, Thomas Gleixner wrote:
>>> On Tue, 9 Jul 2013, Laxman Dewangan wrote:
>>>> When system enters into suspend, it disable all irqs in single
>>>> function call. This disables EARLY_RESUME irqs also along with
>>>> normal irqs.
>>>>
>>>> The EARLY_RESUME irqs get enabled in sys_core_ops->resume and
>>>> non-EARLY_RESUME irqs get enabled in normal system resume path.
>>>>
>>>> When suspend_noirq failed or suspend is aborted for any reason,
>>>> the EARLY_RESUME irqs do not get enabled as sys_core_ops->resume()
>>>> call did not happen. It only enables the non-EARLY_RESUME irqs in normal
>>>> disable for remaining life of system.
>>>>
>>>> Add checks on normal irq_resume() whether EARLY_RESUME irqs have been
>>>> enabled or not and if not then enable it forcefully.
>>>   
>>>>   
>>>> +static bool early_resume_irq_suspended;
>>>> +
>>> Instead of doing that status dance, we could simply reenable all
>>> interrupts in irq_resume(). There's nothing wrong to unmask the few
>>> IRQF_EARLY_RESUME interrupts again.
>>>
>>> Just the XEN ones might be upset. Konrad ?
>> It should not. I did test it and it ran just fine throught the
>> gauntlet test - but let me check it with me looking at the console.
> It is good. You can add an Acked-by-and-Tested-by from me if you would
> like. Thanks!

Hi Thomas,
Can your change be applied now if this is good? I am fine with the 
following change.
If you want, I can send this change through patch or you can take my 
Ack, whatever is good.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

>>> Thanks,
>>>
>>> 	tglx
>>>
>>> Index: linux-2.6/kernel/irq/pm.c
>>> ===================================================================
>>> --- linux-2.6.orig/kernel/irq/pm.c
>>> +++ linux-2.6/kernel/irq/pm.c
>>> @@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
>>>   		bool is_early = desc->action &&
>>>   			desc->action->flags & IRQF_EARLY_RESUME;
>>>   
>>> -		if (is_early != want_early)
>>> +		if (!is_early && want_early)
>>>   			continue;
>>>   
>>>   		raw_spin_lock_irqsave(&desc->lock, flags);

