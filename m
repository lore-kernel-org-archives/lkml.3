Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaCCNVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:21:14 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50192 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaCCNVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <53145F3A.2010203@broadcom.com>
References: <53110a73.fVHl0nWfqeLuOaob%fengguang.wu@intel.com>
	<53110C1A.60804@broadcom.com>
	<CAGVrzcY85PTeQnSf3ptQyC94A3b7FdX9QPxDcSq+UYhgKfWbUg@mail.gmail.com>
	<53110EA5.8070503@broadcom.com>
	<CAGVrzcaPsaDiBbnbopQTjT_-3ohYWs9HFn-4Y9DL1WJy_A7mzg@mail.gmail.com>
	<53145F3A.2010203@broadcom.com>
Date: Mon, 3 Mar 2014 14:21:12 +0100
X-Google-Sender-Auth: uYIzY0jqrZT8R8qo9r77hRmdQVg
Message-ID: <CAMuHMdUjKrsgqJjuD1UF5gPVd3JT=Z425Yw96aa8FKz8HijtsA@mail.gmail.com>
Subject: Re: [wireless-next:master 169/199] drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2469:3:
 error: implicit declaration of function 'atomic_set_mask'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arend van Spriel <arend@broadcom.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>, kbuild-all@01.org,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 11:53 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 02/28/14 23:44, Florian Fainelli wrote:
>> 2014-02-28 14:33 GMT-08:00 Arend van Spriel<arend@broadcom.com>:
>>> On 02/28/2014 11:26 PM, Florian Fainelli wrote:
>>>> 2014-02-28 14:22 GMT-08:00 Arend van Spriel<arend@broadcom.com>:
>>>>> On 02/28/2014 11:15 PM, kbuild test robot wrote:
>>>>>> tree:
>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git
>>>>>> master
>>>>>> head:   3e3831c4fdc53aabf3a56419ef6d96a841c52435
>>>>>> commit: c98db0bec72ac7ef127119c1ed962d6f56802b12 [169/199] brcmfmac:
>>>>>> Use atomic functions for intstatus update.
>>>>>> config: make ARCH=ia64 allmodconfig
>>>>>>
>>>>>> All error/warnings:
>>>>>>
>>>>>>     drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function
>>>>>> 'brcmf_sdio_intr_rstatus':
>>>>>>>>
>>>>>>>> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2469:3: error:
>>>>>>>> implicit declaration of function 'atomic_set_mask'
>>>>>>>> [-Werror=implicit-function-declaration]
>>>>>>
>>>>>>     cc1: some warnings being treated as errors
>>>>>
>>>>>
>>>>> Hi Fengguang,
>>>>>
>>>>> So atomic_set_mask() is not a generally available function. I thought
>>>>> that if the arch does not provide it, the asm-generic implementation is
>>>>> used.
>>>>
>>>>
>>>> Though so as well.
>>>>
>>>>> Also it seems the function prototype is not the same for all
>>>>> archs. :-(
>>>>
>>>>
>>>> This does not sound like it is expected, and this might need fixing,
>>>> do you want to tackle this?
>>>
>>>
>>> I got email m68k and ia64 failing. Some implementations are in assembly.
>>> It has been (counting...) over 20 years since I did some baby steps in
>>> m68k assembly and do not really feel a strong pull to that dark side.
>>
>>
>> This is supposed to be a generic function that everyone should be able
>> to use without knowing the underlying details. Not quite sure why
>> those two architectures are different, maybe we should ask Geert and
>> Tony about this?
>
>
> I was about to when I decided to do some more digging. So taking a closer
> look at include/asm-generic/atomic.h revealed this:
>
> /*
>  * Generic C implementation of atomic counter operations. Usable on
>  * UP systems only. Do not include in machine independent code.
>
> And further down:
>
> #ifdef CONFIG_SMP
> /* Force people to define core atomics */
> # if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
>      !defined(atomic_clear_mask) || !defined(atomic_set_mask)
> #  error "SMP requires a little arch-specific magic"
> # endif
> #endif
>
> So in these SMP era architecture specific implementations seem required.
> IA64 does not provide it (so CONFIG_SMP not supported?) and m68k has
> different prototype. Apparently, the comment /* Force people to define core
> atomics */ did not fly for all archs (yet) :-p.

It's not just m68k, but other UP-only architectures like frv and mn10300
(these probably got derived from m68k).

Furthermore, in addition to the above, m32r uses "unsigned long" instead of
"unsigned int" for the mask.
Even asm-generic uses different mask types for atomic_clear_mask() and
atomic_set_mask().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
