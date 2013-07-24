Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3GXHqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:46:37 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13786 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GXHqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:46:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 24 Jul 2013 00:46:35 -0700
Message-ID: <51EF8666.5050305@nvidia.com>
Date: Wed, 24 Jul 2013 15:46:46 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "linux@roeck-us.net" <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] hwmon: (lm90) add support to handle IRQ
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-4-git-send-email-wni@nvidia.com> <20130718175822.62c358bf@endymion.delvare> <51E8DFB2.9070701@nvidia.com>
In-Reply-To: <51E8DFB2.9070701@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jean

On 07/19/2013 02:41 PM, Wei Ni wrote:
> On 07/18/2013 11:58 PM, Jean Delvare wrote:
>> Hi Wei,
>>
>> On Fri, 12 Jul 2013 15:48:06 +0800, Wei Ni wrote:
>>> When the temperature exceed the limit range value,
>>> the driver can handle the interrupt.
>>>
>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>> ---
>>>  drivers/hwmon/lm90.c |   24 ++++++++++++++++++++++++
>>>  1 file changed, 24 insertions(+)
>>>
>>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>>> index c90037f..1cc3d19 100644
>>> --- a/drivers/hwmon/lm90.c
>>> +++ b/drivers/hwmon/lm90.c
>>> @@ -89,6 +89,7 @@
>>>  #include <linux/err.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/sysfs.h>
>>> +#include <linux/interrupt.h>
>>>  
>>>  /*
>>>   * Addresses to scan
>>> @@ -1460,6 +1461,17 @@ static bool lm90_is_tripped(struct i2c_client *client)
>>>  	return true;
>>>  }
>>>  
>>> +static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
>>> +{
>>> +	struct lm90_data *data = dev_id;
>>> +	struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);
>>
>> Why are you passing data as the dev_id in the first place, instead of
>> client? It's easier to get the data when you have the client
>> (i2c_get_clientdata) than the other way around.
> 
> Oh, I'm stupid :)
> I will pass the client.
> 
>>
>>> +
>>> +	if (lm90_is_tripped(client))
>>> +		return IRQ_HANDLED;
>>> +	else
>>> +		return IRQ_NONE;
>>> +}
>>> +
>>>  static int lm90_probe(struct i2c_client *client,
>>>  		      const struct i2c_device_id *id)
>>>  {
>>> @@ -1536,6 +1548,18 @@ static int lm90_probe(struct i2c_client *client,
>>>  		goto exit_remove_files;
>>>  	}
>>>  
>>> +	if (client->irq >= 0) {
>>
>> I though you had agreed to just check for (client->irq)?
> 
> Oh, yes, I forgot to change it, thanks, I will update it.
> 
>>
>>> +		dev_dbg(dev, "lm90 IRQ: %d\n", client->irq);
>>
>> The "lm90" is redundant, dev_dbg will use the chip name as a prefix.
> 
> Ok, I will remove it.
> 
>>
>>> +		err = devm_request_threaded_irq(dev, client->irq,
>>> +						NULL, lm90_irq_thread,
>>> +						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>>> +						"lm90", data);
>>> +		if (err < 0) {
>>> +			dev_err(dev, "cannot request interrupt\n");
>>
>> You should include the IRQ number in the error message, it is useful
>> for investigating the issue. Not everyone will have the debugging
>> message above enabled.
> 
> Yes, you are right, I will add the IRQ number.
> 
>>
>>> +			goto exit_remove_files;
>>> +		}
>>> +	}
>>> +
>>>  	return 0;
>>>  
>>>  exit_remove_files:
>>
>> That's it for the code. Now I'm not sure I understand what you are
>> trying to do and what this is all good for.
>>
>> First of all, how is the chip wired on your system? You are using an
>> NCT1008, right? Which output of the chip is connected to your interrupt
>> line, THERM or ALERT/THERM2? ALERT is normally used for SMBus Alert but
>> I suppose it could be used for an interrupt too. THERM and THERM2 OTOH
>> are comparator outputs, they stay low as long as the temperature are
>> above the therm limits. Reading the status register won't bring them
>> back up as I understand it, and contrary to the ALERT output, they
>> can't be masked. Won't this result in an interrupt flood if using
>> IRQF_TRIGGER_LOW? Have you tested your code already?
> 
> Let me explain why I want to add the IRQ thread.
> In our tegra30 platform, we use an NCT1008, and in our downstream tree,
> it programmed as following:
> 1. The pin THERM is connected to the PMIC, we will set the THERM limit
> in the initialization, once the this limit is tripped, it will trigged
> the PMIC, and the PMIC will shutdown the system immediately.
> 2. The pin ALERT/THERM2 is configured as ALERT, and it is connected to
> the interrupt line. In the platform init, we will prepare some trip
> temps, such as 20C, 40C,60C, 80C, and we will set 20C to the
> remote-low-temp-limit, and set 40C to remote-high-temp-limit. When the
> temperature exceed this rang, it will interrupt the system, then we will
> update the low/high limit to next rang, for example, if the temp raise
> to 50C, we will set 40C to low-limit, and set 60C to hight-limit, then
> we will run the throttle functions, and update cooling state.
> 
> We wish to upstream these codes, but as you know, it's difficult to use
> current lm90.c and thermal framework to implement it, and these codes
> related many other things, such as throttling cpufreq, other clock freq.
> So at first, I want to update the lm90.c, so that I can add it to the
> thermal fw and use interrupt handler easily. And at the same time I
> followed the thermal framework thread, there has new infrastructure
> posted, which is more easy to add lm90 to thermal fw.
> 
>>
>> Also I don't think just logging an error message is the right thing to
>> do in the case of overheating. The code to handle SMBus alerts is from
>> me, and it does indeed just log the problems, but it was really only
>> meant as a proof of concept when I first added support for SMBus Alert.
>> Today we could do better than this, starting with issuing sysfs
>> notifications to the relevant alarm files (several other hwmon drivers
>> are doing that already.)
> 
> yes, I can try to use sysfs_notify() for the alarm.
> 
>>
>> For a real system, if the THERM output is connected to an interrupt line
>> (instead of directly to a fan controller) I would expect the platform
>> to provide a callback to handle thermal events and take whatever
>> appropriate measure is needed (e.g. throttling.) Just logging the
>> problem won't save the system, by the time someone looks at the log it
>> might be too late.
> 
> In our downstream tree, we write a new driver nct1008.c, whci can handle
> these interrupts and all other things, but as you know this driver can't
> be upstreamed, because there already has the lm90.c :).
> Anyway I think this patch is the first step of the implementation.

Do you have any more suggestions for this series, if no, I will prepare
v4 patches.

Thanks.
Wei.
> 
>>
> 

