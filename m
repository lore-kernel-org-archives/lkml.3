Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3JALEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:04:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59319 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3JALEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:04:02 -0400
Date: Tue, 1 Oct 2013 13:03:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "#3.9.." <stable@vger.kernel.org>, Paul Mackerras <paulus@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL v2] irq fix for 3.12-rc
Message-ID: <20131001110355.GA24825@localhost.localdomain>
References: <1380552959-9396-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFy5YJkchyfCjbCKLGQMo34wcba9AVr2JMNPXZa5vKNT3g@mail.gmail.com>
 <20130930165059.GA9889@localhost.localdomain>
 <20131001065516.GA19718@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001065516.GA19718@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 08:55:16AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Sep 30, 2013 at 09:07:19AM -0700, Linus Torvalds wrote:
> > > On Mon, Sep 30, 2013 at 7:55 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > ...
> > > >     the chances for a stack overrun as reported in powerpc for example:
> > > >
> > > >     [ 1002.364577] do_IRQ: stack overflow: 1920
> > > >     [ 1002.364653] CPU: 0 PID: 1602 Comm: qemu-system-ppc Not tainted 3.10.4-300.1.fc19.ppc64p7 #1
> > > >     [ 1002.364734] Call Trace:
> > > >     [ 1002.364770] [c0000000050a8740] [c0000000000157c0] .show_stack+0x130/0x200 (unreliable)
> > > >     [ 1002.364872] [c0000000050a8810] [c00000000082f6d0] .dump_stack+0x28/0x3c
> > > >     [ 1002.364955] [c0000000050a8880] [c000000000010b98] .do_IRQ+0x2b8/0x2c0
> > > >     [ 1002.365039] [c0000000050a8930] [c0000000000026d4] hardware_interrupt_common+0x154/0x180
> > > >     [ 1002.365148] --- Exception: 501 at .cp_start_xmit+0x3a4/0x820 [8139cp]
> > > >     [ 1002.365148]     LR = .cp_start_xmit+0x390/0x820 [8139cp]
> > > >     [ 1002.365359] [c0000000050a8d40] [c0000000006d7f14] .dev_hard_start_xmit+0x394/0x640
> > > >  ...
> > > 
> > > Btw, I'd really wish people edited things like this when putting them
> > > in the commit logs. I try to do it when I get them (usually though
> > > Andrew's patch-bombs), just because there's just a ton of detail there
> > > that just isn't relevant for the actual issue at hand.
> > > 
> > > The kernel oops messages try to contain all kinds of possibly-relevant
> > > data, which makes them useful for a wide range of situations ("oh, it
> > > looks like a single-bit flip"), but at the same time means that once
> > > you know what the problem is, 90% of the data printed out is just pure
> > > noise and at that point no longer helpful, but just makes it harder to
> > > see what's actually the issue.
> > > 
> > > So please, after you've analyzed an oops, don't use the raw oops data
> > > any more. Usually what remains relevant is the actual oops message
> > > itself, and the backtrace.I try to generally edit out the hex
> > > representation of the symbol information, and obviously stale entries
> > > from the backtrace. I'm not consistent, see for example commit
> > > 6f6b8951897e (register info remains) vs commit d6394b590029 (mainly
> > > just call trace) vs commit 3e6b11df2451 (where I just truncated it
> > > mercilessly). And no, I don't always clean things up (it can be a
> > > bother), but I generally try, so now I'm just trying to spread the
> > > word..
> > > 
> > > Because at some point the excess verbiage really goes from "that's
> > > useful" to being a blob of noise that actually takes away from the
> > > message.
> > 
> > Yeah, I did such things sporadically before. Well, it summed up to 
> > simply remove the timestamps from backtraces but yeah, then I've become 
> > less patient about that and now I simply paste the raw thing.
> > 
> > I'll take care of that and prune these things on my future patches.
> 
> Mind fixing your commit log in this tree? The raw oops really dominates 
> the changelog unnecessarily.

Ok so I made a new branch that cleans that up by removing the printk time
column and the ip column that were all irrelevant.

I onlt kept the stack pointer value column, which I think is still very useful
because it shows we deal with the same stack throughout the whole call trace.

And of course the functions symbols.

Here is the new changelog below. The new pullable branch is irq/urgent-v2

HEAD: ded797547548a5b8e7b92383a41e4c0e6b0ecb7f

Thanks.

---

commit ded797547548a5b8e7b92383a41e4c0e6b0ecb7f
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Tue Sep 24 00:50:25 2013 +0200

    irq: Force hardirq exit's softirq processing on its own stack
    
    The commit facd8b80c67a3cf64a467c4a2ac5fb31f2e6745b
    ("irq: Sanitize invoke_softirq") converted irq exit
    calls of do_softirq() to __do_softirq() on all architectures,
    assuming it was only used there for its irq disablement
    properties.
    
    But as a side effect, the softirqs processed in the end
    of the hardirq are always called on the inline current
    stack that is used by irq_exit() instead of the softirq
    stack provided by the archs that override do_softirq().
    
    The result is mostly safe if the architecture runs irq_exit()
    on a separate irq stack because then softirqs are processed
    on that same stack that is near empty at this stage (assuming
    hardirq aren't nesting).
    
    Otherwise irq_exit() runs in the task stack and so does the softirq
    too. The interrupted call stack can be randomly deep already and
    the softirq can dig through it even further. To add insult to the
    injury, this softirq can be interrupted by a new hardirq, maximizing
    the chances for a stack overrun as reported in powerpc for example:
    
    	do_IRQ: stack overflow: 1920
    	CPU: 0 PID: 1602 Comm: qemu-system-ppc Not tainted 3.10.4-300.1.fc19.ppc64p7 #1
    	Call Trace:
    	[c0000000050a8740] .show_stack+0x130/0x200 (unreliable)
    	[c0000000050a8810] .dump_stack+0x28/0x3c
    	[c0000000050a8880] .do_IRQ+0x2b8/0x2c0
    	[c0000000050a8930] hardware_interrupt_common+0x154/0x180
    	--- Exception: 501 at .cp_start_xmit+0x3a4/0x820 [8139cp]
    		LR = .cp_start_xmit+0x390/0x820 [8139cp]
    	[c0000000050a8d40] .dev_hard_start_xmit+0x394/0x640
    	[c0000000050a8e00] .sch_direct_xmit+0x110/0x260
    	[c0000000050a8ea0] .dev_queue_xmit+0x260/0x630
    	[c0000000050a8f40] .br_dev_queue_push_xmit+0xc4/0x130 [bridge]
    	[c0000000050a8fc0] .br_dev_xmit+0x198/0x270 [bridge]
    	[c0000000050a9070] .dev_hard_start_xmit+0x394/0x640
    	[c0000000050a9130] .dev_queue_xmit+0x428/0x630
    	[c0000000050a91d0] .ip_finish_output+0x2a4/0x550
    	[c0000000050a9290] .ip_local_out+0x50/0x70
    	[c0000000050a9310] .ip_queue_xmit+0x148/0x420
    	[c0000000050a93b0] .tcp_transmit_skb+0x4e4/0xaf0
    	[c0000000050a94a0] .__tcp_ack_snd_check+0x7c/0xf0
    	[c0000000050a9520] .tcp_rcv_established+0x1e8/0x930
    	[c0000000050a95f0] .tcp_v4_do_rcv+0x21c/0x570
    	[c0000000050a96c0] .tcp_v4_rcv+0x734/0x930
    	[c0000000050a97a0] .ip_local_deliver_finish+0x184/0x360
    	[c0000000050a9840] .ip_rcv_finish+0x148/0x400
    	[c0000000050a98d0] .__netif_receive_skb_core+0x4f8/0xb00
    	[c0000000050a99d0] .netif_receive_skb+0x44/0x110
    	[c0000000050a9a70] .br_handle_frame_finish+0x2bc/0x3f0 [bridge]
    	[c0000000050a9b20] .br_nf_pre_routing_finish+0x2ac/0x420 [bridge]
    	[c0000000050a9bd0] .br_nf_pre_routing+0x4dc/0x7d0 [bridge]
    	[c0000000050a9c70] .nf_iterate+0x114/0x130
    	[c0000000050a9d30] .nf_hook_slow+0xb4/0x1e0
    	[c0000000050a9e00] .br_handle_frame+0x290/0x330 [bridge]
    	[c0000000050a9ea0] .__netif_receive_skb_core+0x34c/0xb00
    	[c0000000050a9fa0] .netif_receive_skb+0x44/0x110
    	[c0000000050aa040] .napi_gro_receive+0xe8/0x120
    	[c0000000050aa0c0] .cp_rx_poll+0x31c/0x590 [8139cp]
    	[c0000000050aa1d0] .net_rx_action+0x1dc/0x310
    	[c0000000050aa2b0] .__do_softirq+0x158/0x330
    	[c0000000050aa3b0] .irq_exit+0xc8/0x110
    	[c0000000050aa430] .do_IRQ+0xdc/0x2c0
    	[c0000000050aa4e0] hardware_interrupt_common+0x154/0x180
    	 --- Exception: 501 at .bad_range+0x1c/0x110
    		 LR = .get_page_from_freelist+0x908/0xbb0
    	[c0000000050aa7d0] .list_del+0x18/0x50 (unreliable)
    	[c0000000050aa850] .get_page_from_freelist+0x908/0xbb0
    	[c0000000050aa9e0] .__alloc_pages_nodemask+0x21c/0xae0
    	[c0000000050aaba0] .alloc_pages_vma+0xd0/0x210
    	[c0000000050aac60] .handle_pte_fault+0x814/0xb70
    	[c0000000050aad50] .__get_user_pages+0x1a4/0x640
    	[c0000000050aae60] .get_user_pages_fast+0xec/0x160
    	[c0000000050aaf10] .__gfn_to_pfn_memslot+0x3b0/0x430 [kvm]
    	[c0000000050aafd0] .kvmppc_gfn_to_pfn+0x64/0x130 [kvm]
    	[c0000000050ab070] .kvmppc_mmu_map_page+0x94/0x530 [kvm]
    	[c0000000050ab190] .kvmppc_handle_pagefault+0x174/0x610 [kvm]
    	[c0000000050ab270] .kvmppc_handle_exit_pr+0x464/0x9b0 [kvm]
    	[c0000000050ab320]  kvm_start_lightweight+0x1ec/0x1fc [kvm]
    	[c0000000050ab4f0] .kvmppc_vcpu_run_pr+0x168/0x3b0 [kvm]
    	[c0000000050ab9c0] .kvmppc_vcpu_run+0xc8/0xf0 [kvm]
    	[c0000000050aba50] .kvm_arch_vcpu_ioctl_run+0x5c/0x1a0 [kvm]
    	[c0000000050abae0] .kvm_vcpu_ioctl+0x478/0x730 [kvm]
    	[c0000000050abc90] .do_vfs_ioctl+0x4ec/0x7c0
    	[c0000000050abd80] .SyS_ioctl+0xd4/0xf0
    	[c0000000050abe30] syscall_exit+0x0/0x98
    
    Since this is a regression, this patch proposes a minimalistic
    and low-risk solution by blindly forcing the hardirq exit processing of
    softirqs on the softirq stack. This way we should reduce significantly
    the opportunities for task stack overflow dug by softirqs.
    
    Longer term solutions may involve extending the hardirq stack coverage to
    irq_exit(), etc...
    
    Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: #3.9.. <stable@vger.kernel.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Paul Mackerras <paulus@au1.ibm.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Paul Mackerras <paulus@au1.ibm.com>
    Cc: James Hogan <james.hogan@imgtec.com>
    Cc: James E.J. Bottomley <jejb@parisc-linux.org>
    Cc: Helge Deller <deller@gmx.de>
    Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Andrew Morton <akpm@linux-foundation.org>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 53cc09c..d7d498d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -328,10 +328,19 @@ void irq_enter(void)
 
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
-		__do_softirq();
-	else
+	if (!force_irqthreads) {
+		/*
+		 * We can safely execute softirq on the current stack if
+		 * it is the irq stack, because it should be near empty
+		 * at this stage. But we have no way to know if the arch
+		 * calls irq_exit() on the irq stack. So call softirq
+		 * in its own stack to prevent from any overrun on top
+		 * of a potentially deep task stack.
+		 */
+		do_softirq();
+	} else {
 		wakeup_softirqd();
+	}
 }
 
 static inline void tick_irq_exit(void)
