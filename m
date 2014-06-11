Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbaFKRcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:32:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42845 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987AbaFKRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:32:49 -0400
Message-ID: <539892BD.8020403@codeaurora.org>
Date: Wed, 11 Jun 2014 10:32:45 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: BUG: Bad page state in process swapper pfn:00000
References: <CAMuHMdXm_fT251+ih2cJS+hRkrPuVQi3sMFgYe+k18xe-Wd21w@mail.gmail.com>
In-Reply-To: <CAMuHMdXm_fT251+ih2cJS+hRkrPuVQi3sMFgYe+k18xe-Wd21w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the bisect.

On 6/11/2014 4:40 AM, Geert Uytterhoeven wrote:
> With current mainline, I get an early crash on r8a7791/koelsch:
> 
> BUG: Bad page state in process swapper  pfn:00000
> page:ee20b000 count:0 mapcount:0 mapping:66756200 index:0x65726566
> page flags: 0x74656b63(locked|error|lru|active|owner_priv_1|arch_1|private|writeback|head|swapcache
> |reclaim|mlocked)
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> bad because of flags:
> page flags: 0x212861(locked|lru|active|private|writeback|swapcache|mlocked)
> 
> I bisected it to
> 
> commit 1c2f87c22566cd057bc8cde10c37ae9da1a1bb76
> Author: Laura Abbott <lauraa@codeaurora.org>
> Date:   Sun Apr 13 22:54:58 2014 +0100
> 
>     ARM: 8025/1: Get rid of meminfo
> 
>     memblock is now fully integrated into the kernel and is the prefered
>     method for tracking memory. Rather than reinvent the wheel with
>     meminfo, migrate to using memblock directly instead of meminfo as
>     an intermediate.
> 
>     Acked-by: Jason Cooper <jason@lakedaemon.net>
>     Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>     Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>     Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>     Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>     Tested-by: Leif Lindholm <leif.lindholm@linaro.org>
>     Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> As this is a quite intrusive change, it cannot be reverted on top of mainline.
> 
> The commit before (1c8c3cf0b5239388e712508a85821f4718f4d889)
> does work. Dmesg difference between them:
> 
>  Uncompressing Linux... done, booting the kernel.
>  Booting Linux on physical CPU 0x0
> -Linux version 3.15.0-rc1-koelsch-reference-00027-g1c8c3cf0b523-dirty
> (geert@ramsan) (gcc version 4.6.3 (GCC) ) #174 SMP Wed Jun 11 13:19:00
> CEST 2014
> +Linux version 3.15.0-rc1-koelsch-reference-00028-g1c2f87c22566-dirty
> (geert@ramsan) (gcc version 4.6.3 (GCC) ) #175 SMP Wed Jun 11 13:20:28
> CEST 2014
>  CPU: ARMv7 Processor [413fc0f2] revision 2 (ARMv7), cr=10c5347d
>  CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> -Ignoring memory at 0x200000000 outside 32-bit physical address space
>  Machine model: Koelsch
>  bootconsole [earlycon0] enabled
>  debug: ignoring loglevel setting.
> -Truncating RAM at 40000000-bfffffff to -6f7fffff (vmalloc region overlap).
> +Truncating RAM at 0x00000000-0xc0000000 to -0x6f800000

I'm guessing this is the issue right there.

        memory@40000000 {
                device_type = "memory";
                reg = <0 0x40000000 0 0x40000000>;
        };

        memory@200000000 {
                device_type = "memory";
                reg = <2 0x00000000 0 0x40000000>;
        };

Those are the memory nodes from r8a7791-koelsch.dts. It looks like the memory
outside 32-bit address range is not being dropped. It was suggested to drop
early_init_dt_add_memory_arch which called arm_add_memory and just use the
generic of code directly but the problem is arm_add_memory does additional
bounds checking. It looks like early_init_dt_add_memory_arch in
drivers/of/fdt.c checks for overflow on u64 types but not for overflow
on phys_addr_t (32 bits) which is what memblock_add actually uses. 

For a quick test, can you try bringing back early_init_dt_add_memory_arch
and see if that fixes the problem:

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index e94a157..ea9ce92 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -27,6 +27,10 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+       arm_add_memory(base, size);
+}
 
 #ifdef CONFIG_SMP
 extern struct of_cpu_method __cpu_method_of_table[];

Thanks,
Laura


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
