Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbbAIVFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:05:14 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:37355 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbAIVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:05:12 -0500
Message-ID: <54B04283.5070705@cogentembedded.com>
Date: Sat, 10 Jan 2015 00:05:07 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/11] i2c: add quirk checks to core
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de> <1420824103-24169-3-git-send-email-wsa@the-dreams.de> <54B02D7F.7040501@cogentembedded.com> <20150109204522.GB1904@katana>
In-Reply-To: <20150109204522.GB1904@katana>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/09/2015 11:45 PM, Wolfram Sang wrote:

>>> Let the core do the checks if HW quirks prevent a transfer. Saves code
>> >from drivers and adds consistency.

>>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>>> ---
>>>   drivers/i2c/i2c-core.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 53 insertions(+)
>>>
>>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>>> index 39d25a8cb1ad..7b10a19abf5b 100644
>>> --- a/drivers/i2c/i2c-core.c
>>> +++ b/drivers/i2c/i2c-core.c
>>> @@ -2063,6 +2063,56 @@ module_exit(i2c_exit);
>>>    * ----------------------------------------------------
>>>    */
>>>
>>> +/* Check if val is exceeding the quirk IFF quirk is non 0 */
>>> +#define i2c_quirk_exceeded(val, quirk) ((quirk) && ((val) > (quirk)))
>>> +
>>> +static int i2c_quirk_error(struct i2c_adapter *adap, struct i2c_msg *msg, char *err_msg)
>>> +{
>>> +	dev_err(&adap->dev, "quirk: %s (addr 0x%04x, size %u)\n", err_msg, msg->addr, msg->len);
>>> +	return -EOPNOTSUPP;
>>> +}

>>     Always returning the same value doesn't make much sense. Are you trying
>> to save space on the call sites?

> Please elaborate. I think it does. If a quirk matches, we report that we
> don't support this transfer.

    OK, but what's the point of having this function return *int* if it always 
returns the same value? AFAIU, you're trying to save the code space on the 
call sites of this function by not having *return* -EOPNOTSUPP there each time?

>> [...]
>>> @@ -2080,6 +2130,9 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>>>   	unsigned long orig_jiffies;
>>>   	int ret, try;
>>>
>>> +	if (adap->quirks && i2c_check_for_quirks(adap, msgs, num))

>>     So, you only check for non-zero result of this function? Perhaps it makes
>> sense to return true/false instead?

> Could be done, but what would be the advantage? A lot of functions
> return errno or 0.

    It would have been OK if you were actually caring about the result, e.g. 
returning it from __i2c_transfer(). Since you don't, IMO it would make more 
sense to return true from i2c_check_for_quirks() (making it *bool*) iff it did 
find/apply a quirk.

WBR, Sergei

