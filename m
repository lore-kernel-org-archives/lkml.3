Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaLRHLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:11:31 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:57308 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbaLRHL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:11:28 -0500
Message-ID: <54927E1E.1030407@c-s.fr>
Date: Thu, 18 Dec 2014 08:11:26 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [v2 PATCH 1/2] powerpc32: adds handling of _PAGE_RO
References: <20141217091431.D3F761A5E0D@localhost.localdomain> <1418868868.5581.121.camel@freescale.com>
In-Reply-To: <1418868868.5581.121.camel@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 18/12/2014 03:14, Scott Wood a écrit :
> On Wed, 2014-12-17 at 10:14 +0100, Christophe Leroy wrote:
>> Some powerpc like the 8xx don't have a RW bit in PTE bits but a RO (Read Only) bit.
>> This patch implements the handling of a _PAGE_RO flag to be used in place of _PAGE_RW
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> ---
>> v2 is a complete rework compared to v1
>>
>>   arch/powerpc/include/asm/pgtable-ppc32.h | 11 ++++++-----
>>   arch/powerpc/include/asm/pgtable.h       | 10 +++++++---
>>   arch/powerpc/include/asm/pte-common.h    | 27 ++++++++++++++++++---------
>>   arch/powerpc/mm/gup.c                    |  2 ++
>>   arch/powerpc/mm/mem.c                    |  2 +-
>>   arch/powerpc/mm/pgtable_32.c             | 24 ++++++++++++++++++++----
>>   6 files changed, 54 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
>> index 543bb8e..64ed9e1 100644
>> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
>> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
>> @@ -125,7 +125,7 @@ extern int icache_44x_need_flush;
>>   #ifndef __ASSEMBLY__
>>   
>>   #define pte_clear(mm, addr, ptep) \
>> -	do { pte_update(ptep, ~_PAGE_HASHPTE, 0); } while (0)
>> +	do { pte_update(ptep, ~_PAGE_HASHPTE, _PAGE_RO); } while (0)
> Is this really necessary?  It's already clearing the valid bit.
>
> Likewise in several other places that set or check for _PAGE_RO on pages
> for which no access is permitted.
>
>> @@ -287,8 +287,9 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
>>   static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
>>   {
>>   	unsigned long bits = pte_val(entry) &
>> -		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
>> -	pte_update(ptep, 0, bits);
>> +		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_RO |
>> +		 _PAGE_EXEC);
>> +	pte_update(ptep, _PAGE_RO, bits);
>>   }
> You're unconditionally clearing _PAGE_RO, and apparently relying on the
> undocumented behavior of pte_update() to clear "clr" before setting
> "set".
>
> Instead I'd write this as:
>
> 	unsigned long set = pte_val(entry) &
> 		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
> 	unsigned long clr = pte_val(entry) & _PAGE_RO;
Don't you mean ?

	unsigned long clr = ~pte_val(entry) & _PAGE_RO;

Because, we want to clear _PAGE_RO when _PAGE_RO is not set in entry.

Christophe

>
> 	pte_update(ptep, clr, set);
>
> -Scott
>

