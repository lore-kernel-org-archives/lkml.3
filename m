Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaF3Nyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:54:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64209 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaF3Nyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:54:31 -0400
Message-ID: <53B16C03.7090503@linaro.org>
Date: Mon, 30 Jun 2014 14:54:11 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v6 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-5-git-send-email-daniel.thompson@linaro.org> <20140624160844.GV32514@n2100.arm.linux.org.uk> <53ABEDC9.6020407@linaro.org>
In-Reply-To: <53ABEDC9.6020407@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/14 10:54, Daniel Thompson wrote:
>> Also bear in mind that svc_entry calls trace_hardirqs_off - is this
>> appropriate and safe for the FIQ to call?
> 
> I personally think it appropriate and it looked safe on the lockdep side
> of things. However I will look a bit deeper at this since I don't
> remember how far I chased things back.

I've reviewed as far as I can.

Regarding safety I can't find anything much to upset the FIQ handler. I
think it might occasionally trigger the trace code's recursion avoidance
causing the trace event to be dropped but that's about it.

I admit I came very close to removing the trace_hardirqs calls from the
FIQ code but in the end I've left it. The hardirqs *are* off during FIQ
execution.


>>> +	msr	cpsr_c, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT
>>
>> Here we switch to FIQ mode.  What about the PSR_A_BIT which prevents
>> imprecise aborts on ARMv6+ ?
>>
>> Nevertheless, I think it's safe because the A bit will be set by the
>> CPU when taking the FIQ exception, and it should remain set since
>> cpsr_c won't modify it.
> 
> Agreed.
> 
> Note that while double checking this I realized that this code will drop
> the value of PSR_ISETSTATE (T bit) that the vector_stub macro set for
> us. I'll fix this.

I was wrong about this. CPSR T bit is part of execution state can cannot
be modified by msr.


> I've picked out the following actions from the above:
> 
> 1. Wrap a save and restore lr_abt and spsr_abt around the FIQ handler

Done.

> 2. Add a paired up trace_hardirqs_on() (and review more deeply).

Done.

> 3. Add comments explaining hazards w.r.t. data abort,

Done.

> 4. Correctly manage T bit during transition back to FIQ mode.

Not applicable.

> Do I miss anything?

I hope not!


Daniel.
