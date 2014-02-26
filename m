Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaBZT1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:27:45 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:54686 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaBZT1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:27:43 -0500
Message-ID: <530E4028.70903@de.ibm.com>
Date: Wed, 26 Feb 2014 20:27:36 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Alex Thorlton <athorlton@sgi.com>
CC: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com,
        pbonzini@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com,
        aarcange@redhat.com
Subject: Re: +	mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added	to -mm tree
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com> <530E0306.7020601@de.ibm.com> <20140226153144.GA15527@redhat.com> <20140226165759.GB22802@laptop.programming.kicks-ass.net> <20140226172253.GQ3041@sgi.com> <20140226180603.GA25644@redhat.com>
In-Reply-To: <20140226180603.GA25644@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022619-1948-0000-0000-000007F51FE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 19:06, Oleg Nesterov wrote:
> On 02/26, Alex Thorlton wrote:
>>
>> + * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
>> + * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
>> + */
>> +#ifdef CONFIG_S390
>> +               if (mm_has_pgste(vma->vm_mm))
>>                         return -EINVAL;
>> +#endif
> 
> The comment is not really right...
> 
> And personally I think that
> 
> 	@@ -504,6 +504,9 @@ static int gmap_connect_pgtable(unsigned long address, unsigned long segment,
> 		if (!pmd_present(*pmd) &&
> 		    __pte_alloc(mm, vma, pmd, vmaddr))
> 			return -ENOMEM;
> 	+       /* large pmds cannot yet be handled */
> 	+       if (pmd_large(*pmd))
> 	+               return -EFAULT;
> 
> change still makes sense, so that we can simply revert this s390-
> specific hack in hugepage_madvise().

Yes, it still makes sense to cover existing THPs here.


> I'd suggest the patch below on top of your changes, but I won't argue.
> 
> It would be nice to also change thp_split_mm() to not not play with
> mm->def_flags, but I am not sure if we can do this.
> 
> Oleg.
> ---
> 
> Subject: [PATCH] s390: make sure MADV_HUGEPAGE fails after s390_enable_sie()
> 
> As Christian pointed out, the recent 'Revert "thp: make MADV_HUGEPAGE
> check for mm->def_flags"' breaks qemu, it does QEMU_MADV_HUGEPAGE for
> all kvm pages but this doesn't work after s390_enable_sie/thp_split_mm.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Suggested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a4310a5..0e08d92 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1970,11 +1970,22 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  {
>  	switch (advice) {
>  	case MADV_HUGEPAGE:
> +#ifdef CONFIG_S390
> +		/*
> +		 * MADV_HUGEPAGE is broken after s390_enable_sie(), qemu
> +		 * blindly does madvise(MADV_HUGEPAGE) for for all kvm pages
> +		 * and expects it must fail on s390. Avoid a possible SIGSEGV
> +		 * until qemu is changed.

I prefer:
		 * until kvm/s390 can handle large pages in the host.

Otherwise qemu has to be changed again, if we get THP working for kvm.

> +		 */
> +		if (mm_has_pgste(vma->vm_mm))
> +			return -EINVAL;
> +#endif
>  		/*
>  		 * Be somewhat over-protective like KSM for now!
>  		 */
>  		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
>  			return -EINVAL;
> +

Unrelated white space?
>  		*vm_flags &= ~VM_NOHUGEPAGE;
>  		*vm_flags |= VM_HUGEPAGE;
>  		/*
> 



With the comment and white space change:

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks for the quick patch

