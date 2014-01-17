Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaAQBiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:38:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44021 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaAQBio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:38:44 -0500
Message-ID: <52D889A2.8000808@codeaurora.org>
Date: Thu, 16 Jan 2014 17:38:42 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 02/15] clk: Allow drivers to pass in a regmap
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org> <1387847559-18330-3-git-send-email-sboyd@codeaurora.org> <20140109015158.7168.60274@quantum> <52D4B502.3080409@codeaurora.org> <20140115093641.4167.83109@quantum>
In-Reply-To: <20140115093641.4167.83109@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 01:36 AM, Mike Turquette wrote:
> Quoting Saravana Kannan (2014-01-13 19:54:42)
>> On 01/08/2014 05:51 PM, Mike Turquette wrote:
>>> Quoting Stephen Boyd (2013-12-23 17:12:26)
>>>> Add support to the clock core so that drivers can pass in a
>>>> regmap. If no regmap is specified try to query the device that's
>>>> registering the clock for its regmap. This should allow drivers
>>>> to use the core regmap helpers. This is based on a similar design
>>>> in the regulator framework.
>>>>
>>>> Cc: Mark Brown <broonie@kernel.org>
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> ---
>>>>    drivers/clk/clk.c            | 8 ++++++++
>>>>    include/linux/clk-provider.h | 7 +++++++
>>>>    2 files changed, 15 insertions(+)
>>>>
>>>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>>>> index 9ad7b71..5e71f5c 100644
>>>> --- a/drivers/clk/clk.c
>>>> +++ b/drivers/clk/clk.c
>>>> @@ -20,6 +20,7 @@
>>>>    #include <linux/device.h>
>>>>    #include <linux/init.h>
>>>>    #include <linux/sched.h>
>>>> +#include <linux/regmap.h>
>>>>
>>>>    static DEFINE_SPINLOCK(enable_lock);
>>>>    static DEFINE_MUTEX(prepare_lock);
>>>> @@ -1834,6 +1835,13 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
>>>>           clk->num_parents = hw->init->num_parents;
>>>>           hw->clk = clk;
>>>>
>>>> +       if (hw->init->regmap)
>>>> +               hw->regmap = hw->init->regmap;
>>>
>>> Hi Stephen,
>>>
>>> The whole series looks good to me except for the placement of the regmap
>>> details inside struct clk_hw. That structure exists only to hide struct
>>> clk from the hardware-specific clock structure and I'd not like to set
>>> the precedent of shoving per-clock data into it.
>>>
>>> As an alternative, how about finding a way to put these per-clock regmap
>>> details into the hardware-specific clock structure? I understand that
>>> you want to make these ops available to others, which is why they are in
>>> the public struct clk_hw. I'm just wondering if that is the right way to
>>> do it...
>>>
>>> Patch #3 illustrates the sort of struct-member-creep that worries me.
>>> What is to stop someone from putting "unsigned int divider_reg" or
>>> "unsigned int mux_reg", and then the thing just keeps growing.
>>
>> I agree with Mike here. This definitely encourages struct field creep if
>> more people want to use it.
>>
>> I talked to Stephen is person and my recommendation is to not have any
>> new fields other than struct regmap in clk_hw and remove the above 2
>> lines of code.
>>
>>>> +       else if (dev && dev_get_regmap(dev, NULL))
>>>> +               hw->regmap = dev_get_regmap(dev, NULL);
>>
>> Move "struct regmap *regmap" into struct clk_hw (since it's truly
>> reusable across clock types and is technically purely HW related) and
>> update it from the device's regmap like above.
>
> Hi Saravana,
>
> Thanks for your comments. In the paragraph above you mean "struct
> clk_hw" or do you mean the hardware-specific structure(s) defined in a
> clock driver?
>
>>
>> We can then provide __clk_regmap_enable(regmap, offset, enable_mask)
>> helper functions. Then clock specific functions can use the helper. We
>> can even a simple macro to generate these wrappers.
>>
>> #define DEFINE_REGMAP_EN_DIS(clktype) \
>>
>> int clk_type##_enable(clktype *c, ....) { }
>> int clk_type##_disable(clktype *c, ....) { }
>>
>>
>> That to me seems like a reasonable compromise.
>
> Providing common functions for the basic case (e.g. read-modify-write on
> a register using a known mask) is reasonable. But that is exactly what
> the existing basic clock types do (sans regmap) and they have all become
> pretty ugly over time. And the clk-composite implementation just makes
> me a sad panda.
>
> I'm not opposed to providing public implementations of clk_ops callbacks
> that use regmap, but I will be very mindful of any feature creep in the
> future.
>
> I am still unconvinced that adding struct regmap to struct clk_hw is a
> good idea. The regmap data is a function of hardware-specific details
> and those details always have and always will belong in the clock
> driver

The details of the bits inside the register and how it's used would be 
clock type specific. Meaning, a Vendor X clock gate might have a busy 
bit and Vendor Y clock gate might not have a busy bit.

Regmap doesn't try to consolidate that. I'm not saying those clock gates 
should not be consolidated, but that's not what regmap is trying to do.

Regmap is helpful to consolidate clocks that behave exactly the same 
way, but differ in how the clock registers are accessed. Eg: mem-mapped 
IO, I2C, CP15 read/writes. So, even with a MSM based board, just because 
the way to access the registers are different, we could have to 
implement 3 different clock gate types. Which I think would be the wrong 
thing to do. Regmap cleanly consolidates this because the clock types 
just need to store the offsets and operate on them as usual using regmap 
APIs.

Since the regmap for the clock is assigned based on the device that's 
registering the enable/disable code for a clock gate can be agnostic of 
how the registers are accesses. Yes, regmap does provide helpers for 
read/modify writes, but that's not the main reason for using it.

Btw, this is a very real case on MSMs. The CPU clocks are accesses thru 
CP15 instructions, and the other clock trees are accessed through 
mem-mapped IO. But they pretty much behave the same way. That's what reg 
map is solving.

And I think this is a common problem for ANY clock type that one might 
implement. Which is why I think it should be in some common clock 
struct. The clock drivers will need access to the regmap. So, I picked 
clk_hw (the struct defined by the clock framework) and not struct clk. 
This also allows for the framework registration code to go populate the 
regmap pointer for all clocks from the regmap of the device.

Thoughts?

Thanks,
Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
