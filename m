Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab3IDVk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:40:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:38692 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab3IDVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:40:27 -0400
Message-ID: <1378330796.4321.50.camel@pasglop>
Subject: do_softirq() vs __do_softirq() in irq_exit() and stack overflow
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, davem@davemloft.net,
        Paul Mackerras <paulus@au1.ibm.com>
Date: Thu, 05 Sep 2013 07:39:56 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks !

It appears that the current version of irq_exit() calls __do_softirq()
directly rather than do_softirq().

That means we are going to call the softirq's in the current interrupt
frame rather than on the separate softirq stack.

The current frame is also still the normal kernel stack, because
do_IRQ() itself only switches to the interrupt stack for processing
the handlers (it's back to the original stack by the time it calls
irq_exit).

That means that we end up stacking the normal stack, the actually HW
interrupt stack frame (which can be pretty big on ppc) + do_IRQ's own,
then the softirq (networks stack can create HUGE stack frames) and ...
we are in softirq, so HW irqs are enable, we can thus can another irq
stack frame piled up on top of that (or a perf stack).

We are observing actual overflows, here's an example blowing up our 16k
stack on ppc64, you notice that it's all on the normal kernel stack:

[ 1002.364577] do_IRQ: stack overflow: 1920
[ 1002.364653] CPU: 0 PID: 1602 Comm: qemu-system-ppc Not tainted 3.10.4-300.1.fc19.ppc64p7 #1
[ 1002.364734] Call Trace:
[ 1002.364770] [c0000000050a8740] [c0000000000157c0] .show_stack+0x130/0x200 (unreliable)
[ 1002.364872] [c0000000050a8810] [c00000000082f6d0] .dump_stack+0x28/0x3c
[ 1002.364955] [c0000000050a8880] [c000000000010b98] .do_IRQ+0x2b8/0x2c0
[ 1002.365039] [c0000000050a8930] [c0000000000026d4] hardware_interrupt_common+0x154/0x180
[ 1002.365148] --- Exception: 501 at .cp_start_xmit+0x3a4/0x820 [8139cp]
[ 1002.365148]     LR = .cp_start_xmit+0x390/0x820 [8139cp]
[ 1002.365359] [c0000000050a8d40] [c0000000006d7f14] .dev_hard_start_xmit+0x394/0x640
[ 1002.365433] [c0000000050a8e00] [c0000000007028c0] .sch_direct_xmit+0x110/0x260
[ 1002.365499] [c0000000050a8ea0] [c0000000006d8420] .dev_queue_xmit+0x260/0x630
[ 1002.365571] [c0000000050a8f40] [d0000000027d30d4] .br_dev_queue_push_xmit+0xc4/0x130 [bridge]
[ 1002.365641] [c0000000050a8fc0] [d0000000027d01f8] .br_dev_xmit+0x198/0x270 [bridge]
[ 1002.365707] [c0000000050a9070] [c0000000006d7f14] .dev_hard_start_xmit+0x394/0x640
[ 1002.365774] [c0000000050a9130] [c0000000006d85e8] .dev_queue_xmit+0x428/0x630
[ 1002.365834] [c0000000050a91d0] [c000000000729764] .ip_finish_output+0x2a4/0x550
[ 1002.365902] [c0000000050a9290] [c00000000072aaf0] .ip_local_out+0x50/0x70
[ 1002.365960] [c0000000050a9310] [c00000000072aed8] .ip_queue_xmit+0x148/0x420
[ 1002.366018] [c0000000050a93b0] [c000000000749524] .tcp_transmit_skb+0x4e4/0xaf0
[ 1002.366085] [c0000000050a94a0] [c00000000073de9c] .__tcp_ack_snd_check+0x7c/0xf0
[ 1002.366152] [c0000000050a9520] [c0000000007451d8] .tcp_rcv_established+0x1e8/0x930
[ 1002.366217] [c0000000050a95f0] [c00000000075326c] .tcp_v4_do_rcv+0x21c/0x570
[ 1002.366274] [c0000000050a96c0] [c000000000754a44] .tcp_v4_rcv+0x734/0x930
[ 1002.366332] [c0000000050a97a0] [c000000000724144] .ip_local_deliver_finish+0x184/0x360
[ 1002.366398] [c0000000050a9840] [c000000000724468] .ip_rcv_finish+0x148/0x400
[ 1002.366457] [c0000000050a98d0] [c0000000006d3248] .__netif_receive_skb_core+0x4f8/0xb00
[ 1002.366523] [c0000000050a99d0] [c0000000006d5414] .netif_receive_skb+0x44/0x110
[ 1002.366594] [c0000000050a9a70] [d0000000027d4e2c] .br_handle_frame_finish+0x2bc/0x3f0 [bridge]
[ 1002.366674] [c0000000050a9b20] [d0000000027de5ac] .br_nf_pre_routing_finish+0x2ac/0x420 [bridge]
[ 1002.366754] [c0000000050a9bd0] [d0000000027df5ec] .br_nf_pre_routing+0x4dc/0x7d0 [bridge]
[ 1002.366820] [c0000000050a9c70] [c000000000717aa4] .nf_iterate+0x114/0x130
[ 1002.366877] [c0000000050a9d30] [c000000000717b74] .nf_hook_slow+0xb4/0x1e0
[ 1002.366938] [c0000000050a9e00] [d0000000027d51f0] .br_handle_frame+0x290/0x330 [bridge]
[ 1002.367005] [c0000000050a9ea0] [c0000000006d309c] .__netif_receive_skb_core+0x34c/0xb00
[ 1002.367072] [c0000000050a9fa0] [c0000000006d5414] .netif_receive_skb+0x44/0x110
[ 1002.367138] [c0000000050aa040] [c0000000006d6218] .napi_gro_receive+0xe8/0x120
[ 1002.367210] [c0000000050aa0c0] [d00000000208536c] .cp_rx_poll+0x31c/0x590 [8139cp]
[ 1002.367276] [c0000000050aa1d0] [c0000000006d59cc] .net_rx_action+0x1dc/0x310
[ 1002.367335] [c0000000050aa2b0] [c0000000000a0568] .__do_softirq+0x158/0x330
[ 1002.367394] [c0000000050aa3b0] [c0000000000a0978] .irq_exit+0xc8/0x110
[ 1002.367452] [c0000000050aa430] [c0000000000109bc] .do_IRQ+0xdc/0x2c0
[ 1002.367510] [c0000000050aa4e0] [c0000000000026d4] hardware_interrupt_common+0x154/0x180
[ 1002.367580] --- Exception: 501 at .bad_range+0x1c/0x110
[ 1002.367580]     LR = .get_page_from_freelist+0x908/0xbb0
[ 1002.367658] [c0000000050aa7d0] [c00000000041d758] .list_del+0x18/0x50 (unreliable)
[ 1002.367725] [c0000000050aa850] [c0000000001bfa98] .get_page_from_freelist+0x908/0xbb0
[ 1002.367792] [c0000000050aa9e0] [c0000000001bff5c] .__alloc_pages_nodemask+0x21c/0xae0
[ 1002.367860] [c0000000050aaba0] [c0000000002126d0] .alloc_pages_vma+0xd0/0x210
[ 1002.367918] [c0000000050aac60] [c0000000001e93f4] .handle_pte_fault+0x814/0xb70
[ 1002.367985] [c0000000050aad50] [c0000000001eade4] .__get_user_pages+0x1a4/0x640
[ 1002.368052] [c0000000050aae60] [c00000000004606c] .get_user_pages_fast+0xec/0x160
[ 1002.368130] [c0000000050aaf10] [d000000001f73930] .__gfn_to_pfn_memslot+0x3b0/0x430 [kvm]
[ 1002.368205] [c0000000050aafd0] [d000000001f7e214] .kvmppc_gfn_to_pfn+0x64/0x130 [kvm]
[ 1002.368280] [c0000000050ab070] [d000000001f8a824] .kvmppc_mmu_map_page+0x94/0x530 [kvm]
[ 1002.368354] [c0000000050ab190] [d000000001f85064] .kvmppc_handle_pagefault+0x174/0x610 [kvm]
[ 1002.368429] [c0000000050ab270] [d000000001f85b74] .kvmppc_handle_exit_pr+0x464/0x9b0 [kvm]
[ 1002.368504] [c0000000050ab320] [d000000001f88ec4] kvm_start_lightweight+0x1ec/0x1fc [kvm]
[ 1002.368578] [c0000000050ab4f0] [d000000001f86a58] .kvmppc_vcpu_run_pr+0x168/0x3b0 [kvm]
[ 1002.368652] [c0000000050ab9c0] [d000000001f7f218] .kvmppc_vcpu_run+0xc8/0xf0 [kvm]
[ 1002.368725] [c0000000050aba50] [d000000001f7bdac] .kvm_arch_vcpu_ioctl_run+0x5c/0x1a0 [kvm]
[ 1002.368797] [c0000000050abae0] [d000000001f74618] .kvm_vcpu_ioctl+0x478/0x730 [kvm]
[ 1002.368865] [c0000000050abc90] [c00000000025302c] .do_vfs_ioctl+0x4ec/0x7c0
[ 1002.368923] [c0000000050abd80] [c0000000002533d4] .SyS_ioctl+0xd4/0xf0
[ 1002.368981] [c0000000050abe30] [c000000000009ed4] syscall_exit+0x0/0x98
[ 1002.369117] ------------[ cut here ]------------

Cheers,
Ben.


