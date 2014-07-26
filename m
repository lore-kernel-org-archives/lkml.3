Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaGZPVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:21:09 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:63475 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGZPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <53CFC170.9090505@roeck-us.net>
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
	<53CFC170.9090505@roeck-us.net>
Date: Sat, 26 Jul 2014 17:21:04 +0200
X-Google-Sender-Auth: X6Np2M-5uiDvzYFKuO7UL5HvUuo
Message-ID: <CAMuHMdW=iecARisoUuDY1hNaZgWWZJwpVjXDpXYqscx=myDx+w@mail.gmail.com>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sasha Levin <sasha.levin@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Nick Krause <xerofoify@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 4:06 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/23/2014 05:51 AM, Sasha Levin wrote:
>> Revert since we're trying to return -ENXIO from a function returning
>> unsigned int. Not only it causes compiler warnings it's also obviously
>> incorrect.
>>
>> In general, watch for patches from Nick Krause since they are not even
>> build tested.
>>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>
> Guess I wasn't fast enough with my comments :-(
>
> Acked-by: Guenter Roeck <linux@roeck-us.net>

I applied Nick's cleanup (which is not yet in mainline, just in the m68k repo)
because I thought Nick was right (in this particular case ;-), cfr. my
reasoning in www.spinics.net/lists/kernel/msg1774736.html

W.r.t. the signess, I didn't see the compiler warning, as the version of gcc
I'm using didn't print that warning. However, irq_startup() converts the
value returned by .irq_startup() from unsigned to signed.
I assume this is just a missing conversion when the genirq framework
itself was introduced (m68k was converted quite late)?

W.r.t. the actual value, any non-zero value is treated the same.
I can change it to 1, if that makes you feel better. If returning a non-zero
value here is wrong, presumable the code has been wrong since it
incarnation.

As we're close to the opening of the merge window, it would be nice
if we could conclude on this ;-)

Thanks!

>> ---
>>   arch/m68k/q40/q40ints.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
>> index 9dfa1ea..513f9bb 100644
>> --- a/arch/m68k/q40/q40ints.c
>> +++ b/arch/m68k/q40/q40ints.c
>> @@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data
>> *data)
>>         case 1: case 2: case 8: case 9:
>>         case 11: case 12: case 13:
>>                 printk("%s: ISA IRQ %d not implemented by HW\n", __func__,
>> irq);
>> -               return -ENXIO;
>> +               /* FIXME return -ENXIO; */
>>         }
>>         return 0;
>>   }
>>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
