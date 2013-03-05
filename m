Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3CEWDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:03:12 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3CEWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:03:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="27806070"
Message-ID: <51366B9E.7010502@codeaurora.org>
Date: Tue, 05 Mar 2013 14:03:10 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: proc: Add Krait proc info
References: <1362439299-29617-1-git-send-email-sboyd@codeaurora.org> <20130305083421.GA19391@mudshark.cambridge.arm.com>
In-Reply-To: <20130305083421.GA19391@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 00:34, Will Deacon wrote:
> Hi Stephen, Stepan,
>
> On Mon, Mar 04, 2013 at 11:21:39PM +0000, Stephen Boyd wrote:
>> From: Stepan Moskovchenko <stepanm@codeaurora.org>
>>
>> Add processor info for the Qualcomm, Inc. Krait family of
>> processors, to use the generic ARMv7 initialisation
>> procedure but explicitly enable the IDIV hardware
>> capability flag.
>>
>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/mm/proc-v7.S |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
>> index 3a3c015..81adeb3 100644
>> --- a/arch/arm/mm/proc-v7.S
>> +++ b/arch/arm/mm/proc-v7.S
>> @@ -434,6 +434,16 @@ __v7_ca15mp_proc_info:
>>  	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
>>  
>>  	/*
>> +	 * Qualcomm Inc. Krait processors.
>> +	 */
>> +	.type	__krait_proc_info, #object
>> +__krait_proc_info:
>> +	.long	0x510f0400		@ Required ID value
>> +	.long	0xff0ffc00		@ Mask for ID
>> +	__v7_proc __v7_setup, hwcaps = HWCAP_IDIV
> I was looking at this the other day and wondered whether we could set
> HWCAP_IDIV in __v7_setup, depending on ID_ISAR0[27:24]. I can't immediately
> think why that would be difficult, but similarly there may well be a reason
> why we assign it like this.
>
> Fancy taking a look?

Ok I'll take a look. Should we be masking out HWCAP_IDIVT on
!CONFIG_ARM_THUMB configurations?

----8<-----

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..e2c8bbf 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -484,7 +484,7 @@ static void __init setup_processor(void)
                 list->elf_name, ENDIANNESS);
        elf_hwcap = list->elf_hwcap;
 #ifndef CONFIG_ARM_THUMB
-       elf_hwcap &= ~HWCAP_THUMB;
+       elf_hwcap &= ~(HWCAP_THUMB | HWCAP_IDIVT);
 #endif
 
        feat_v6_fixup();

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

