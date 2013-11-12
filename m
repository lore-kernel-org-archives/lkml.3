Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3KLORe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:17:34 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:44619 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3KLORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:17:31 -0500
Message-ID: <52823877.60806@codethink.co.uk>
Date: Tue, 12 Nov 2013 14:17:27 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        =?ISO-8859-1?Q?M=E5ns_Rul?= =?ISO-8859-1?Q?lg=E5rd?= 
	<mans@mansr.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.10.1311092357090.2314@knanqh.ubzr> <528193A0.7050505@codeaurora.org> <alpine.LFD.2.10.1311120839310.9667@knanqh.ubzr> <20131112140436.GK16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131112140436.GK16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 14:04, Russell King - ARM Linux wrote:
> On Tue, Nov 12, 2013 at 09:01:16AM -0500, Nicolas Pitre wrote:
>> What about this patch which I think is currently your best option.  Note
>> it would need to use the facilities from asm/opcodes.h to make it endian
>> agnostic.
>>
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index 6a1b8a81b1..379cffe4ab 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -383,6 +383,34 @@ static void __init cpuid_init_hwcaps(void)
>>   		elf_hwcap |= HWCAP_IDIVT;
>>   	}
>>
>> +	/*
>> +	 * Patch our division routines with the corresponding opcode
>> +	 * if the hardware supports it.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_THUMB2_KERNEL) && (elf_hwcap & HWCAP_IDIVT)) {
>> +		extern char __aeabi_uidiv, __aeabi_idiv;
>> +		u16 *uidiv = (u16 *)&__aeabi_uidiv;
>> +		u16 *idiv = (u16 *)&__aeabi_idiv;
>> +
>> +		uidiv[0] = 0xfbb0;  /* udiv r0, r0, r1 */
>> +		uidiv[1] = 0xf0f1;
>> +		uidiv[2] = 0x4770;  /* bx lr */
>> +
>> +		idiv[0] = 0xfb90;  /* sdiv r0, r0, r1 */
>> +		idiv[1] = 0xf0f1;
>> +		idiv[2] = 0x4770;  /* bx lr */
>> +	} else if (!IS_ENABLED(CONFIG_THUMB2_KERNEL) && (elf_hwcap & HWCAP_IDIVA)) {
>> +		extern char __aeabi_uidiv, __aeabi_idiv;
>> +		u32 *uidiv = (u32 *)&__aeabi_uidiv;
>> +		u32 *idiv = (u32 *)&__aeabi_idiv;
>> +
>> +		uidiv[0] = 0xe730f110;  /* udiv r0, r0, r1 */
>> +		uidiv[1] = 0xe12fff1e;  /* bx lr */
>> +
>> +		idiv[0] = 0xe710f110;  /* sdiv r0, r0, r1 */
>> +		idiv[1] = 0xe12fff1e;  /* bx lr */
>> +	}
>
> What about endianness, and what if XIP is enabled?

I was also going to add a note about endian-ness.

Given these are single instructoins for ARM, is it possible we could
make a table of all the callers and fix them up when we initialise
as we do for the SMP/UP case and for page-offset?


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
