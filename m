Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3JVVMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:12:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33270 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JVVMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:12:45 -0400
Date: Tue, 22 Oct 2013 23:12:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131022211237.GH2490@laptop.programming.kicks-ass.net>
References: <20131016205227.GJ7456@tassilo.jf.intel.com>
 <20131016210319.GI10651@twins.programming.kicks-ass.net>
 <20131016230712.GC26785@twins.programming.kicks-ass.net>
 <20131017094145.GE3364@laptop.programming.kicks-ass.net>
 <20131017160034.GO227855@redhat.com>
 <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017220156.GB10651@twins.programming.kicks-ass.net>
 <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 03:27:48PM -0700, Linus Torvalds wrote:
> On Thu, Oct 17, 2013 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Oh wait,.. now that Steven fixed being able to take faults from NMI
> > context; we could actually try copy_from_user_inatomic(). Being able to
> > directly access userspace would make the whole deal a lot easier again.
> 
> Careful! There is one magic piece of state that you need to
> save-and-restore if you do this, namely %cr2. Taking a page fault
> always writes to %cr2, and we must *not* corrupt it in the NMI
> handler.

It looks like this is already dealt with (a similar thing is done for
i386).

---
commit 7fbb98c5cb07563d3ee08714073a8e5452a96be2
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jun 7 10:21:21 2012 -0400

    x86: Save cr2 in NMI in case NMIs take a page fault
    
    Avi Kivity reported that page faults in NMIs could cause havic if
    the NMI preempted another page fault handler:
    
       The recent changes to NMI allow exceptions to take place in NMI
       handlers, but I think that a #PF (say, due to access to vmalloc space)
       is still problematic.  Consider the sequence
    
        #PF  (cr2 set by processor)
          NMI
            ...
            #PF (cr2 clobbered)
              do_page_fault()
              IRET
            ...
            IRET
          do_page_fault()
            address = read_cr2()
    
       The last line reads the overwritten cr2 value.
    
    Originally I wrote a patch to solve this by saving the cr2 on the stack.
    Brian Gerst suggested to save it in the r12 register as both r12 and rbx
    are saved by the do_nmi handler as required by the C standard. But rbx
    is already used for saving if swapgs needs to be run on exit of the NMI
    handler.
    
    Link: http://lkml.kernel.org/r/4FBB8C40.6080304@redhat.com
    Link: http://lkml.kernel.org/r/1337763411.13348.140.camel@gandalf.stny.rr.com
    
    Reported-by: Avi Kivity <avi@redhat.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Suggested-by: Brian Gerst <brgerst@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7d65133..111f6bb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1758,10 +1758,30 @@ ENTRY(nmi)
 	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
+
+	/*
+	 * Save off the CR2 register. If we take a page fault in the NMI then
+	 * it could corrupt the CR2 value. If the NMI preempts a page fault
+	 * handler before it was able to read the CR2 register, and then the
+	 * NMI itself takes a page fault, the page fault that was preempted
+	 * will read the information from the NMI page fault and not the
+	 * origin fault. Save it off and restore it if it changes.
+	 * Use the r12 callee-saved register.
+	 */
+	movq %cr2, %r12
+
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
+
+	/* Did the NMI take a page fault? Restore cr2 if it did */
+	movq %cr2, %rcx
+	cmpq %rcx, %r12
+	je 1f
+	movq %r12, %cr2
+1:
+	
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
 nmi_swapgs:
