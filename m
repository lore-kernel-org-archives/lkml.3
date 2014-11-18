Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaKRQdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:33:41 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40105 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaKRQdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:33:38 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
In-Reply-To: <20141118160112.GC2725@suse.de>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de> <877fyugrmc.fsf@linux.vnet.ibm.com> <20141118160112.GC2725@suse.de>
User-Agent: Notmuch/0.18.2+162~g34d2c62 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 18 Nov 2014 22:03:30 +0530
Message-ID: <87y4r879k5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111816-4790-0000-0000-000005052D79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> On Mon, Nov 17, 2014 at 01:56:19PM +0530, Aneesh Kumar K.V wrote:
>> Mel Gorman <mgorman@suse.de> writes:
>> 
>> > This is follow up from the "pipe/page fault oddness" thread.
>> >
>> > Automatic NUMA balancing depends on being able to protect PTEs to trap a
>> > fault and gather reference locality information. Very broadly speaking it
>> > would mark PTEs as not present and use another bit to distinguish between
>> > NUMA hinting faults and other types of faults. It was universally loved
>> > by everybody and caused no problems whatsoever. That last sentence might
>> > be a lie.
>> >
>> > This series is very heavily based on patches from Linus and Aneesh to
>> > replace the existing PTE/PMD NUMA helper functions with normal change
>> > protections. I did alter and add parts of it but I consider them relatively
>> > minor contributions. Note that the signed-offs here need addressing. I
>> > couldn't use "From" or Signed-off-by from the original authors as the
>> > patches had to be broken up and they were never signed off. I expect the
>> > two people involved will just stick their signed-off-by on it.
>> 
>> 
>> How about the additional change listed below for ppc64 ? One part of the
>> patch is to make sure that we don't hit the WARN_ON in set_pte and set_pmd
>> because we find the _PAGE_PRESENT bit set in case of numa fault. I
>> ended up relaxing the check there.
>> 
>
> I folded the set_pte_at and set_pmd_at changes into the patch "mm: Convert
> p[te|md]_numa users to p[te|md]_protnone_numa" with one change -- both
> set_pte_at and set_pmd_at checks are under CONFIG_DEBUG_VM for consistency.
>
>> Second part of the change is to add a WARN_ON to make sure we are
>> not depending on DSISR_PROTFAULT for anything else. We ideally should not
>> get a DSISR_PROTFAULT for PROT_NONE or NUMA fault. hash_page_mm do check
>> whether the access is allowed by pte before inserting a pte into hash
>> page table. Hence we will never find a PROT_NONE or PROT_NONE_NUMA ptes
>> in hash page table. But it is good to run with VM_WARN_ON ?
>> 
>
> Due to the nature of the check and when they are hit, I converted it to
> a WARN_ON_ONCE. Due to the exceptional circumstance the overhead should
> be non-existant and shouldn't need to be hidden below VM_WARN_ON. I also
> noted that with the patch the kernel  potentially no longer recovers
> from this exceptional cirsumstance and instead falls through. To avoid
> this, I preserved the "goto out_unlock".
>
> Is this still ok?
>
> ---8<---
> ppc64: Add paranoid warnings for unexpected DSISR_PROTFAULT
>
> ppc64 should not be depending on DSISR_PROTFAULT and it's unexpected
> if they are triggered. This patch adds warnings just in case they
> are being accidentally depended upon.
>
> Requires-signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  arch/powerpc/mm/copro_fault.c |  7 ++++++-
>  arch/powerpc/mm/fault.c       | 20 +++++++++-----------
>  2 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
> index 5a236f0..46152aa 100644
> --- a/arch/powerpc/mm/copro_fault.c
> +++ b/arch/powerpc/mm/copro_fault.c
> @@ -64,7 +64,12 @@ int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
>  		if (!(vma->vm_flags & VM_WRITE))
>  			goto out_unlock;
>  	} else {
> -		if (dsisr & DSISR_PROTFAULT)
> +		/*
> +		 * protfault should only happen due to us
> +		 * mapping a region readonly temporarily. PROT_NONE
> +		 * is also covered by the VMA check above.
> +		 */
> +		if (WARN_ON_ONCE(dsisr & DSISR_PROTFAULT))
>  			goto out_unlock;
>  		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
>  			goto out_unlock;


we should do that DSISR_PROTFAILT check after vma->vm_flags. It is not
that we will not hit DSISR_PROTFAULT, what we want to ensure here is that
we get a prot fault only for cases convered by that vma check. So
everything should be taking the if (!(vma->vm_flags & (VM_READ |
VM_EXEC))) branch if it is a protfault. If not we would like to know
about that. And hence the idea of not using WARN_ON_ONCE. I was also not
sure whether we want to enable that always. The reason for keeping that
within CONFIG_DEBUG_VM is to make sure that nobody ends up depending on
PROTFAULT outside the vma check convered. So expectations is that
developers working on feature will run with DEBUG_VM enable and finds
this warning. We don't expect to hit this otherwise.

> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 5007497..9d6e0b3 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -396,17 +396,6 @@ good_area:
>  #endif /* CONFIG_8xx */
>
>  	if (is_exec) {
> -#ifdef CONFIG_PPC_STD_MMU
> -		/* Protection fault on exec go straight to failure on
> -		 * Hash based MMUs as they either don't support per-page
> -		 * execute permission, or if they do, it's handled already
> -		 * at the hash level. This test would probably have to
> -		 * be removed if we change the way this works to make hash
> -		 * processors use the same I/D cache coherency mechanism
> -		 * as embedded.
> -		 */
> -#endif /* CONFIG_PPC_STD_MMU */
> -
>  		/*
>  		 * Allow execution from readable areas if the MMU does not
>  		 * provide separate controls over reading and executing.
> @@ -421,6 +410,14 @@ good_area:
>  		    (cpu_has_feature(CPU_FTR_NOEXECUTE) ||
>  		     !(vma->vm_flags & (VM_READ | VM_WRITE))))
>  			goto bad_area;
> +#ifdef CONFIG_PPC_STD_MMU
> +		/*
> +		 * protfault should only happen due to us
> +		 * mapping a region readonly temporarily. PROT_NONE
> +		 * is also covered by the VMA check above.
> +		 */
> +		WARN_ON_ONCE(error_code & DSISR_PROTFAULT);
> +#endif /* CONFIG_PPC_STD_MMU */
>  	/* a write */
>  	} else if (is_write) {
>  		if (!(vma->vm_flags & VM_WRITE))
> @@ -430,6 +427,7 @@ good_area:
>  	} else {
>  		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
>  			goto bad_area;
> +		WARN_ON_ONCE(error_code & DSISR_PROTFAULT);
>  	}
>
>  	/*

