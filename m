Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaCCKxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:53:51 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:47368 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCCKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:53:50 -0500
X-IronPort-AV: E=Sophos;i="4.97,577,1389772800"; 
   d="scan'208";a="17459522"
Message-ID: <53145F3A.2010203@broadcom.com>
Date: Mon, 3 Mar 2014 11:53:46 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: kbuild test robot <fengguang.wu@intel.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>, <kbuild-all@01.org>,
        Tony Luck <tony.luck@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [wireless-next:master 169/199] drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2469:3:
 error: implicit declaration of function 'atomic_set_mask'
References: <53110a73.fVHl0nWfqeLuOaob%fengguang.wu@intel.com> <53110C1A.60804@broadcom.com> <CAGVrzcY85PTeQnSf3ptQyC94A3b7FdX9QPxDcSq+UYhgKfWbUg@mail.gmail.com> <53110EA5.8070503@broadcom.com> <CAGVrzcaPsaDiBbnbopQTjT_-3ohYWs9HFn-4Y9DL1WJy_A7mzg@mail.gmail.com>
In-Reply-To: <CAGVrzcaPsaDiBbnbopQTjT_-3ohYWs9HFn-4Y9DL1WJy_A7mzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/14 23:44, Florian Fainelli wrote:
> 2014-02-28 14:33 GMT-08:00 Arend van Spriel<arend@broadcom.com>:
>> On 02/28/2014 11:26 PM, Florian Fainelli wrote:
>>> 2014-02-28 14:22 GMT-08:00 Arend van Spriel<arend@broadcom.com>:
>>>> On 02/28/2014 11:15 PM, kbuild test robot wrote:
>>>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
>>>>> head:   3e3831c4fdc53aabf3a56419ef6d96a841c52435
>>>>> commit: c98db0bec72ac7ef127119c1ed962d6f56802b12 [169/199] brcmfmac: Use atomic functions for intstatus update.
>>>>> config: make ARCH=ia64 allmodconfig
>>>>>
>>>>> All error/warnings:
>>>>>
>>>>>     drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdio_intr_rstatus':
>>>>>>> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2469:3: error: implicit declaration of function 'atomic_set_mask' [-Werror=implicit-function-declaration]
>>>>>     cc1: some warnings being treated as errors
>>>>
>>>> Hi Fengguang,
>>>>
>>>> So atomic_set_mask() is not a generally available function. I thought
>>>> that if the arch does not provide it, the asm-generic implementation is
>>>> used.
>>>
>>> Though so as well.
>>>
>>>> Also it seems the function prototype is not the same for all
>>>> archs. :-(
>>>
>>> This does not sound like it is expected, and this might need fixing,
>>> do you want to tackle this?
>>
>> I got email m68k and ia64 failing. Some implementations are in assembly.
>> It has been (counting...) over 20 years since I did some baby steps in
>> m68k assembly and do not really feel a strong pull to that dark side.
>
> This is supposed to be a generic function that everyone should be able
> to use without knowing the underlying details. Not quite sure why
> those two architectures are different, maybe we should ask Geert and
> Tony about this?

I was about to when I decided to do some more digging. So taking a 
closer look at include/asm-generic/atomic.h revealed this:

/*
  * Generic C implementation of atomic counter operations. Usable on
  * UP systems only. Do not include in machine independent code.

And further down:

#ifdef CONFIG_SMP
/* Force people to define core atomics */
# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
      !defined(atomic_clear_mask) || !defined(atomic_set_mask)
#  error "SMP requires a little arch-specific magic"
# endif
#endif

So in these SMP era architecture specific implementations seem required. 
IA64 does not provide it (so CONFIG_SMP not supported?) and m68k has 
different prototype. Apparently, the comment /* Force people to define 
core atomics */ did not fly for all archs (yet) :-p.

Regards,
Arend
