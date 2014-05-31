Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107AbaEaDrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:47:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49152 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935072AbaEaDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:47:31 -0400
Message-ID: <538950D4.1040901@linaro.org>
Date: Fri, 30 May 2014 22:47:32 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, mporter@linaro.org,
        bcm@fixthebug.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] clk: kona: don't init clocks at startup time
References: <1401483188-5395-1-git-send-email-elder@linaro.org> <1401483188-5395-4-git-send-email-elder@linaro.org> <20140530233702.10062.60452@quantum>
In-Reply-To: <20140530233702.10062.60452@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 06:37 PM, Mike Turquette wrote:
> Quoting Alex Elder (2014-05-30 13:53:04)
>> +static int kona_clk_prepare(struct clk_hw *hw)
>>  {
>> +       struct kona_clk *bcm_clk = to_kona_clk(hw);
>> +       struct ccu_data *ccu = bcm_clk->ccu;
>> +       unsigned long flags;
>> +       int ret = 0;
>> +
>> +       flags = ccu_lock(ccu);
>> +       __ccu_write_enable(ccu);
>> +
>>         switch (bcm_clk->type) {
>>         case bcm_clk_peri:
>> -               return __peri_clk_init(bcm_clk);
>> +               if (!__peri_clk_init(bcm_clk))
>> +                       ret = -EINVAL;
>> +               break;
>>         default:
>>                 BUG();
>>         }
> 
> The switch-case only has one match, plus a default. Will there be others
> in the future?  Otherwise it can be replaced with an if-statement.

Yes, bus clocks in patch 5/7.  Maybe another type
someday but at least these two.  All the code is
structured this way in anticipation of other clock
types.


>> -       return -EINVAL;
>> -}
>> -
>> -/* Set a CCU and all its clocks into their desired initial state */
>> -bool __init kona_ccu_init(struct ccu_data *ccu)
>> -{
>> -       unsigned long flags;
>> -       unsigned int which;
>> -       struct clk **clks = ccu->clk_data.clks;
>> -       bool success = true;
>> -
>> -       flags = ccu_lock(ccu);
>> -       __ccu_write_enable(ccu);
>> -
>> -       for (which = 0; which < ccu->clk_data.clk_num; which++) {
>> -               struct kona_clk *bcm_clk;
>> -
>> -               if (!clks[which])
>> -                       continue;
>> -               bcm_clk = to_kona_clk(__clk_get_hw(clks[which]));
>> -               success &= __kona_clk_init(bcm_clk);
>> -       }
>>  
>>         __ccu_write_disable(ccu);
>>         ccu_unlock(ccu, flags);
>> -       return success;
>> +
>> +       return ret;
>>  }
> 
> Does this prepare callback "enable" a clock? E.g does a line NOT toggle
> at a rate prior to this call, and then after this call completes that
> same line is now toggling at a rate?

Hmmm.  Good question.

The state of the gate (if present) will not change, so it'll continue
toggling if it was before, and will not start if it was not.  But once
this is done we'll know whether the hardware is enabled or not because
we'll have read its value.

>>  
>> -/* Clock operations */
>> +static void kona_clk_unprepare(struct clk_hw *hw)
>> +{
>> +       /* Nothing to do. */
>> +}
> 
> Is doing nothing the right thing to do? Could power be saved somehow if
> the .unprepare callback really gets called? Remember that if .unprepare

This is again a skeleton in place now because the prerequisite code will
actually fill this in with something to do.  But in any case I use the
enable/disable methods for gate control; the main purpose for these
prepare methods will be to prepare and enable the prerequisite clock.
I may need to think a bit more about what belongs in the prepare
function

> actually runs (because struct clk->prepare_count == 0) then the next
> call to clk_prepare will actually call your .prepare callback and set up
> the prereq clocks again. So the prereq clock initialization is no longer
> a one-time thing, which might afford you some optimizations.

I'll think about this.  Already the code caches the current state
of the hardware and doesn't update the hardware unless it changes
that state.  If I maintained an initialized flag (which I just got
rid of) I could probably avoid taking the spin lock, etc., for
some savings.

This switch over to using the prepare method to do the
initialization may not have been as well thought out as it
should have been.  It changes from "initialize all clocks, once,
all at once" to "initialize each clock only when it's needed
(but every time it's needed)."

					-Alex

> Regards,
> Mike
> 
>>  
>>  static int kona_peri_clk_enable(struct clk_hw *hw)
>>  {
>> @@ -1264,6 +1258,8 @@ static int kona_peri_clk_set_rate(struct clk_hw *hw, unsigned long rate,
>>  }
>>  
>>  struct clk_ops kona_peri_clk_ops = {
>> +       .prepare = kona_clk_prepare,
>> +       .unprepare = kona_clk_unprepare,
>>         .enable = kona_peri_clk_enable,
>>         .disable = kona_peri_clk_disable,
>>         .is_enabled = kona_peri_clk_is_enabled,
>> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
>> index e9a8466..3409111 100644
>> --- a/drivers/clk/bcm/clk-kona.h
>> +++ b/drivers/clk/bcm/clk-kona.h
>> @@ -511,6 +511,5 @@ extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
>>  extern struct clk *kona_clk_setup(struct kona_clk *bcm_clk);
>>  extern void __init kona_dt_ccu_setup(struct ccu_data *ccu,
>>                                 struct device_node *node);
>> -extern bool __init kona_ccu_init(struct ccu_data *ccu);
>>  
>>  #endif /* _CLK_KONA_H */
>> -- 
>> 1.9.1
>>

