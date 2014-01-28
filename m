Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaA1TzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:55:09 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43596 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaA1TzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:55:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140128194739.GP15937@n2100.arm.linux.org.uk>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
	<CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
	<CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
	<20140128171823.GN15937@n2100.arm.linux.org.uk>
	<CAE9FiQUa3uKZNc=5fiuvcR4bjEeQ3=RuhFVxUyKyMsJwe2YurA@mail.gmail.com>
	<20140128194739.GP15937@n2100.arm.linux.org.uk>
Date: Tue, 28 Jan 2014 11:55:05 -0800
X-Google-Sender-Auth: 3IM4EnERp-Y0hp2qgvQ0js4xQiA
Message-ID: <CAE9FiQXc5GYK2EnZ3j3STYLy_t8FeUkqeJb+3=bJ7hT9vtORMQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Yinghai Lu <yinghai@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:47 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 28, 2014 at 11:43:02AM -0800, Yinghai Lu wrote:
>> On Tue, Jan 28, 2014 at 9:18 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Tue, Jan 28, 2014 at 09:12:27AM -0800, Yinghai Lu wrote:
>> >> On Tue, Jan 28, 2014 at 7:30 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> >> > Like Olof, I noticed multiple boot failures on various ARM boards.
>> >> > I've confirmed that reverting the arch/arm part of this patch makes
>> >> > them all happily booting again.
>> >>
>> >> please try attached patch.
>> >
>> > Maybe I'm missing something, but there is no ARCH_LOW_ADDRESS_LIMIT
>> > defined in the ARM header files, so I don't see how adding that
>> > additional include changes anything.
>>
>> there is one for arm64 and s390.
>>
>> arch/arm64/include/asm/processor.h:#define ARCH_LOW_ADDRESS_LIMIT       PHYS_MAS
>> arch/s390/include/asm/processor.h:#define ARCH_LOW_ADDRESS_LIMIT        0x7fffff
>
> Forgive me being difficult, but how exactly does your patch come anywhere
> close to sortting out the reported regression by Kevin and Olof, and now
> myself which is on ARM?
>
> Your patch adds asm/processor.h to a header file, to allow architectures
> to override ARCH_LOW_ADDRESS_LIMIT, but there is /no/ override for ARM,
> so your patch has _zero_ effect there - we still end up with this being
> 0xffffffff, and we still end up with the thing being unable to boot.
>
> Maybe you could describe what this ARCH_LOW_ADDRESS_LIMIT is, and what
> it should be set to - I'm less than clear on how to set this given that
> we have a multitude of different physical memory layouts - where memory
> can start at almost any physical address.

well, I just want to restore the alloc_bootmem_low by following patch.

commit 9233d2be108f573caa21eb450411bf8fa68cadbb
Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date:   Tue Jan 21 15:50:47 2014 -0800

    arch/arm/kernel/: use memblock apis for early memory allocations

    Switch to memblock interfaces for early memory allocator instead of
    bootmem allocator.  No functional change in beahvior than what it is in
    current code from bootmem users points of view.

    Archs already converted to NO_BOOTMEM now directly use memblock
    interfaces instead of bootmem wrappers build on top of memblock.  And
    the archs which still uses bootmem, these new apis just fallback to
    exiting bootmem APIs.

    Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
...
@@ -717,7 +717,7 @@ static void __init
request_standard_resources(const struct machine_desc *mdesc)
        kernel_data.end     = virt_to_phys(_end - 1);

        for_each_memblock(memory, region) {
-               res = alloc_bootmem_low(sizeof(*res));
+               res = memblock_virt_alloc(sizeof(*res), 0);
                res->name  = "System RAM";

but looks like memblock_virt_alloc_low is not the same as alloc_bootmem_low yet.

Let's me check further.

Thanks

Yinghai
