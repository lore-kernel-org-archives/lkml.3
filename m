Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3LPXqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:46:08 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43963 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3LPXqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:46:05 -0500
Message-ID: <52AF90B6.1000204@felipetonello.com>
Date: Mon, 16 Dec 2013 15:45:58 -0800
From: Felipe Ferreri Tonello <eu@felipetonello.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Heiko Abraham <abrahamh@web.de>
Subject: Re: [PATCH] input: egalax: Send touch end event when is about to
 suspend
References: <1386720196-5821-1-git-send-email-eu@felipetonello.com> <20131215104053.GC20197@core.coreip.homeip.net>
In-Reply-To: <20131215104053.GC20197@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 12/15/2013 02:40 AM, Dmitry Torokhov wrote:
> Hi Felipe,
>
> On Tue, Dec 10, 2013 at 04:03:16PM -0800, Felipe F. Tonello wrote:
>> From: "Felipe F. Tonello" <eu@felipetonello.com>
>>
>> This is useful to report for users of this device that don't know anything
>> about the suspension of the device. So users will receive a touch end event
>> when the device is about to suspend, making it more user friendly.
>>
>> One example of users is the X Server with the evdev input driver. This patch
>> make sure that the X server will propagate a touch end event to its windows.
>>
>
> Hmm, I would argue we need to do this in input core, similarly to what
> we do for the keys, so that all drivers would benefit from the change.
>
> Thanks.

I agree with you. I didn't do in this case because previous patches that 
I had to change core functionality were declined due the fact it's hard 
to maintain backwards compatibility.

Do you recommend me something in this case?

Thanks for your answer.

Felipe

>
>> Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
>> ---
>>   drivers/input/touchscreen/egalax_ts.c | 18 +++++++++++++++++-
>>   1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
>> index 054d225..1f21f0d 100644
>> --- a/drivers/input/touchscreen/egalax_ts.c
>> +++ b/drivers/input/touchscreen/egalax_ts.c
>> @@ -63,6 +63,7 @@
>>   struct egalax_ts {
>>   	struct i2c_client		*client;
>>   	struct input_dev		*input_dev;
>> +	bool					ids_in_use[MAX_SUPPORT_POINTS];
>>   };
>>
>>   static irqreturn_t egalax_ts_interrupt(int irq, void *dev_id)
>> @@ -117,6 +118,8 @@ static irqreturn_t egalax_ts_interrupt(int irq, void *dev_id)
>>   	input_mt_report_pointer_emulation(input_dev, true);
>>   	input_sync(input_dev);
>>
>> +	ts->ids_in_use[id] = down;
>> +
>>   	return IRQ_HANDLED;
>>   }
>>
>> @@ -247,9 +250,22 @@ static int egalax_ts_suspend(struct device *dev)
>>   		0x3, 0x6, 0xa, 0x3, 0x36, 0x3f, 0x2, 0, 0, 0
>>   	};
>>   	struct i2c_client *client = to_i2c_client(dev);
>> -	int ret;
>> +	struct egalax_ts *ts = i2c_get_clientdata(client);
>> +	int ret, id;
>>
>>   	ret = i2c_master_send(client, suspend_cmd, MAX_I2C_DATA_LEN);
>> +
>> +	/* We send a touch end event (for the ids in use) if the egalax module is
>> +	   about to be turned off. */
>> +	for (id = 0; id < MAX_SUPPORT_POINTS; ++id) {
>> +		if (ts->ids_in_use[id]) {
>> +			input_mt_slot(ts->input_dev, id);
>> +			input_mt_report_slot_state(ts->input_dev, MT_TOOL_FINGER, false);
>> +			input_mt_report_pointer_emulation(ts->input_dev, true);
>> +			input_sync(ts->input_dev);
>> +		}
>> +	}
>> +
>>   	return ret > 0 ? 0 : ret;
>>   }
>>
>> --
>> 1.8.3.1
>>
>
