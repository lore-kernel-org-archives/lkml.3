Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581AbaEFIds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:33:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46567 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934562AbaEFIdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:44 -0400
Message-ID: <53689E54.5080705@ti.com>
Date: Tue, 6 May 2014 11:33:24 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 6/7] Input: pixcir_i2c_ts: Implement wakeup from suspend
References: <1399280678-23925-1-git-send-email-rogerq@ti.com> <1399280678-23925-7-git-send-email-rogerq@ti.com> <20140506052148.GB2608@core.coreip.homeip.net>
In-Reply-To: <20140506052148.GB2608@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 08:21 AM, Dmitry Torokhov wrote:
> On Mon, May 05, 2014 at 12:04:37PM +0300, Roger Quadros wrote:
>> Improve the suspend and resume handlers to allow the device
>> to wakeup the system from suspend.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
>> ---
>>  drivers/input/touchscreen/pixcir_i2c_ts.c | 53 ++++++++++++++++++++++++++++---
>>  1 file changed, 49 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
>> index 927aed1..5f6a27e 100644
>> --- a/drivers/input/touchscreen/pixcir_i2c_ts.c
>> +++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
>> @@ -348,21 +348,66 @@ static void pixcir_input_close(struct input_dev *dev)
>>  static int pixcir_i2c_ts_suspend(struct device *dev)
>>  {
>>  	struct i2c_client *client = to_i2c_client(dev);
>> +	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
>> +	struct input_dev *input = ts->input;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&input->mutex);
>> +
>> +	if (input->users) {
>> +		ret = pixcir_stop(ts);
>> +		if (ret)
>> +			goto unlock;
>> +	}
>> +
>> +	/*
>> +	 * If wakeup is enabled we need to enable interrupt generation
>> +	 * but don't need to process any reports i.e. ts->exiting must be true.
>> +	 */
>> +	if (device_may_wakeup(&client->dev)) {
>> +		/* enable wakeup interrupt generation */
>> +		ret = pixcir_int_enable(ts, 1);
>> +		if (ret) {
>> +			dev_err(dev, "Failed to enable interrupt generation\n");
>> +			goto unlock;
>> +		}
> 
> I am not sure why we need to disable event processing here. Why not do
> 
> 	if (device_may_wakeup(&client->dev)) {
> 		enable_irq_wake(client->irq); 
> 		ret = pixcir_int_enable(ts, true);
> 		...
> 	} else if (input->users) {
> 		ret = pixcir_stop(ts);
> 	}
> 
> like many of the drivers do?

Seems to work without disabling event processing. I'll send a v5 with this
and patch 2 fixed as per your suggestion. Thanks.

cheers,
-roger
