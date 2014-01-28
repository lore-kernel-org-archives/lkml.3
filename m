Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaA1RXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:23:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52136 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaA1RXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:23:36 -0500
Message-ID: <52E7E776.30909@ti.com>
Date: Tue, 28 Jan 2014 12:23:02 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org> <1390590670-25901-4-git-send-email-yinghai@kernel.org> <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com> <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com> <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
In-Reply-To: <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 January 2014 12:12 PM, Yinghai Lu wrote:
> On Tue, Jan 28, 2014 at 7:30 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> > On Tue, Jan 28, 2014 at 12:02 AM, Olof Johansson <olof@lixom.net> wrote:
>>> >> Hi,
>>> >>
>>> >> On Fri, Jan 24, 2014 at 11:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> >>> The new memblock_virt APIs are used to replaced old bootmem API.
>>>> >>>
>>>> >>> We need to allocate page below 4G for swiotlb.
>>>> >>>
>>>> >>> That should fix regression on Andrew's system that is using swiotlb.
>>>> >>>
>>>> >>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> >>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> >>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> >>
>>> >> This seems to have been merged by Linus tonight as ad6492b80f, and it
>>> >> had fallout on ARM systems (boot failures with no console output on
>>> >> all but 5 of my machine/config combos).
>>> >>
>>> >> Seems like it didn't have a chance to sit in -next, which is somewhat
>>> >> understandable given that it's considered a bugfix and it indeed fixed
>>> >> the bug it was meant to.
>>> >>
>>> >> i'm out of time to debug this tonight (I noticed the failures as I was
>>> >> heading to bed and figured I'd at least bisect them), so I wouldn't
>>> >> mind seeing a revert of the ARM side change of ad6492b80f until it's
>>> >> been sorted out so we keep bisectabilty intact for the rest of the
>>> >> kernel.
>> >
>> > Like Olof, I noticed multiple boot failures on various ARM boards.
>> > I've confirmed that reverting the arch/arm part of this patch makes
>> > them all happily booting again.
> please try attached patch.
> 
> Index: linux-2.6/include/linux/bootmem.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bootmem.h
> +++ linux-2.6/include/linux/bootmem.h
> @@ -179,6 +179,9 @@ static inline void * __init memblock_vir
>                                                     NUMA_NO_NODE);
>  }
> 
> +/* Take arch's ARCH_LOW_ADDRESS_LIMIT at first*/
> +#include <asm/processor.h>
> +
>  #ifndef ARCH_LOW_ADDRESS_LIMIT
>  #define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
>  #endif

This won't help mostly since the ARM 32 arch don't set ARCH_LOW_ADDRESS_LIMIT.
Sorry i couldn't respond to the thread earlier because of travel and
don't have access to my board to try out the patches.
The issue is mostly because on ARM the allocations needs to be limited lowmem and
that has been ensured using BOOTMEM_ALLOC_ACCESSIBLE in bootmem case and
MEMBLOCK_ALLOC_ACCESSIBLE in memblock case.

Even though ARM change done to use alloc_low() is correct, it has undesired
side effect of allocating memory from highmem because of non-use of
ARCH_LOW_ADDRESS_LIMIT. Setting ARCH_LOW_ADDRESS_LIMIT to MEMBLOCK_ALLOC_ACCESSIBLE
in ARM case also doesn't seem right.

Unless you have better idea, backing out the arch/arm change from the
subject patch seems to be most safe.

Regards,
Ssantosh





