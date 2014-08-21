Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaHURqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:46:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40900 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaHURqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:46:37 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "Menon, Nishanth" <nm@ti.com>
CC: Dmitry Torokhov <dtor@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
Thread-Topic: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
Thread-Index: AQHPvVmPSBoHiwpjW0OMgiSDUUUlVQ==
Date: Thu, 21 Aug 2014 17:46:05 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DF07F9@DFLE09.ent.ti.com>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
 <1408636935-29515-1-git-send-email-nm@ti.com>
 <1408636935-29515-3-git-send-email-nm@ti.com>
 <00FC9A978A94B7418C33AFAE8A35ED49DF0662@DFLE09.ent.ti.com>
 <53F62A2B.6010208@ti.com>
 <00FC9A978A94B7418C33AFAE8A35ED49DF07A2@DFLE09.ent.ti.com>
 <20140821173715.GA23419@kahuna>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 12:37 PM, Menon, Nishanth wrote:
> On 12:32-20140821, Murphy, Dan wrote:
>> On 08/21/2014 12:19 PM, Menon, Nishanth wrote:
>>> On 08/21/2014 11:59 AM, Murphy, Dan wrote:
>>> [...]
>>> Ooops.. missed answering one addition statement:
>>>
>>>>> +	of_property_read_u32(np, "ti,palmas-long-press-seconds", &val);
>>>>
>>>> Probably should check the return to make sure the value exists and that is is
>>>> within an expected range.
>>> It is an optional parameter and may not exist in dt. when it does
>>> exist, the logic tries to do a best match (this is the for loop in the
>>> logic just below).
>>>
>>
>> The issue is val might be returned as a negative which will then proceed to
>> set the config->long_press_time_val to the lowest time value which then overrides
>> your initial setting of config->long_press_time_val = ARRAY_SIZE(lpk_times) - 1;
>>
> 
> Does the following as a replacement look OK? if yes, I can incorporate
> as part of v3 of this series.
> /**
>  * palmas_pwron_params_ofinit() - device tree parameter parser
>  * @dev:	palmas button device
>  * @config:	configuration params that this fills up
>  */
> static void palmas_pwron_params_ofinit(struct device *dev,
> 				       struct palmas_pwron_config *config)
> {
> 	struct device_node *np;
> 	u32 val;
> 	int i, ret;
> 	u8 lpk_times[] = { 6, 8, 10, 12 };
> 	int pwr_on_deb_ms[] = { 15, 100, 500, 1000 };
> 
> 	/* Handle cases where device node based configuration is not present */
> 	if (!of_have_populated_dt())
> 		return;
> 	np = of_node_get(dev->of_node);
> 	if (!np)
> 		return;
> 
> 	/* Default config parameters - least debounce, max long key press */
> 	config->pwron_debounce_val = 0;

And you can drop this as this value is set to zero in the probe when initialized.

> 	config->long_press_time_val = ARRAY_SIZE(lpk_times) - 1;

I would move this up to just before checking the dt.  Then they are defaulted
properly or move these to the probe.  Otherwise defaults are not set.

> 
> 	ret = of_property_read_u32(np, "ti,palmas-long-press-seconds", &val);
> 	if (ret)
> 		goto skip_lpk;
> 	for (i = 0; i < ARRAY_SIZE(lpk_times); i++) {
> 		if (val <= lpk_times[i]) {
> 			config->long_press_time_val = i;
> 			break;
> 		}
> 	}
> 
> skip_lpk:
> 	ret = of_property_read_u32(np, "ti,palmas-pwron-debounce-milli-seconds",
> 				   &val);
> 	if (ret)
> 		goto skip_debounce;
> 	for (i = 0; i < ARRAY_SIZE(pwr_on_deb_ms); i++) {
> 		if (val <= pwr_on_deb_ms[i]) {
> 			config->pwron_debounce_val = i;
> 			break;
> 		}
> 	}
> 
> skip_debounce:
> 	dev_info(dev, "h/w controlled shutdown duration=%d seconds\n",
> 		 lpk_times[config->long_press_time_val]);
> 
> 	of_node_put(np);
> }
> 


-- 
------------------
Dan Murphy
