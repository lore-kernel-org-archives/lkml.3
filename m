Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaBNLwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:52:33 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:32902 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaBNLwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:52:32 -0500
Message-ID: <52FE037C.70504@mev.co.uk>
Date: Fri, 14 Feb 2014 11:52:28 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: clean up conditional statement in addi_apci_3xxx.c
References: <1392262167-4073-1-git-send-email-chase.southwood@yahoo.com> <52FC99AA.90508@mev.co.uk>
In-Reply-To: <52FC99AA.90508@mev.co.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-13 10:08, Ian Abbott wrote:
> On 2014-02-13 03:29, Chase Southwood wrote:
>> In this if-else conditional statement, if (chan < 16), but
>> (data[0] == INSN_CONFIG_DIO_QUERY), the function does not return early,
>> but the else-branch does not get executed either.  As a result, mask
>> would be used uninitialized in the next line.  What we want here is if
>> (chan < 16) and (data[0] != INSN_CONFIG_DIO_QUERY), return an error, but
>> in every other case, initialize mask and then proceed.  Found by a static
>> checker.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>>   drivers/staging/comedi/drivers/addi_apci_3xxx.c | 12 +++++-------
>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>> b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>> index ceadf8e..04c5153 100644
>> --- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>> +++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>> @@ -688,13 +688,11 @@ static int apci3xxx_dio_insn_config(struct
>> comedi_device *dev,
>>        * Port 1 (channels 8-15) are always outputs
>>        * Port 2 (channels 16-23) are programmable i/o
>>        */
>> -    if (chan < 16) {
>> -        if (data[0] != INSN_CONFIG_DIO_QUERY)
>> -            return -EINVAL;
>> -    } else {
>> -        /* changing any channel in port 2 changes the entire port */
>> -        mask = 0xff0000;
>> -    }
>> +    if ((chan < 16) && (data[0] != INSN_CONFIG_DIO_QUERY))
>> +        return -EINVAL;
>> +
>> +    /* changing any channel in port 2 changes the entire port */
>> +    mask = 0xff0000;
>>
>>       ret = comedi_dio_insn_config(dev, s, insn, data, mask);
>>       if (ret)
>
> Seems correct.
>
> Acked-by: Ian Abbott <abbotti@mev.co.uk>

Okay, as Hartley pointed out, it isn't correct, so I withdraw my 
"Acked-by".

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
