Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaFQNyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:54:36 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:32907 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbaFQNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:54:35 -0400
Message-ID: <53A04888.5010204@linaro.org>
Date: Tue, 17 Jun 2014 14:54:16 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rob Clark <robdclark@gmail.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3] ARM: add get_user() support for 8 byte types
References: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org> <20140612155843.GK23430@n2100.arm.linux.org.uk> <53A015B3.2070809@linaro.org> <20140617110908.GH23430@n2100.arm.linux.org.uk> <53A0428C.10200@linaro.org> <20140617133620.GJ23430@n2100.arm.linux.org.uk>
In-Reply-To: <20140617133620.GJ23430@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/14 14:36, Russell King - ARM Linux wrote:
> On Tue, Jun 17, 2014 at 02:28:44PM +0100, Daniel Thompson wrote:
>> On 17/06/14 12:09, Russell King - ARM Linux wrote:
>>> On Tue, Jun 17, 2014 at 11:17:23AM +0100, Daniel Thompson wrote:
>>>> ... at this point there is a narrowing cast followed by an implicit
>>>> widening. This results in compiler either ignoring r3 altogether or, if
>>>> spilling to the stack, generating code to set r3 to zero before doing
>>>> the store.
>>>
>>> In actual fact, there's very little difference between the two
>>> implementations in terms of generated code.
>>>
>>> The difference between them is what happens on the 64-bit big endian
>>> narrowing case, where we use __get_user_4 with your version.  This
>>> adds one additional instruction.
>>
>> Good point.
>>
>>
>>> and 64-bit narrowed to 32-bit:
>>>
>>>         str     lr, [sp, #-4]!
>>> -       mov     ip, r0
>>> +       mov     r3, r0
>>>         mov     r0, r1
>>>  #APP
>>>  @ 275 "t-getuser.c" 1
>>> -       bl      __get_user_8
>>> +       bl      __get_user_4
>>>  @ 0 "" 2
>>> -       str     r2, [ip, #0]
>>> +       str     r2, [r3, #0]
>>>         ldr     pc, [sp], #4
>>
>> The later case avoids allocating r3 for the __get_user_x and should
>> reduce register pressure and, potentially, saves a few instructions
>> elsewhere (one of my rather large test functions does demonstrate this
>> effect).
>>
>> I don't know if we care about that. If we do I'm certainly happy to put
>> a patch together than exploits this (whilst avoiding the add in the big
>> endian case).
> 
> No need - the + case is your version, the - case is my version.  So your
> version wins on this point. :)

:) Thanks, although credit really goes to Rob Clark...

I think currently:

1. Rob's patch is better for register pressure in the narrowing case
   (above).

2. Your patch is probably better for big endian due to the add in Rob's
   version. I say probably because, without proof, I suspect the cost
   of the add would in most cases outweigh the register pressure
   benefit.

3. Your patch has better implementation of __get_user_8 (it uses ldrd).

Hence I'm suspect we need to combine elements from both patches.

