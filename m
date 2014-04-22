Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbaDVUSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:18:52 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34613 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaDVUSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:18:48 -0400
Date: Tue, 22 Apr 2014 13:17:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: 3.15rc2 hanging processes on exit.
In-Reply-To: <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
References: <20140422180308.GA19038@redhat.com> <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Linus Torvalds wrote:
> On Tue, Apr 22, 2014 at 11:03 AM, Dave Jones <davej@redhat.com> wrote:
> > I've got a test box that's running my fuzzer that is in an odd state.
> > The processes are about to end, but they don't seem to be making any
> > progress.  They've been spinning in the same state for a few hours now..
> >
> > perf top -a is showing a lot of time is being spent in page_fault and bad_gs
> >
> > there's a large trace file here from the function tracer:
> > http://codemonkey.org.uk/junk/trace.out
> 
> The trace says that it's one of the infinite loops that do
> 
>  - cmpxchg_futex_value_locked() fails
>  - we do fault_in_user_writeable(FAULT_FLAG_WRITE) and that succeeds
>  - so we try again
> 
> So it implies that handle_mm_fault() returned without VM_FAULT_ERROR,
> but the page still isn't actually writable.
> 
> And to me that smells like (vm_flags & VM_WRITE) isn't set. We'll
> fault in the page all right, but the resulting page table entry still
> isn't writable.
> 
> Are you testing anything new? Or is this strictly new to 3.15? The
> only thing in this area we do differently is commit cda540ace6a1 ("mm:
> get_user_pages(write,force) refuse to COW in shared areas"), but
> fault_in_user_writeable() never used the force bit afaik. Adding Hugh
> just in case.
> 
> So I think we should make fault_in_user_writeable() just check the
> vm_flags. Something like the attached (UNTESTED!) patch.
> 
> Guys? Comments?

Your patch looks to me correct and to the point; but I agree that
we haven't made a relevant change there recently, so I suppose it
comes from a trinity improvement rather than a new bug in 3.15.

(Dave, do you have time to confirm that by running new trinity on 3.14?)

One nit: we're inconsistent, and shall never move VM_READ,VM_WRITE bits,
but it would set a better example to declare "vm_flags_t vm_flags"
in your patch below, instead of "unsigned vm_flags".

Hugh
---

 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index d0f0bef3be48..91a3e848745d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1955,12 +1955,17 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long address, unsigned int fault_flags)
 {
 	struct vm_area_struct *vma;
+	unsigned vm_flags;
 	int ret;
 
 	vma = find_extend_vma(mm, address);
 	if (!vma || address < vma->vm_start)
 		return -EFAULT;
 
+	vm_flags = (fault_flags & FAULT_FLAG_WRITE) ? VM_WRITE : VM_READ;
+	if (!(vm_flags & vma->vm_flags))
+		return -EFAULT;
+
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
