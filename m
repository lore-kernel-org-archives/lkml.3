Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaFKTTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:19:15 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59118 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <539892BD.8020403@codeaurora.org>
References: <CAMuHMdXm_fT251+ih2cJS+hRkrPuVQi3sMFgYe+k18xe-Wd21w@mail.gmail.com>
	<539892BD.8020403@codeaurora.org>
Date: Wed, 11 Jun 2014 21:19:10 +0200
X-Google-Sender-Auth: ZxfhB0Bx3Mu4qjDOQjfnSBdCuu4
Message-ID: <CAMuHMdWZutiNpGScEhCzgM70jJ+MZ1ErmKtNfMHVLDB+d5Lyzw@mail.gmail.com>
Subject: Re: BUG: Bad page state in process swapper pfn:00000
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laura,

On Wed, Jun 11, 2014 at 7:32 PM, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 6/11/2014 4:40 AM, Geert Uytterhoeven wrote:
>> With current mainline, I get an early crash on r8a7791/koelsch:
>>
>> BUG: Bad page state in process swapper  pfn:00000
>> page:ee20b000 count:0 mapcount:0 mapping:66756200 index:0x65726566
>> page flags: 0x74656b63(locked|error|lru|active|owner_priv_1|arch_1|private|writeback|head|swapcache
>> |reclaim|mlocked)
>> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>> bad because of flags:
>> page flags: 0x212861(locked|lru|active|private|writeback|swapcache|mlocked)
>>
>> I bisected it to
>>
>> commit 1c2f87c22566cd057bc8cde10c37ae9da1a1bb76
>> Author: Laura Abbott <lauraa@codeaurora.org>
>> Date:   Sun Apr 13 22:54:58 2014 +0100
>>
>>     ARM: 8025/1: Get rid of meminfo

>> -Truncating RAM at 40000000-bfffffff to -6f7fffff (vmalloc region overlap).
>> +Truncating RAM at 0x00000000-0xc0000000 to -0x6f800000
>
> I'm guessing this is the issue right there.
>
>         memory@40000000 {
>                 device_type = "memory";
>                 reg = <0 0x40000000 0 0x40000000>;
>         };
>
>         memory@200000000 {
>                 device_type = "memory";
>                 reg = <2 0x00000000 0 0x40000000>;
>         };
>
> Those are the memory nodes from r8a7791-koelsch.dts. It looks like the memory
> outside 32-bit address range is not being dropped. It was suggested to drop
> early_init_dt_add_memory_arch which called arm_add_memory and just use the
> generic of code directly but the problem is arm_add_memory does additional
> bounds checking. It looks like early_init_dt_add_memory_arch in
> drivers/of/fdt.c checks for overflow on u64 types but not for overflow
> on phys_addr_t (32 bits) which is what memblock_add actually uses.
>
> For a quick test, can you try bringing back early_init_dt_add_memory_arch
> and see if that fixes the problem:
>
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index e94a157..ea9ce92 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -27,6 +27,10 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach-types.h>
>
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +       arm_add_memory(base, size);
> +}
>
>  #ifdef CONFIG_SMP
>  extern struct of_cpu_method __cpu_method_of_table[];

Thanks, my board boots again after applying this quick hack.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
