Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaL3JF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:05:56 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37261 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaL3JFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:05:52 -0500
MIME-Version: 1.0
In-Reply-To: <54A19C17.1020909@ti.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
	<1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>
	<54A19C17.1020909@ti.com>
Date: Tue, 30 Dec 2014 18:05:51 +0900
Message-ID: <CA+Ln22G3kVA_-tsjAxbe2rqSHeLtdU2X_EhNL0uW3cUCgaWLgg@mail.gmail.com>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like interface
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>, Daniel Drake <drake@endlessm.com>,
        Jon Loeliger <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for investigating this, even before I could look into
splitting this.

2014-12-30 3:23 GMT+09:00 Nishanth Menon <nm@ti.com>:
> On 12/23/2014 04:48 AM, Marek Szyprowski wrote:
>
>> -static void l2c310_resume(void)
>> +static void l2c310_configure(void __iomem *base)
>>  {
>> -     void __iomem *base = l2x0_base;
>> +     unsigned revision;
>>
>> -     if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
>> -             unsigned revision;
>> -
>> -             /* restore pl310 setup */
>> -             writel_relaxed(l2x0_saved_regs.tag_latency,
>> -                            base + L310_TAG_LATENCY_CTRL);
>> -             writel_relaxed(l2x0_saved_regs.data_latency,
>> -                            base + L310_DATA_LATENCY_CTRL);
>> -             writel_relaxed(l2x0_saved_regs.filter_end,
>> -                            base + L310_ADDR_FILTER_END);
>> -             writel_relaxed(l2x0_saved_regs.filter_start,
>> -                            base + L310_ADDR_FILTER_START);
>> -
>> -             revision = readl_relaxed(base + L2X0_CACHE_ID) &
>> -                             L2X0_CACHE_ID_RTL_MASK;
>> -
>> -             if (revision >= L310_CACHE_ID_RTL_R2P0)
>> -                     l2c_write_sec(l2x0_saved_regs.prefetch_ctrl, base,
>> -                                   L310_PREFETCH_CTRL);
>> -             if (revision >= L310_CACHE_ID_RTL_R3P0)
>> -                     l2c_write_sec(l2x0_saved_regs.pwr_ctrl, base,
>> -                                   L310_POWER_CTRL);
>> -
>> -             l2c_enable(base, l2x0_saved_regs.aux_ctrl, 8);
>> -
>> -             /* Re-enable full-line-of-zeros for Cortex-A9 */
>> -             if (l2x0_saved_regs.aux_ctrl & L310_AUX_CTRL_FULL_LINE_ZERO)
>> -                     set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
>> -     }
>> +     /* restore pl310 setup */
>> +     writel_relaxed(l2x0_saved_regs.tag_latency,
>> +                    base + L310_TAG_LATENCY_CTRL);
>> +     writel_relaxed(l2x0_saved_regs.data_latency,
>> +                    base + L310_DATA_LATENCY_CTRL);
>> +     writel_relaxed(l2x0_saved_regs.filter_end,
>> +                    base + L310_ADDR_FILTER_END);
>> +     writel_relaxed(l2x0_saved_regs.filter_start,
>> +                    base + L310_ADDR_FILTER_START);
>> +
>
> ^^ The above change broke AM437xx. Looks like the change causes the
> following behavior difference on AM437x. For some reason, touching any
> of the above 4 registers(even with the values read from the same
> registers) causes AM437x to go beserk. Comment the 4 writes and we
> reach shell. looks like l2c310_resume is not invoked prior to this
> series. :(.. now that we reuse that logic to actually do programming,
> we start to see the problem.

Hmm, but the thing is that .configure() should not be called if the
controller is already configured, i.e. L2X0_CTRL_EN in L2X0_CTRL is
set. Maybe I missed some check somewhere. Let me reread my code I
wrote quite a long time ago and make sure.

>
> one option might be to write only those registers that differ from
> saved_registers (example: unmodified values dont need reprogramming).
>
> Looks like the following also need addressing:
> data->save is called twice (once more after l2cof_init)
> l2c310_init_fns also needs l2c310_configure
> will be nice to use l2x0_data only after we kmemdup data in __l2c_init

I'll check this.

>
> if you'd like to split this up in pieces, [1] might be nice - will go
> good to change the pl310, aurora etc in each chunks to enable better
> review.

Thanks a lot, the split up version will be definitely useful. Just to
make sure, the parts look quite bisectable, but have you verified that
applying the changes one by one leave the L2 cache working on OMAP?

>
> [1]
> https://github.com/nmenon/linux-2.6-playground/commits/temp/l2c-patch2-splitup

Best regards,
Tomasz
