Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3GKIlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:41:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6872 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3GKIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:41:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 11 Jul 2013 01:41:05 -0700
Message-ID: <51DE6F66.6020606@nvidia.com>
Date: Thu, 11 Jul 2013 16:40:06 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] hwmon: (lm90) add support to handle IRQ.
References: <1373455539-2831-1-git-send-email-wni@nvidia.com> <1373455539-2831-3-git-send-email-wni@nvidia.com> <20130710181820.GB22430@roeck-us.net>
In-Reply-To: <20130710181820.GB22430@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 02:18 AM, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 07:25:38PM +0800, Wei Ni wrote:
>> When the temperature exceed the limit range value,
>> the driver can handle the interrupt.
>>
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>  drivers/hwmon/lm90.c |   77 +++++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 64 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>> index 2cb7f8e..88ff362 100644
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
>> @@ -179,6 +180,19 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
>>  #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
>>  #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
>>  
>> +/* LM90 status */
>> +#define LM90_LTHRM	(1 << 0)	/* local THERM limit tripped */
>> +#define LM90_RTHRM	(1 << 1)	/* remote THERM limit tripped */
>> +#define LM90_OPEN	(1 << 2)	/* remote is an open circuit */
>> +#define LM90_RLOW	(1 << 3)	/* remote low temp limit tripped */
>> +#define LM90_RHIGH	(1 << 4)	/* remote high temp limit tripped */
>> +#define LM90_LLOW	(1 << 5)	/* local low temp limit tripped */
>> +#define LM90_LHIGH	(1 << 6)	/* local high temp limit tripped */
>> +#define LM90_BUSY	(1 << 7)	/* ADC is converting */
>> +
>> +#define MAX6696_RLOW	(1 << 3)	/* remote2 low temp limit tripped */
>> +#define MAX6696_RHIGH	(1 << 4)	/* remote2 high temp limit tripped */
>> +
>>  /*
>>   * Driver data (common to all clients)
>>   */
>> @@ -1423,6 +1437,43 @@ static void lm90_init_client(struct i2c_client *client)
>>  		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
>>  }
>>  
>> +static void lm90_alarm_status(struct i2c_client *client,
>> +			      u8 alarms, u8 alarms_max6696)
>> +{
> If you are introdcing a function to evaluate the alarm status, you might as well
> copy the register reads as well as the mask evaluations into this function.
> 
> If you don't want to see the "Everything ok" output if nothing is wrong, it can
> return a boolean indicating if a status bit was set. This way the calling code
> can also more easily determine if it should return IRQ_NONE or IRQ_HANDLED.

Yes, you are right, I will change change the function to:
lm90_is_tripped(*client)
{
/* read status register */
/* check bit */
/* return true or false to indicate if the limit tripped */
}

> 
>> +	if (alarms & (LM90_LLOW | LM90_LHIGH | LM90_LTHRM))
>> +		dev_warn(&client->dev,
>> +			 "temp%d out of range, please check!\n", 1);
>> +	if (alarms & (LM90_RLOW | LM90_RHIGH | LM90_RTHRM))
>> +		dev_warn(&client->dev,
>> +			 "temp%d out of range, please check!\n", 2);
>> +	if (alarms & LM90_OPEN)
>> +		dev_warn(&client->dev,
>> +			 "temp%d diode open, please check!\n", 2);
>> +
>> +	if (alarms_max6696 & (MAX6696_RLOW | MAX6696_RHIGH))
>> +		dev_warn(&client->dev,
>> +			 "temp%d out of range, please check!\n", 3);
>> +}
>> +
>> +static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
>> +{
>> +	struct lm90_data *data = dev_id;
>> +	struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);
>> +	u8 alarms, alarms_max6696 = 0;
>> +
> Please stick with alarms2 instead of alarms_max6696 as in the original code.
> 
>> +	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
>> +
>> +	if (data->kind == max6696)
>> +		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &alarms_max6696);
>> +
>> +	if ((alarms & 0x7f) == 0 && (alarms_max6696 & 0xfe) == 0) {
>> +		return IRQ_NONE;
>> +	} else {
> 
> That else statement is unnecessary.
> 
>> +		lm90_alarm_status(client, alarms, alarms_max6696);
>> +		return IRQ_HANDLED;
>> +	}
>> +}
>> +
>>  static int lm90_probe(struct i2c_client *client,
>>  		      const struct i2c_device_id *id)
>>  {
>> @@ -1499,6 +1550,18 @@ static int lm90_probe(struct i2c_client *client,
>>  		goto exit_remove_files;
>>  	}
>>  
>> +	if (client->irq >= 0) {
>> +		dev_dbg(dev, "lm90 IRQ: %d\n", client->irq);
>> +		err = devm_request_threaded_irq(dev, client->irq,
>> +						NULL, lm90_irq_thread,
>> +						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>> +						"lm90", data);
>> +		if (err < 0) {
>> +			dev_err(dev, "cannot request interrupt\n");
>> +			goto exit_remove_files;
>> +		}
>> +	}
>> +
>>  	return 0;
>>  
>>  exit_remove_files:
>> @@ -1532,19 +1595,7 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
>>  	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
>>  		dev_info(&client->dev, "Everything OK\n");
>>  	} else {
>> -		if (alarms & 0x61)
>> -			dev_warn(&client->dev,
>> -				 "temp%d out of range, please check!\n", 1);
>> -		if (alarms & 0x1a)
>> -			dev_warn(&client->dev,
>> -				 "temp%d out of range, please check!\n", 2);
>> -		if (alarms & 0x04)
>> -			dev_warn(&client->dev,
>> -				 "temp%d diode open, please check!\n", 2);
>> -
>> -		if (alarms2 & 0x18)
>> -			dev_warn(&client->dev,
>> -				 "temp%d out of range, please check!\n", 3);
>> +		lm90_alarm_status(client, alarms, alarms2);
>>  
>>  		/*
>>  		 * Disable ALERT# output, because these chips don't implement
>> -- 
>> 1.7.9.5
>>
>>

