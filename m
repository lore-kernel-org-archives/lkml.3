Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaCEUCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:02:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaCEUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:02:45 -0500
Date: Wed, 5 Mar 2014 12:02:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
Message-Id: <20140305120243.5b69dfe64d66f5cc7afe66e2@linux-foundation.org>
In-Reply-To: <8761nt1pfk.fsf@rustcorp.com.au>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
	<20140303151611.5671eebb74cedb99aa5396c8@linux-foundation.org>
	<8761nt1pfk.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 10:34:15 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> > On Thu, 27 Feb 2014 21:53:46 +0200 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> >> +
> >> +void do_set_pte(struct vm_area_struct *vma, unsigned long address,
> >> +		struct page *page, pte_t *pte, bool write, bool anon);
> >>  #endif
> >>  
> >>  /*
> >
> > lguest made a dubious naming decision:
> >
> > drivers/lguest/page_tables.c:890: error: conflicting types for 'do_set_pte'
> > include/linux/mm.h:593: note: previous declaration of 'do_set_pte' was here
> >
> > I'll rename lguest's do_set_pte() to do_guest_set_pte() as a
> > preparatory patch.
> 
> s/do_/ if you don't mind; if we're going to prefix it, we don't need the
> extra verb.

drivers/lguest/page_tables.c already has a guest_set_pte(), which calls
do_guest_set_pte().

How about we use the __ tradition, so __guest_set_pte() is a helper for
guest_set_pte()?


--- a/drivers/lguest/page_tables.c~drivers-lguest-page_tablesc-rename-do_set_pte
+++ a/drivers/lguest/page_tables.c
@@ -887,7 +887,7 @@ void guest_new_pagetable(struct lg_cpu *
  * _PAGE_ACCESSED then we can put a read-only PTE entry in immediately, and if
  * they set _PAGE_DIRTY then we can put a writable PTE entry in immediately.
  */
-static void do_set_pte(struct lg_cpu *cpu, int idx,
+static void __guest_set_pte(struct lg_cpu *cpu, int idx,
 		       unsigned long vaddr, pte_t gpte)
 {
 	/* Look up the matching shadow page directory entry. */
@@ -960,13 +960,13 @@ void guest_set_pte(struct lg_cpu *cpu,
 		unsigned int i;
 		for (i = 0; i < ARRAY_SIZE(cpu->lg->pgdirs); i++)
 			if (cpu->lg->pgdirs[i].pgdir)
-				do_set_pte(cpu, i, vaddr, gpte);
+				__guest_set_pte(cpu, i, vaddr, gpte);
 	} else {
 		/* Is this page table one we have a shadow for? */
 		int pgdir = find_pgdir(cpu->lg, gpgdir);
 		if (pgdir != ARRAY_SIZE(cpu->lg->pgdirs))
 			/* If so, do the update. */
-			do_set_pte(cpu, pgdir, vaddr, gpte);
+			__guest_set_pte(cpu, pgdir, vaddr, gpte);
 	}
 }
 
_

