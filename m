Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaCYLdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:33:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38542 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaCYLdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:33:08 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-77-533169719aa5
Message-id: <53316966.90600@samsung.com>
Date: Tue, 25 Mar 2014 12:32:54 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] clocksource: exynos_mct: Fix stall after CPU hotplugging
References: <1395744087-8655-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1395744087-8655-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xq7qFmYbBBp0dlhYbZ6xntZj3Wdbi
	9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dksfbIXXaLzZumMjtwedy5tofN4925c+we
	m5fUe/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGlM9T2Qu+8Vf8XNLH3MB4haeLkZNDQsBE
	YkfjOkYIW0ziwr31bF2MXBxCAksZJTZtfM8I4XxmlFj5YDoTSBWvgIbE9gfzmUFsFgFVic6W
	TWDdbAJqEp8bHrGB2PwCWhJrmq6zgNiiAhES9xoPs0L0Ckr8mHyPBWSoiMA0JonlNz6AOcwC
	UxglmictBdsgLOArsW35FrCpQgJuEivmbAbbxingLvHq4mKwDcwC1hIrJ21jhLDlJTavecs8
	gVFwFpIls5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSGx83cG49JjVIUYB
	DkYlHt4NpgbBQqyJZcWVuYcYJTiYlUR4DcMMg4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwTrnL
	wC3zNXmSzUdrlc5pP7ccUjs4Yw3vByXXD9evvPbt/u7dsd25vqzqyc7neXcmbGO7d0fl4d+j
	EVdbvvYr224JEVQO+yan8dzOel3qx5NbzwYprcoIEqi/bLFf22e+mpZZROSl04Zus2Uf6KUv
	OnmQh8MwXP3V/8C5cf/TpBJnvo+xe+nmqsRSnJFoqMVcVJwIAJKNFUtrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Two comments inline.

On 25.03.2014 11:41, Krzysztof Kozlowski wrote:

[snip]

> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 48f76bc05da0..0b49b09dd1a9 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -339,7 +339,14 @@ static void exynos4_mct_tick_start(unsigned long cycles,
>   static int exynos4_tick_set_next_event(unsigned long cycles,
>   				       struct clock_event_device *evt)
>   {
> -	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
> +	/*
> +	 * In case of hotplugging non-boot CPU, the set_next_event could be
> +	 * called on CPU0 by ISR before IRQ affinity is set to proper CPU.

Hmm, is this a desired behavior? I guess this is a question for Thomas 
and Daniel.

> +	 * Thus for accessing proper MCT Lx timer, 'per_cpu' for cpumask
> +	 * in event must be used instead of 'this_cpu_ptr'.
> +	 */
> +	struct mct_clock_event_device *mevt = &per_cpu(percpu_mct_tick,
> +			cpumask_first(evt->cpumask));
>
>   	exynos4_mct_tick_start(cycles, mevt);
>
> @@ -371,23 +378,13 @@ static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
>
>   static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
>   {
> -	struct clock_event_device *evt = &mevt->evt;
> -
> -	/*
> -	 * This is for supporting oneshot mode.
> -	 * Mct would generate interrupt periodically
> -	 * without explicit stopping.
> -	 */
> -	if (evt->mode != CLOCK_EVT_MODE_PERIODIC)
> -		exynos4_mct_tick_stop(mevt);
> -
>   	/* Clear the MCT tick interrupt */
>   	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
>   		exynos4_mct_write(0x1, mevt->base + MCT_L_INT_CSTAT_OFFSET);
>   		return 1;
> -	} else {
> -		return 0;
>   	}
> +
> +	return 0;

Nobody seems to be checking return value of this function (and I don't 
see what it could be used for anyway), so I guess it could be simply 
made void.

Best regards,
Tomasz
