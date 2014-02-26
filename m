Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaBZPG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:06:56 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53748 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaBZPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:06:53 -0500
Message-ID: <530E0306.7020601@de.ibm.com>
Date: Wed, 26 Feb 2014 16:06:46 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com,
        mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com,
        heiko.carstens@de.ibm.com, hannes@cmpxchg.org,
        gerald.schaefer@de.ibm.com, ebiederm@xmission.com, aarcange@redhat.com,
        athorlton@sgi.com
Subject: Re: +	mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added	to -mm tree
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com>
In-Reply-To: <20140226145025.GA12571@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022615-3548-0000-0000-0000083893C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 15:50, Oleg Nesterov wrote:
[...]

>> NAK.
>>
>> Since 2012 qemu does call "qemu_madvise(new_block->host, size, QEMU_MADV_HUGEPAGE);" for all kvm pages.
>> (commit ad0b5321f1f797274603ebbe20108b0750baee94 Call MADV_HUGEPAGE for guest RAM allocations) so this
>> breaks any recent kvm guest on s390.
> 
> Well, I can't really discuss the changes in arch/s390.
> 
> But perhaps qemu can be changed to avoid MADV_HUGEPAGE on s390 ?
> Otherwise I'd suggest the change below.
> 
> Oleg.
> 
> 
> --- x/mm/huge_memory.c
> +++ x/mm/huge_memory.c
> @@ -1968,8 +1968,6 @@ out:
>  int hugepage_madvise(struct vm_area_struct *vma,
>  		     unsigned long *vm_flags, int advice)
>  {
> -	struct mm_struct *mm = vma->vm_mm;
> -
>  	switch (advice) {
>  	case MADV_HUGEPAGE:
>  		/*
> @@ -1977,8 +1975,16 @@ int hugepage_madvise(struct vm_area_stru
>  		 */
>  		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
>  			return -EINVAL;
> -		if (mm->def_flags & VM_NOHUGEPAGE)
> +
> +/*
> + * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
> + * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
> + */
> +#ifdef CONFIG_S390
> +		if (vma->vm_mm->def_flags & VM_NOHUGEPAGE)
>  			return -EINVAL;
> +#endif
> +

Ifdefs are ugly but might be the only way of not breaking existing userspace.
If we come up with a solution for THP in KVM host processes on s390, we can
then remove that wart. We could even limit that hack to KVM only processes
to retain Alex' prctl capability by checking mm_has_pgste (defined in
arch/s390/include/asm/pgtable.h should be included via linux/mm.h)

> +
> +/*
> + * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
> + * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
> + */
> +#ifdef CONFIG_S390
> +		if ((vma->vm_mm->def_flags & VM_NOHUGEPAGE) && mm_has_pgste(vma->vm_mm))
>  			return -EINVAL;
> +#endif
> +


