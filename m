Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3CNHhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:37:55 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:40144 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3CNHhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:37:54 -0400
Message-ID: <51417E4E.2090707@gmail.com>
Date: Thu, 14 Mar 2013 00:37:50 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] mtd: use the full-id as the keyword for some nand
 chips
References: <1363229965-13128-1-git-send-email-b32955@freescale.com>  <CAN8TOE9XBphuTY6h_fgBaSfrFRVg0ZuG+9OxDYR+yvfJn1CcGQ@mail.gmail.com> <1363244859.11441.81.camel@sauron.fi.intel.com>
In-Reply-To: <1363244859.11441.81.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 12:07 AM, Artem Bityutskiy wrote:
> On Wed, 2013-03-13 at 21:48 -0700, Brian Norris wrote:
>> On Wed, Mar 13, 2013 at 7:59 PM, Huang Shijie <b32955@freescale.com> wrote:
>>> As time goes on, we begin to meet the situation that we can not
>>> get enough information from some nand chips's id data.
>>> Take some Toshiba's nand chips for example.
>>> I have 4 Toshiba's nand chips in my hand:
>>>          TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2
>>>
>>> When we read these chips' datasheets, we will get the geometry of these chips:
>>>          TC58NVG2S0F : 4096 + 224
>>>          TC58NVG3S0F : 4096 + 232
>>>          TC58NVG5D2  : 8192 + 640
>>>          TC58NVG6D2  : 8192 + 640
>>>
>>> But we can not parse out the correct oob size for these chips from the id data.
>>> So it is time to add some new fields to the nand_flash_dev{},
>>> and update the detection mechanisms.
>>>
>>> v4 --> v4:
>>>          [1] remove the id_len field.
>>>          [2] based on Artem "mtd: nand: use more reasonable integer types"
>>>          [3] add more comments.
>>
>> Sorry for not posting this earlier, but why don't we want an id_len
>> field? NAND chips often only have a 5-byte or 6-byte ID "defined" in
>> their datasheet, and so the next few bytes aren't guaranteed to be any
>> particular value. Wouldn't we want to accommodate for any potential
>> variation in the "undefined" bytes? (These bytes do typically have a
>> pattern, and in fact, we currently rely on that fact.) Also, I can
>> easily foresee a situation in which someone might want to support NAND
>> based solely on the datasheet, not waiting till they get a sample of
>> that chip in their hands. In that case, they cannot specify a full 8
>> bytes in the table; they can (and should) only specify the few
>> substring found in their datasheet.
>>
>> Really, the only argument I see for dropping id_len is to save space.
>> I think this is a bad choice.
>
> Let's take a flash which has 5 bytes ID length, suppose it is
> {1, 2, 3, 4, 5}. The 8-byte table value for this flash would be:
> {1, 2, 3, 4, 5, 0, 0, 0}. When we read the ID sequence, we need to start
> with allocating an 8-byte array and initializing it to 0. Then we read
> the 5-byte ID and end up with: {1, 2, 3, 4, 5, 0, 0, 0}. And we

When we "read the 5-byte ID", are you referring to reading the ID from 
the NAND flash? Unfortunately, things are *never* this nice. Those last 
3 bytes can be anything. Often they wrap around; see my nand_id_len() 
function. But they rarely are 0.

So, we have no way to identify (100% guaranteed) a 5-byte or 6-byte ID 
that comes from the flash. But we *can* compare a substring of it 
against 5 or 6 byte ID in our table, if they are marked with lengths.

> successfully match the table entry.
>
> That was my thinking.
>
> There is a potential problem: there may be a flash with 6 bytes ID with
> value {1, 2, 3, 4, 5, 0}, in which case the algorithm would not work.
>
> However, I consider this to be very unlikely. And even if this unlikely
> situation happens, it will probably be noticed and we could fix this
> with adding the ID length field.
>
> My rationale is avoiding over-designing and trying to cover low
> probability theoretical cases.

I agree about avoiding over-designing. I only would add that my 
scenario's are not so theoretical. It just happens that I (and others) 
have successfully managed to devise heuristics for most of the 5-byte 
and 6-byte IDs I've seen.

> But yes, I did not really strongly opposed the field, it was more that I
> asked questions from Huang about why is this needed, and expected to
> hear some justification. Huang preferred to answer that he does not
> really need this, and I just thought that if this is all he can say,
> then he should not add it.
>
> This is often, generally, the role of maintainer who cannot get into all
> the details - ask questions and validate the answers. Generally, good
> answers have correlation with quality code.

That is entirely reasonable.

> You did provide good arguments thanks! If my rationally is not
> convincing enough and you think this is not over-engineering, let's have
> the ID length field.

I do not think that it is over-engineering, but with the immediate needs 
(Huang's patch set), it is not necessary. I am OK with either result. 
It's not too difficult to add the field as needed.

> BTW, Huang, I think we should introduce a Macro instead of the '8'
> constant. And if ATM we do not have 8-byte ID's in our table, we should
> make the macro to contain a smaller number. This number can be increased
> when needed.

Sounds like a good idea. (But I don't expect that this will need increased.)

Brian
