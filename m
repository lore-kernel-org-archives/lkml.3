Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaCDB0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:26:39 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:52700 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaCDB0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:26:37 -0500
Date: Tue, 4 Mar 2014 03:26:13 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
Message-ID: <20140304012613.GB21508@node.dhcp.inet.fi>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
 <20140303151611.5671eebb74cedb99aa5396c8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303151611.5671eebb74cedb99aa5396c8@linux-foundation.org>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:16:11PM -0800, Andrew Morton wrote:
> On Thu, 27 Feb 2014 21:53:46 +0200 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > The patch introduces new vm_ops callback ->map_pages() and uses it for
> > mapping easy accessible pages around fault address.
> > 
> > On read page fault, if filesystem provides ->map_pages(), we try to map
> > up to FAULT_AROUND_PAGES pages around page fault address in hope to
> > reduce number of minor page faults.
> > 
> > We call ->map_pages first and use ->fault() as fallback if page by the
> > offset is not ready to be mapped (cold page cache or something).
> >
> > ...
> >
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> >
> > ...
> >
> > @@ -571,6 +576,9 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
> >  		pte = pte_mkwrite(pte);
> >  	return pte;
> >  }
> > +
> > +void do_set_pte(struct vm_area_struct *vma, unsigned long address,
> > +		struct page *page, pte_t *pte, bool write, bool anon);
> >  #endif
> >  
> >  /*
> 
> lguest made a dubious naming decision:
> 
> drivers/lguest/page_tables.c:890: error: conflicting types for 'do_set_pte'
> include/linux/mm.h:593: note: previous declaration of 'do_set_pte' was here
> 
> I'll rename lguest's do_set_pte() to do_guest_set_pte() as a
> preparatory patch.

Thanks.

> btw, do_set_pte() could really do with some documentation.  It's not a
> trivial function and it does a lot of stuff.  It's exported to other
> compilation units and we should explain the what, the why and
> particularly the locking preconditions.

Like this?

>From f9be5307ed59ab65645377c1da03eaf4167bfcf2 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Tue, 4 Mar 2014 03:15:43 +0200
Subject: [PATCH] mm: documentaton for do_set_pte()

do_set_pte() now exported to other compilation unit. Let's document
interface.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/memory.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index e2d54e818c5b..6dc622b06915 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3319,7 +3319,21 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	return ret;
 }
 
-
+/**
+ * do_set_pte - setup new PTE entry for given page and add reverse page mapping.
+ *
+ * @vma: virtual memory area
+ * @address: user virtual address
+ * @page: page to map
+ * @pte: pointer to target page table entry
+ * @write: true, if new entry is writable
+ * @anon: true, if it's anonymous page
+ *
+ * Caller must hold page table lock relevant for @pte.
+ *
+ * Target users are page handler itself and implementations of
+ * vm_ops->map_pages.
+ */
 void do_set_pte(struct vm_area_struct *vma, unsigned long address,
 		struct page *page, pte_t *pte, bool write, bool anon)
 {
-- 
 Kirill A. Shutemov
