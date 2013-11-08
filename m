Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab3KHXf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:35:26 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:42564 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab3KHXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:35:25 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <527D5D5C.2080409@codeaurora.org>
References: <526DBEAA.4030707@linaro.org>
	<1382984701-2371-1-git-send-email-sboyd@codeaurora.org>
	<878uxcq1m7.fsf@linaro.org>
	<20131029060058.GD21983@codeaurora.org>
	<CAOesGMhjC=NDn4YiY4tQ3ZcW_rK9_qOY03CVD1eyVFC74ucdrA@mail.gmail.com>
	<CAOesGMhB2Akf_B2_J3LVdt1bDvcsTE7+8Kq=NvsXmkf3EwGsiw@mail.gmail.com>
	<527D5D5C.2080409@codeaurora.org>
Date: Fri, 8 Nov 2013 15:35:24 -0800
Message-ID: <CAOesGMhyPaMUs3XJshqZ-KYhtWhenttq7qDpF0+4dQ9PvBYVGA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 1:53 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 11/08/13 12:45, Olof Johansson wrote:
>> On Fri, Nov 8, 2013 at 12:06 PM, Olof Johansson <olof@lixom.net> wrote:
>>> On Mon, Oct 28, 2013 at 11:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>> On 10/28, Kevin Hilman wrote:
>>>>> Stephen Boyd <sboyd@codeaurora.org> writes:
>>>>>
>>>>>> This will allow the scheduler tick to be restarted if we're in
>>>>>> full NOHZ mode.
>>>>>>
>>>>>> Cc: Kevin Hilman <khilman@linaro.org>
>>>>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>>> Minor nit, but I'd prefer a more verbose changelog (I forget things
>>>>> quickly and like to rely on changelogs for my memory.)  Probably worth
>>>>> adding something like: "By default, irq_work is tied to the tick
>>>>> processing (update_process_times()) but in full NOHZ mode, no tick means
>>>>> no IRQ work.  In order for IRQ work to be done in full NOHZ mode, a
>>>>> self-IPI is used to process IRQ work."
>>>>>
>>>>> Other than the changelog nit, patch looks good, feel free to add
>>>>>
>>>>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>>>>>
>>>>> If Russell is OK with this, it can go to his patch system.
>>>>>
>>>> Fair enough. This is what I came up with. I'll send it off to the
>>>> patch tracker in about 12 hours if nobody else has anymore
>>>> comments.
>>>>
>>>> ----8<-----
>>>> ARM: Support arch_irq_work_raise() via self IPIs
>>>>
>>>> By default, IRQ work is run from the tick interrupt (see
>>>> irq_work_run() in update_process_times()). When we're in full
>>>> NOHZ mode, restarting the tick requires the use of IRQ work and
>>>> if the only place we run IRQ work is in the tick interrupt we
>>>> have an unbreakable cycle. Implement arch_irq_work_raise() via
>>>> self IPIs to break this cycle and get the tick started again.
>>>> Note that we implement this via IPIs which are only available on
>>>> SMP builds. This shouldn't be a problem because full NOHZ is only
>>>> supported on SMP builds anyway.
>>>>
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>>
>>> Hm, so I think this just landed in -next, which seems... late for
>>> 3.13. Anyway, it causes boot failures on Cubieboards (Allwinner A10),
>>> I just bisected it down to this patch (fails to boot
>>> multi_v7_defconfig, no console output at all).
>>>
>>> Unfortunately I'm not getting any debug_ll output from the board at
>>> the moment, so I can't actually get to a panic stack or other error
>>> info. :( I hope I can get back to you with one later today.
>> Turns out that I hit this on the BeagleBone as well, and I got a trace
>> out of it. Seems like this might be broken on all non-SMP platforms
>> built with CONFIG_SMP=y?
>
> Ah yes. We don't have IPI support on UP kernels but SMP_ON_UP exposes
> arch_irq_work_raise(). How about this? We should just skip this function
> if we're running on UP.

Yep.

Tested-by: Olof Johansson <olof@lixom.net>

Send it to Russell's tracker, plz.


-Olof
