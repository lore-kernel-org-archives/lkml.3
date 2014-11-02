Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaKBHIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:08:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:9914 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaKBHIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:08:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="615436318"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tiejun Chen <tiejun.chen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v4] KVM: x86: fix access memslots w/o hold srcu read lock
Date: Sun,  2 Nov 2014 15:07:43 +0800
Message-Id: <1414912063-10923-1-git-send-email-wanpeng.li@linux.intel.com>
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
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v3 -> v4:
 * bypass the problem altoghter by kvm_make_request
v2 -> v3:
 * take care all vmx_vcpu_reset call path
v1 -> v2:
 * just fix hold the srcu read lock in vmx_vcpu_reset path

 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a0f78db..3e556c6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4579,7 +4579,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write32(TPR_THRESHOLD, 0);
 	}
 
-	kvm_vcpu_reload_apic_access_page(vcpu);
+	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	if (vmx_vm_has_apicv(vcpu->kvm))
 		memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));
-- 
1.7.1

