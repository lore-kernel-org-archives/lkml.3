Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaBZQ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:58:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52732 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBZQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:58:15 -0500
Date: Wed, 26 Feb 2014 17:57:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com,
        pbonzini@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com,
        aarcange@redhat.com, athorlton@sgi.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added to -mm tree
Message-ID: <20140226165759.GB22802@laptop.programming.kicks-ass.net>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org>
 <530D9F50.1080400@de.ibm.com>
 <20140226145025.GA12571@redhat.com>
 <530E0306.7020601@de.ibm.com>
 <20140226153144.GA15527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226153144.GA15527@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 04:31:44PM +0100, Oleg Nesterov wrote:
> --- x/arch/s390/mm/pgtable.c
> +++ x/arch/s390/mm/pgtable.c
> @@ -1084,7 +1084,6 @@ static inline void thp_split_mm(struct m
>  		vma->vm_flags &= ~VM_HUGEPAGE;
>  		vma->vm_flags |= VM_NOHUGEPAGE;
>  	}
> -	mm->def_flags |= VM_NOHUGEPAGE;
>  }
>  #else
>  static inline void thp_split_mm(struct mm_struct *mm)
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
> @@ -1977,8 +1975,12 @@ int hugepage_madvise(struct vm_area_stru
>  		 */
>  		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
>  			return -EINVAL;
> -		if (mm->def_flags & VM_NOHUGEPAGE)
> +
> +#ifdef CONFIG_S390

Do we want a comment here, explaining why s390 is special again?

> +		if (mm_has_pgste(vma->vm_mm))
>  			return -EINVAL;
> +#endif
> +
>  		*vm_flags &= ~VM_NOHUGEPAGE;
>  		*vm_flags |= VM_HUGEPAGE;
>  		/*
> 
