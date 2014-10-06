Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaJFTbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:31:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41426 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaJFTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:31:47 -0400
Message-ID: <5432EE21.7030906@codeaurora.org>
Date: Mon, 06 Oct 2014 12:31:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH 1/2] clk: Make clk API return per-user struct clk instances
References: <1412255097-15928-1-git-send-email-tomeu.vizoso@collabora.com> <1412255097-15928-2-git-send-email-tomeu.vizoso@collabora.com> <20141003231515.GM10233@codeaurora.org> <CAAObsKDa=ia3Gbu1WkoUBjXt2GCoysK7rv=3PzLarnfS7K5ZLA@mail.gmail.com>
In-Reply-To: <CAAObsKDa=ia3Gbu1WkoUBjXt2GCoysK7rv=3PzLarnfS7K5ZLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 10:14 AM, Tomeu Vizoso wrote:
>> This is the end goal. I understand that the provider API is sort
>> of a mess with us allowing drivers to use the underscore and
>> non-underscore functions and the mixture of struct clk and struct
>> ckl_hw throughout.
>>
>>   struct clk_hw <--> struct clk_core <----> struct clk
>>                                         \-> struct clk
>>                                         |-> struct clk
> Agree this is how it should look like at some point, but for now I
> need a reference to struct clk from struct clk_hw, so providers can
> keep using the existing API. This reference would be removed once they
> move to the new clk_hw-based API.

Ok sounds like we're on the same page.

>>> +struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev_id,
>>> +                          const char *con_id);
>>> +#endif
>>> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
>>> index da4bda8..fe3712f 100644
>>> --- a/drivers/clk/clkdev.c
>>> +++ b/drivers/clk/clkdev.c
>>> @@ -168,14 +172,27 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
>>>   struct clk *clk_get_sys(const char *dev_id, const char *con_id)
>>>   {
>>>        struct clk_lookup *cl;
>>> +     struct clk *clk = NULL;
>>>
>>>        mutex_lock(&clocks_mutex);
>>>        cl = clk_find(dev_id, con_id);
>>> -     if (cl && !__clk_get(cl->clk))
>>> -             cl = NULL;
>>> +     if (cl) {
>>> +#if defined(CONFIG_COMMON_CLK)
>>> +             clk = __clk_create_clk(cl->clk->core, dev_id, con_id);
>>> +             if (clk && !__clk_get(clk)) {
>>> +                     kfree(clk);
>> This looks weird. It makes me suspect we've failed to reference
>> count something properly. Can we avoid this?
> Can you extend on this? But I see how the behaviour doesn't match the
> previous one because cl should be NULLed when __clk_get fails. I have
> fixed this.

It triggers my "that's not symmetric filter" because it requires the 
caller to free something allocated by the callee. Do we still need 
__clk_get() to be called in the common clock path? Why not just do the 
stuff we do in __clk_get() in __clk_create_clk()? Then if that fails we 
can return an error pointer indicating some sort of failure (-ENOENT?) 
and we don't need to do any sort of cleanup otherwise.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

