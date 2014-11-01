Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaKACpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:45:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:4268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaKACpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:45:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="615077881"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tiejun Chen <tiejun.chen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3] KVM: x86: fix access memslots w/o hold srcu read lock
Date: Sat,  1 Nov 2014 10:44:27 +0800
Message-Id: <1414809867-8324-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The srcu read lock must be held while accessing memslots (e.g.
when using gfn_to_* functions), however, commit c24ae0dcd3e8
("kvm: x86: Unpin and remove kvm_arch->apic_access_page") call
gfn_to_page() in kvm_vcpu_reload_apic_access_page() w/o hold it in 
vmx_vcpu_reset() path which leads to suspicious rcu_dereference_check() 
usage warning. This patch fix it by holding srcu read lock in all 
kvm_vcpu_reset() call path.


[ INFO: suspicious RCU usage. ]
3.18.0-rc2-test2+ #70 Not tainted
-------------------------------
include/linux/kvm_host.h:474 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by qemu-system-x86/2371:
 #0:  (&vcpu->mutex){+.+...}, at: [<ffffffffa037d800>] vcpu_load+0x20/0xd0 [kvm]

stack backtrace:
CPU: 4 PID: 2371 Comm: qemu-system-x86 Not tainted 3.18.0-rc2-test2+ #70
Hardware name: Dell Inc. OptiPlex 9010/0M9KCM, BIOS A12 01/10/2013
 0000000000000001 ffff880209983ca8 ffffffff816f514f 0000000000000000
 ffff8802099b8990 ffff880209983cd8 ffffffff810bd687 00000000000fee00
 ffff880208a2c000 ffff880208a10000 ffff88020ef50040 ffff880209983d08
Call Trace:
 [<ffffffff816f514f>] dump_stack+0x4e/0x71
 [<ffffffff810bd687>] lockdep_rcu_suspicious+0xe7/0x120
 [<ffffffffa037d055>] gfn_to_memslot+0xd5/0xe0 [kvm]
 [<ffffffffa03807d3>] __gfn_to_pfn+0x33/0x60 [kvm]
 [<ffffffffa0380885>] gfn_to_page+0x25/0x90 [kvm]
 [<ffffffffa038aeec>] kvm_vcpu_reload_apic_access_page+0x3c/0x80 [kvm]
 [<ffffffffa08f0a9c>] vmx_vcpu_reset+0x20c/0x460 [kvm_intel]
 [<ffffffffa039ab8e>] kvm_vcpu_reset+0x15e/0x1b0 [kvm]
 [<ffffffffa039ac0c>] kvm_arch_vcpu_setup+0x2c/0x50 [kvm]
 [<ffffffffa037f7e0>] kvm_vm_ioctl+0x1d0/0x780 [kvm]
 [<ffffffff810bc664>] ? __lock_is_held+0x54/0x80
 [<ffffffff812231f0>] do_vfs_ioctl+0x300/0x520
 [<ffffffff8122ee45>] ? __fget+0x5/0x250
 [<ffffffff8122f0fa>] ? __fget_light+0x2a/0xe0
 [<ffffffff81223491>] SyS_ioctl+0x81/0xa0
 [<ffffffff816fed6d>] system_call_fastpath+0x16/0x1b

Reported-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v2 -> v3:
 * take care all vmx_vcpu_reset call path
v1 -> v2:
 * just fix hold the srcu read lock in vmx_vcpu_reset path

 arch/x86/kvm/x86.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0033df3..701a90d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6458,7 +6458,7 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	int r;
+	int r, idx;
 	sigset_t sigsaved;
 
 	if (!tsk_used_math(current) && init_fpu(current))
@@ -6469,7 +6469,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		kvm_vcpu_block(vcpu);
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		kvm_apic_accept_events(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
 		r = -EAGAIN;
 		goto out;
@@ -6626,7 +6628,11 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
+	int idx;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_apic_accept_events(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
 					vcpu->arch.pv.pv_unhalted)
 		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
@@ -6943,13 +6949,15 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	int r;
+	int r, idx;
 
 	vcpu->arch.mtrr_state.have_fixed = 1;
 	r = vcpu_load(vcpu);
 	if (r)
 		return r;
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_vcpu_reset(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	kvm_mmu_setup(vcpu);
 	vcpu_put(vcpu);
 
-- 
1.7.1

