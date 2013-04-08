Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935642Ab3DHSco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:32:44 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43923 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935603Ab3DHScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:32:41 -0400
Message-ID: <51630D3E.30706@gmail.com>
Date: Mon, 08 Apr 2013 20:32:30 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v5] clk: add si5351 i2c common clock driver
References: <1365139415-17815-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130407225046.GA16326@roeck-us.net> <51620604.4070204@gmail.com> <20130408001725.GA16648@roeck-us.net> <51625F9A.1050308@gmail.com> <20130408145407.GA12243@roeck-us.net> <CABJ1b_T30trVjXps-rSbYTNo1DcPeT8WsZ+M18B9wTJPBnL-gA@mail.gmail.com> <20130408173628.14359.70620@quantum>
In-Reply-To: <20130408173628.14359.70620@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 07:36 PM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2013-04-08 08:38:44)
>> On Mon, Apr 8, 2013 at 4:54 PM, Guenter Roeck<linux@roeck-us.net>  wrote:
>>> On Mon, Apr 08, 2013 at 08:11:38AM +0200, Sebastian Hesselbarth wrote:
>>>> On 04/08/2013 02:17 AM, Guenter Roeck wrote:
>>>>> On Mon, Apr 08, 2013 at 01:49:24AM +0200, Sebastian Hesselbarth wrote:
>>>>>> On 04/08/2013 12:50 AM, Guenter Roeck wrote:
>>>>>>> On Fri, Apr 05, 2013 at 05:23:35AM -0000, Sebastian Hesselbarth wrote:
>>>>>>>> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
>>>>>>>> i2c programmable clock generators. Currently, the driver supports
>>>>>>>> DT kernels only and VXCO feature of si5351b is not implemented. DT
>>>>>>>> bindings selectively allow to overwrite stored Si5351 configuration
>>>>>>>> which is very helpful for clock generators with empty eeprom
>>>>>>>> configuration. Corresponding device tree binding documentation is
>>>>>>>> also added.
>>>>>>>>
>>>>>>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>>>>>>> Tested-by: Daniel Mack<zonque@gmail.com>
>>>>>>>>
>>>>>>> [ ... ]
>>>>>>>
>>>>>>>> +static inline void _si5351_msynth_set_pll_master(
>>>>>>>> + struct si5351_driver_data *drvdata, unsigned char num, int is_master)
>>>>>>>> +{
>>>>>>>> + unsigned long flags;
>>>>>>>> +
>>>>>>>> + if (num>    8 ||
>>>>>>>> +     (drvdata->variant == SI5351_VARIANT_A3&&    num>    3))
>>>>>>>> +         return;
>>>>>>>> +
>>>>>>>> + flags = __clk_get_flags(drvdata->msynth[num].hw.clk);
>>>>>>>> + if (is_master)
>>>>>>>> +         flags |= CLK_SET_RATE_PARENT;
>>>>>>>> + else
>>>>>>>> +         flags&= ~CLK_SET_RATE_PARENT;
>>>>>>>> + __clk_set_flags(drvdata->msynth[num].hw.clk, flags);
>>>>>>>> +}
>>>>>>>> +
>>>>>>> Unless I am missing something, neither __clk_get_flags() nor the new
>>>>>>> __clk_set_flags is exported.
>>>>>>>
>>>>>>> Did you try to build and load the driver as module ?
>>>>>>
>>>>>> Well, good catch. I didn't try to build v5 as a module, but I guess it
>>>>>> will fail. But I consider this as something that has to be addressed in
>>>>>> clk framework itself, not in this patch. There will be other
>>>>>> clk-providers built as module in the future for sure.
>>>>>>
>>>>> Sure, but you provided the patch to make __clk_set_flags global. To avoid
>>>>> build failures, I would suggest to either submit a patch to export the
>>>>> missing functions, or to remove the ability to build the driver as module.
>>>>
>>>> Actually, I knew that __clk_set_flags patch will not be accepted
>>>> before posting it ;)
>>>>
>>> Ah, but part of that is to get you to think about it again, and to defend it if
>>> it is really needed. After all, "it can be abused" applies to pretty much every
>>> API.
>>
>> Guenter,
>>
>> I already thought about it a lot and I consider clk api broken in a way here.
>>
>>> Key question is if you _really_ need run-time flag modifications, or if you can
>>> live with initialization-time settings. If you really need it, you'll have to
>>> explain the reasons.
>>
>> The question is not if _I_ really need run-time flags but why the api allows to
>> perform run-time modifications of the clock hierarchy without allowing different
>> flags? There is clk_set_parent() so I guess clk api knows about run-time changes
>> already, but you cannot have different flags per parent. And with
>> __clk_set_flags()
>> rejected, you are not allowed to change the flags.
>>
>> I understand that some flags are permanent and required at registration, but
>> CLK_SET_PARENT_RATE is not. It is not limited by hardware but limited by api.
>> One way would be a more generic clk-mux with per parent flags, but for
>> the current
>> implementation, I cannot see how clk-mux can be exploited here.
>>
>
> There are a couple of ways to get past this issue.  One is removal of
> some of the flags.  I have never liked CLK_SET_RATE_PARENT, since I
> think the ability to propagate a rate-change request up to the parent
> should be enabled for all clocks.  This is in the interest of the driver
> author who does not care to know intimate details of the clock
> hierarchy.
>
> When I developed the rate-change propagation code I was likely too hasty
> in defining a per-clock flag for that behavior.  It might have been
> enough to simply compare the&best_parent_rate value from .round_rate
> and compare it against clk->parent->rate.  This means that no flag is
> necessary.
>
> This assumes that the .round_rate implementation has enough knowledge to
> know whether or not to propagate the rate-change request up to the
> parent.  This may not not true for the common divider type.
>
> I'll make some tests on removing this flag (and potentially other flags)
> to see how painful it is.

Mike,

another good thing would be to have implementation independent building 
blocks for clk drivers. I think clk-fixed-rate, clk-gate, clk-mux and
some clk-synth should be enough. The current core clk templates in the
api are almost all special implementations.

Sebastian
