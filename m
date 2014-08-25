Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaHYH4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:56:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:44155 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbaHYH4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:56:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="562977832"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] KVM: x86: fix xen guest panic due to lack of KVM_REQ_EVENT
Date: Mon, 25 Aug 2014 15:58:26 +0800
Message-Id: <1408953506-7289-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=82211

(XEN) ..MP-BIOS bug: 8254 timer not connected to IO-APIC
(XEN) ...trying to set up timer (IRQ0) through the 8259A ...  failed.
(XEN) ...trying to set up timer as Virtual Wire IRQ... failed.
(XEN) ...trying to set up timer as ExtINT IRQ... failed :(.
(XEN) 
(XEN) ****************************************
(XEN) Panic on CPU 0:
(XEN) IO-APIC + timer doesn't work!  Boot with apic_verbosity=debug and send a report.
(XEN) ****************************************

Commit 6addfc42992b ("KVM: x86: avoid useless set of KVM_REQ_EVENT after 
emulation") sets a KVM_REQ_EVENT if an interrupt could be injected, which 
happens a) if an interrupt shadow bit (STI or MOV SS) has gone away; b) 
if the interrupt flag has just been set. However, a KVM_REQ_EVENT should 
be set if there is no sti sequence. This patch fix it by set a KVM_REQ_EVENT 
if both the first and the second instructions are not sti.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c10408e..b7c0073 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4928,6 +4928,8 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 		if (!mask)
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
+	if (!(int_shadow || mask))
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
 static void inject_emulated_exception(struct kvm_vcpu *vcpu)
-- 
1.9.1

