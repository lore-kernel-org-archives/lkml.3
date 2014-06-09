Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaFINYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:24:04 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:34690 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaFINYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:24:02 -0400
Message-ID: <5395B4D0.6040302@huawei.com>
Date: Mon, 9 Jun 2014 21:21:20 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alonid@stratoscale.com" <alonid@stratoscale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH] ARM: kdump: Add vmcore_elf64_check_arch
References: <1399124686-63299-1-git-send-email-sdu.liu@huawei.com> <20140506121558.GB30234@arm.com>
In-Reply-To: <20140506121558.GB30234@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/5/6 20:15, Will Deacon 写道:
> On Sat, May 03, 2014 at 02:44:46PM +0100, Liu Hua wrote:
>> Hi Will or Russell,
> 
> Hello,
> 
>> With CONFIG_LPAE=y, memory in 32-bit ARM systems can exceed
>> 4G. So if we use kdump in such systems. The capture kernel
>> should parse 64-bit elf header(parse_crash_elf64_headers).
>>
>> And this process can not pass because ARM linux only provides
>> zero vmcore_elf64_check_arch function by commit 4b3bf7aef.
>>
>> This patch adds check functions related to elf64 header.
> 
> [...]
> 
>> diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
>> index d0d1e83..452086a 100644
>> --- a/arch/arm/kernel/elf.c
>> +++ b/arch/arm/kernel/elf.c
>> @@ -38,6 +38,39 @@ int elf_check_arch(const struct elf32_hdr *x)
>>  }
>>  EXPORT_SYMBOL(elf_check_arch);
>>  
>> +int elf_check_arch_64(const struct elf64_hdr *x)
>> +{
>> +	unsigned int eflags;
>> +
>> +	/* Make sure it's an ARM executable */
>> +	if (x->e_machine != EM_ARM)
>> +		return 0;
>> +
>> +	/* Make sure the entry address is reasonable */
>> +	if (x->e_entry & 1) {
>> +		if (!(elf_hwcap & HWCAP_THUMB))
>> +			return 0;
>> +	} else if (x->e_entry & 3)
>> +		return 0;
>> +
>> +	eflags = x->e_flags;
>> +	if ((eflags & EF_ARM_EABI_MASK) == EF_ARM_EABI_UNKNOWN) {
>> +		unsigned int flt_fmt;
>> +
>> +		/* APCS26 is only allowed if the CPU supports it */
>> +		if ((eflags & EF_ARM_APCS_26) && !(elf_hwcap & HWCAP_26BIT))
>> +			return 0;
>> +
>> +		flt_fmt = eflags & (EF_ARM_VFP_FLOAT | EF_ARM_SOFT_FLOAT);
>> +
>> +		/* VFP requires the supporting code */
>> +		if (flt_fmt == EF_ARM_VFP_FLOAT && !(elf_hwcap & HWCAP_VFP))
>> +			return 0;
>> +	}
>> +	return 1;
>> +}
>> +EXPORT_SYMBOL(elf_check_arch_64);
> 
Hi Will,

Sorry to reply you so late. These days I am working on kdump feature for LPAE enabled
kernel. And now I think this patch is not good.

> This function looks identical to elf_check_arch. Why do we need to duplicate
> that code? You could use some pre-processor magic to make the core part of
> the functions agnostic to header type.

At the begging I think I should add elf_check_arch_64 just as elf_check_arch to
do complicated check.

But for ARM32, elf_check_arch_64 would not be used except for kdump. No programs
with elf64 header can be loaded into 32bit ARM kernel. So I think I can just check
the "e_machine", just as what other platform does. I think other checks is useless
for kdump.

> In fact, if elf_check_arch could handle both header types then the generic
> definition of vmcore_elf64_check_arch in include/linux/crash_dump.h would
> work out of the box.

As I mentioned, I afraid this will make the code hard to understand.( Sorry
for my former incorrect patch).

How about this patch?

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index f4b46d3..9424542 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -97,7 +97,7 @@ struct elf32_hdr;
 extern int elf_check_arch(const struct elf32_hdr *);
 #define elf_check_arch elf_check_arch

-#define vmcore_elf64_check_arch(x) (0)
+#define vmcore_elf64_check_arch(x) ((x)->e_machine == EM_ARM)

 extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define elf_read_implies_exec(ex,stk) arm_elf_read_implies_exec(&(ex), stk)


Thanks,
Liu Hua



> Will
> 
> .
> 


