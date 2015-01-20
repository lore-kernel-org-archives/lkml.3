Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbbATKPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:15:15 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:46551 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbATKPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:15:13 -0500
MIME-Version: 1.0
In-Reply-To: <20150119205908.GC27202@codeaurora.org>
References: <1421688067-24426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421688067-24426-3-git-send-email-tomeu.vizoso@collabora.com> <20150119205908.GC27202@codeaurora.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 20 Jan 2015 11:14:52 +0100
X-Google-Sender-Auth: 2E5WENtgEyD1UUsdTauZvxOka08
Message-ID: <CAAObsKAWH0ExC3hpUMvBcooENo0ZEWzxfPDPiOczD3AZ+KUz9A@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] clk: Make clk API return per-user struct clk instances
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 January 2015 at 21:59, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 01/19, Tomeu Vizoso wrote:
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 97f3425..f2a1ff3 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -694,32 +751,32 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
>>                             unsigned long *best_parent_rate,
>>                             struct clk_hw **best_parent_p)
>>  {
>> -     struct clk *clk = hw->clk, *parent, *best_parent = NULL;
>> +     struct clk_core *core = hw->clk->core, *parent, *best_parent = NULL;
>
> Can't we just use hw->core here?

Yup.

>>       int i, num_parents;
>>       unsigned long parent_rate, best = 0;
>>
>>
>> @@ -820,15 +877,18 @@ int clk_prepare(struct clk *clk)
>>  {
>>       int ret;
>>
>> +     if (IS_ERR_OR_NULL(clk))
>> +             return PTR_ERR(clk);
>
> What's going on here? Should be if (!clk)?

Yeah, guess I miscopied it from a function that was expected to be
called chained with others.

>> +
>>       clk_prepare_lock();
>> -     ret = __clk_prepare(clk);
>> +     ret = clk_core_prepare(clk->core);
>>       clk_prepare_unlock();
>>
>>       return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(clk_prepare);
>> @@ -1066,9 +1149,24 @@ long clk_get_accuracy(struct clk *clk)
>>
>>       return accuracy;
>>  }
>> +
>> +/**
>> + * clk_get_accuracy - return the accuracy of clk
>> + * @clk: the clk whose accuracy is being returned
>> + *
>> + * Simply returns the cached accuracy of the clk, unless
>> + * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
>> + * issued.
>> + * If clk is NULL then returns 0.
>> + */
>> +long clk_get_accuracy(struct clk *clk)
>> +{
>> +     return clk_core_get_accuracy(clk->core);
>
> Oops. Missing NULL check.

Yup.

>> +}
>>  EXPORT_SYMBOL_GPL(clk_get_accuracy);
>>
>> @@ -1130,14 +1220,29 @@ unsigned long clk_get_rate(struct clk *clk)
> [...]
>> + *
>> + * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
>> + * is set, which means a recalc_rate will be issued.
>> + * If clk is NULL then returns 0.
>> + */
>> +unsigned long clk_get_rate(struct clk *clk)
>> +{
>> +     return clk_core_get_rate(clk->core);
>
> Oops. Missing NULL check.

Agreed.

>> +}
>>  EXPORT_SYMBOL_GPL(clk_get_rate);
>> @@ -1629,37 +1741,26 @@ static struct clk *__clk_init_parent(struct clk *clk)
> [...]
>> -int clk_set_parent(struct clk *clk, struct clk *parent)
>> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
>> +{
>> +     clk_core_reparent(clk->core, new_parent->core);
>> +}
>
> Is this used? Looks like we can remove it. Sorry, not sure how I
> missed this last time.

Yes, done.

>> +
>> +static int clk_core_set_parent(struct clk_core *clk, struct clk_core *parent)
>>  {
>>       int ret = 0;
>>       int p_index = 0;
>> @@ -1719,6 +1820,28 @@ out:
> [...]
>> +int clk_set_parent(struct clk *clk, struct clk *parent)
>> +{
>> +     return clk_core_set_parent(clk->core, parent->core);
>
> Oops. Missing NULL check for both inputs.

Agreed.

>> +}
>>  EXPORT_SYMBOL_GPL(clk_set_parent);
>>
>>  /**
>> @@ -1793,18 +1909,31 @@ out:
>>  }
>>
>>  /**
>> + * clk_get_phase - return the phase shift of a clock signal
>> + * @clk: clock signal source
>> + *
>> + * Returns the phase shift of a clock node in degrees, otherwise returns
>> + * -EERROR.
>> + */
>> +int clk_get_phase(struct clk *clk)
>> +{
>> +     return clk_core_get_phase(clk->core);
>
> Oops. Missing NULL check.

Agreed.

I have also reworked the changes to __clk_init to maintain the
existing behaviour.

Thanks,

Tomeu

> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
