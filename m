Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaFLCve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:51:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53333 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaFLCvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:51:33 -0400
Message-ID: <539915B3.9050904@codeaurora.org>
Date: Wed, 11 Jun 2014 19:51:31 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: BUG: Bad page state in process swapper pfn:00000
References: <CAMuHMdXm_fT251+ih2cJS+hRkrPuVQi3sMFgYe+k18xe-Wd21w@mail.gmail.com>	<539892BD.8020403@codeaurora.org> <CAMuHMdWZutiNpGScEhCzgM70jJ+MZ1ErmKtNfMHVLDB+d5Lyzw@mail.gmail.com>
In-Reply-To: <CAMuHMdWZutiNpGScEhCzgM70jJ+MZ1ErmKtNfMHVLDB+d5Lyzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/2014 12:19 PM, Geert Uytterhoeven wrote:
> Hi Laura,
> 
> On Wed, Jun 11, 2014 at 7:32 PM, Laura Abbott <lauraa@codeaurora.org> wrote:
>> On 6/11/2014 4:40 AM, Geert Uytterhoeven wrote:
>>> With current mainline, I get an early crash on r8a7791/koelsch:
>>>
>>> BUG: Bad page state in process swapper  pfn:00000
>>> page:ee20b000 count:0 mapcount:0 mapping:66756200 index:0x65726566
>>> page flags: 0x74656b63(locked|error|lru|active|owner_priv_1|arch_1|private|writeback|head|swapcache
>>> |reclaim|mlocked)
>>> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>>> bad because of flags:
>>> page flags: 0x212861(locked|lru|active|private|writeback|swapcache|mlocked)
>>>
>>> I bisected it to
>>>
>>> commit 1c2f87c22566cd057bc8cde10c37ae9da1a1bb76
>>> Author: Laura Abbott <lauraa@codeaurora.org>
>>> Date:   Sun Apr 13 22:54:58 2014 +0100
>>>
>>>     ARM: 8025/1: Get rid of meminfo
> 
>>> -Truncating RAM at 40000000-bfffffff to -6f7fffff (vmalloc region overlap).
>>> +Truncating RAM at 0x00000000-0xc0000000 to -0x6f800000
>>
>> I'm guessing this is the issue right there.
>>
>>         memory@40000000 {
>>                 device_type = "memory";
>>                 reg = <0 0x40000000 0 0x40000000>;
>>         };
>>
>>         memory@200000000 {
>>                 device_type = "memory";
>>                 reg = <2 0x00000000 0 0x40000000>;
>>         };
>>
>> Those are the memory nodes from r8a7791-koelsch.dts. It looks like the memory
>> outside 32-bit address range is not being dropped. It was suggested to drop
>> early_init_dt_add_memory_arch which called arm_add_memory and just use the
>> generic of code directly but the problem is arm_add_memory does additional
>> bounds checking. It looks like early_init_dt_add_memory_arch in
>> drivers/of/fdt.c checks for overflow on u64 types but not for overflow
>> on phys_addr_t (32 bits) which is what memblock_add actually uses.
>>
>> For a quick test, can you try bringing back early_init_dt_add_memory_arch
>> and see if that fixes the problem:
>>
>> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
>> index e94a157..ea9ce92 100644
>> --- a/arch/arm/kernel/devtree.c
>> +++ b/arch/arm/kernel/devtree.c
>> @@ -27,6 +27,10 @@
>>  #include <asm/mach/arch.h>
>>  #include <asm/mach-types.h>
>>
>> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>> +{
>> +       arm_add_memory(base, size);
>> +}
>>
>>  #ifdef CONFIG_SMP
>>  extern struct of_cpu_method __cpu_method_of_table[];
> 
> Thanks, my board boots again after applying this quick hack.
> 

Great! Russell are you okay with taking the above as a fix or would you prefer
I fixup drivers/of/fdt.c right now? 


Thanks,
Laura

----8<----
>From 14bda557a108ad197e7c5f040f50ca024b45cc17 Mon Sep 17 00:00:00 2001
From: Laura Abbott <lauraa@codeaurora.org>
Date: Wed, 11 Jun 2014 19:39:29 -0700
Subject: [PATCH] arm: Bring back early_init_dt_add_memory_arch

Commit 1c2f87c (ARM: 8025/1: Get rid of meminfo) removed
early_init_dt_add_memory_arch in favor of using the common method.
The common method does not currently check for memory outside of
32-bit bounds which may lead to memory being incorrectly added to
the system. Bring back early_init_dt_add_memory_arch for now until
the generic function can be fixed up.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/kernel/devtree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index e94a157..ea9ce92 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -27,6 +27,10 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	arm_add_memory(base, size);
+}
 
 #ifdef CONFIG_SMP
 extern struct of_cpu_method __cpu_method_of_table[];
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
