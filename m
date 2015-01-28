Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928AbbA1EV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:21:59 -0500
Received: from mail.kernel.org ([198.145.29.136]:39748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964887AbbA1EV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:56 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 086/177] kvm: x86: don't kill guest on unknown exit reason
Date: Wed, 28 Jan 2015 12:08:59 +0800
Message-Id: <1422418236-12852-172-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2bc19dc3754fc066c43799659f0d848631c44cfe upstream.

KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
triggered by a priveledged application.  Let's not kill the guest: WARN
and inject #UD instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kvm/svm.c | 6 +++---
 arch/x86/kvm/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1cd908c..86c74c0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3494,9 +3494,9 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
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
index 43c39db..2eb4e5a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5936,10 +5936,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
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

