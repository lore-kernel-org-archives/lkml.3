Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaJWIJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:09:55 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50125 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaJWIJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:09:29 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve Capper <steve.capper@linaro.org>,
        Andrea Arcangeli <aarcange@redhat.com>, benh@kernel.crashing.org,
        mpe@ellerman.id.au, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 1/2] mm: Update generic gup implementation to handle hugepage directory
In-Reply-To: <20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org>
References: <1413520687-31729-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-unknown-linux-gnu)
Date: Thu, 23 Oct 2014 13:38:30 +0530
Message-ID: <87r3xzgqdd.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102308-0009-0000-0000-0000007FDF89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 17 Oct 2014 10:08:06 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>
>> Update generic gup implementation with powerpc specific details.
>> On powerpc at pmd level we can have hugepte, normal pmd pointer
>> or a pointer to the hugepage directory.
>> 
>> ...
>>
>> --- a/arch/arm/include/asm/pgtable.h
>> +++ b/arch/arm/include/asm/pgtable.h
>> @@ -181,6 +181,8 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>>  /* to find an entry in a kernel page-table-directory */
>>  #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
>>  
>> +#define pgd_huge(pgd)		(0)
>> +
>>  #define pmd_none(pmd)		(!pmd_val(pmd))
>>  #define pmd_present(pmd)	(pmd_val(pmd))
>>  
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index cefd3e825612..ed8f42497ac4 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -464,6 +464,8 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
>>  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>>  extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
>>  
>> +#define pgd_huge(pgd)		(0)
>> +
>
> So only arm, arm64 and powerpc implement CONFIG_HAVE_GENERIC_RCU_GUP
> and only powerpc impements pgd_huge().
>
> Could we get a bit of documentation in place for pgd_huge() so that
> people who aren't familiar with powerpc can understand what's going
> on?


I ended up moving that to include/linux/hugetlb.h with the below
comments added. Let me know if the below is ok 

/*
 * hugepages at page global directory. If arch support
 * hugepages at pgd level, they need to define this.
 */
#ifndef pgd_huge
#define pgd_huge(x)	0
#endif

#ifndef is_hugepd
/*
 * Some architectures requires a hugepage directory format that is
 * required to support multiple hugepage sizes. For example
 * a4fe3ce7699bfe1bd88f816b55d42d8fe1dac655 introduced the same
 * on powerpc. This allows for a more flexible hugepage pagetable
 * layout.
 */
typedef struct { unsigned long pd; } hugepd_t;
#define is_hugepd(hugepd) (0)
#define __hugepd(x) ((hugepd_t) { (x) })
static inline int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
			      unsigned pdshift, unsigned long end,
			      int write, struct page **pages, int *nr)
{
	return 0;
}
#else
extern int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
		       unsigned pdshift, unsigned long end,
		       int write, struct page **pages, int *nr);
#endif


-aneesh

