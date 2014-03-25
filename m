Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaCYNyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:54:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52270 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaCYNyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:54:36 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-9f-53318a997a94
Message-id: <1395755672.24026.0.camel@AMDC1943>
Subject: Re: [PATCH] clocksource: exynos_mct: Fix stall after CPU hotplugging
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 25 Mar 2014 14:54:32 +0100
In-reply-to: <53316966.90600@samsung.com>
References: <1395744087-8655-1-git-send-email-k.kozlowski@samsung.com>
 <53316966.90600@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xa7ozuwyDDfpWmlpsnLGe1WLeZ1mL
	3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Sx9shddov1M16zWGzeNJXZgcvjzrU9bB7vzp1j
	99i8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4MtbPZC84K1jRt6mXpYHxFm8XIyeHhICJ
	xMWJG1ggbDGJC/fWs3UxcnEICSxllLj66z+U85lR4u20J2wgVbwC+hLf5x4H6xAW8JXYtnwL
	I4jNJmAssXn5ErAaEQEVicunpjOCNDMLfGeS+HzmNjtIgkVAVWLOg39gRZwCmhI9N7rBbCGB
	VIk1zd/BhjILqEtMmreIGeIkJYnd7Z3sEHF5ic1r3jJDHCEo8WPyPZYJjAKzkLTMQlI2C0nZ
	AkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghEfB1B+PSY1aHGAU4GJV4eDeYGgQLsSaW
	FVfmHmKU4GBWEuHNajcMFuJNSaysSi3Kjy8qzUktPsTIxMEp1cAoae2gMpP7RItk5RKby2Vx
	WgrfKv6tfGzKr7tmu1PldUkjJ66i55kMX9ZdK4v0WZ9nHX9Db+ExLolpv4yYzkgGCmzZ2PDn
	/0KrAKNvB+XUoi+4xl5O9lgZ0vo2XL7XmJWpIe7LSguHrfZaAaX3FNNmmbmfvGx6YlHk7i4d
	SUM++ZmOMmsf/1NiKc5INNRiLipOBAAiOnENXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 12:32 +0100, Tomasz Figa wrote:
> Hi Krzysztof,
> 
> Two comments inline.
> 
> On 25.03.2014 11:41, Krzysztof Kozlowski wrote:
> 
> [snip]
> 
> > diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> > index 48f76bc05da0..0b49b09dd1a9 100644
> > --- a/drivers/clocksource/exynos_mct.c
> > +++ b/drivers/clocksource/exynos_mct.c
> > @@ -339,7 +339,14 @@ static void exynos4_mct_tick_start(unsigned long cycles,
> >   static int exynos4_tick_set_next_event(unsigned long cycles,
> >   				       struct clock_event_device *evt)
> >   {
> > -	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
> > +	/*
> > +	 * In case of hotplugging non-boot CPU, the set_next_event could be
> > +	 * called on CPU0 by ISR before IRQ affinity is set to proper CPU.
> 
> Hmm, is this a desired behavior? I guess this is a question for Thomas 
> and Daniel.
> 
> > +	 * Thus for accessing proper MCT Lx timer, 'per_cpu' for cpumask
> > +	 * in event must be used instead of 'this_cpu_ptr'.
> > +	 */
> > +	struct mct_clock_event_device *mevt = &per_cpu(percpu_mct_tick,
> > +			cpumask_first(evt->cpumask));
> >
> >   	exynos4_mct_tick_start(cycles, mevt);
> >
> > @@ -371,23 +378,13 @@ static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
> >
> >   static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
> >   {
> > -	struct clock_event_device *evt = &mevt->evt;
> > -
> > -	/*
> > -	 * This is for supporting oneshot mode.
> > -	 * Mct would generate interrupt periodically
> > -	 * without explicit stopping.
> > -	 */
> > -	if (evt->mode != CLOCK_EVT_MODE_PERIODIC)
> > -		exynos4_mct_tick_stop(mevt);
> > -
> >   	/* Clear the MCT tick interrupt */
> >   	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
> >   		exynos4_mct_write(0x1, mevt->base + MCT_L_INT_CSTAT_OFFSET);
> >   		return 1;
> > -	} else {
> > -		return 0;
> >   	}
> > +
> > +	return 0;
> 
> Nobody seems to be checking return value of this function (and I don't 
> see what it could be used for anyway), so I guess it could be simply 
> made void.

I'll send a another patch for it.

Best regards,
Krzysztof

