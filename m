Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaBNRyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:54:54 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:51481
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbaBNRyx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:54:53 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Staging: comedi: clean up conditional statement in
 addi_apci_3xxx.c
Thread-Topic: [PATCH] Staging: comedi: clean up conditional statement in
 addi_apci_3xxx.c
Thread-Index: AQHPKGvUl/6RuqPc2U28kb22edW/fpqze0LQgAGe9ID//++kQA==
Date: Fri, 14 Feb 2014 17:54:52 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817EC2DFE@P3PWEX4MB008.ex4.secureserver.net>
References: <1392262167-4073-1-git-send-email-chase.southwood@yahoo.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817EBF5B2@P3PWEX4MB008.ex4.secureserver.net>
 <52FE02D9.1090205@mev.co.uk>
In-Reply-To: <52FE02D9.1090205@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 14, 2014 4:50 AM, Ian Abbott wrote:
> On 2014-02-13 18:25, Hartley Sweeten wrote:
>> On Wednesday, February 12, 2014 8:29 PM, Chase Southwood wrote:
>>> In this if-else conditional statement, if (chan < 16), but
>>> (data[0] == INSN_CONFIG_DIO_QUERY), the function does not return early,
>>> but the else-branch does not get executed either.  As a result, mask
>>> would be used uninitialized in the next line.  What we want here is if
>>> (chan < 16) and (data[0] != INSN_CONFIG_DIO_QUERY), return an error, but
>>> in every other case, initialize mask and then proceed.  Found by a static
>>> checker.
>>>
>>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>> ---
>>>   drivers/staging/comedi/drivers/addi_apci_3xxx.c | 12 +++++-------
>>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>>> index ceadf8e..04c5153 100644
>>> --- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>>> +++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
>>> @@ -688,13 +688,11 @@ static int apci3xxx_dio_insn_config(struct comedi_device *dev,
>>>   	 * Port 1 (channels 8-15) are always outputs
>>>   	 * Port 2 (channels 16-23) are programmable i/o
>>>   	 */
>>> -	if (chan < 16) {
>>> -		if (data[0] != INSN_CONFIG_DIO_QUERY)
>>> -			return -EINVAL;
>>> -	} else {
>>> -		/* changing any channel in port 2 changes the entire port */
>>> -		mask = 0xff0000;
>>> -	}
>>> +	if ((chan < 16) && (data[0] != INSN_CONFIG_DIO_QUERY))
>>> +		return -EINVAL;
>>> +
>>> +	/* changing any channel in port 2 changes the entire port */
>>> +	mask = 0xff0000;
>>>
>>>   	ret = comedi_dio_insn_config(dev, s, insn, data, mask);
>>>   	if (ret)
>>
>> The uninitialized mask when chan < 16 is an issue. But your patch is not quite correct.
>>
>> The original code was intending to limit the valid instructions for channels < 16 to only
>> INSN_CONFIG_DIO_QUERY. These channels have fixed directions: 0-7 (port 0) are
>> always inputs and 8-15 (port 1) are always outputs. Channels 16-23 (port 2) have
>> programmable direction but changing any channel effects the entire port, that's
>> what the 0xff0000 mask is for.
>>
>> Changing the mask to 0xff0000 for any chanspec will result in the INSN_CONFIG_DIO_QUERY
>> instruction returning the direction of port 2 regardless of what the chanspec is.
>>
>> The "right" fix would be:
>> 1) Default the mask to 0 so that comedi_dio_insn_config() will use a chan_mask
>> based on the chanspec for the INSN_CONFIG_DIO_QUERY instruction.
>> 2) Ignore all instructions except INSN_CONFIG_DIO_QUERY when the chan < 16.
>> 3) Modify the mask for chan >= 16 when the instruction is not INSN_CONFIG_DIO_QUERY
>> so that the INSN_CONFIG_DIO_{INPUT,OUTPUT} instructions update the entire
>> port.
>
> Agreed, but another question is why does comedi_dio_insn_config() in 
> drivers.c need to look at the supplied mask at all for 
> INSN_CONFIG_DIO_QUERY?

It doesn't, that's why the mask is set to a default of 0 (1 above) and only modified
(3 above) when the instruction is not INSN_CONFIG_DIO_QUERY and chan >= 16.

With a mask of 0 comedi_dio_insn_config() will properly figure out the mask based
on the chanspec.

Regards,
Hartley

