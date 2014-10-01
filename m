Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJAIUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:20:52 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46023 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAIUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:20:49 -0400
Date: Wed, 1 Oct 2014 01:19:00 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: pipe/page fault oddness.
In-Reply-To: <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
References: <20140930033327.GA14558@redhat.com> <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com> <20140930043309.GA16196@redhat.com> <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com> <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
 <20140930160510.GA15903@redhat.com> <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com> <20140930162201.GC15903@redhat.com> <20140930164047.GA18354@redhat.com> <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
 <20140930182059.GA24431@redhat.com> <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Linus Torvalds wrote:
> On Tue, Sep 30, 2014 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
> >
> > page_fault_kernel:    address=__per_cpu_end ip=copy_page_to_iter error_code=0x2
> 
> Interesting. "error_code" in particular. The value "2" means that the
> CPU thinks that the page is not present (bit zero is clear).
> 
> (That "address" is useless - it's tried to turn a user address into a
> kernel symbol, and the percpu symbols are zero-based, so it picks the
> last of them. The "ip" is useless too, since it doesn't give the
> offset)
> 
> So the CPU thinks it's a write to a not-present page, which means that
> _PAGE_PRESENT bit is clear.
> 
> Now the *kernel* thinks a page is present not just if _PAGE_PRESENT is
> set, but also if _PAGE_PROTNONE or _PAGE_NUMA are set. Sadly, your
> trace is not very useful, because inlining has caused pretty much all
> the cases to be in "handle_mm_fault()", so the trace doesn't really
> tell which path this all takes.
> 
> But we can still do *some* analysis on the trace: do_wp_page()
> shouldn't have been inlined, so it would have shown up in the trace if
> it had been called. So I think we can be pretty confident that the
> ptep_set_access_flags() we see is the one from handle_pte_fault().
> 
> And if that is the case, then we know that "pte_present()" is indeed
> true as far a the kernel is concerned. So with _PAGE_PRESENT not being
> set (based on the error code), we know that _PAGE_PROTNONE must be
> set, otherwise we'd have triggered the pte_numa() check and exited
> through do_numa_page().
> 
> So it smells like we have a PROT_NONE VM area (at least the paeg table
> entries imply that). But "access_error()" should have flagged that (it
> checks "vma->vm_flags & VM_WRITE"). How do we have a page table entry
> marked _PAGE_PROTNONE, but VM_WRITE set in the vma?
> 
> Or, possibly, we have some confusion about the page tables themselves
> (corruption, wrong %cr3 value, whatever), explaining why the CPU
> thinks one thing, but our software page table walker thinks another.
> 
> I'm not seeing how this all happens. But I'm adding Kirill to the cc,
> since he might see something I missed, and he touched some of this
> code last ("tag, you're it").
> 
> Kirill: the thread is on lkml, but basically it boils down to the
> second byte write in fault_in_pages_writeable() faulting forever,
> despite handle_mm_fault() apparently thinking that everything is fine.
> 
> Also adding Hugh Dickins, just because the more people who know this
> code that are involved, the better.

I've tried, but failed to explain it.

I think it's likely related to the VM_BUG_ON(!(val & _PAGE_PRESENT))
which linux-next has in pte_mknuma(), which Sasha Levin first reported
hitting in https://lkml.org/lkml/2014/8/26/869 (a resumption of the
"mm: BUG in unmap_page_range" thread, though its subject bug is fixed).

Mel and I gave it a lot of thought, but that too remains unexplained.
Sasha could reproduce it fairly easily on linux-next, but could not
reproduce it on 3.17-rc4 (plus the VM_BUG_ON); maybe Dave is doing
something different enough to get it on 3.17-rc7.

I say they're likely related because both could be explained if
there's some way in which a PROTNONE pte can get left behind after
the vma has been mprotected back from PROT_NONE to read-writable.
But we cannot see how (even when racing with page migration).

Irrelevance follows...

There *appears* to be a risk of hitting the VM_BUG_ON, or with no
VM_BUG_ON (as in 3.17-rc) pte_mknuma proceeding to add _PAGE_NUMA
to _PAGE_PROTNONE - making the pte then fail the pte_numa test,
but pass the pte_special test, hence fail the vm_normal_page test:
when coming from change_prot_numa serving MPOL_MF_LAZY for mbind.

However, that would still not explain Dave's endless refaulting;
though I was reminded to send you a patch to fix it, except that
when I came to test the fix, I could not produce the problem, and
eventually discovered a720094ded8c ("mm: mempolicy: Hide MPOL_NOOP
and MPOL_MF_LAZY from userspace for now") - that call to
change_prot_numa is still just dead code, so we're still safe from
its use on PROT_NONE areas (which task_numa_work carefully avoids).

Some time wasted on that, but I learnt a valuable debugging technique:
#undef EINVAL
#define EINVAL __LINE__

Hugh
