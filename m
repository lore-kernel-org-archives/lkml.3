Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaH1WW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:22:27 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:63793 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaH1WW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
References: <20140827204940.GA10556@laptop.dumpdata.com>
	<1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
Date: Thu, 28 Aug 2014 15:22:25 -0700
X-Google-Sender-Auth: xcYxRyW618a7IC9RvGjZZGzpOEY
Message-ID: <CAGXu5jJj33N0+wP4w2nztwDpofwCwfByAmOmd87iDpqh4iwSAg@mail.gmail.com>
Subject: Re: [PATCH] Solved the Xen PV/KASLR riddle
From: Kees Cook <keescook@chromium.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 11:01 AM, Stefan Bader
<stefan.bader@canonical.com> wrote:
>> > So not much further... but then I think I know what I do next. Probably should
>> > have done before. I'll replace the WARN_ON in vmalloc that triggers by a panic
>> > and at least get a crash dump of that situation when it occurs. Then I can dig
>> > in there with crash (really should have thought of that before)...
>>
>> <nods> I dug a bit in the code (arch/x86/xen/mmu.c) but there is nothing there
>> that screams at me, so I fear I will have to wait until you get the crash
>> and get some clues from that.
>
> Ok, what a journey. So after long hours of painful staring at the code...
> (and btw, if someone could tell me how the heck one can do a mfn_to_pfn
> in crash, I really would appreaciate :-P)
>
> So at some point I realized that level2_fixmap_pgt seemed to contain
> an oddly high number of entries (given that the virtual address that
> failed would be mapped by entry 0). And suddenly I realized that apart
> from entries 506 and 507 (actual fixmap and vsyscalls) the whole list
> actually was the same as level2_kernel_gpt (without the first 16M
> cleared).
>
> And then I realized that xen_setup_kernel_pagetable is wrong to a
> degree which makes one wonder how this ever worked. Adding PMD_SIZE
> as an offset (2M) isn't changing l2 at all. This just copies Xen's
> kernel mapping, AGAIN!.

Woo! Nice find!

-Kees

>
> I guess we all just were lucky that in most cases modules would not
> use more than 512M (which is the correctly cleaned up remainder
> of kernel_level2_pgt)...
>
> I still need to compile a kernel with the patch and the old layout
> but I kind of got exited by the find. At least this is tested with
> the 1G/~1G layout and it comes up without vmalloc errors.
>
> -Stefan
>
> From 4b9a9a45177284e29d345eb54c545bd1da718e1b Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Thu, 28 Aug 2014 19:17:00 +0200
> Subject: [PATCH] x86/xen: Fix setup of 64bit kernel pagetables
>
> This seemed to be one of those what-the-heck moments. When trying to
> figure out why changing the kernel/module split (which enabling KASLR
> does) causes vmalloc to run wild on boot of 64bit PV guests, after
> much scratching my head, found that the current Xen code copies the
> same L2 table not only to the level2_ident_pgt and level2_kernel_pgt,
> but also (due to miscalculating the offset) to level2_fixmap_pgt.
>
> This only worked because the normal kernel image size only covers the
> first half of level2_kernel_pgt and module space starts after that.
> With the split changing, the kernel image uses the full PUD range of
> 1G and module space starts in the level2_fixmap_pgt. So basically:
>
> L4[511]->level3_kernel_pgt[510]->level2_kernel_pgt
>                           [511]->level2_fixmap_pgt
>
> And now the incorrect copy of the kernel mapping in that range bites
> (hard).
>
> This change might not be the fully correct approach as it basically
> removes the pre-set page table entry for the fixmap that is compile
> time set (level2_fixmap_pgt[506]->level1_fixmap_pgt). For one the
> level1 page table is not yet declared in C headers (that might be
> fixed). But also with the current bug, it was removed, too. Since
> the Xen mappings for level2_kernel_pgt only covered kernel + initrd
> and some Xen data this did never reach that far. And still, something
> does create entries at level2_fixmap_pgt[506..507]. So it should be
> ok. At least I was able to successfully boot a kernel with 1G kernel
> image size without any vmalloc whinings.
>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  arch/x86/xen/mmu.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index e8a1201..803034c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1902,8 +1902,22 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>                 /* L3_i[0] -> level2_ident_pgt */
>                 convert_pfn_mfn(level3_ident_pgt);
>                 /* L3_k[510] -> level2_kernel_pgt
> -                * L3_i[511] -> level2_fixmap_pgt */
> +                * L3_k[511] -> level2_fixmap_pgt */
>                 convert_pfn_mfn(level3_kernel_pgt);
> +
> +               /* level2_fixmap_pgt contains a single entry for the
> +                * fixmap area at offset 506. The correct way would
> +                * be to convert level2_fixmap_pgt to mfn and set the
> +                * level1_fixmap_pgt (which is completely empty) to RO,
> +                * too. But currently this page table is not delcared,
> +                * so it would be a bit of voodoo to get its address.
> +                * And also the fixmap entry was never set anyway due
> +                * to using the wrong l2 when getting Xen's tables.
> +                * So let's just nuke it.
> +                * This orphans level1_fixmap_pgt, but that should be
> +                * as it always has been.
> +                */
> +               memset(level2_fixmap_pgt, 0, 512*sizeof(long));
>         }
>         /* We get [511][511] and have Xen's version of level2_kernel_pgt */
>         l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
> @@ -1913,21 +1927,15 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>         addr[1] = (unsigned long)l3;
>         addr[2] = (unsigned long)l2;
>         /* Graft it onto L4[272][0]. Note that we creating an aliasing problem:
> -        * Both L4[272][0] and L4[511][511] have entries that point to the same
> +        * Both L4[272][0] and L4[511][510] have entries that point to the same
>          * L2 (PMD) tables. Meaning that if you modify it in __va space
>          * it will be also modified in the __ka space! (But if you just
>          * modify the PMD table to point to other PTE's or none, then you
>          * are OK - which is what cleanup_highmap does) */
>         copy_page(level2_ident_pgt, l2);
> -       /* Graft it onto L4[511][511] */
> +       /* Graft it onto L4[511][510] */
>         copy_page(level2_kernel_pgt, l2);
>
> -       /* Get [511][510] and graft that in level2_fixmap_pgt */
> -       l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
> -       l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
> -       copy_page(level2_fixmap_pgt, l2);
> -       /* Note that we don't do anything with level1_fixmap_pgt which
> -        * we don't need. */
>         if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>                 /* Make pagetable pieces RO */
>                 set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security
