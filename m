Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbbAPQrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:47:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35601 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbAPQrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:47:03 -0500
Message-ID: <54B94084.7040609@arm.com>
Date: Fri, 16 Jan 2015 16:47:00 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "leo.yan@linaro.org" <leo.yan@linaro.org>,
        "yexl@marvell.com" <yexl@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm64: Consolidate hotplug notifier for instruction
 emulation
References: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com> <1421325366-13263-3-git-send-email-suzuki.poulose@arm.com> <20150116160730.GY7091@arm.com>
In-Reply-To: <20150116160730.GY7091@arm.com>
X-OriginalArrivalTime: 16 Jan 2015 16:47:01.0141 (UTC) FILETIME=[0CBA3450:01D031AC]
X-MC-Unique: 115011616470114201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/15 16:07, Will Deacon wrote:
> On Thu, Jan 15, 2015 at 12:36:05PM +0000, Suzuki K. Poulose wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>
>> As of now each insn_emulation has a cpu hotplug notifier that
>> enables/disables the CPU feature bit for the functionality. This
>> patch re-arranges the code, such that there is only one notifier
>> that runs through the list of registered emulation hooks and runs
>> their corresponding set_hw_mode.
>>
>> We do nothing when a CPU is dying as we will set the appropriate bits
>> as it comes back online based on the state of the hooks.
>>
>> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> ---
>>   Documentation/arm64/legacy_instructions.txt |    4 +
>>   arch/arm64/include/asm/cpufeature.h         |    2 +
>>   arch/arm64/kernel/armv8_deprecated.c        |  113 +++++++++++++++------------
>>   3 files changed, 69 insertions(+), 50 deletions(-)
>>
>> diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.txt
>> index a3b3da2..0a4dc26 100644
>> --- a/Documentation/arm64/legacy_instructions.txt
>> +++ b/Documentation/arm64/legacy_instructions.txt
>> @@ -27,6 +27,10 @@ behaviours and the corresponding values of the sysctl nodes -
>>     instructions. Using hardware execution generally provides better
>>     performance, but at the loss of ability to gather runtime statistics
>>     about the use of the deprecated instructions.
>> +  Note: Emulation of a deprecated instruction depends on the availability
>> +  of the feature on all the active CPUs. In case of CPU hotplug, if a new
>> +  CPU doesn't support a feature, it could result in the abortion of the
>> +  hotplug operation.
>
> Is this true? We should be able to *emulate* the instruction anywhere,
> it's the "hardware execution" setting that needs CPU support.
Yes. Particularly for SETEND, if the CPU doesn't support mixed endian 
data access at EL0, we shouldn't emulate setend and cause unexpected 
results at EL0. So it is upto the hook to raise a flag if it can emulate 
without the hardware capability.

>
>>   The default mode depends on the status of the instruction in the
>>   architecture. Deprecated instructions should default to emulation
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index c7f68d1..a56b45f 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -29,6 +29,8 @@
>>   #define ID_AA64MMFR0_EL1_BigEndEL0	(0x1UL << 16)
>>   #define ID_AA64MMFR0_EL1_BigEnd		(0x1UL << 8)
>>
>> +#define SCTLR_EL1_CP15BEN 	(1 << 5)
>> +
>>   #ifndef __ASSEMBLY__
>>
>>   extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
>> diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
>> index c363671..be64218 100644
>> --- a/arch/arm64/kernel/armv8_deprecated.c
>> +++ b/arch/arm64/kernel/armv8_deprecated.c
>> @@ -19,6 +19,7 @@
>>   #include <asm/system_misc.h>
>>   #include <asm/traps.h>
>>   #include <asm/uaccess.h>
>> +#include <asm/cpufeature.h>
>>
>>   #define CREATE_TRACE_POINTS
>>   #include "trace-events-emulation.h"
>> @@ -46,7 +47,7 @@ struct insn_emulation_ops {
>>   	const char		*name;
>>   	enum legacy_insn_status	status;
>>   	struct undef_hook	*hooks;
>> -	int			(*set_hw_mode)(bool enable);
>> +	int			(*set_hw_mode)(void *enable);
>
> I think it would be cleaner to have a wrapper for the on_each_cpu
> variant of this, otherwise we lose the type information altogether.
>
OK.
>>   };
>>
>>   struct insn_emulation {
>> @@ -85,6 +86,40 @@ static void remove_emulation_hooks(struct insn_emulation_ops *ops)
>>   	pr_notice("Removed %s emulation handler\n", ops->name);
>>   }
>>

>>
>> +static int insn_cpu_hotplug_notify(struct notifier_block *b,
>> +			      unsigned long action, void *hcpu)
>> +{
>> +	int rc = 0;
>> +	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
>> +		rc = run_all_insn_set_hw_mode();
>> +
>> +	/* Abort the CPU hotplug if there is an incompatibility */
>> +	return notifier_from_errno(rc);
>
> Could we restrict the emulation options instead and just disable hardware
> support for the instruction?

As explained earlier, each hook could decide if missing a feature could 
result in an abort.

Thanks
Suzuki


