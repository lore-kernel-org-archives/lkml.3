Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207Ab3JPRLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:11:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64118 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761134Ab3JPRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:11:52 -0400
Message-ID: <525EC8D1.7000900@gmail.com>
Date: Thu, 17 Oct 2013 01:11:45 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] arm64, jump label: optimize jump label implementation
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com> <1381893492-7135-7-git-send-email-liuj97@gmail.com> <20131016114608.GH5403@mudshark.cambridge.arm.com>
In-Reply-To: <20131016114608.GH5403@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 07:46 PM, Will Deacon wrote:
> On Wed, Oct 16, 2013 at 04:18:11AM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Optimize jump label implementation for ARM64 by dynamically patching
>> kernel text.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/arm64/Kconfig                  |  1 +
>>  arch/arm64/include/asm/jump_label.h | 52 ++++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/Makefile          |  1 +
>>  arch/arm64/kernel/jump_label.c      | 60 +++++++++++++++++++++++++++++++++++++
>>  4 files changed, 114 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/jump_label.h
>>  create mode 100644 arch/arm64/kernel/jump_label.c
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index c044548..da388e4 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -17,6 +17,7 @@ config ARM64
>>  	select GENERIC_SMP_IDLE_THREAD
>>  	select GENERIC_TIME_VSYSCALL
>>  	select HARDIRQS_SW_RESEND
>> +	select HAVE_ARCH_JUMP_LABEL
>>  	select HAVE_ARCH_TRACEHOOK
>>  	select HAVE_DEBUG_BUGVERBOSE
>>  	select HAVE_DEBUG_KMEMLEAK
>> diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
>> new file mode 100644
>> index 0000000..d268fab
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/jump_label.h
>> @@ -0,0 +1,52 @@
>> +/*
>> + * Copyright (C) 2013 Huawei Ltd.
>> + * Author: Jiang Liu <jiang.liu@huawei.com>
>> + *
>> + * Based on arch/arm/include/asm/jump_label.h
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +#ifndef _ASM_ARM64_JUMP_LABEL_H
>> +#define _ASM_ARM64_JUMP_LABEL_H
>> +#include <linux/types.h>
>> +
>> +#ifdef __KERNEL__
>> +
>> +#define JUMP_LABEL_NOP_SIZE 4
>> +
>> +static __always_inline bool arch_static_branch(struct static_key *key)
>> +{
>> +	asm goto("1:\n\t"
>> +		 "nop\n\t"
>> +		 ".pushsection __jump_table,  \"aw\"\n\t"
>> +		 ".align 3\n\t"
>> +		 ".quad 1b, %l[l_yes], %c0\n\t"
>> +		 ".popsection\n\t"
>> +		 :  :  "i"(key) :  : l_yes);
>> +
>> +	return false;
>> +l_yes:
>> +	return true;
>> +}
>> +
>> +#endif /* __KERNEL__ */
>> +
>> +typedef u64 jump_label_t;
>> +
>> +struct jump_entry {
>> +	jump_label_t code;
>> +	jump_label_t target;
>> +	jump_label_t key;
>> +};
>> +
>> +#endif	/* _ASM_ARM64_JUMP_LABEL_H */
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index 9af6cb3..b7db65e 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o smp_psci.o
>>  arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
>>  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
>>  arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
>> +arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
>>  
>>  obj-y					+= $(arm64-obj-y) vdso/
>>  obj-m					+= $(arm64-obj-m)
>> diff --git a/arch/arm64/kernel/jump_label.c b/arch/arm64/kernel/jump_label.c
>> new file mode 100644
>> index 0000000..74cbc73
>> --- /dev/null
>> +++ b/arch/arm64/kernel/jump_label.c
>> @@ -0,0 +1,60 @@
>> +/*
>> + * Copyright (C) 2013 Huawei Ltd.
>> + * Author: Jiang Liu <jiang.liu@huawei.com>
>> + *
>> + * Based on arch/arm/kernel/jump_label.c
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/jump_label.h>
>> +#include <asm/jump_label.h>
>> +#include <asm/insn.h>
>> +
>> +#ifdef HAVE_JUMP_LABEL
>> +
>> +static void __arch_jump_label_transform(struct jump_entry *entry,
>> +					enum jump_label_type type,
>> +					bool is_static)
>> +{
>> +	void *addr = (void *)entry->code;
>> +	u32 insn;
>> +
>> +	if (type == JUMP_LABEL_ENABLE) {
>> +		/* no way out if instruction offset is out of range(+/-128M) */
>> +		insn = aarch64_insn_gen_branch_imm(entry->code,
>> +						   entry->target, 0);
>> +		BUG_ON(!insn);
> 
> In this case, rather than BUG_ON, it would be better (somehow) to abort
> optimisation and instead patch in a branch to the actual condition check.
Hi Will,
	The ARM64 virtual address arrangement already ensures that all
kernel and module texts are within +/-128M, otherwise even module load
will fail. So the BUG_ON() should never happen.

Will add more comments into aarch64_insn_gen_branch_imm().

> 
>> +	} else {
>> +		insn = aarch64_insn_gen_nop();
> 
> You could make the code more concise by limiting your patching ability to
> branch immediates. Then a nop is simply a branch to the next instruction (I
> doubt any modern CPUs will choke on this, whereas the architecture requires
> a NOP to take time).
I guess a NOP should be more effecient than a "B #4" on real CPUs:)

> 
> Will
> 

