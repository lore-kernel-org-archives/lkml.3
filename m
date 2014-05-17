Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbaEQN7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:59:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:25468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbaEQN7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:59:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,859,1392192000"; 
   d="scan'208";a="540686710"
Message-ID: <53776B32.8010400@intel.com>
Date: Sat, 17 May 2014 21:59:14 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 6/9] I2C: Add smbus word/block process call helper
 function
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-7-git-send-email-tianyu.lan@intel.com> <20140517102110.GB2602@katana>
In-Reply-To: <20140517102110.GB2602@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 06:21 PM, Wolfram Sang wrote:
> On Mon, Apr 28, 2014 at 10:27:45PM +0800, Lan Tianyu wrote:
>> Add i2c_smbus_word/block_proc_call() helper function. These will be used
>> in the implementation of i2c ACPI address space handler.
>>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>   drivers/i2c/i2c-core.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/i2c.h    |  4 ++++
>>   2 files changed, 60 insertions(+)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 3bf0048..638befd 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -2306,6 +2306,30 @@ s32 i2c_smbus_write_word_data(const struct i2c_client *client, u8 command,
>>   EXPORT_SYMBOL(i2c_smbus_write_word_data);
>>
>>   /**
>> + * i2c_smbus_word_proc_call - SMBus "word proc call" protocol
>> + * @client: Handle to slave device
>> + * @command: Byte interpreted by slave
>> + * @value: 16-bit "word" being written
>> + *
>> + * This executes the SMBus "word proc all" protocol, returning negative errno
>> + * else a 16-bit unsigned "word" received from the device.
>> + */
>> +s32 i2c_smbus_word_proc_call(const struct i2c_client *client, u8 command,
>> +			      u16 value)
>> +{
>> +	union i2c_smbus_data data;
>> +	int status;
>> +
>> +	data.word = value;
>> +	status = i2c_smbus_xfer(client->adapter, client->addr, client->flags,
>> +			      I2C_SMBUS_READ, command,
>> +			      I2C_SMBUS_PROC_CALL, &data);
>> +
>> +	return (status < 0) ? status : data.word;
>> +}
>> +EXPORT_SYMBOL(i2c_smbus_word_proc_call);
>> +
>> +/**
>
> Same as smbus_quick function before, documentation updates are missing.
> Also similar, we had such a function before which was removed due to no
> users? It looks very much like the function here, so we should stick to
> the old naming IMO. Is it the old one? Such information would be nice
> since it affects reviewing.

Yes, there was an old function and commit c8110933 removed it. Sorry, I didn't 
that before. I will bring the old one back.

>
>>    * i2c_smbus_read_block_data - SMBus "block read" protocol
>>    * @client: Handle to slave device
>>    * @command: Byte interpreted by slave
>> @@ -2362,6 +2386,38 @@ s32 i2c_smbus_write_block_data(const struct i2c_client *client, u8 command,
>>   }
>>   EXPORT_SYMBOL(i2c_smbus_write_block_data);
>>
>> +/**
>> + * i2c_smbus_block_proc_call - SMBus "block write" protocol
>> + * @client: Handle to slave device
>> + * @command: Byte interpreted by slave
>> + * @length: Size of data block; SMBus allows at most 32 bytes
>> + * @values: Byte array which will be written.
>> + *
>> + * This executes the SMBus "block proc call" protocol, returning negative errno
>> + * else the number of read bytes.
>> + */
>> +s32 i2c_smbus_block_proc_call(const struct i2c_client *client, u8 command,
>> +			       u8 length, u8 *values)
>
> Please rename to "i2c_smbus_block_process_call" as the old function was
> named. Needs documentation updates.
>
>> +	if (length > I2C_SMBUS_BLOCK_MAX)
>> +		length = I2C_SMBUS_BLOCK_MAX;
>
> I think we should return an error here.

Ok.

>
> BTW what were your test scenarios for these functions and smbus quick?
>

 From ACPI spec, Read/Write quick and Word/Block process call protocol will be 
used by Bios ACPI code. But so far, I don't find such machines. So these 
functions has not been tested.




