Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3LSFyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:54:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37311 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab3LSFyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:54:47 -0500
Message-ID: <52B28A1B.3030209@ti.com>
Date: Thu, 19 Dec 2013 11:24:35 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/9] Input: pixcir_i2c_ts: Get rid of pdata->attb_read_val()
References: <1387358480-8313-1-git-send-email-rogerq@ti.com> <1387358480-8313-6-git-send-email-rogerq@ti.com> <20131218142056.GF28504@core.coreip.homeip.net>
In-Reply-To: <20131218142056.GF28504@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 07:50 PM, Dmitry Torokhov wrote:
> On Wed, Dec 18, 2013 at 02:51:16PM +0530, Roger Quadros wrote:
>> Get rid of the attb_read_val() platform hook. Instead,
>> read the ATTB gpio directly from the driver.
>>
>> Fail if valid ATTB gpio is not provided by patform data.
> 
> Do you also need to define polarity?
> 

In patch 3, in pixcir_start(), we explicitly configure the GPIO output
polarity as /* LEVEL_TOUCH interrupt with active low polarity */

So I don't think we need to define polarity.

cheers,
-roger

>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
>> ---
>>  drivers/input/touchscreen/pixcir_i2c_ts.c | 19 +++++++++++++++++--
>>  include/linux/input/pixcir_ts.h           |  1 -
>>  2 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
>> index 3370fd9..a783d94 100644
>> --- a/drivers/input/touchscreen/pixcir_i2c_ts.c
>> +++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
>> @@ -91,11 +91,12 @@ static void pixcir_ts_poscheck(struct pixcir_i2c_ts_data *data)
>>  static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
>>  {
>>  	struct pixcir_i2c_ts_data *tsdata = dev_id;
>> +	const struct pixcir_ts_platform_data *pdata = tsdata->chip;
>>  
>>  	while (!tsdata->exiting) {
>>  		pixcir_ts_poscheck(tsdata);
>>  
>> -		if (tsdata->chip->attb_read_val())
>> +		if (gpio_get_value(pdata->gpio_attb))
>>  			break;
>>  
>>  		msleep(20);
>> @@ -301,8 +302,10 @@ static struct pixcir_ts_platform_data *pixcir_parse_dt(struct device *dev)
>>  		return ERR_PTR(-ENOMEM);
>>  
>>  	pdata->gpio_attb = of_get_named_gpio(np, "attb-gpio", 0);
>> -	if (!gpio_is_valid(pdata->gpio_attb))
>> +	if (!gpio_is_valid(pdata->gpio_attb)) {
>>  		dev_err(dev, "Failed to get ATTB GPIO\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>>  
>>  	if (of_property_read_u32(np, "x-size", &pdata->x_size)) {
>>  		dev_err(dev, "Failed to get x-size property\n");
>> @@ -344,6 +347,11 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
>>  	} else if (!pdata) {
>>  		dev_err(&client->dev, "platform data not defined\n");
>>  		return -EINVAL;
>> +	} else {
>> +		if (!gpio_is_valid(pdata->gpio_attb)) {
>> +			dev_err(dev, "Invalid gpio_attb in pdata\n");
>> +			return -EINVAL;
>> +		}
>>  	}
>>  
>>  	tsdata = devm_kzalloc(dev, sizeof(*tsdata), GFP_KERNEL);
>> @@ -380,6 +388,13 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
>>  
>>  	input_set_drvdata(input, tsdata);
>>  
>> +	error = devm_gpio_request_one(dev, pdata->gpio_attb,
>> +			GPIOF_DIR_IN, "pixcir_i2c_attb");
>> +	if (error) {
>> +		dev_err(dev, "Failed to request ATTB gpio\n");
>> +		return error;
>> +	}
>> +
>>  	error = devm_request_threaded_irq(dev, client->irq, NULL, pixcir_ts_isr,
>>  				     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>>  				     client->name, tsdata);
>> diff --git a/include/linux/input/pixcir_ts.h b/include/linux/input/pixcir_ts.h
>> index f17c192..88ffdb50 100644
>> --- a/include/linux/input/pixcir_ts.h
>> +++ b/include/linux/input/pixcir_ts.h
>> @@ -44,7 +44,6 @@ enum pixcir_int_mode {
>>  #define PIXCIR_INT_POL_HIGH	(1UL << 2)
>>  
>>  struct pixcir_ts_platform_data {
>> -	int (*attb_read_val)(void);
>>  	unsigned int x_size;	/* X axis resolution */
>>  	unsigned int y_size;	/* Y axis resolution */
>>  	int gpio_attb;		/* GPIO connected to ATTB line */
>> -- 
>> 1.8.3.2
>>
> 

