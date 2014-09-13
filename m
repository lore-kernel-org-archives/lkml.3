Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaIMJB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:01:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:52284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaIMJBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:01:54 -0400
Date: Sat, 13 Sep 2014 11:01:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
In-Reply-To: <5413552A.1020907@intel.com>
Message-ID: <alpine.DEB.2.10.1409122222130.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos>
 <alpine.DEB.2.10.1409121120440.4178@nanos> <5413050A.1090307@intel.com> <alpine.DEB.2.10.1409121812550.4178@nanos> <5413552A.1020907@intel.com>
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
> On 09/12/2014 10:34 AM, Thomas Gleixner wrote:
> > On Fri, 12 Sep 2014, Dave Hansen wrote:
> >> There are two mappings in play:
> >> 1. The mapping with the actual data, which userspace is munmap()ing or
> >>    brk()ing away, etc... (never tagged VM_MPX)
> > 
> > It's not tagged that way because it is mapped by user space.
> 
> Correct.  It is not tagged because it is mapped by user space.
> 
> > This is the directory, right?
> 
> No.  The untagged mapping in question here is for normal user data, like
> an mmap() or brk(), unrelated to MPX.

Ok. That makes sense.
 
> The directory is a separate matter.  It is also (currently) untagged
> with VM_MPX since it is also allocated by userspace.

So if that gets unmapped my observation holds. You still try to access
the directory, take the fault, queue work and in the work you dont
know how to handle it either.

So if the unmapped region affects bd_addr then we should just release
the affected BT mappings, i.e. all vmas flagged with VMA_MPX.

> > With the allocation from #BR you make that behaviour
> > dynamic and you just provide an empty "no bounds" table to make the
> > bound checker happy.
> 
> Kinda.  We do provide an empty table, but the first access will always
> be a write, so it doesn't stay empty for long.

So this comes from adding an entry to a not yet mapped table not from
an actual bound check? I still need to digest the details in the
manual.

> The bounds directory is not being unmapped here.  I _think_ I covered
> that above, but don't be shy if I'm not being clear. ;)

Fair enough. My confusion.
 
> If the bounds directory moved around, this would make sense.  Otherwise,
> it's a waste of space because all vmas in a given mm would have the
> exact same bd_addr, and we might as well just store it in mm->bd_something.

Ok. But we really want to do some sanity checking on all of this.
 
> Are you suggesting that we support moving the bounds directory around?

No, but the stupid thing CAN move around and we want to think about it
now instead of figuring out what to do about it later.

So if we go and store bd_addr with the prctl then you can do in the
#BR "Invalid BD entry":

    bd_addr = xsave->xsave_buf->bndcsr.cfg_reg_u;
    
    /*
     * Catch the case that this is not enabled, i.e. mm->bd_addr == 0,
     * and the case that stupid user space moved the directory
     * around.
     */
    if (mm->bd_addr != bd_addr) {
       Yell and whack stupid app over the head;
    }

> Also, the bd_entry can be _calculated_ from vma->vm_start and the
> bd_addr.  It seems a bit redundant to store it like this.

Fair enough.

> If you are talking about the VM_MPX VMA that was allocated to hold the
> bounds table, this won't work.

Sorry yes, that only works for unmapping the bound directory itself.

> Once we unmap the bounds table, we would have a bounds directory entry
> pointing at empty address space.  That address space could now be
> allocated for some other (random) use, and the MPX hardware is now going
> to go trying to walk it as if it were a bounds table.  That would be bad.
> 
> Any unmapping of a bounds table has to be accompanied by a corresponding
> write to the bounds directory entry.  That write to the bounds directory
> can fault.

So if it fails you need to keep the bound table around until you can
handle that somewhere else, i.e. outside of the mmap sem held
region. That's what you are planning to do with the work queue thing.

Now I'm asking myself, whether we are forced to do that from the end
of do_unmap() rather than doing it from the call site outside of the
mmap_sem held region. I can see that adding arch_unmap() to do_unmap()
is a very simple solution, but it comes with the price of dealing with
faults inside of the mmap_sem held region.

It might be worthwhile to think about the following:

   down_write(mmap_sem);
   
   do_stuff()
     do_munmap(mm, start, len)
        ...
        arch_munmap(mm, start, len) {
	  if (!mm->bd_addr)
	     return;
	  bt_work = kmalloc(sizeof(struct bt_work));
	  bt_work->start = start;
	  bt_work->len = len;
	  hlist_add(&bt_work->list, &mm->bt_work_head);
        } 

And then instead of up_write(mmap_sem);

    arch_up_write(mmap_sem);

Which by default is mapped to up_write(mmap_sem);

Now for the MPX case you can do:
{
	HLIST_HEAD(bt_work_head);

	hlist_move_list(&mm->bt_work_head, &bt_work_head);
	up_write(mmap_sem);

	hlist_for_each_entry_safe()
		handle_bt_work();
}
          
So that needs a few more changes vs. the up_write(mmap_sem) at the
callsites of do_munmap(), but we might even make that a generic thing,
i.e. replace up_write(mmap_sem) with release_write(mmap_sem). I can
imagine that we have other use cases for this.

Thoughts?

	tglx
