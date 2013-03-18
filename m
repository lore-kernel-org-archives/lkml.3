Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3CRRNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:13:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19573 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3CRRNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:13:17 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="30600725"
Message-ID: <51474B2C.6030508@codeaurora.org>
Date: Mon, 18 Mar 2013 10:13:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 2/3] ARM: Detect support for SDIV/UDIV from ISAR0 register
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org> <1363138321-27849-3-git-send-email-sboyd@codeaurora.org> <20130317143624.GE19071@mudshark.cambridge.arm.com>
In-Reply-To: <20130317143624.GE19071@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/13 07:36, Will Deacon wrote:
> On Wed, Mar 13, 2013 at 01:32:00AM +0000, Stephen Boyd wrote:
>> The ISAR0 register indicates support for the SDIV and UDIV
>> instructions in both the Thumb and ARM instruction set. Read the
>> register to detect the supported instructions and update the
>> elf_hwcap mask as appropriate. This is better than adding more
>> and more cpuid checks in proc-v7.S for each new cpu variant that
>> supports these instructions.
>>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/kernel/setup.c | 20 ++++++++++++++++++++
>>  arch/arm/mm/proc-v7.S   |  4 ++--
>>  2 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index e2c8bbf..bd27a70 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -353,6 +353,23 @@ void __init early_print(const char *str, ...)
>>  	printk("%s", buf);
>>  }
>>  
>> +static void __init idiv_setup(void)
>> +{
>> +	unsigned int divide_instrs;
>> +
>> +	if (cpu_architecture() < CPU_ARCH_ARMv7)
>> +		return;
>> +
>> +	divide_instrs = (read_cpuid_ext(CPUID_EXT_ISAR0) & 0x0f000000) >> 24;
>> +
>> +	switch (divide_instrs) {
>> +	case 2:
>> +		elf_hwcap |= HWCAP_IDIVA;
>> +	case 1:
>> +		elf_hwcap |= HWCAP_IDIVT;
>> +	}
>> +}
>> +
>>  static void __init feat_v6_fixup(void)
>>  {
>>  	int id = read_cpuid_id();
>> @@ -483,6 +500,9 @@ static void __init setup_processor(void)
>>  	snprintf(elf_platform, ELF_PLATFORM_SIZE, "%s%c",
>>  		 list->elf_name, ENDIANNESS);
>>  	elf_hwcap = list->elf_hwcap;
>> +
>> +	idiv_setup();
> Perhaps give this a more generic name (cpuid_init_hwcaps) so we can add more
> probing later on (we could probe swp, for example).

No problem. Thanks for the review.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

