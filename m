Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaKFWnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaKFWnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:02 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 102/162] kvm: x86: don't kill guest on unknown exit reason
Date: Thu,  6 Nov 2014 14:36:06 -0800
Message-Id: <1415313426-9622-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 2bc19dc3754fc066c43799659f0d848631c44cfe upstream.

KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
triggered by a priveledged application.  Let's not kill the guest: WARN
and inject #UD instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/svm.c | 6 +++---
 arch/x86/kvm/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 121bd0d..1f5faa5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3482,9 +3482,9 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || !svm_exit_handlers[exit_code]) {
-		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
-		kvm_run->hw.hardware_exit_reason = exit_code;
-		return 0;
+		WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_code);
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
 	}
 
 	return svm_exit_handlers[exit_code](svm);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6e4b08b..f5c384c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6854,10 +6854,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
 	else {
-		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
-		vcpu->run->hw.hardware_exit_reason = exit_reason;
+		WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
 	}
-	return 0;
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
-- 
1.9.1

