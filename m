Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3ILM5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:57:13 -0400
Received: from mail.eperm.de ([89.247.134.16]:38411 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab3ILM5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:57:12 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Thu, 12 Sep 2013 14:57:04 +0200
Message-ID: <2277854.fnx9Fj2PUt@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMuHMdUNPp9a_dAoeJvrZFGFxStU96Ws+WSp2gRocMngZrNSAA@mail.gmail.com>
References: <10005394.BRCyBMYWy3@tauon> <2140053.ysf7239sM3@tauon> <CAMuHMdUNPp9a_dAoeJvrZFGFxStU96Ws+WSp2gRocMngZrNSAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. September 2013, 14:47:23 schrieb Geert Uytterhoeven:

Hi Geert,

>On Thu, Sep 12, 2013 at 2:35 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
>>>On Thu, Sep 12, 2013 at 2:08 PM, Stephan Mueller
>>><smueller@chronox.de>
>>>
>> wrote:
>>>>>BTW, I prefer a different name than "random_get_fast_cycles()", as
>>>>>it's better to have something that returns different and
>>>>>unpredictable numbers than an actual monotonic cycle counter.
>>>>>
>>>> A monotonic counter is fully ok. Note, for /dev/random, the
>>>> occurrence
>>>> of events delivers entropy. Thus, we have to be able to precisely
>>>> measure that occurrence. The timer itself does not need to deliver
>>>> any
>>>> entropy as long as it is fast.
>>>
>>>Well, in my specific case (m68k/Amiga) I can use:
>>>  - a 24-bit counter running at only ca. 15 or 31 kHz (actual
>>>
>>>frequency may vary),
>>>
>>>  - a 16-bit counter running at ca. 700 kHz.
>>>
>>>That is, if they have to be monotonic cycle counters.
>>>
>>>If not, I can mix the two (e.g. "a << 8 | (b & 0xff)") to get a
>>>32-bit
>>>value. That result would be fine for /dev/random, I guess, but it's
>>>not really "get_cycles()".
>>>
>> Note, get_cycles should return an u64.
>
>Currently cycles_t is 64-bit (defined as a 64-bit type, that still
>doesn't say anything about the actual values) on blackfin, c6x, cris,
>ia64, m32r, parisc64, ppc64, s390x, tile, x86, and xtensa.
>On all other architectures cycles_t is 32 bit.
>
>> Not sure what a and b here is, but if a is the 24 bit value and b the
>> faster 16 bit value, wouldn't there be a gap?
>
>No, 24 + 8 = 32 (cycles_t is 32-bit on m68k).

With gap I meant a logical break as discussed below.
>
>> I.e. wouldn't it be better to use the full 16 bit counter as low
>> value
>> and OR the 24 bit on bits 48 to 17?
>> 
>> Yet, there is a break in that counter: the 16 low bits rotate several
>> times (around 10 times) before bit 17 is changed once.
>
>Sure, but it's also slower, as this will be called for every interrupt,
>and the counters (accessed by byte!) are on a slow bus. Think of Ted's
>L3-cache-miss story.

I see. Well, I think a fast running 8 bit counter is to little 
considering that the maximum entropy an event may have is assumed to be 
/dev/random is 11 bits.

Thus, I would not be comfortable with the proposed 8 bit fast counter. 
Of course one may say, the 31 or 15 kHz counter is still fast, but is it 
sufficiently fast so that an observer (ie. somebody outside the kernel) 
cannot measure that event with (11 - 8) = 3 low bits precision of that 
slow counter in the worst case?


>
>Gr{oetje,eeting}s,
>
>                        Geert
>
>--
>Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>geert@linux-m68k.org
>
>In personal conversations with technical people, I call myself a
>hacker. But when I'm talking to journalists I just say "programmer" or
>something like that. -- Linus Torvalds


Ciao
Stephan
