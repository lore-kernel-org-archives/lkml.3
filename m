Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbbACQQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:16:05 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36252 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbACQQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:16:03 -0500
MIME-Version: 1.0
In-Reply-To: <20150103153446.GA23591@kahuna>
References: <1420220628-23742-1-git-send-email-nm@ti.com>
	<1420220628-23742-3-git-send-email-nm@ti.com>
	<CA+Ln22Epd8VpA9DQPFYBdjewUY3ejODhaRHgBSNZAQCYjx5saw@mail.gmail.com>
	<20150103153446.GA23591@kahuna>
Date: Sun, 4 Jan 2015 01:16:02 +0900
Message-ID: <CA+Ln22Ejvwd9J=jnWAUeb=nn-cvWiptqOydax+z4BeMrww_xqg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] ARM: l2c: AM437x: Introduce support for cache
 filter programming
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Santosh <ssantosh@kernel.org>, Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-04 0:34 GMT+09:00 Nishanth Menon <nm@ti.com>:
> On 15:40-20150103, Tomasz Figa wrote:
>> Hi Nishanth,
>>
>> 2015-01-03 2:43 GMT+09:00 Nishanth Menon <nm@ti.com>:
>> > AM437x generation of processors support programming the PL310 L2Cache
>> > controller's address filter start and end registers using a secure
>> > montior service.
>>
>> typo: s/montior/monitor/
>>
>> [snip]
>
> Uggh.. yes indeed. I will post a v3 updating the comments. If the
> following is ok.
>>
>> > +               base = omap4_get_l2cache_base();
>> > +               filter_start = (reg == L310_ADDR_FILTER_START) ? val :
>> > +                              readl_relaxed(base + L310_ADDR_FILTER_START);
>> > +               filter_end = (reg == L310_ADDR_FILTER_END) ? val :
>> > +                              readl_relaxed(base + L310_ADDR_FILTER_END);
>> > +               omap_smc1_2(AM43X_MON_L2X0_SETFILTER_INDEX, filter_start,
>> > +                           filter_end);
>> > +               return;
>>
>> I don't have any significant comments about this patch in particular,
>> but just noticed that you need to do read-backs here (and the typo
>> thanks to the spell checker of my mailing app). Maybe you should
>> consider switching to the .configure() API I introduced in my series?
>> This would let you get rid of the hardcoded static mapping.
>
> Yeah, I have two choices there.. Either I provide the fundamental
> write function for the generic l2c code to use OR I provide a
> duplicate of resultant l2c_configure(aux write) + l2c310_configure.
>
> To allow for reuse of improvements or anything like errata
> implementations in the future, OMAP L2C implementation has chosen to provide the
> low level code and allow the higherlevel configure/write/whatever of the
> future to stay in arch/arm/mm/cache-l2x0.c. The write_sec operation is
> not too complicated enough to warrant a replication of l2c310_configure.
>
> So, I prefer the current implementation than providing a .configure
> handler for outer_cache.configure from SoC level.
>
> Let me know if anyone has a strong objection to this.

Well, what l2c310_configure() does after my series is just writing the
registers. If they cannot be written normally (without some tricks
such as reading back other registers) then IMHO a separate function
should be provided.

This is becomes possible after patch 3/8 (ARM: l2c: Add interface to
ask hypervisor to configure L2C) and what is used on Exynos which also
updates multiple registers in single SMC calls. You can find an
example of use in patch 6/8 (ARM: EXYNOS: Add .write_sec outer cache
callback for L2C-310). What's even more interesting is that approaches
similar to the one currently used on OMAP had been NAKed, when
proposed for Exynos and this is why we have the solution proposed by
my patches.

Note that .write_sec() callback is still used for L2X0_CTRL and
L2X0_DEBUG_CTRL registers, because there might be a need to write them
separately (e.g. to disable the controller and to perform debug
operations/workarounds when the controller is already enabled).

Best regards,
Tomasz
