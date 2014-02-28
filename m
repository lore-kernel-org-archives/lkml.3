Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaB1DVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:21:12 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7316 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB1DVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:21:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Feb 2014 19:18:22 -0800
Message-ID: <531000A6.1010709@nvidia.com>
Date: Fri, 28 Feb 2014 11:21:10 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwmon: (lm90) split set&show temp as common codes
References: <1393309301-28337-1-git-send-email-wni@nvidia.com> <1393309301-28337-2-git-send-email-wni@nvidia.com> <530C391B.5090206@roeck-us.net> <530C527F.1020806@nvidia.com> <530C5AE8.8010709@roeck-us.net> <530C60A4.5040302@nvidia.com> <20140225160653.GA18768@roeck-us.net>
In-Reply-To: <20140225160653.GA18768@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 12:06 AM, Guenter Roeck wrote:
> On Tue, Feb 25, 2014 at 05:21:40PM +0800, Wei Ni wrote:
>> On 02/25/2014 04:57 PM, Guenter Roeck wrote:
>>> On 02/25/2014 12:21 AM, Wei Ni wrote:
>>>> On 02/25/2014 02:32 PM, Guenter Roeck wrote:
>>>>> On 02/24/2014 10:21 PM, Wei Ni wrote:
>>>>>> Split set&show temp codes as common functions, so we can use it
>>>>>> directly when implement linux thermal framework.
>>>>>> And handle error return value for the lm90_select_remote_channel
>>>>>> and write_tempx, then set_temp8 and set_temp11 could return it
>>>>>> to user-space.
>>>>>>
>>>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>>>> Signed-off-by: Jean Delvare <khali@linux-fr.org>
>>>>>> ---
>>>>>>    drivers/hwmon/lm90.c |  170 ++++++++++++++++++++++++++++++++++----------------
>>>>>>    1 file changed, 115 insertions(+), 55 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>>>>>> index c9ff08d..fb9e224 100644
>>>>>> --- a/drivers/hwmon/lm90.c
>>>>>> +++ b/drivers/hwmon/lm90.c
>>>>>> @@ -473,20 +473,29 @@ static int lm90_read16(struct i2c_client *client, u8 regh, u8 regl, u16 *value)
>>>>>>     * various registers have different meanings as a result of selecting a
>>>>>>     * non-default remote channel.
>>>>>>     */
>>>>>> -static inline void lm90_select_remote_channel(struct i2c_client *client,
>>>>>> -					      struct lm90_data *data,
>>>>>> -					      int channel)
>>>>>> +static inline int lm90_select_remote_channel(struct i2c_client *client,
>>>>>> +					     struct lm90_data *data,
>>>>>> +					     int channel)
>>>>>>    {
>>>>>>    	u8 config;
>>>>>> +	int err;
>>>>>>
>>>>>>    	if (data->kind == max6696) {
>>>>>>    		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
>>>>>>    		config &= ~0x08;
>>>>>>    		if (channel)
>>>>>>    			config |= 0x08;
>>>>>> -		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
>>>>>> -					  config);
>>>>>> +		err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
>>>>>> +						config);
>>>>>> +		if (err < 0) {
>>>>>> +			dev_err(&client->dev,
>>>>>> +				"Failed to select remote channel %d, err %d\n",
>>>>>> +				channel, err);
>>>>>> +			return err;
>>>>>
>>>>> Not my call to make, but I really dislike all that new noisiness.
>>>>> Sure, it is ok to pass the error back, but in my opinion that is
>>>>> good enough. If every driver in the kernel would be that noisy,
>>>>> the log would be all but useless.
>>>>
>>>> This was discussed in https://lkml.org/lkml/2013/12/227
>>>> Jean wish to catch and return write errors,then the set_temp8() could
>>>> return error to user-space.
>>>>
>>>
>>> The link doesn't work for me. Anyway, catching write errors and being
>>> noisy about it are different issues, and I am a bit surprised that
>>> Jean wants the driver to be noisy about it, but if so I won't object.
>>
>> Sorry, the link should be https://lkml.org/lkml/2013/7/12/227
>>
> FWIW, Jean was asking for errors to be detected and be reported to the user,
> not to create log messages to the console for each error.

Sorry for late reply, I'm busy on other issues these days.
I will remove that log messages, and will try to add this node in dts
file for our tegra board.
I will send out patch next week.

Wei.

> 
> Guenter
> 

