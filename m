Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaIDVZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:25:53 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:58013 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbaIDVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
References: <5405E186.2080406@canonical.com>
	<20140902192941.GB3001@console-pimps.org>
	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
	<5406D0DB.90401@canonical.com>
	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
	<54073409.6030004@canonical.com>
	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
	<20140903175948.GH3001@console-pimps.org>
	<CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
	<54084376.8090002@canonical.com>
	<540860F1.6060801@fensystems.co.uk>
	<CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
Date: Thu, 4 Sep 2014 23:25:48 +0200
Message-ID: <CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Michael Brown <mbrown@fensystems.co.uk>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Matt Fleming <matt@console-pimps.org>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2014 21:12, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 4 September 2014 14:54, Michael Brown <mbrown@fensystems.co.uk> wrote:
>> On 04/09/14 11:48, Maarten Lankhorst wrote:
>>>>>
>>>>> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
>>>>> done the single __attribute__() hacks in other projects and someone
>>>>> (usually me) always eventually forgets to tag some instance.
>>>>>
>>>> It appears we just got lucky on arm64, since we don't have any global
>>>> variables, but the issue does exist there as well.
>>>>
>>> FWIW, visibility pushing doesn't seem to work for functions declared with
>>> extern.
>>> Following seems to get rid of all GOTPCREL:
>>
>>
>> Are you sure?  The iPXE build process relies on this:
>>
>>   /* Force visibility of all symbols to "hidden", i.e. inform gcc that
>>    * all symbol references resolve strictly within our final binary.
>>    * This avoids unnecessary PLT/GOT entries on x86_64.
>>    *
>>    * This is a stronger claim than specifying "-fvisibility=hidden",
>>    * since it also affects symbols marked with "extern".
>>    */
>>   #ifndef ASSEMBLY
>>   #if __GNUC__ >= 4
>>   #pragma GCC visibility push(hidden)
>>   #endif
>>   #endif /* ASSEMBLY */
>>
>> and https://gcc.gnu.org/wiki/Visibility states that
>>
>>   "#pragma GCC visibility is stronger than -fvisibility; it affects extern
>> declarations as well. -fvisibility only affects definitions, so that
>> existing code can be recompiled with minimal changes. This is more true for
>> C than C++; C++ interfaces tend use classes, which are affected by
>> -fvisibility."
>>
>
> This is exactly the reason I suggested using the #pragma in the first
> place, only you need to take care to put it before #includes or it
> won't apply to extern declarations contained in those.
>
> But my later suggestion was to apply the attribute to extern
> declarations explicitly, it is probably more portable, and if we can
> assert that the GOT is empty, we can easily spot new ones popping up
> before they make it into the tree.
> Since Maarten's research seems to suggest that using the visibility
> attribute is feasible as it dates back to the GCC 3.x days, I will go
> ahead and implement the fix I suggested.
>

As it turns out, this breaks 32-bit, and the linker script is shared.

So I suggest that we go with Matt's suggestion, i.e., move/clone the
GOT fixup code so that it runs exactly once in each code path, but
early enough so that the embedded EFI application gets the treatment
too.
And don't forget head_32.S ...

Cheers,
Ard.
