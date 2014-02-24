Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaBXGn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:43:26 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52824 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBXGnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:43:24 -0500
MIME-Version: 1.0
In-Reply-To: <CADApbeiyGoSAF9n5-+Ys1H4VDgN+d727E6ARWFGj4EixqeP79w@mail.gmail.com>
References: <20140223212703.511977310@linutronix.de>
	<20140223212737.214342433@linutronix.de>
	<20140223231755.GA27579@pengutronix.de>
	<CADApbeiyGoSAF9n5-+Ys1H4VDgN+d727E6ARWFGj4EixqeP79w@mail.gmail.com>
Date: Mon, 24 Feb 2014 14:43:23 +0800
Message-ID: <CAN1soZy_TfzNigfn4y6kF2qe4K+AQsagd-1KWYrz1VEavMO4bA@mail.gmail.com>
Subject: Re: [patch 09/26] arm: mmp: Remove pointless fiddling with irq internals
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 2:07 PM, Chao Xie <xiechao.mail@gmail.com> wrote:
> On Mon, Feb 24, 2014 at 7:17 AM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
>> Hi Thomas,
>>
>> On Sun, Feb 23, 2014 at 09:40:13PM -0000, Thomas Gleixner wrote:
>>> The pm-mmp2 and pm-pxa910 power management related irq_set_wake
>>> callbacks fiddle pointlessly with the irq actions for no reason except
>>> for lack of understanding how the wakeup mechanism works.
>>>
>>> On supsend the core disables all interrupts lazily, i.e. it does not
>>> mask them at the irq controller level. So any interrupt which is
>>> firing during supsend will mark the corresponding interrupt line as
>> s/supsend/suspend/ twice
>>> pending. Just before the core powers down it checks whether there are
>>> interrupts pending from interrupt lines which are marked as wakeup
>>> sources and if so it aborts the resume and resends the interrupts.
>> It's the suspend that is aborted, not the resume.
>>
>> Other than that your change looks fine.
>>
> For pxa910 and MMP2, wake up source only wake up the AP subsystem.
> The AP subsystem includes the APMU(AP Power Mangament Unit) and cores.
> Now the core is still powered down. APMU will check the interrupt
> lines, and find
> that there are interrupt pending, it will power on the cores.
> So if the irq is disabled, even wake up source can wake up AP subsystem, but the
> core is still powered down. It will not be powered up by APMU.
>

Yes, suspend/resume can't work if the above code is removed.

Interrupt source (logic AND with interrupt mask register) is connected
to MPMU as
wakeup source. If the interrupt is disabled, there's no wakeup source event.

And APMU is waken up by MPMU.

So please don't remove the above code. We must keep these interrupt lines active
to wake up the whole system.

Regards
Haojian
