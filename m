Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaKELlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:41:44 -0500
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:48466 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290AbaKELlm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:41:42 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <545A0CEE.2050101@topic.nl>
Date: Wed, 5 Nov 2014 12:41:34 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Add ltc3562 voltage regulator driver
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <1415083845-27079-1-git-send-email-mike.looijmans@topic.nl> <20141104202638.GZ3815@sirena.org.uk>
In-Reply-To: <20141104202638.GZ3815@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/04/2014 09:26 PM, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 07:50:45AM +0100, Mike Looijmans wrote:
>
>> v3: Add .of_match_table and prefix lltc
>>      Clarify why regmap cannot be used
>>      Add lltc,operating-mode (0..3) DT property
>>      regulator child nodes are optional
>
> Leave out the mode setting in the DT for now please, Javier was looking
> at adding a standard property for this with a driver defined mapping to
> modes - you should implement the standard get_mode() and set_mode() (but
> can always do that as a followup).
>
>> +/* the LTC3562 does not have a register map, instead it receives a two-byte
>> + * command set. The first byte sets the mask for the output(s) to be programmed
>> + * and the second byte hold the "enable" bit and the DAC code. */
>> +struct ltc3562_status {
>> +	u8 addr_mode;	/* sub-address byte: program mask an operating mode */
>> +	u8 enable_daccode;	/* data byte: Enable bit and DAC code  */
>> +};
>
> So, I managed to find a datasheet[1] and this does actually seem to be a
> standard register map.  It looks like this is a 4x12 register map with
> the program bytes being essentially register addresses (called sub
> addresses in the datasheet), two pad bits (normally we'd include these
> in the data for convenience) and the rest of the bits data.  What am I
> missing here?
>
> Otherwise this looks good.
>
> [1] http://cds.linear.com/docs/en/datasheet/3562fa.pdf
>

Things that makes me think it's NOT a register map:
- You cannot read from the device
- You always have to send a complete command set (two bytes)
- There is data (the regulator mode) in the address byte
- The 'address' is not an index but a bitmask in bits 4..7

Yeah, I think you can force-feed this to regmap. It will just make the code 
considerably bigger and harder to understand, and as far as I know, the one 
and only advantage this will bring is that you can dump the current 
"registers" (4x10 bits of data) via /sys/kernel/debug/regmap.

I fail to see the use for regmap here, but if your view on this is "regmap or 
burst" then I'll implement it.

Mike.


Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

