Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3EYTZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:25:54 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:38978 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769Ab3EYTZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:25:54 -0400
Message-ID: <51A1103F.6000702@schinagl.nl>
Date: Sat, 25 May 2013 21:25:51 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130322 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl> <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl> <51969EA9.1060602@free-electrons.com> <5197B82F.8010809@schinagl.nl> <519FE0AE.2010102@schinagl.nl> <20130525122208.GD17847@lukather>
In-Reply-To: <20130525122208.GD17847@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/13 14:22, Maxime Ripard wrote:
> Hi Oliver,
>
> On Fri, May 24, 2013 at 11:50:38PM +0200, Oliver Schinagl wrote:
>> On 05/18/13 19:19, Oliver Schinagl wrote:
>> <snip>
>>>>> +
>>>>> +
>>>>> +/* We read the entire key, using a look up table. Returned is only the
>>>>> + * requested byte. This is of course slower then it could be and uses 4 times
>>>>> + * more reads as needed but keeps code a little simpler.
>>>>> + */
>>>>> +u8 sunxi_sid_read_byte(const int key)
>>>>> +{
>>>>> +	u32 sid_key;
>>>>> +	u8 ret;
>>>>> +
>>>>> +	ret = 0;
>>>>> +	if (likely((key <= SUNXI_SID_SIZE))) {
>>>>> +		sid_key = ioread32(p->sid_base + keys_lut[key >> 2]);
>>>>> +		switch (key % 4) {
>>>>> +		case 0:
>>>>> +			ret = (sid_key >> 24) & 0xff;
>>>>> +			break;
>>>>> +		case 1:
>>>>> +			ret = (sid_key >> 16) & 0xff;
>>>>> +			break;
>>>>> +		case 2:
>>>>> +			ret = (sid_key >> 8) & 0xff;
>>>>> +			break;
>>>>> +		case 3:
>>>>> +			ret = sid_key & 0xff;
>>>>> +			break;
>>>>> +		}
>>>>> +	}
>>>>
>>>> Come on, you can do better. This lookup table is useless.
>>> I didn't want to depend on the fixed layout of memory, but consider it
>>> removed.
>> But i'm not smart enough :p
>>
>> We can either use the look up table (which does have benefits as its
>> potentially more future proof), or do some ((key >> 2) << 2) to
>> 'drop' the LSB's that we want to ignore (unless there's some smarter
>> way).
>>
>> Personally, I think the LUT is a little cleaner and more readable,
>> but I guess if you look at poor efficiency, the lut costs some
>> memory, the left/right shift cost an additional >> 2 ... what you
>> prefer.
>
> What about:
>
> val = ioread32be(base + (key / 4));
> val >>= (key % 4) * 8;
> return val & 0xff;
>
> No lookup table, no weird swich statement, and you get the endianness
> conversion only when you need it.
Ok I think I like the Endianess, ioread32be does the right thing then? 
I'll read up on that.
As for key / 4; how will that work without the lut?

Lets take byte 14 (out of the available 16). Byte 14 (0x0e) is located 
in SID_KEY3, so base + 0x0c. We need to write a whole 32bit word to keep 
with alignment, the registers go wakko if you do unaligned reads. So we 
need to read the entire 32 bits, then find our byte.

key / 4 for 14 yields 0x03. So we have base + 0x03, which is not what we 
want. We want base + 0x0c, which is either ((key >> 2) << 2)) Or, ((key 
/ 4) * 4)) which to me, are both equally confusing. So we either use the 
look up table, which is a little cleaner and is a bit more future proof 
if either a) there's more 'eeprom like' storage which can be combined 
herein or b) 'a' next version has non-continuing regions. Granted 
neither is something to worry about right now.

Turl already mentioned the calculated shift, instead of the switch. I 
agree to also like it better and have already rewritten that bit.


If I made a really stupid thinking mistake or my math is somehow wrong, 
feel free to point it out :) I don't mind manning up to my mistakes :)
>
> Maxime
>

