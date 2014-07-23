Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaGWFma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:42:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63950 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaGWFm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:42:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CF4B42.6060106@roeck-us.net>
Date: Tue, 22 Jul 2014 22:42:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Remove printk statement and add return statement
 in q40ints.c
References: <1406088515-4026-1-git-send-email-xerofoify@gmail.com>	<53CF3FFB.4080809@roeck-us.net> <CAPDOMVgJ1-L0wvxwkdut9XDsAHNFd_VsEN75W_Thn1P-phgnuw@mail.gmail.com>
In-Reply-To: <CAPDOMVgJ1-L0wvxwkdut9XDsAHNFd_VsEN75W_Thn1P-phgnuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 09:56 PM, Nick Krause wrote:
> On Wed, Jul 23, 2014 at 12:54 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 07/22/2014 09:08 PM, Nicholas Krause wrote:
>>>
>>> This removes the printk statement for irqs not defined by the hardware in
>>> function q40_irq_startup and instead returns -ENXIO as stated by the fix
>>> me message.
>>>
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>    arch/m68k/q40/q40ints.c | 3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
>>> index 513f9bb..86f05c0 100644
>>> --- a/arch/m68k/q40/q40ints.c
>>> +++ b/arch/m68k/q40/q40ints.c
>>> @@ -48,8 +48,7 @@ static unsigned int q40_irq_startup(struct irq_data
>>> *data)
>>>          switch (irq) {
>>>          case 1: case 2: case 8: case 9:
>>>          case 11: case 12: case 13:
>>> -               printk("%s: ISA IRQ %d not implemented by HW\n", __func__,
>>> irq);
>>> -               /* FIXME return -ENXIO; */
>>> +               return -ENXIO;
>>
>>
>> Returning -ENXIO from a function returning an unsigned int isn't really very
>> helpful,
>> don't you think ?
>>
>> With all those FIXMEs, you might want to keep in mind that there is
>> typically a
>> good reason for it. If it was as easy as your proposed fix, you can assume
>> that the FIXME would not have been there in the first place.
>>
>> Guenter
>>
>
>
> Sorry Guenter,
> That's fine. can I can change  the return type of the function or is
> that going to break things?
> Nick
>

Please have a look at the context. q40_irq_startup is used to initialize
struct irq_chip.irq_startup, which expects an unsigned int as return value.
To make things more interesting, the caller (function irq_startup) assigns
the result to an int. However, _callers_ of irq_startup either ignore
the return value, or assume that an interrupt is pending if the return
value is not 0.

So all your change accomplishes is to tell the caller that an interrupt
would be pending. Changing the return value to int will only result
in a compile warning but otherwise not change anything.

Unless you put in the effort to really analyze the code, and that applies
to each FIXME you are trying to fix, I would suggest to leave it alone.
Otherwise we just end up worse than before.

Guenter

