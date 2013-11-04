Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3KDKFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:05:55 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17749 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3KDKFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:05:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Nov 2013 02:04:58 -0800
Message-ID: <52777187.5010202@nvidia.com>
Date: Mon, 4 Nov 2013 18:05:59 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] hwmon: (lm90) add support to handle IRQ
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
	<1375856306-14415-3-git-send-email-wni@nvidia.com>
 <20131104103434.5a085e27@endymion.delvare>
In-Reply-To: <20131104103434.5a085e27@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 05:34 PM, Jean Delvare wrote:
> Hi Wei,
> 
> I'm hitting a problem with that patch now...
> 
> On Wed, 7 Aug 2013 14:18:25 +0800, Wei Ni wrote:
>> When the temperature exceed the limit range value,
>> the driver can handle the interrupt.
>>
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>  drivers/hwmon/lm90.c |   23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>> index 1da2eff..2e68773 100644
>> --- a/drivers/hwmon/lm90.c
>> +++ b/drivers/hwmon/lm90.c
>> @@ -89,6 +89,7 @@
>>  #include <linux/err.h>
>>  #include <linux/mutex.h>
>>  #include <linux/sysfs.h>
>> +#include <linux/interrupt.h>
>>  
>>  /*
>>   * Addresses to scan
>> @@ -1433,6 +1434,16 @@ static bool lm90_is_tripped(struct i2c_client *client)
>>  	return true;
>>  }
>>  
>> +static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
>> +{
>> +	struct i2c_client *client = dev_id;
>> +
>> +	if (lm90_is_tripped(client))
> 
> Did you really send the latest version of the patch? lm90_is_tripped()
> takes two arguments now, but here you only pass one.
> 
> If you have a more up-to-date version of this patch, please send it
> over quickly.

Hi, Jean
It's so sorry. As you know I resend the "[PATCH RESEND v4 1/3] hwmon:
(lm90) Define status bits" last week, but didn't rebase this patch. I
will rebase it and send it right now.

Wei.
Thanks.

> 
>> +		return IRQ_HANDLED;
>> +	else
>> +		return IRQ_NONE;
>> +}
>> +
>>  static int lm90_probe(struct i2c_client *client,
>>  		      const struct i2c_device_id *id)
>>  {
>> @@ -1509,6 +1520,18 @@ static int lm90_probe(struct i2c_client *client,
>>  		goto exit_remove_files;
>>  	}
>>  
>> +	if (client->irq) {
>> +		dev_dbg(dev, "IRQ: %d\n", client->irq);
>> +		err = devm_request_threaded_irq(dev, client->irq,
>> +						NULL, lm90_irq_thread,
>> +						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>> +						"lm90", client);
>> +		if (err < 0) {
>> +			dev_err(dev, "cannot request IRQ: %d\n", client->irq);
>> +			goto exit_remove_files;
>> +		}
>> +	}
>> +
>>  	return 0;
>>  
>>  exit_remove_files:
> 
> 

