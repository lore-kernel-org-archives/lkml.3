Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaE2Qxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:53:52 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63877 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbaE2Qxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:53:50 -0400
Message-ID: <5387661E.7060106@linaro.org>
Date: Thu, 29 May 2014 11:53:50 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, mporter@linaro.org,
        bcm@fixthebug.org, devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] clk: bcm281xx: implement prerequisite clocks
References: <1400590362-11177-1-git-send-email-elder@linaro.org> <1400590362-11177-3-git-send-email-elder@linaro.org> <20140524005358.23136.8918@quantum> <53873577.8000502@linaro.org> <20140529163552.10062.50409@quantum>
In-Reply-To: <20140529163552.10062.50409@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 11:35 AM, Mike Turquette wrote:
> Quoting Alex Elder (2014-05-29 06:26:15)
>> On 05/23/2014 07:53 PM, Mike Turquette wrote:
>>> The above seems like a lot effort to go to. Why not skip all of this and
>>> just implement the prerequisite logic in the .enable & .disable
>>> callbacks? E.g. your kona clk .enable callback would look like:
>>
>> I think the problem is that it means the clock consumers
>> would have to know that prerequisite relationship.  And
>> that is dependent on the clock tree.  The need for it in
>> this case was because the boot loader didn't initialize
>> all the clocks that were needed.  If we could count on
>> the boot loader setting things up initially we might not
>> need to do this.

I think you've convinced me that if the prerequisite is
set up at initialization time, the consumers don't need
to know about the the clock tree.

>>>
>>> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
>>> index d603c4e..51f35b4 100644
>>> --- a/drivers/clk/bcm/clk-kona.c
>>> +++ b/drivers/clk/bcm/clk-kona.c
>>> @@ -987,6 +987,12 @@ static int kona_peri_clk_enable(struct clk_hw *hw)
>>>  {
>>>       struct kona_clk *bcm_clk = to_kona_clk(hw);
>>>       struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
>>> +     int ret;
>>> +
>>> +     hw->prereq_bus_clk = clk_get(hw->ccu, hw->prereq);
>>> +     ret = clk_enable(prereq_bus_clk);
>>> +     if (ret)
>>> +             return ret;
>>>  
>>>       return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
>>>  }
>>> @@ -997,6 +1003,9 @@ static void kona_peri_clk_disable(struct clk_hw *hw)
>>>       struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
>>>  
>>>       (void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
>>> +
>>> +     clk_disable(hw->prereq_bus_clk);
>>> +     clk_put(hw->prereq_bus_clk);
>>>  }
>>>  
>>>  static int kona_peri_clk_is_enabled(struct clk_hw *hw)
>>>
>>>
>>> I guess it might take some trickery to get clk_get to work like that.
>>> Let me know if I've completely lost the plot.
>>
>> I don't think so, but I think there's a lot of stuff
>> here to try to understand, and you're trying to extract
>> it from the code without the benefit of some background
>> of how and why it's done this way.
>>
>> Hopefully all this verbiage is moving you closer to
>> understanding...  I appreciate your patience.
> 
> Hi Alex,
> 
> Can you comment on my diff above? I basically tossed up some pseudo-code
> to show how clk_enable calls can be nested inside of each other. I'd
> like to know if that approach makes sense for your prereq clocks case.

Yes, I should have looked more closely before.

Are you suggesting this prerequisite notion get elevated into the
common framework?  Or is "hw" here just representative of the
Kona-specific clock structure?

In any case, you're suggesting the prerequisite be handled in the
enable path (as opposed to the one-time initialization path),
which during the course of this discussion I've been thinking may
be the right way to do it.

Let me see if I can rework it that way and I'll let you know
what I discover as a result.  I hope to have something to
talk about later today.

Thanks a lot Mike.

					-Alex

> Note that Linux device drivers that consume leaf clocks do NOT need to
> know about the prereq clocks. All of that prereq clock knowledge is
> stored in the .enable callback for the leaf clock (see above).
> 
> Regards,
> Mike
> 
>>
>>                                         -Alex
>>

