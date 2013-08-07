Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3HGIHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:07:46 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12214 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab3HGIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:07:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Aug 2013 01:05:59 -0700
Message-ID: <52020047.1080705@nvidia.com>
Date: Wed, 7 Aug 2013 16:07:35 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Alexander Shiyan <shc_work@mail.ru>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] hwmon: (lm90) Add power control
References: <1375858358-15070-1-git-send-email-wni@nvidia.com> <1375858358-15070-2-git-send-email-wni@nvidia.com> <1375860442.896960598@f427.i.mail.ru> <5201F811.9050602@nvidia.com> <5201FC2C.4030908@roeck-us.net>
In-Reply-To: <5201FC2C.4030908@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:50 PM, Guenter Roeck wrote:
> On 08/07/2013 12:32 AM, Wei Ni wrote:
>> On 08/07/2013 03:27 PM, Alexander Shiyan wrote:
>>>> The device lm90 can be controlled by the vdd rail.
>>>> Adding the power control support to power on/off the vdd rail.
>>>> And make sure that power is enabled before accessing the device.
>>>>
>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>> ---
>>>>   drivers/hwmon/lm90.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>> [...]
>>>> +	if (!data->lm90_reg) {
>>>> +		data->lm90_reg = regulator_get(&client->dev, "vdd");
>>>> +		if (IS_ERR_OR_NULL(data->lm90_reg)) {
>>>> +			if (PTR_ERR(data->lm90_reg) == -ENODEV)
>>>> +				dev_info(&client->dev,
>>>> +					 "No regulator found for vdd. Assuming vdd is always powered.");
>>>> +			else
>>>> +				dev_warn(&client->dev,
>>>> +					 "Error [%ld] in getting the regulator handle for vdd.\n",
>>>> +					 PTR_ERR(data->lm90_reg));
>>>> +			data->lm90_reg = NULL;
>>>> +			mutex_unlock(&data->update_lock);
>>>> +			return -ENODEV;
>>>> +		}
>>>> +	}
>>>> +	if (is_enable) {
>>>> +		ret = regulator_enable(data->lm90_reg);
>>>> +		msleep(POWER_ON_DELAY);
>>>
>>> Can this delay be handled directly from regulator?
>>
>> I think it should be handled in the device driver.
>> Because there have different delay time to wait devices stable.
>>
> 
> Then why does no other caller of regulator_enable() need this ?
> I don't think lm90 is so much different to other users of regulator
> functionality.

May be I'm wrong. I noticed that in lm90 SPEC, the max of "SMBus Clock
Low Time" is 25ms, so I supposed that it may need about 20ms to stable
after power on.

Anyway, if I remove this delay, the driver also works fine, so I will
remove it in my next patch.

Thanks.
Wei.

> 
> Besides that, your delay is unconditional, even for static regulators
> which are always on. Other callers of regulator_enable() don't need
> all that complexity, which I take as sign that it is not needed here either.
> 
> Guenter
> 

