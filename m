Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaILUS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:18:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:30399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbaILUS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:18:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="scan'208";a="572471885"
Message-ID: <5413552A.1020907@intel.com>
Date: Fri, 12 Sep 2014 13:18:50 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos> <alpine.DEB.2.10.1409121120440.4178@nanos> <5413050A.1090307@intel.com> <alpine.DEB.2.10.1409121812550.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121812550.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 10:34 AM, Thomas Gleixner wrote:
> On Fri, 12 Sep 2014, Dave Hansen wrote:
>> There are two mappings in play:
>> 1. The mapping with the actual data, which userspace is munmap()ing or
>>    brk()ing away, etc... (never tagged VM_MPX)
> 
> It's not tagged that way because it is mapped by user space.

Correct.  It is not tagged because it is mapped by user space.

> This is the directory, right?

No.  The untagged mapping in question here is for normal user data, like
an mmap() or brk(), unrelated to MPX.

The directory is a separate matter.  It is also (currently) untagged
with VM_MPX since it is also allocated by userspace.

>> 2. The mapping for the bounds table *backing* the data (is tagged with
>>    VM_MPX)
> 
> That's the stuff, which gets magically allocated from do_bounds(). And
> the reason you do that from the #BR is that user space would have to
> allocate a gazillion of bound tables to make sure that every corner
> case is covered.

Yes.

> With the allocation from #BR you make that behaviour
> dynamic and you just provide an empty "no bounds" table to make the
> bound checker happy.

Kinda.  We do provide an empty table, but the first access will always
be a write, so it doesn't stay empty for long.

...
> Now, I have a hard time to see how that is supposed to work.
> 
> do_unmap()
>  detach_vmas_to_be_unmapped()
>  unmap_region()
>    free_pgtables()
>  arch_unmap()
>    mpx_unmap()
> 
> So at the point where you try to access the directory to gather the
> information about the entries which might be affected, that stuff is
> unmapped already and the page tables are gone.
> 
> Brilliant idea, really. And if you run into the fault in mpx_unmap()
> you plan to delegate the fixup to a work queue. How is that thing
> going to find what belonged to the unmapped directory?

The bounds directory is not being unmapped here.  I _think_ I covered
that above, but don't be shy if I'm not being clear. ;)

> Even if the stuff would be accessible at that point, it is a damned
> stupid idea to rely on anything userspace is providing to you. I
> learned that the hard way in futex.c
> 
> The proper solution to this problem is:
> 
>     do_bounds()
> 	bd_addr = get_bd_addr_from_xsave();
> 	bd_entry = bndstatus & ADDR_MASK:
> 
> 	bt = mpx_mmap(bd_addr, bd_entry, len);
> 
> 	set_bt_entry_in_bd(bd_entry, bt);
> 
> And in mpx_mmap()
> 
>        .....
>        vma = find_vma();
> 
>        vma->bd_addr = bd_addr;
>        vma->bd_entry = bd_entry;

If the bounds directory moved around, this would make sense.  Otherwise,
it's a waste of space because all vmas in a given mm would have the
exact same bd_addr, and we might as well just store it in mm->bd_something.

Are you suggesting that we support moving the bounds directory around?

Also, the bd_entry can be _calculated_ from vma->vm_start and the
bd_addr.  It seems a bit redundant to store it like this.

Also this would add 16 bytes to the currently 184-byte VMA.  That seems
suboptimal to me.  It would eat over a megabyte of memory on my *laptop*
alone.

> Now on mpx_unmap()
> 
>     for_each_vma()
> 	if (is_affected(vma->bd_addr, vma->bd_entry))
>  	   unmap(vma);
> 
> That does not require a prctl, no fault handling in the unmap path, it
> just works and is robust by design because it does not rely on any
> user space crappola. You store the directory context at allocation
> time and free it when that context goes away. It's that simple, really.

If you are talking about the VM_MPX VMA that was allocated to hold the
bounds table, this won't work.

Once we unmap the bounds table, we would have a bounds directory entry
pointing at empty address space.  That address space could now be
allocated for some other (random) use, and the MPX hardware is now going
to go trying to walk it as if it were a bounds table.  That would be bad.

Any unmapping of a bounds table has to be accompanied by a corresponding
write to the bounds directory entry.  That write to the bounds directory
can fault.



