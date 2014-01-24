Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaAXOTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:19:23 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55937 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaAXOTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:19:21 -0500
Date: Fri, 24 Jan 2014 15:19:08 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/2] mm: thp: kill the bogus ->def_flags check in
 hugepage_madvise()
Message-ID: <20140124151908.7ef2c0ce@vbox-ubuntu>
In-Reply-To: <20140123164334.GA7097@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
	<13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
	<20140118234957.GB10970@node.dhcp.inet.fi>
	<20140120195812.GD18196@sgi.com>
	<20140120201525.GA31416@redhat.com>
	<20140120204108.GE18196@sgi.com>
	<20140122174553.GA29710@redhat.com>
	<20140122174646.GC29710@redhat.com>
	<alpine.LSU.2.11.1401221209520.1541@eggly.anvils>
	<20140123164334.GA7097@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012414-1948-0000-0000-00000792985A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 17:43:34 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/22, Hugh Dickins wrote:
> >
> > On Wed, 22 Jan 2014, Oleg Nesterov wrote:
> >
> > > hugepage_madvise() checks "mm->def_flags & VM_NOHUGEPAGE" but
> > > this can be never true, currently mm->def_flags can only have
> > > VM_LOCKED.
> >
> > But line 1087 of arch/s390/mm/pgtable.c says
> > 	mm->def_flags |= VM_NOHUGEPAGE;
> > from 3eabaee998c787e7e1565574821652548f7fc003
> > "KVM: s390: allow sie enablement for multi-threaded programs".
> 
> Argh. Thanks Hugh!
> 
> Another case when I forgot about /bin/grep. So the patch is wrong,
> at least the changelog is certainly is. I am stupid.
> 
> But, perhaps, this all still can work? Looks like, s390 already
> implements PR_SET_THP_DISABLE using the same idea, it would be
> nice to avoid another hack.
> 
> Gerald, any chance we can revert 8e72033f2a489 "thp: make
> MADV_HUGEPAGE check for mm->def_flags" ? The changelog says "In order
> to also prevent MADV_HUGEPAGE on such an mm", is it really important?
> I mean, if the application calls madvise(MADV_HUGEPAGE) it should
> probably know what it does and, this can be useful after if
> PR_SET_THP_DISABLE or KVM_S390_ENABLE_SIE. Of course I do not
> understand this code, perhaps MADV_HUGEPAGE is simply impossible.

Yes, after discussion with Martin, I think that commit 8e72033f2a489 can
be reverted if we add a small add-on patch to the s390 gmap code instead,
like this:

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 3584ed9..a87cdb4 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -504,6 +504,9 @@ static int gmap_connect_pgtable(unsigned long address, unsigned long segment,
        if (!pmd_present(*pmd) &&
            __pte_alloc(mm, vma, pmd, vmaddr))
                return -ENOMEM;
+       /* large pmds cannot yet be handled */
+       if (pmd_large(*pmd))
+               return -EFAULT;
        /* pmd now points to a valid segment table entry. */
        rmap = kmalloc(sizeof(*rmap), GFP_KERNEL|__GFP_REPEAT);
        if (!rmap)

