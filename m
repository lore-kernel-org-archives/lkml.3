Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBZQR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:17:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaBZQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:17:25 -0500
Date: Wed, 26 Feb 2014 16:31:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com,
        mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com,
        heiko.carstens@de.ibm.com, hannes@cmpxchg.org,
        gerald.schaefer@de.ibm.com, ebiederm@xmission.com, aarcange@redhat.com,
        athorlton@sgi.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
	added to -mm tree
Message-ID: <20140226153144.GA15527@redhat.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com> <530E0306.7020601@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E0306.7020601@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Christian Borntraeger wrote:
>
> On 26/02/14 15:50, Oleg Nesterov wrote:
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
> Ifdefs are ugly but might be the only way of not breaking existing userspace.

Yes, agreed. but note that this code is already s390-specific, nobody
else puts VM_NOHUGEPAGE into ->def_flags (until this series of course).

> If we come up with a solution for THP in KVM host processes on s390, we can
> then remove that wart. We could even limit that hack to KVM only processes
> to retain Alex' prctl capability by checking mm_has_pgste

Yes, yes, I looked at mm->context.has_pgste too ;) But I wasn't sure
we can rely on it. Thanks.

> > +/*
> > + * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
> > + * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
> > + */
> > +#ifdef CONFIG_S390
> > +		if ((vma->vm_mm->def_flags & VM_NOHUGEPAGE) && mm_has_pgste(vma->vm_mm))
> >  			return -EINVAL;

Hmm... but why do we need to check VM_NOHUGEPAGE then? Can't the
change below work?

Oleg.

--- x/arch/s390/mm/pgtable.c
+++ x/arch/s390/mm/pgtable.c
@@ -1084,7 +1084,6 @@ static inline void thp_split_mm(struct m
 		vma->vm_flags &= ~VM_HUGEPAGE;
 		vma->vm_flags |= VM_NOHUGEPAGE;
 	}
-	mm->def_flags |= VM_NOHUGEPAGE;
 }
 #else
 static inline void thp_split_mm(struct mm_struct *mm)
--- x/mm/huge_memory.c
+++ x/mm/huge_memory.c
@@ -1968,8 +1968,6 @@ out:
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
 {
-	struct mm_struct *mm = vma->vm_mm;
-
 	switch (advice) {
 	case MADV_HUGEPAGE:
 		/*
@@ -1977,8 +1975,12 @@ int hugepage_madvise(struct vm_area_stru
 		 */
 		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
 			return -EINVAL;
-		if (mm->def_flags & VM_NOHUGEPAGE)
+
+#ifdef CONFIG_S390
+		if (mm_has_pgste(vma->vm_mm))
 			return -EINVAL;
+#endif
+
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*

