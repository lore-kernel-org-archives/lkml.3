Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3DONY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:24:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45979 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3DONY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:24:27 -0400
Message-ID: <516BFF83.8040800@ti.com>
Date: Mon, 15 Apr 2013 09:24:19 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <durgadoss.r@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv3 3/3] staging: ti-soc-thermal: remove external heat while
 extrapolating hotspot
References: <1365165150-11720-1-git-send-email-eduardo.valentin@ti.com>  <1365165150-11720-4-git-send-email-eduardo.valentin@ti.com> <1365990259.2803.4.camel@rzhang1-mobl4>
In-Reply-To: <1365990259.2803.4.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-2013 21:44, Zhang Rui wrote:
> On Fri, 2013-04-05 at 08:32 -0400, Eduardo Valentin wrote:
>> For boards that provide a PCB sensor close to SoC junction
>> temperature, it is possible to remove the cumulative heat
>> reported by the SoC temperature sensor.
>>
>> This patch changes the extrapolation computation to consider
>> an external sensor in the extrapolation equations.
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>
> hmm, who should take this patch?
>

I will send this one to Greg, maintainer of the staging tree.

BTW, Rui, do you think there is still time to send the TI driver out of 
the drivers/staging/ti-soc-thermal to drivers/thermal/ti-soc-thermal for 
3.10? If yes, I can send a series straight away.



> thanks,
> rui
>> ---
>>   drivers/staging/ti-soc-thermal/ti-thermal-common.c |   30 +++++++++++++------
>>   1 files changed, 20 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
>> index 231c549..780368b 100644
>> --- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
>> +++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
>> @@ -38,6 +38,7 @@
>>   /* common data structures */
>>   struct ti_thermal_data {
>>   	struct thermal_zone_device *ti_thermal;
>> +	struct thermal_zone_device *pcb_tz;
>>   	struct thermal_cooling_device *cool_dev;
>>   	struct ti_bandgap *bgp;
>>   	enum thermal_device_mode mode;
>> @@ -77,10 +78,12 @@ static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
>>   static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
>>   				      unsigned long *temp)
>>   {
>> +	struct thermal_zone_device *pcb_tz = NULL;
>>   	struct ti_thermal_data *data = thermal->devdata;
>>   	struct ti_bandgap *bgp;
>>   	const struct ti_temp_sensor *s;
>> -	int ret, tmp, pcb_temp, slope, constant;
>> +	int ret, tmp, slope, constant;
>> +	unsigned long pcb_temp;
>>
>>   	if (!data)
>>   		return 0;
>> @@ -92,16 +95,22 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
>>   	if (ret)
>>   		return ret;
>>
>> -	pcb_temp = 0;
>> -	/* TODO: Introduce pcb temperature lookup */
>> +	/* Default constants */
>> +	slope = s->slope;
>> +	constant = s->constant;
>> +
>> +	pcb_tz = data->pcb_tz;
>>   	/* In case pcb zone is available, use the extrapolation rule with it */
>> -	if (pcb_temp) {
>> -		tmp -= pcb_temp;
>> -		slope = s->slope_pcb;
>> -		constant = s->constant_pcb;
>> -	} else {
>> -		slope = s->slope;
>> -		constant = s->constant;
>> +	if (!IS_ERR_OR_NULL(pcb_tz)) {
>> +		ret = thermal_zone_get_temp(pcb_tz, &pcb_temp);
>> +		if (!ret) {
>> +			tmp -= pcb_temp; /* got a valid PCB temp */
>> +			slope = s->slope_pcb;
>> +			constant = s->constant_pcb;
>> +		} else {
>> +			dev_err(bgp->dev,
>> +				"Failed to read PCB state. Using defaults\n");
>> +		}
>>   	}
>>   	*temp = ti_thermal_hotspot_temperature(tmp, slope, constant);
>>
>> @@ -248,6 +257,7 @@ static struct ti_thermal_data
>>   	data->sensor_id = id;
>>   	data->bgp = bgp;
>>   	data->mode = THERMAL_DEVICE_ENABLED;
>> +	data->pcb_tz = thermal_zone_get_zone_by_name("pcb");
>>   	INIT_WORK(&data->thermal_wq, ti_thermal_work);
>>
>>   	return data;
>
>
>
>

