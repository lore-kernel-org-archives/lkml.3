Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaHFQh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:37:57 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52122 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaHFQhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <53E1A3A3.8080706@huawei.com>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
	<1397559967-26050-3-git-send-email-sdu.liu@huawei.com>
	<CAL_JsqKE-L2PN3mXHNdTPMEyTMR9ZtbgGB=O_V6nOXN0YC0a4A@mail.gmail.com>
	<alpine.LFD.2.11.1405301441210.17310@knanqh.ubzr>
	<CAGXu5j+ga5Enrsd8LuYarGh1Ozakmi3MNw+b9fZ7ubGUJFZY=w@mail.gmail.com>
	<53E1A3A3.8080706@huawei.com>
Date: Wed, 6 Aug 2014 09:37:54 -0700
X-Google-Sender-Auth: sYuNYHB14I7SYf1MeVgqmNPqh-M
Message-ID: <CAGXu5jKxtm0YAojOLhd_O9AFUAX+xHgEwwB0W_fpN7Xy8wHphQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ARM : change fixmap mapping region to support 32 CPUs
From: Kees Cook <keescook@chromium.org>
To: Liu hua <sdu.liu@huawei.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robherring2@gmail.com>, wangnan0 <wangnan0@huawei.com>,
        Laura Abbott <lauraa@codeaurora.org>, peifeiyue <peifeiyue@huawei.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>, Rabin Vincent <rabin@rab.in>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "liusdu@126.com" <liusdu@126.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 8:40 PM, Liu hua <sdu.liu@huawei.com> wrote:
> 于 2014/8/6 10:51, Kees Cook 写道:
>> On Fri, May 30, 2014 at 12:25 PM, Nicolas Pitre
>> <nicolas.pitre@linaro.org> wrote:
>>> On Fri, 30 May 2014, Rob Herring wrote:
>>>
>>>> There's work in flight to support early_ioremap, early console, and RO
>>>> text patching which all use the fixmap region.
>>>>
>>>> There's a couple of options to solve this:
>>>>
>>>> - Only support up to 16 cpus. It could be anywhere between 17-31, but
>>>> that seems somewhat unlikely. Are we really ever going to see 32-bit
>>>> 32 core systems?
>>>
>>> I wouldn't rule that out.  I've seen 16-core ARM chips in 2008 (although
>>> they didn't go into production).  Silly limitations like that always
>>> come back to bite you.  And we have better alternatives.
>>>
>>>> - Reduce KM_TYPE_NR from 16 to 15. Based on the comment for it, we
>>>> probably don't want to do that. Is increasing it to the default of 20
>>>> worthwhile? Some of the options here would allow doing that.
>>>> - Add 0xffe00000-0xfff00000 to the fixmap region. This would make
>>>> fixmap span 2 PMDs with the top PMD having a mixture of uses like we
>>>> had before.
>>>
>>> That would be my preferred approach.  Note here it could be
>>> 0xffe00000-0xfffe0000 to include the whole of the previous fixmap area
>>> curently unused.
>>>
>>>> - push the PCI i/o space down to 0xfec00000 and make fixmap 4MB. This
>>>> is a cleaner solution as the 2 PMDs are only used for fixmap. This may
>>>> require some static mapping adjustments on some platforms.
>>>
>>> No need.  With the latest changes, the fixmap area is between 0xffc00000
>>> and 0xffe00000 (there is apparently a mistake in
>>> Documentation/arm/memory.txt).  So currently 0xff000000-0xffc00000 is
>>> free, which makes the fixmap area far away from the PCI i/o area with
>>> plenti of space in between.
>>
>> So, it seems there is something wrong with this patch series. I had to
>> revert "ARM: 8031/2: change fixmap mapping region to support 32 CPUs"
>> to make other fixmap changes work correctly. I think this is due to
>> the non-highmem config case moving the fixmap to a location where
>> there is to page table entry...
> Hi Kees,
>
> Did this patch conflict with others, or it will at the future?

Strictly from the perspective of upstream, it conflicts with future
patches (I'm working on the RO text patching bit currently). There was
a fixmap series before (from Mark Salter and Rabin Vincent) that
worked, but after rebasing to the current tree, this 32-cpu support
patch appears to break it.

> As Rob said "There's work in flight to support early_ioremap, early console, and RO
> text patching which all use the fixmap region."  So if this patch will block kernel's
> new feature, Should we makes new patch to changes it, not revert it. Because there are
> arm platforms with more than 14 CPUs.

Right -- it seems like for kmap stuff, 64k is needed per CPU? I
thought there was agreement to do 16 CPUs, rather than 32. But let me
merge threads, and add Nicolas's question...

Nicolas Pitre said:
> Could you elaborate please?  How can the non-highmem config move the
> fixmap area?  And what are those other fixmap changes?

The comment and code that existed before the patch said this:

/*
 * Nothing too fancy for now.
 *
 * On ARM we already have well known fixed virtual addresses imposed by
 * the architecture such as the vector page which is located at 0xffff0000,
 * therefore a second level page table is already allocated covering
 * 0xfff00000 upwards.
 *
 * The cache flushing code in proc-xscale.S uses the virtual area between
 * 0xfffe0000 and 0xfffeffff.
 */

#define FIXADDR_START           0xfff00000UL
#define FIXADDR_END             0xfffe0000UL

After the patch:

#define FIXADDR_START           0xffc00000UL
#define FIXADDR_TOP             0xffe00000UL

With the original code, there is (I think) a page table entry for the
fixmap range. For the latter, there isn't. I see a NULL pgd entry
fault when trying to use it, and noticed that this only exists under
highmem:

static void __init kmap_init(void)
{
#ifdef CONFIG_HIGHMEM
        pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
                PKMAP_BASE, _PAGE_KERNEL_TABLE);

        fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
                FIXADDR_START, _PAGE_KERNEL_TABLE);
#endif
}

My initial attempts at using HIGHMEM failed, but I think that's
because it the entire fixmap area was taken by the kmap 32-cpu stuff.
I'm going to continue playing with it, but if anyone sees a trivial
solution, I'd love to know. :) It's not clear to me what's needed to
get the page table initialized for the whole region (with or without
HIGHMEM).

Thanks!

-Kees

>
> Thanks,
> Liu Hua
>>
>> -Kees
>>
>>>
>>>> - Same as previous option, but convert the PCI i/o space to fixmap
>>>> entries. We don't really need all 2MB for PCI.
>>>
>>> See above.
>>>
>>>> Also, there is an error in the documentation below:
>>>>
>>>>>
>>>>> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
>>>>> ---
>>>>>  Documentation/arm/memory.txt   |  2 +-
>>>
>>> Yep, good that you spotted it as well.  I failed to catch it during my
>>> review so I'll send a patch.
>>>
>>>
>>> Nicolas
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>>
>>
>
>



-- 
Kees Cook
Chrome OS Security
