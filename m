Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaJXIyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:54:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJXIys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:54:48 -0400
Date: Fri, 24 Oct 2014 10:54:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 09/11] pvqspinlock, x86: Add para-virtualization
 support
Message-ID: <20141024085437.GV21513@worktop.programming.kicks-ass.net>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
 <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:10:38PM -0400, Waiman Long wrote:

> Since enabling paravirt spinlock will disable unlock function inlining,
> a jump label can be added to the unlock function without adding patch
> sites all over the kernel.

But you don't have to. My patches allowed for the inline to remain,
again reducing the overhead of enabling PV spinlocks while running on a
real machine.

Look at: 

  http://lkml.kernel.org/r/20140615130154.213923590@chello.nl

In particular this hunk:

Index: linux-2.6/arch/x86/kernel/paravirt_patch_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt_patch_64.c
+++ linux-2.6/arch/x86/kernel/paravirt_patch_64.c
@@ -22,6 +22,10 @@ DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs")
 DEF_NATIVE(, mov32, "mov %edi, %eax");
 DEF_NATIVE(, mov64, "mov %rdi, %rax");

+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_QUEUE_SPINLOCK)
+DEF_NATIVE(pv_lock_ops, queue_unlock, "movb $0, (%rdi)");
+#endif
+ 
 unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
 {
        return paravirt_patch_insns(insnbuf, len,
@@ -61,6 +65,9 @@ unsigned native_patch(u8 type, u16 clobb
                PATCH_SITE(pv_cpu_ops, clts);
                PATCH_SITE(pv_mmu_ops, flush_tlb_single);
                PATCH_SITE(pv_cpu_ops, wbinvd);
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_QUEUE_SPINLOCK)
+               PATCH_SITE(pv_lock_ops, queue_unlock);
+#endif

        patch_site:
                ret = paravirt_patch_insns(ibuf, len, start, end);


That makes sure to overwrite the callee-saved call to the
pv_lock_ops::queue_unlock with the immediate asm "movb $0, (%rdi)".


Therefore you can retain the inlined unlock with hardly (there might be
some NOP padding) any overhead at all. On PV it reverts to a callee
saved function call.
