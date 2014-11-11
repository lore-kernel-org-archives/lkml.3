Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaKKL4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:56:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaKKLJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 055/170] kvm: x86: don't kill guest on unknown exit reason
Date: Tue, 11 Nov 2014 11:06:54 +0000
Message-Id: <1415704129-12709-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 2bc19dc3754fc066c43799659f0d848631c44cfe upstream.

KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
triggered by a priveledged application.  Let's not kill the guest: WARN
and inject #UD instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/svm.c | 6 +++---
 arch/x86/kvm/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ee77b4bfa88b..1c10d9071958 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3528,9 +3528,9 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
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
index 5f885b760846..515704968236 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7044,10 +7044,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
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
2.1.0

