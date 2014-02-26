Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBZPWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:22:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:2320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaBZPWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:22:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,548,1389772800"; 
   d="scan'208";a="482143528"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com,
        peterz@infradead.org, pbonzini@redhat.com, mingo@kernel.org,
        mgorman@suse.de, kirill.shutemov@linux.intel.com,
        heiko.carstens@de.ibm.com, hannes@cmpxchg.org,
        gerald.schaefer@de.ibm.com, ebiederm@xmission.com, aarcange@redhat.com,
        athorlton@sgi.com
In-Reply-To: <530E0306.7020601@de.ibm.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org>
 <530D9F50.1080400@de.ibm.com>
 <20140226145025.GA12571@redhat.com>
 <530E0306.7020601@de.ibm.com>
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added to -mm tree
Content-Transfer-Encoding: 7bit
Message-Id: <20140226152236.0757FE0098@blue.fi.intel.com>
Date: Wed, 26 Feb 2014 17:22:35 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> On 26/02/14 15:50, Oleg Nesterov wrote:
> [...]
> 
> >> NAK.
> >>
> >> Since 2012 qemu does call "qemu_madvise(new_block->host, size, QEMU_MADV_HUGEPAGE);" for all kvm pages.
> >> (commit ad0b5321f1f797274603ebbe20108b0750baee94 Call MADV_HUGEPAGE for guest RAM allocations) so this
> >> breaks any recent kvm guest on s390.
> > 
> > Well, I can't really discuss the changes in arch/s390.
> > 
> > But perhaps qemu can be changed to avoid MADV_HUGEPAGE on s390 ?
> > Otherwise I'd suggest the change below.
> > 
> > Oleg.
> > 
> > 
> > --- x/mm/huge_memory.c
> > +++ x/mm/huge_memory.c
> > @@ -1968,8 +1968,6 @@ out:
> >  int hugepage_madvise(struct vm_area_struct *vma,
> >  		     unsigned long *vm_flags, int advice)
> >  {
> > -	struct mm_struct *mm = vma->vm_mm;
> > -
> >  	switch (advice) {
> >  	case MADV_HUGEPAGE:
> >  		/*
> > @@ -1977,8 +1975,16 @@ int hugepage_madvise(struct vm_area_stru
> >  		 */
> >  		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
> >  			return -EINVAL;
> > -		if (mm->def_flags & VM_NOHUGEPAGE)
> > +
> > +/*
> > + * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
> > + * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
> > + */
> > +#ifdef CONFIG_S390
> > +		if (vma->vm_mm->def_flags & VM_NOHUGEPAGE)
> >  			return -EINVAL;
> > +#endif
> > +
> 
> Ifdefs are ugly

IS_ENABLED(CONFIG_S390) should help with this.

-- 
 Kirill A. Shutemov
