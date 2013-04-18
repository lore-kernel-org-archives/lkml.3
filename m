Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3DRBCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 21:02:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:18806 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab3DRBCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 21:02:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,496,1363158000"; 
   d="scan'208";a="320013464"
From: Yang Zhang <yang.z.zhang@intel.com>
To: kvm@vger.kernel.org
Cc: gleb@redhat.com, mtosatti@redhat.com, rdunlap@infradead.org,
        rientjes@google.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Yang Zhang <yang.z.zhang@intel.com>
Subject: [PATCH] KVM: x86: Don't sending posted interrupt if not config CONFIG_SMP
Date: Thu, 18 Apr 2013 08:57:47 +0800
Message-Id: <1366246667-7599-1-git-send-email-yang.z.zhang@intel.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Zhang <yang.z.zhang@Intel.com>

If not config smp, posted interrupt logic will not work. So we should not 
send posted interrupt and let vcpu to pick the pending interrupt before
vmentry.

Without this patch, the build fails when CONFIG_SMP is disabled.
Thanks Randy to report this issue.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Yang Zhang <yang.z.zhang@Intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---
 arch/x86/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 52b21da..d5c6b95 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3946,10 +3946,12 @@ static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 
 	r = pi_test_and_set_on(&vmx->pi_desc);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
+#ifdef CONFIG_SMP
 	if (!r && (vcpu->mode == IN_GUEST_MODE))
 		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
 				POSTED_INTR_VECTOR);
 	else
+#endif
 		kvm_vcpu_kick(vcpu);
 }
 
-- 
1.7.1

