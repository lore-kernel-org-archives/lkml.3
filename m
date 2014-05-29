Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaE2N0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:26:17 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:55226 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbaE2N0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:26:16 -0400
Message-ID: <53873577.8000502@linaro.org>
Date: Thu, 29 May 2014 08:26:15 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, mporter@linaro.org,
        bcm@fixthebug.org, devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] clk: bcm281xx: implement prerequisite clocks
References: <1400590362-11177-1-git-send-email-elder@linaro.org> <1400590362-11177-3-git-send-email-elder@linaro.org> <20140524005358.23136.8918@quantum>
In-Reply-To: <20140524005358.23136.8918@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 07:53 PM, Mike Turquette wrote:
> Quoting Alex Elder (2014-05-20 05:52:39)
>> @@ -743,11 +746,16 @@ struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
>>         clk = clk_register(NULL, &bcm_clk->hw);
>>         if (IS_ERR(clk)) {
>>                 pr_err("%s: error registering clock %s (%ld)\n", __func__,
>> -                       init_data->name, PTR_ERR(clk));
>> +                       name, PTR_ERR(clk));
>>                 goto out_teardown;
>>         }
>>         BUG_ON(!clk);
>>  
>> +       /*  Make it so we can look the clock up using clk_find() */
> 
> s/clk_find/clk_get/ ?

Yes, this is a mistake.

> 
>> +       bcm_clk->cl.con_id = name;
>> +       bcm_clk->cl.clk = clk;
>> +       clkdev_add(&bcm_clk->cl);
> 
> This is not so nice. I'll explain more below.

Actually, this code is no longer needed at all.  It was
at one time, but I evolved away from that need, and never
noticed that this remnant remained.  I will delete it.

I'm really sorry I missed that, it was confusing for
it to still be there I'm sure.

>> +
>>         return clk;
>>  out_teardown:
>>         bcm_clk_teardown(bcm_clk);
>> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
>> index d8a7f38..fd070d6 100644
>> --- a/drivers/clk/bcm/clk-kona.c
>> +++ b/drivers/clk/bcm/clk-kona.c
>> @@ -1195,6 +1195,48 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
>>         return true;
>>  }
>>  
>> +static bool __kona_clk_init(struct kona_clk *bcm_clk);
>> +static bool __kona_prereq_init(struct kona_clk *bcm_clk)
>> +{
>> +       struct clk *clk;
>> +       struct clk_hw *hw;
>> +       struct kona_clk *prereq;
>> +
>> +       BUG_ON(clk_is_initialized(bcm_clk));
>> +
>> +       if (!bcm_clk->p.prereq)
>> +               return true;
>> +
>> +       clk = clk_get(NULL, bcm_clk->p.prereq);
> 
> The clkdev global namespace is getting polluted with all of these new
> prereq clocks. If there was an associated struct device *dev with them
> then it wouldn't be a problem, but you might get collisions with other
> clock drivers that also use NULL for the device.

Again, you caught a confusing mistake.  The clk_lookup
structure will go away.

> It would be a lot nicer for the clocks that require a prereq clock to
> just use clk_get(dev, "well_known_name"); in the same way that drivers
> use it, without considering it a special case.

That is in fact what happens, in __kona_prereq_init().

>> +       if (IS_ERR(clk)) {
>> +               pr_err("%s: unable to get prereq clock %s for %s\n",
>> +                       __func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
>> +               return false;
>> +       }
>> +       hw = __clk_get_hw(clk);
>> +       if (!hw) {
>> +               pr_err("%s: null hw pointer for clock %s\n", __func__,
>> +                       bcm_clk->init_data.name);
>> +               return false;
>> +       }
>> +       prereq = to_kona_clk(hw);
>> +       if (prereq->ccu != bcm_clk->ccu) {
>> +               pr_err("%s: prereq clock %s CCU different for clock %s\n",
>> +                       __func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
>> +               return false;
>> +       }
>> +
>> +       /* Initialize the prerequisite clock first */
>> +       if (!__kona_clk_init(prereq)) {
>> +               pr_err("%s: failed to init prereq %s for clock %s\n",
>> +                       __func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
>> +               return false;
>> +       }
>> +       bcm_clk->p.prereq_clk = clk;
> 
> The above seems like a lot effort to go to. Why not skip all of this and
> just implement the prerequisite logic in the .enable & .disable
> callbacks? E.g. your kona clk .enable callback would look like:

I think the problem is that it means the clock consumers
would have to know that prerequisite relationship.  And
that is dependent on the clock tree.  The need for it in
this case was because the boot loader didn't initialize
all the clocks that were needed.  If we could count on
the boot loader setting things up initially we might not
need to do this.

> 
> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> index d603c4e..51f35b4 100644
> --- a/drivers/clk/bcm/clk-kona.c
> +++ b/drivers/clk/bcm/clk-kona.c
> @@ -987,6 +987,12 @@ static int kona_peri_clk_enable(struct clk_hw *hw)
>  {
>  	struct kona_clk *bcm_clk = to_kona_clk(hw);
>  	struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
> +	int ret;
> +
> +	hw->prereq_bus_clk = clk_get(hw->ccu, hw->prereq);
> +	ret = clk_enable(prereq_bus_clk);
> +	if (ret)
> +		return ret;
>  
>  	return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
>  }
> @@ -997,6 +1003,9 @@ static void kona_peri_clk_disable(struct clk_hw *hw)
>  	struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
>  
>  	(void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
> +
> +	clk_disable(hw->prereq_bus_clk);
> +	clk_put(hw->prereq_bus_clk);
>  }
>  
>  static int kona_peri_clk_is_enabled(struct clk_hw *hw)
> 
> 
> I guess it might take some trickery to get clk_get to work like that.
> Let me know if I've completely lost the plot.

I don't think so, but I think there's a lot of stuff
here to try to understand, and you're trying to extract
it from the code without the benefit of some background
of how and why it's done this way.

Hopefully all this verbiage is moving you closer to
understanding...  I appreciate your patience.

					-Alex

