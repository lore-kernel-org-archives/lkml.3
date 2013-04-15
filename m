Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab3DOMqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:46:45 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49595 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3DOMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:46:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, jan.kiszka@siemens.com, kvm@vger.kernel.org
Subject: [PATCH] kvm: nVMX: check vmcs12 for valid activity state
Date: Mon, 15 Apr 2013 14:46:36 +0200
Message-Id: <1366029996-3284-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM does not use the activity state VMCS field, and does not support
it in nested VMX either (the corresponding bits in the misc VMX feature
MSR are zero).  Fail entry if the activity state is set to anything but
"active".

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c75c25d..589e79a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7223,6 +7223,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return 1;
 	}
 
+	if (vmcs12->guest_activity_state != 0) {
+		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+		return 1;
+	}
+
 	if ((vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_MSR_BITMAPS) &&
 			!IS_ALIGNED(vmcs12->msr_bitmap, PAGE_SIZE)) {
 		/*TODO: Also verify bits beyond physical address width are 0*/
-- 
1.8.1.4

