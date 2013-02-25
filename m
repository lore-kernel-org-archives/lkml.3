Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3BYGLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 01:11:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34170 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3BYGLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 01:11:40 -0500
Message-ID: <512B00E0.8030801@ti.com>
Date: Mon, 25 Feb 2013 11:42:48 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
References: <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com> <alpine.LFD.2.02.1302212214020.22263@ionos> <5127436E.4040100@ti.com> <alpine.LFD.2.02.1302221122290.22263@ionos> <20130222103149.GC12140@e102568-lin.cambridge.arm.com> <51275058.7010809@ti.com> <alpine.LFD.2.02.1302221212500.22263@ionos> <20130222144829.GG12140@e102568-lin.cambridge.arm.com> <alpine.LFD.2.02.1302221558000.22263@ionos> <20130222152639.GH12140@e102568-lin.cambridge.arm.com> <alpine.LFD.2.02.1302221946070.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302221946070.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2013 12:22 AM, Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Lorenzo Pieralisi wrote:
>> On Fri, Feb 22, 2013 at 03:03:02PM +0000, Thomas Gleixner wrote:
>>> On Fri, 22 Feb 2013, Lorenzo Pieralisi wrote:
>>>> On Fri, Feb 22, 2013 at 12:07:30PM +0000, Thomas Gleixner wrote:
>>>>> Now we could make use of that and avoid going deep idle just to come
>>>>> back right away via the IPI. Unfortunately the notification thingy has
>>>>> no return value, but we can fix that.
>>>>>
>>>>> To confirm that theory, could you please try the hack below and add
>>>>> some instrumentation (trace_printk)?
>>>>
>>>> Applied, and it looks like that's exactly why the warning triggers, at least
>>>> on the platform I am testing on which is a dual-cluster ARM testchip.
>>>>
I too confirm that the warnings cause is same.

>>>> There is a still time window though where the CPU (the IPI target) can get
>>>> back to idle (tick_broadcast_pending still not set) before the CPU target of
>>>> the broadcast has a chance to run tick_handle_oneshot_broadcast (and set
>>>> tick_broadcast_pending), or am I missing something ?
>>>
>>> Well, the tick_broadcast_pending bit is uninteresting if the
>>> force_broadcast bit is set. Because if that bit is set we know for
>>> sure, that we got woken with the cpu which gets the broadcast timer
>>> and raced back to idle before the broadcast handler managed to
>>> send the IPI.
>>
>> Gah, my bad sorry, I mixed things up. I thought
>>
>> tick_check_broadcast_pending()
>>
>> was checking against the tick_broadcast_pending mask not
>>
>> tick_force_broadcast_mask
>
> Yep, that's a misnomer. I just wanted to make sure that my theory is
> correct. I need to think about the real solution some more.
>
> We have two alternatives:
>
> 1) Make the clockevents_notify function have a return value.
>
> 2) Add something like the hack I gave you with a proper name.
>
> The latter has the beauty, that we just need to modify the platform
> independent idle code instead of going down to every callsite of the
> clockevents_notify thing.
>
I agree that 2 is better alternative to avoid multiple changes.
Whichever alternative you choose, will be happy to test it :)

Regards,
Santosh
