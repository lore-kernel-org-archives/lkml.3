Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3FRIzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:55:12 -0400
Received: from smtp0.epfl.ch ([128.178.224.218]:40410 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754645Ab3FRIzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:55:08 -0400
Message-ID: <51C02067.4000302@epfl.ch>
Date: Tue, 18 Jun 2013 10:55:03 +0200
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: twl4030-power: Start transition to DT
References: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch> <1369921916-7435-3-git-send-email-florian.vaussard@epfl.ch> <20130618000211.GC7998@zurbaran>
In-Reply-To: <20130618000211.GC7998@zurbaran>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/18/2013 02:02 AM, Samuel Ortiz wrote:
> Hi Florian,
>
> On Thu, May 30, 2013 at 03:51:55PM +0200, Florian Vaussard wrote:
>>   int twl4030_power_probe(struct platform_device *pdev)
>>   {
>>   	struct twl4030_power_data *pdata = pdev->dev.platform_data;
>> +	struct device_node *node = pdev->dev.of_node;
>>   	int err = 0;
>> -	int i;
>> -	struct twl4030_resconfig *resconfig;
>> -	u8 val, address = twl4030_start_script_address;
>> +	u8 val;
>> +
>> +	if (!pdata && !node) {
>> +		dev_err(&pdev->dev, "Platform data is missing\n");
>> +		return -EINVAL;
>> +	}
>>
>>   	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
>>   			       TWL4030_PM_MASTER_PROTECT_KEY);
>> @@ -525,26 +575,17 @@ int twl4030_power_probe(struct platform_device *pdev)
>>   	if (err)
>>   		goto unlock;
>>
>> -	for (i = 0; i < pdata->num; i++) {
>> -		err = load_twl4030_script(pdata->scripts[i], address);
>> +	if (pdata) {
>> +		err = twl4030_power_configure_scripts(pdata);
>>   		if (err)
>>   			goto load;
>> -		address += pdata->scripts[i]->size;
>> -	}
>> -
>> -	resconfig = pdata->resource_config;
>> -	if (resconfig) {
>> -		while (resconfig->resource) {
>> -			err = twl4030_configure_resource(resconfig);
>> -			if (err)
>> -				goto resource;
>> -			resconfig++;
>> -
>> -		}
>> +		err = twl4030_power_configure_resources(pdata);
>> +		if (err)
>> +			goto resource;
> You're simplifying the probe routine here by defining 2
> twl4030_power_configure_* functions. That's good, but it should be a
> separate patch as it's not related to the DT porting effort.
>

I agree. I will post a v2 with the changes.

Regards,
Florian
