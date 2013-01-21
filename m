Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3AUWSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:18:24 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36808 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3AUWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:18:23 -0500
Message-ID: <50FDBEAC.2050606@linaro.org>
Date: Mon, 21 Jan 2013 14:18:20 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <20130121211218.GX23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130121211218.GX23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 01:12 PM, Russell King - ARM Linux wrote:
> On Mon, Jan 21, 2013 at 01:00:15PM -0800, John Stultz wrote:
>> So if you can not get actual timer ticks any faster then 200 HZ on that
>> hardware, setting HZ higher could cause some jiffies related timer
>> trouble
> Err, no John.  It's the other way around - especially on some platforms
> which are incapable of being converted to the clock source support.
>
> EBSA110 has _one_ counter.  It counts down at a certain rate, and when
> it rolls over from 0 to FFFF, it produces an interrupt and continues
> counting down from FFFF.
>
> To produce anything close to a reasonable regular tick rate from that,
> the only way to do it is - with interrupts disabled - read the current
> value to find out how far the timer has rolled over, and set it so that
> the next event will expire as close as possible to the desired HZ rate.
>
> So, none of the clcokevent stuff can be used; and we rely _purely_ on
> counting interrupts in jiffy based increments to provide any reference
> of time.
> Moreover, because the counter is only 16-bit, and it's clocked from
> something around 7MHz, well, maths will tell you why 200Hz had to be
> chosen rather than 100Hz.

Ah, so the counter can't do anything *lower* then ~107HZ, right? (7MHZ/2^16)

So we used to have the ACTHZ code to handle error from the HZ rate 
requested and the HZ rate possible given the underlying hardware. That's 
been moved to the register_refined_jiffies(), but do you have a sense if 
there a reason it couldn't be used? I don't quite recall the bounds at 
this second, so ~7% error might very well be too large.

So yes, I suspect these sorts of platforms, where there are no modern 
clocksource/clockevent driver, as well as further constraints (like 
specific HZ) are likely not good candidates for a multi-arch build.

thanks
-john
