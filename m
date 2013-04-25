Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab3DYURE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:17:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37932 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab3DYURD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:17:03 -0400
Message-ID: <51798F2B.4000602@ti.com>
Date: Thu, 25 Apr 2013 16:16:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        J Keerthy <j-keerthy@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1] staging: ti-soc-thermal: remove usage of IS_ERR_OR_NULL
References: <1366897576-20423-1-git-send-email-eduardo.valentin@ti.com> <20130425174445.GA25783@flint.arm.linux.org.uk>
In-Reply-To: <20130425174445.GA25783@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Thanks for your time reviewing this patch.

On 25-04-2013 13:44, Russell King wrote:
> On Thu, Apr 25, 2013 at 09:46:16AM -0400, Eduardo Valentin wrote:
>> diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
>> index f20c1cf..5027833 100644
>> --- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
>> +++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
>> @@ -469,7 +469,7 @@ static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
>>   {
>>   	int ret = 0;
>>
>> -	if (IS_ERR_OR_NULL(bgp)) {
>> +	if (!bgp || IS_ERR(bgp)) {
>>   		pr_err("%s: invalid bandgap pointer\n", __func__);
>>   		ret = -EINVAL;
>
> We really don't need these kinds of "bad pointer passed to a function"
> checks in the kernel.  Just ensure that all callers have correctly
> error checked the return value.

Right.. I will check if it is safe to simply remove the above check.

>
>>   		goto exit;
>> @@ -1191,7 +1191,7 @@ int ti_bandgap_probe(struct platform_device *pdev)
>>   	int clk_rate, ret = 0, i;
>>
>>   	bgp = ti_bandgap_build(pdev);
>> -	if (IS_ERR_OR_NULL(bgp)) {
>> +	if (IS_ERR(bgp)) {
>>   		dev_err(&pdev->dev, "failed to fetch platform data\n");
>>   		return PTR_ERR(bgp);
>
> That was definitely a bug, good fix.
>
>>   	}
>> @@ -1207,14 +1207,14 @@ int ti_bandgap_probe(struct platform_device *pdev)
>>   	}
>>
>>   	bgp->fclock = clk_get(NULL, bgp->conf->fclock_name);
>> -	ret = IS_ERR_OR_NULL(bgp->fclock);
>> +	ret = IS_ERR(bgp->fclock);
>>   	if (ret) {
>>   		dev_err(&pdev->dev, "failed to request fclock reference\n");
>>   		goto free_irqs;
>>   	}
>
> I'm not sure that's correct.  If free_irqs ends up returning 'ret' then
> it will return 0 or 1, not the error code.

Indeed. Good point.

>
> 	if (IS_ERR(bgp->fclock)) {
> 		dev_err...
> 		ret = PTR_ERR(bgp->fclock);
> 		goto free_irqs;
> 	}
>
> would be much better in that case.

Yes, I will incorporate the above on next version.

>
> Also another fix - clk_get(&pdev->dev, "fclk") and arrange for the
> clkdev settings for this device.  Same for the one below but call
> it "div_clk" or something.

Yeh, that may come in a separated patch. I believe the driver just 
follows the TI OMAP autogeneration design. It just fetches the clk name 
fro hw database and auto gen the clkdev settings, I believe.

>
>>
>>   	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
>> -	ret = IS_ERR_OR_NULL(bgp->div_clk);
>> +	ret = IS_ERR(bgp->div_clk);
>>   	if (ret) {
>
> Possibly the same problem here if 'ret' ends up being returned as-is.

agreed.

>
>> diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
>> index 8e67ebf..4c5f55c37 100644
>> --- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
>> +++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
>> @@ -101,7 +101,7 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
>>
>>   	pcb_tz = data->pcb_tz;
>>   	/* In case pcb zone is available, use the extrapolation rule with it */
>> -	if (!IS_ERR_OR_NULL(pcb_tz)) {
>> +	if (!IS_ERR(pcb_tz)) {
>>   		ret = thermal_zone_get_temp(pcb_tz, &pcb_temp);
>>   		if (!ret) {
>>   			tmp -= pcb_temp; /* got a valid PCB temp */
>> @@ -124,7 +124,7 @@ static int ti_thermal_bind(struct thermal_zone_device *thermal,
>>   	struct ti_thermal_data *data = thermal->devdata;
>>   	int id;
>>
>> -	if (IS_ERR_OR_NULL(data))
>> +	if (!data || IS_ERR(data))
>>   		return -ENODEV;
>>
>>   	/* check if this is the cooling device we registered */
>> @@ -146,7 +146,7 @@ static int ti_thermal_unbind(struct thermal_zone_device *thermal,
>>   {
>>   	struct ti_thermal_data *data = thermal->devdata;
>>
>> -	if (IS_ERR_OR_NULL(data))
>> +	if (!data || IS_ERR(data))
>>   		return -ENODEV;
>>
>>   	/* check if this is the cooling device we registered */
>> @@ -282,6 +282,7 @@ static struct ti_thermal_data
>>   	data->sensor_id = id;
>>   	data->bgp = bgp;
>>   	data->mode = THERMAL_DEVICE_ENABLED;
>> +	/* pcb_tz will be either valid or PTR_ERR() */
>>   	data->pcb_tz = thermal_zone_get_zone_by_name("pcb");
>>   	INIT_WORK(&data->thermal_wq, ti_thermal_work);
>>
>> @@ -295,7 +296,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
>>
>>   	data = ti_bandgap_get_sensor_data(bgp, id);
>>
>> -	if (IS_ERR_OR_NULL(data))
>> +	if (!data || IS_ERR(data))
>>   		data = ti_thermal_build_data(bgp, id);
>>
>>   	if (!data)
>> @@ -306,7 +307,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
>>   				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
>>   				NULL, FAST_TEMP_MONITORING_RATE,
>>   				FAST_TEMP_MONITORING_RATE);
>> -	if (IS_ERR_OR_NULL(data->ti_thermal)) {
>> +	if (IS_ERR(data->ti_thermal)) {
>>   		dev_err(bgp->dev, "thermal zone device is NULL\n");
>>   		return PTR_ERR(data->ti_thermal);
>>   	}
>> @@ -343,7 +344,7 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
>>   	struct ti_thermal_data *data;
>>
>>   	data = ti_bandgap_get_sensor_data(bgp, id);
>> -	if (IS_ERR_OR_NULL(data))
>> +	if (!data || IS_ERR(data))
>>   		data = ti_thermal_build_data(bgp, id);
>
> I can't tell whether the above are correct or not as I can't see the
> original code.


That is in staging/next.

>
>>
>>   	if (!data)
>> @@ -356,7 +357,7 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
>>
>>   	/* Register cooling device */
>>   	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
>> -	if (IS_ERR_OR_NULL(data->cool_dev)) {
>> +	if (IS_ERR(data->cool_dev)) {
>>   		dev_err(bgp->dev,
>>   			"Failed to register cpufreq cooling device\n");
>>   		return PTR_ERR(data->cool_dev);
>
> Definitely a bug - and another good fix.

Thanks.
>

