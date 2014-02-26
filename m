Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaBZRWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:22:53 -0500
Received: from relay3.sgi.com ([192.48.152.1]:54483 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752435AbaBZRWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:22:52 -0500
Date: Wed, 26 Feb 2014 11:22:53 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, pbonzini@redhat.com, mingo@kernel.org,
        mgorman@suse.de, kirill.shutemov@linux.intel.com,
        heiko.carstens@de.ibm.com, hannes@cmpxchg.org,
        gerald.schaefer@de.ibm.com, ebiederm@xmission.com, aarcange@redhat.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added to -mm tree
Message-ID: <20140226172253.GQ3041@sgi.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org>
 <530D9F50.1080400@de.ibm.com>
 <20140226145025.GA12571@redhat.com>
 <530E0306.7020601@de.ibm.com>
 <20140226153144.GA15527@redhat.com>
 <20140226165759.GB22802@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226165759.GB22802@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:57:59PM +0100, Peter Zijlstra wrote:
> On Wed, Feb 26, 2014 at 04:31:44PM +0100, Oleg Nesterov wrote:
> Do we want a comment here, explaining why s390 is special again?

Here's what I've got, with everybody's suggestions spun together:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 82166bf..7f01491 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1968,8 +1968,6 @@ out:
 int hugepage_madvise(struct vm_area_struct *vma,
                     unsigned long *vm_flags, int advice)
 {
-       struct mm_struct *mm = vma->vm_mm;
-
        switch (advice) {
        case MADV_HUGEPAGE:
                /*
@@ -1977,8 +1975,16 @@ int hugepage_madvise(struct vm_area_struct *vma,
                 */
                if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
                        return -EINVAL;
-               if (mm->def_flags & VM_NOHUGEPAGE)
+
+/*
+ * MADV_HUGEPAGE after PRCTL_THP_DISABLE is broken on s390 because
+ * qemu blindly does madvise(MADV_HUGEPAGE) after s390_enable_sie().
+ */
+#ifdef CONFIG_S390
+               if (mm_has_pgste(vma->vm_mm))
                        return -EINVAL;
+#endif
+
                *vm_flags &= ~VM_NOHUGEPAGE;
                *vm_flags |= VM_HUGEPAGE;
                /*

I've compiled and tested and it works ok on my machines (I don't have an
s390 to test on though :).  Is everybody okay with this solution?

BTW, Kirill, I looked at using IS_ENABLED to clean up the ifdef, but it
won't work here, since mm_has_pgste isn't defined unless CONFIG_S390
is defined.  i.e.: This line:

if (IS_ENABLED(CONFIG_S390) && mm_has_pgste(vma->vm_mm))

won't compile.
