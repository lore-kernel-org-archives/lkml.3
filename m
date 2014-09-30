Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaI3S6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:58:03 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:63344 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaI3S6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140930182059.GA24431@redhat.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<20140930160510.GA15903@redhat.com>
	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
	<20140930162201.GC15903@redhat.com>
	<20140930164047.GA18354@redhat.com>
	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
	<20140930182059.GA24431@redhat.com>
Date: Tue, 30 Sep 2014 11:58:00 -0700
X-Google-Sender-Auth: WlpA60fgzg7oPVMERERXEuw7n0g
Message-ID: <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
>
> page_fault_kernel:    address=__per_cpu_end ip=copy_page_to_iter error_code=0x2

Interesting. "error_code" in particular. The value "2" means that the
CPU thinks that the page is not present (bit zero is clear).

(That "address" is useless - it's tried to turn a user address into a
kernel symbol, and the percpu symbols are zero-based, so it picks the
last of them. The "ip" is useless too, since it doesn't give the
offset)

So the CPU thinks it's a write to a not-present page, which means that
_PAGE_PRESENT bit is clear.

Now the *kernel* thinks a page is present not just if _PAGE_PRESENT is
set, but also if _PAGE_PROTNONE or _PAGE_NUMA are set. Sadly, your
trace is not very useful, because inlining has caused pretty much all
the cases to be in "handle_mm_fault()", so the trace doesn't really
tell which path this all takes.

But we can still do *some* analysis on the trace: do_wp_page()
shouldn't have been inlined, so it would have shown up in the trace if
it had been called. So I think we can be pretty confident that the
ptep_set_access_flags() we see is the one from handle_pte_fault().

And if that is the case, then we know that "pte_present()" is indeed
true as far a the kernel is concerned. So with _PAGE_PRESENT not being
set (based on the error code), we know that _PAGE_PROTNONE must be
set, otherwise we'd have triggered the pte_numa() check and exited
through do_numa_page().

So it smells like we have a PROT_NONE VM area (at least the paeg table
entries imply that). But "access_error()" should have flagged that (it
checks "vma->vm_flags & VM_WRITE"). How do we have a page table entry
marked _PAGE_PROTNONE, but VM_WRITE set in the vma?

Or, possibly, we have some confusion about the page tables themselves
(corruption, wrong %cr3 value, whatever), explaining why the CPU
thinks one thing, but our software page table walker thinks another.

I'm not seeing how this all happens. But I'm adding Kirill to the cc,
since he might see something I missed, and he touched some of this
code last ("tag, you're it").

Kirill: the thread is on lkml, but basically it boils down to the
second byte write in fault_in_pages_writeable() faulting forever,
despite handle_mm_fault() apparently thinking that everything is fine.

Also adding Hugh Dickins, just because the more people who know this
code that are involved, the better.

              Linus
