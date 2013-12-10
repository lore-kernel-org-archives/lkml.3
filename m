Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LJXFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:05:31 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:37095 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3LJXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:05:29 -0500
Message-ID: <52A79E31.9070304@c-s.fr>
Date: Wed, 11 Dec 2013 00:05:21 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc 8xx: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
References: <20131210112945.E4E311A2BF3@localhost.localdomain> <1386714253.10013.123.camel@snotra.buserror.net>
In-Reply-To: <1386714253.10013.123.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 10/12/2013 23:24, Scott Wood a écrit :
> On Tue, 2013-12-10 at 12:29 +0100, Christophe Leroy wrote:
>> Today, the only way to load kernels whose size is greater than 8Mbytes is to
>> activate CONFIG_PIN_TLB. Otherwise, the physical memory initially mapped is
>> limited to 8Mbytes. This patch adds the capability to select the size of initial
>> memory between 8/16/24 Mbytes and this is regardless of whether CONFIG_PIN_TLB
>> is active or not. It allows to load "big" kernels (for instance when activating
>> CONFIG_LOCKDEP_SUPPORT) without having to activate CONFIG_PIN_TLB.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> diff -ur a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -980,6 +980,29 @@
>>   config PIN_TLB
>>   	bool "Pinned Kernel TLBs (860 ONLY)"
>>   	depends on ADVANCED_OPTIONS && 8xx
>> +
>> +choice
>> +	prompt "Initial Data Memory Mapped on 8xx"
>> +	default 8xx_MAP_8M
>> +	depends on ADVANCED_OPTIONS && 8xx
>> +
>> +config	8xx_INIT_MAP_8M
>> +	bool "8 Mbytes"
>> +
>> +config	8xx_INIT_MAP_16M
>> +	bool "16 Mbytes"
>> +
>> +config	8xx_INIT_MAP_24M
>> +	bool "24 Mbytes"
> Are you working with a loader that passes initial-mapped-area size in r7
> as per ePAPR?  If so, we could rely on that at runtime.  If you're using
> a non-ancient U-Boot, it should qualify here even if it's not fully
> ePAPR compliant (it passes the value of the bootm_mapsize variable in
> r7).
Ok, let me check that. But it means that the size of the kernel I can 
boot will depend on the initial memory mapped by uboot ? Isn't it 
limitating ?
Even if uboot only maps 8Mbytes, why couldn't I be allowed to boot a 
kernel having 10 Mbytes data if I have 32 Mbytes mem on the board ?
I don't like the idea of having to change the bootloader just because I 
want to activate CONFIG_LOCKDEP to debug my kernel.
>
>> -#ifdef CONFIG_PIN_TLB
>> +#if defined (CONFIG_8xx_INIT_MAP_16M) || defined (CONFIG_8xx_INIT_MAP_24M)
>>   	/* Map two more 8M kernel data pages.
>>   	*/
>> +#ifdef CONFIG_PIN_TLB
>>   	addi	r10, r10, 0x0100
>>   	mtspr	SPRN_MD_CTR, r10
>> +#endif
>>   
>>   	lis	r8, KERNELBASE@h	/* Create vaddr for TLB */
>>   	addis	r8, r8, 0x0080		/* Add 8M */
>> @@ -858,15 +860,19 @@
>>   	addis	r11, r11, 0x0080	/* Add 8M */
>>   	mtspr	SPRN_MD_RPN, r11
>>   
>> +#ifdef CONFIG_8xx_INIT_MAP_24M
>> +#ifdef CONFIG_PIN_TLB
>>   	addi	r10, r10, 0x0100
>>   	mtspr	SPRN_MD_CTR, r10
>> +#endif
> Are these ifdefs for CONFIG_PIN_TLB really needed?  It shouldn't harm
> anything to use those entries even if they're not being pinned.

I'm not sure I understand your comment.
ifdef for CONFIG_PIN_TLB was already there before, but was enclosing the 
whole block, so 24 Mbytes were automatically mapped when you selected 
CONFIG_PIN_TLB and only 8 Mbytes were mapped when you didn't select 
CONFIG_PIN_TLB.
I reduced the scope of those ifdefs so that they now apply on the 
pinning only.

Christophe
