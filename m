Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaBYI5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:57:16 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62803 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaBYI5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:57:14 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <530C5AE8.8010709@roeck-us.net>
Date: Tue, 25 Feb 2014 00:57:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, "khali@linux-fr.org" <khali@linux-fr.org>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwmon: (lm90) split set&show temp as common codes
References: <1393309301-28337-1-git-send-email-wni@nvidia.com> <1393309301-28337-2-git-send-email-wni@nvidia.com> <530C391B.5090206@roeck-us.net> <530C527F.1020806@nvidia.com>
In-Reply-To: <530C527F.1020806@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 12:21 AM, Wei Ni wrote:
> On 02/25/2014 02:32 PM, Guenter Roeck wrote:
>> On 02/24/2014 10:21 PM, Wei Ni wrote:
>>> Split set&show temp codes as common functions, so we can use it
>>> directly when implement linux thermal framework.
>>> And handle error return value for the lm90_select_remote_channel
>>> and write_tempx, then set_temp8 and set_temp11 could return it
>>> to user-space.
>>>
>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>> Signed-off-by: Jean Delvare <khali@linux-fr.org>
>>> ---
>>>    drivers/hwmon/lm90.c |  170 ++++++++++++++++++++++++++++++++++----------------
>>>    1 file changed, 115 insertions(+), 55 deletions(-)
>>>
>>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>>> index c9ff08d..fb9e224 100644
>>> --- a/drivers/hwmon/lm90.c
>>> +++ b/drivers/hwmon/lm90.c
>>> @@ -473,20 +473,29 @@ static int lm90_read16(struct i2c_client *client, u8 regh, u8 regl, u16 *value)
>>>     * various registers have different meanings as a result of selecting a
>>>     * non-default remote channel.
>>>     */
>>> -static inline void lm90_select_remote_channel(struct i2c_client *client,
>>> -					      struct lm90_data *data,
>>> -					      int channel)
>>> +static inline int lm90_select_remote_channel(struct i2c_client *client,
>>> +					     struct lm90_data *data,
>>> +					     int channel)
>>>    {
>>>    	u8 config;
>>> +	int err;
>>>
>>>    	if (data->kind == max6696) {
>>>    		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
>>>    		config &= ~0x08;
>>>    		if (channel)
>>>    			config |= 0x08;
>>> -		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
>>> -					  config);
>>> +		err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
>>> +						config);
>>> +		if (err < 0) {
>>> +			dev_err(&client->dev,
>>> +				"Failed to select remote channel %d, err %d\n",
>>> +				channel, err);
>>> +			return err;
>>
>> Not my call to make, but I really dislike all that new noisiness.
>> Sure, it is ok to pass the error back, but in my opinion that is
>> good enough. If every driver in the kernel would be that noisy,
>> the log would be all but useless.
>
> This was discussed in https://lkml.org/lkml/2013/12/227
> Jean wish to catch and return write errors,then the set_temp8() could
> return error to user-space.
>

The link doesn't work for me. Anyway, catching write errors and being
noisy about it are different issues, and I am a bit surprised that
Jean wants the driver to be noisy about it, but if so I won't object.

Guenter

