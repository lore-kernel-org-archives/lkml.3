Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093AbaEMPMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:12:07 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53959 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaEMPMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:12:02 -0400
Message-ID: <5372363B.4080608@gmail.com>
Date: Tue, 13 May 2014 17:11:55 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Mark Rutland <mark.rutland@arm.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH 1/2] clk: of: helper for determining flags properties
References: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org> <1399982253-21079-2-git-send-email-gabriel.fernandez@linaro.org> <20140513122054.GA2419@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140513122054.GA2419@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 02:20 PM, Mark Rutland wrote:
> On Tue, May 13, 2014 at 12:57:32PM +0100, Gabriel FERNANDEZ wrote:
>> The patch provides a helper to get flags properties of
>> a clock node.
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>   drivers/clk/clk.c            | 11 +++++++++++
>>   include/linux/clk-provider.h |  6 ++++++
>>   2 files changed, 17 insertions(+)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 4d56220..cae8985 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -2528,6 +2528,17 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>>   }
>>   EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>>
>> +unsigned long of_clk_get_flags(struct device_node *np)
>> +{
>> +	unsigned long flags = 0;
>> +
>> +	if (of_property_read_bool(np, "set-rate-parent"))
>> +		flags |= CLK_SET_RATE_PARENT;
>
> NAK.
>
> This is _not_ a hardware property. This flag describes internals of the
> Linux clock framework, and is thus not suitable for DT.

Mark,

while I agree above property is not a hardware property, it is at least
some kind of use-case property. If not by DT, we will have to allow some
way to describe master-slave relationships between clocks in a driver
independent way.

> You've also failed to document the property.
>
> What are you trying to achieve here, and why do you think this is the
> best way of achieving that?

I cannot tell from the commit msgs, but consider clk-si5351 which is a
driver for an external programmable clock with N PLLs and M outputs. Now
connect a video clock consumer and an audio clock consumer to two
different outputs and those to one PLL (as you want audio clock derived
from video clock, typical HDMI scenario).

Now, there should be a way to tell the generic driver which outputs are
allowed to change the PLLs rate and which don't. Otherwise, the clock
chip would be pretty useless as e.g. your audio clock consumer will
overwrite the rate the video clock consumer has chosen.

BTW, clk-si5351 has vendor-specific properties to specify which output
clocks are pll-masters for some kernel cycles already.

Sebastian

>> +
>> +	return flags;
>> +}
>> +EXPORT_SYMBOL_GPL(of_clk_get_flags);
>> +
>>   struct clock_provider {
>>   	of_clk_init_cb_t clk_init_cb;
>>   	struct device_node *np;
>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>> index 59e2eb5..650bc10 100644
>> --- a/include/linux/clk-provider.h
>> +++ b/include/linux/clk-provider.h
>> @@ -519,6 +519,7 @@ int of_clk_get_parent_count(struct device_node *np);
>>   const char *of_clk_get_parent_name(struct device_node *np, int index);
>>
>>   void of_clk_init(const struct of_device_id *matches);
>> +unsigned long of_clk_get_flags(struct device_node *np);
>>
>>   #else /* !CONFIG_OF */
>>
>> @@ -546,6 +547,11 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
>>   {
>>   	return NULL;
>>   }
>> +static inline unsigned long of_clk_get_flags(struct device_node *np)
>> +{
>> +	return NULL;
>> +}
>> +
>>   #define of_clk_init(matches) \
>>   	{ while (0); }
>>   #endif /* CONFIG_OF */
>> --
>> 1.9.1
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

