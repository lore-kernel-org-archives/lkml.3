Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaJVTDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:03:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41569 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbaJVTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:03:21 -0400
Message-ID: <5447FF51.5000401@ti.com>
Date: Wed, 22 Oct 2014 22:02:41 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] PM / clock_ops: Add pm_clk_add_clk()
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com> <1413809764-21995-2-git-send-email-grygorii.strashko@ti.com> <20141022173856.GB28104@dtor-ws>
In-Reply-To: <20141022173856.GB28104@dtor-ws>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 08:38 PM, Dmitry Torokhov wrote:
> On Mon, Oct 20, 2014 at 03:56:02PM +0300, Grygorii Strashko wrote:
>> From: Geert Uytterhoeven <geert+renesas@glider.be>
>>
>> The existing pm_clk_add() allows to pass a clock by con_id. However,
>> when referring to a specific clock from DT, no con_id is available.
>>
>> Add pm_clk_add_clk(), which allows to specify the struct clk * directly.
>>
>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>
>>   Pay attantion pls, that there is another series of patches
>>   which have been posted already and which depends from this patch
>>     "[PATCH v4 0/3] ARM: rk3288 : Add PM Domain support"
>>     https://lkml.org/lkml/2014/10/20/105
>>
>>   drivers/base/power/clock_ops.c | 41 +++++++++++++++++++++++++++++++----------
>>   include/linux/pm_clock.h       |  8 ++++++++
>>   2 files changed, 39 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
>> index 7836930..f14b767 100644
>> --- a/drivers/base/power/clock_ops.c
>> +++ b/drivers/base/power/clock_ops.c
>> @@ -53,7 +53,8 @@ static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
>>    */
>>   static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
>>   {
>> -	ce->clk = clk_get(dev, ce->con_id);
>> +	if (!ce->clk)
>> +		ce->clk = clk_get(dev, ce->con_id);
>>   	if (IS_ERR(ce->clk)) {
>>   		ce->status = PCE_STATUS_ERROR;
>>   	} else {
>> @@ -63,15 +64,8 @@ static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
>>   	}
>>   }
>>
>> -/**
>> - * pm_clk_add - Start using a device clock for power management.
>> - * @dev: Device whose clock is going to be used for power management.
>> - * @con_id: Connection ID of the clock.
>> - *
>> - * Add the clock represented by @con_id to the list of clocks used for
>> - * the power management of @dev.
>> - */
>> -int pm_clk_add(struct device *dev, const char *con_id)
>> +static int __pm_clk_add(struct device *dev, const char *con_id,
>> +			struct clk *clk)
>>   {
>>   	struct pm_subsys_data *psd = dev_to_psd(dev);
>>   	struct pm_clock_entry *ce;
>> @@ -93,6 +87,8 @@ int pm_clk_add(struct device *dev, const char *con_id)
>>   			kfree(ce);
>>   			return -ENOMEM;
>>   		}
>> +	} else {
>> +		ce->clk = clk;
>>   	}
>>
>>   	pm_clk_acquire(dev, ce);
>> @@ -104,6 +100,31 @@ int pm_clk_add(struct device *dev, const char *con_id)
>>   }
>>
>>   /**
>> + * pm_clk_add - Start using a device clock for power management.
>> + * @dev: Device whose clock is going to be used for power management.
>> + * @con_id: Connection ID of the clock.
>> + *
>> + * Add the clock represented by @con_id to the list of clocks used for
>> + * the power management of @dev.
>> + */
>> +int pm_clk_add(struct device *dev, const char *con_id)
>> +{
>> +	return __pm_clk_add(dev, con_id, NULL);
>
> Bikeshedding: why do we need __pm_clk_add() and not simply have
> "canonical" pm_clk_add_clk() and then do:
>
> int pm_clk_add(struct device *dev, const char *con_id)
> {
> 	struct clk *clk;
>
> 	clk = clk_get(dev, con_id);
> 	...
> 	return pm_clk_add_clk(dev, clk);
> }

Hm. I did fast look at code and:
1) agree - there is a lot of thing which can be optimized ;)
2) in my strong opinion, this patch is the fastest and simplest
way to introduce new API (take a look on pm_clock_entry->con_id
management code) and It is exactly what we need as of now.

regards,
-grygorii

