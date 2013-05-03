Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3ECPv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:51:27 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36856 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3ECPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:51:25 -0400
Message-ID: <5183DCF8.10204@gmail.com>
Date: Fri, 03 May 2013 23:51:20 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: eunb.song@samsung.com
CC: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jogo@openwrt.org, david.daney@cavium.com
Subject: Re: MIPS : die at free_initmem() function 3.9+
References: <31174990.226951367567235155.JavaMail.weblogic@epml13>
In-Reply-To: <31174990.226951367567235155.JavaMail.weblogic@epml13>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eunbong,
	Thanks for reporting!
	I think this issue may be caused by __pa_symbol() on 64bits MIPS machines
due to following definition:
#ifdef CONFIG_64BIT
#define __pa(x)                                                         \
({                                                                      \
    unsigned long __x = (unsigned long)(x);                             \
    __x < CKSEG0 ? XPHYSADDR(__x) : CPHYSADDR(__x);                     \
})
#else
#define __pa(x)                                                         \
    ((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
#endif
#define __va(x)         ((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))

So on 64bits MIPS platforms, __va(__pa(x)) may not equal to x, that may cause
trouble to free_initmem_default(). Could you please help to do another test
by changing
	free_initmem_default(POISON_FREE_INITMEM);
to
	free_initmem_default(0);

This test could help to identify whether this panic is caused by
	memset((void *)pos, poison, PAGE_SIZE);
in function free_reserved_area().

Thanks!
Gerry

On 05/03/2013 03:47 PM, EUNBONG SONG wrote:
> 
> Hello. I try to boot my cavium board with david's patch. 
> It's is not applied yet in linux tree, i got the patch from mailing list.
> And the patch is as follow.
> 
> 
> This is only very lightly tested, we need more testing before
> declaring it the definitive fix.
> 
>  arch/mips/kernel/genex.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
> index ecb347c..57cda9a 100644
> --- a/arch/mips/kernel/genex.S
> +++ b/arch/mips/kernel/genex.S
> @@ -132,12 +132,13 @@ LEAF(r4k_wait)
>         .set    noreorder
>         /* start of rollback region */
>         LONG_L  t0, TI_FLAGS($28)
> -       nop
>         andi    t0, _TIF_NEED_RESCHED
>         bnez    t0, 1f
>          nop
> -       nop
> -       nop
> +       /* Enable interrupts so WAIT will complete */
> +       mfc0    t0, CP0_STATUS
> +       ori     t0, ST0_IE
> +       mtc0    t0, CP0_STATUS
>         .set    mips3
>         wait
>         /* end of rollback region (the region size must be power of two) */
> 
> I think, it works well. But i encounter another problem at free_initmem(). 
> The log messages are as follow.
> 
> [  132.134719] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0+ #29
> [  132.141678] Stack : 0000000000000004 000000000000003f ffffffff80fa0000 ffffffff802924a8
>           0000000000000000 ffffffff80fa0000 00000000000000ff ffffffff80293760
>           0000000000000000 0000000000000000 ffffffff81080000 ffffffff81080000
>           ffffffff80e2baf0 ffffffff80f93977 a80000004146cbb8 0000000000000020
>           0000000000000003 0000000000000020 a800000041473da8 ffffffff810f0000
>           a800000041473a10 ffffffff806ef910 a800000041473828 ffffffff80290920
>           0000000000000000 ffffffff80293b90 000000000000000a ffffffff80e2baf0
>           0000000000000000 a800000041473750 000000004146cef8 ffffffff805e7794
>           0000000000000000 0000000000000000 0000000000000000 0000000000000000
>           0000000000000000 ffffffff80272498 0000000000000000 0000000000000000
>           ...
> [  132.207201] Call Trace:
> [  132.209655] [<ffffffff80272498>] show_stack+0x68/0x80
> [  132.225943] [<ffffffff802bd4ac>] notifier_call_chain+0x5c/0xa8
> [  132.231776] [<ffffffff802bdb84>] __atomic_notifier_call_chain+0x3c/0x58
> [  132.238391] [<ffffffff802bdbe8>] notify_die+0x38/0x48
> [  132.243442] [<ffffffff802716cc>] die+0x4c/0x148
> [  132.247974] [<ffffffff8027f998>] do_page_fault+0x4b8/0x500
> [  132.253461] [<ffffffff8026c764>] resume_userspace_check+0x0/0x10
> [  132.259469] [<ffffffff80324a54>] free_reserved_area+0x8c/0x178
> [  132.265304] [<ffffffff806e0dc8>] kernel_init+0x20/0x100
> [  132.270529] [<ffffffff8026c7e0>] ret_from_kernel_thread+0x10/0x18
> 
> And i just changed free_initmem() functions as follow
> 
> diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
> index 9b973e0..e246e9b 100644
> --- a/arch/mips/mm/init.c
> +++ b/arch/mips/mm/init.c
> @@ -447,7 +447,10 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  void __init_refok free_initmem(void)
>  {
>         prom_free_prom_memory();
> -       free_initmem_default(POISON_FREE_INITMEM);
> +
> +       free_init_pages("unused kernel memory",
> +                       __pa_symbol(&__init_begin),
> +                       __pa_symbol(&__init_end));
>  }
> 
> After that it works well. but i don't know why it works well.
> 
> Thanks. 
> 

