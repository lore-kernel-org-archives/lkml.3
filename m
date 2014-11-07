Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKGIAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:00:44 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:53506 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaKGIAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:00:39 -0500
Message-ID: <545C7C2E.3060109@c-s.fr>
Date: Fri, 07 Nov 2014 09:00:46 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v4,17/21] powerpc/8xx: set PTE bit 22 off TLBmiss
References: <20140919083609.A92871AB040@localhost.localdomain> <20141107033745.GA23796@home.buserror.net>
In-Reply-To: <20141107033745.GA23796@home.buserror.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 07/11/2014 04:37, Scott Wood a écrit :
> On Fri, Sep 19, 2014 at 10:36:09AM +0200, LEROY Christophe wrote:
>> No need to re-set this bit at each TLB miss. Let's set it in the PTE.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> ---
>> Changes in v2:
>> - None
>>
>> Changes in v3:
>> - Removed PPC405 related macro from PPC8xx specific code
>> - PTE_NONE_MASK doesn't need PAGE_ACCESSED in Linux 2.6
>>
>> Changes in v4:
>> - None
>>
>>   arch/powerpc/include/asm/pgtable-ppc32.h | 20 ++++++++++++++++++++
>>   arch/powerpc/include/asm/pte-8xx.h       |  7 +++++--
>>   arch/powerpc/kernel/head_8xx.S           | 10 ++--------
>>   3 files changed, 27 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
>> index 47edde8..35a9b44 100644
>> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
>> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
>> @@ -172,6 +172,25 @@ static inline unsigned long pte_update(pte_t *p,
>>   #ifdef PTE_ATOMIC_UPDATES
>>   	unsigned long old, tmp;
>>   
>> +#ifdef CONFIG_PPC_8xx
>> +	unsigned long tmp2;
>> +
>> +	__asm__ __volatile__("\
>> +1:	lwarx	%0,0,%4\n\
>> +	andc	%1,%0,%5\n\
>> +	or	%1,%1,%6\n\
>> +	/* 0x200 == Extended encoding, bit 22 */ \
>> +	/* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
>> +	rlwimi	%1,%1,32-2,0x200\n /* get _PAGE_USER */ \
>> +	rlwinm	%3,%1,32-1,0x200\n /* get _PAGE_RW */ \
>> +	or	%1,%3,%1\n\
>> +	xori	%1,%1,0x200\n"
>> +"	stwcx.	%1,0,%4\n\
>> +	bne-	1b"
> Why do you need this...
>
>> diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
>> index d44826e..daa4616 100644
>> --- a/arch/powerpc/include/asm/pte-8xx.h
>> +++ b/arch/powerpc/include/asm/pte-8xx.h
>> @@ -48,19 +48,22 @@
>>    */
>>   #define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
>>   #define _PAGE_USER	0x0800	/* msb PP bits */
>> +/* set when neither _PAGE_USER nor _PAGE_RW are set */
>> +#define _PAGE_KNLRO	0x0200
>>   
>>   #define _PMD_PRESENT	0x0001
>>   #define _PMD_BAD	0x0ff0
>>   #define _PMD_PAGE_MASK	0x000c
>>   #define _PMD_PAGE_8M	0x000c
>>   
>> -#define _PTE_NONE_MASK _PAGE_ACCESSED
>> +#define _PTE_NONE_MASK _PAGE_KNLRO
>>   
>>   /* Until my rework is finished, 8xx still needs atomic PTE updates */
>>   #define PTE_ATOMIC_UPDATES	1
>>   
>>   /* We need to add _PAGE_SHARED to kernel pages */
>> -#define _PAGE_KERNEL_RO	(_PAGE_SHARED)
>> +#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
>> +#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
>>   #define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
> ...if 0x200 is already being set in the PTE here?
>
If I understand well the way it works, those defines are used for 
setting the PTE the first time.
Then, pte_update() is used to modify the pte settings on an existing pte

0x200 must be set when and only when the page is a RO kernel page. If 
later on pte_update() is called for instance to set the page to RW, the 
0x200 has to be removed. Same, if pte_update() is called to remove 
_PAGE_RW (ptep_set_wrprotect() does this), 0x200 must be set back.

Christophe

