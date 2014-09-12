Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaILReY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:34:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:49131 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaILReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:34:23 -0400
Date: Fri, 12 Sep 2014 19:34:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
In-Reply-To: <5413050A.1090307@intel.com>
Message-ID: <alpine.DEB.2.10.1409121812550.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos>
 <alpine.DEB.2.10.1409121120440.4178@nanos> <5413050A.1090307@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Dave Hansen wrote:
> On 09/12/2014 02:24 AM, Thomas Gleixner wrote:
> > On Fri, 12 Sep 2014, Thomas Gleixner wrote:
> >> On Thu, 11 Sep 2014, Dave Hansen wrote:
> >>> Well, we use it to figure out whether we _potentially_ need to tear down
> >>> an VM_MPX-flagged area.  There's no guarantee that there will be one.
> >>
> >> So what you are saying is, that if user space sets the pointer to NULL
> >> via the unregister prctl, kernel can safely ignore vmas which have the
> >> VM_MPX flag set. I really can't follow that logic.
> >>  
> >> 	mmap_mpx();
> >> 	prctl(enable mpx);
> >> 	do lots of crap which uses mpx;
> >> 	prctl(disable mpx);
> >>
> >> So after that point the previous use of MPX is irrelevant, just
> >> because we set a pointer to NULL? Does it just look like crap because
> >> I do not get the big picture how all of this is supposed to work?
> > 
> > do_bounds() will happily map new BTs no matter whether the prctl was
> > invoked or not. So what's the value of the prctl at all?
> 
> The behavior as it stands is wrong.  We should at least have the kernel
> refuse to map new BTs if the prctl() hasn't been issued.  We'll fix it up.
> 
> > The mapping is flagged VM_MPX. Why is this not sufficient?
> 
> The comment is confusing and only speaks to half of what the if() in
> question is doing.  We'll get a better comment in there.  But, for the
> sake of explaining it fully:
> 
> There are two mappings in play:
> 1. The mapping with the actual data, which userspace is munmap()ing or
>    brk()ing away, etc... (never tagged VM_MPX)

It's not tagged that way because it is mapped by user space. This is
the directory, right?

> 2. The mapping for the bounds table *backing* the data (is tagged with
>    VM_MPX)

That's the stuff, which gets magically allocated from do_bounds(). And
the reason you do that from the #BR is that user space would have to
allocate a gazillion of bound tables to make sure that every corner
case is covered. With the allocation from #BR you make that behaviour
dynamic and you just provide an empty "no bounds" table to make the
bound checker happy.

> The code ends up looking like this:
> 
> vm_munmap()
> {
> 	do_unmap(vma); // #1 above
> 	if (mm->bd_addr && !(vma->vm_flags & VM_MPX))
> 		// lookup the backing vma (#2 above)
> 		vm_munmap(vma2)
> }
> 
> The bd_addr check is intended to say "could the kernel have possibly
> created some VM_MPX vmas?"  As you noted above, we will happily go
> creating VM_MPX vmas without mm->bd_addr being set.  That's will get fixed.
> 
> The VM_MPX _flags_ check on the VMA is there simply to prevent
> recursion.  vm_munmap() of the VM_MPX vma is called _under_ vm_munmap()
> of the data VMA, and we've got to ensure it doesn't recurse.  *This*
> part of the if() in question is not addressed in the comment.  That's
> something we can fix up in the next version.

Ok, slowly I get the puzzle together :)

Now, the question is whether this magic fragile fixup is the right
thing to do in the context of unmap/brk.

So if the directory is unmapped, you want to free the bounds tables
which are referenced from the directory, i.e. those which you
allocated in do_bounds().
 
So you call arch_unmap() at the very end of do_unmap(). This walks the
directory to look at the entries and unmaps the bounds table which is
referenced from the directory and then clears the directory entry.

Now, I have a hard time to see how that is supposed to work.

do_unmap()
 detach_vmas_to_be_unmapped()
 unmap_region()
   free_pgtables()
 arch_unmap()
   mpx_unmap()

So at the point where you try to access the directory to gather the
information about the entries which might be affected, that stuff is
unmapped already and the page tables are gone.

Brilliant idea, really. And if you run into the fault in mpx_unmap()
you plan to delegate the fixup to a work queue. How is that thing
going to find what belonged to the unmapped directory?

Even if the stuff would be accessible at that point, it is a damned
stupid idea to rely on anything userspace is providing to you. I
learned that the hard way in futex.c

The proper solution to this problem is:

    do_bounds()
	bd_addr = get_bd_addr_from_xsave();
	bd_entry = bndstatus & ADDR_MASK:

	bt = mpx_mmap(bd_addr, bd_entry, len);

	set_bt_entry_in_bd(bd_entry, bt);

And in mpx_mmap()

       .....
       vma = find_vma();

       vma->bd_addr = bd_addr;
       vma->bd_entry = bd_entry;

Now on mpx_unmap()

    for_each_vma()
	if (is_affected(vma->bd_addr, vma->bd_entry))
 	   unmap(vma);

That does not require a prctl, no fault handling in the unmap path, it
just works and is robust by design because it does not rely on any
user space crappola. You store the directory context at allocation
time and free it when that context goes away. It's that simple, really.

So you can still think about a prctl in order to enable/disable the
automatic mapping stuff, but that's a completely different story.
   
Thanks,

	tglx
