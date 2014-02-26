Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaBZOvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:51:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaBZOvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:51:21 -0500
Date: Wed, 26 Feb 2014 15:50:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com,
        mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com,
        heiko.carstens@de.ibm.com, hannes@cmpxchg.org,
        gerald.schaefer@de.ibm.com, ebiederm@xmission.com, aarcange@redhat.com,
        athorlton@sgi.com
Subject: Re: +
	mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch added
	to -mm tree
Message-ID: <20140226145025.GA12571@redhat.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530D9F50.1080400@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Christian Borntraeger wrote:
>
> On 26/02/14 00:53, akpm@linux-foundation.org wrote:
> > Subject: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch added to -mm tree
> > To: athorlton@sgi.com,aarcange@redhat.com,borntraeger@de.ibm.com,ebiederm@xmission.com,gerald.schaefer@de.ibm.com,hannes@cmpxchg.org,heiko.carstens@de.ibm.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,pbonzini@redhat.com,peterz@infradead.org,riel@redhat.com,rientjes@google.com,schwidefsky@de.ibm.com,viro@zeniv.linux.org.uk
> > From: akpm@linux-foundation.org
> > Date: Tue, 25 Feb 2014 15:53:13 -0800
> >
> >
> > The patch titled
> >      Subject: mm: revert "thp: make MADV_HUGEPAGE check for mm->def_flags"
> > has been added to the -mm tree.  Its filename is
> >      mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
> >
> > This patch should soon appear at
> >     http://ozlabs.org/~akpm/mmots/broken-out/mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
> > and later at
> >     http://ozlabs.org/~akpm/mmotm/broken-out/mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
>
>
> NAK.
>
> Since 2012 qemu does call "qemu_madvise(new_block->host, size, QEMU_MADV_HUGEPAGE);" for all kvm pages.
> (commit ad0b5321f1f797274603ebbe20108b0750baee94 Call MADV_HUGEPAGE for guest RAM allocations) so this
> breaks any recent kvm guest on s390.

Well, I can't really discuss the changes in arch/s390.

But perhaps qemu can be changed to avoid MADV_HUGEPAGE on s390 ?
Otherwise I'd suggest the change below.

Oleg.


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
@@ -1977,8 +1975,16 @@ int hugepage_madvise(struct vm_area_stru
 		 */
 		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
 			return -EINVAL;
-		if (mm->def_flags & VM_NOHUGEPAGE)
+
+/*
+ * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
+ * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
+ */
+#ifdef CONFIG_S390
+		if (vma->vm_mm->def_flags & VM_NOHUGEPAGE)
 			return -EINVAL;
+#endif
+
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*

