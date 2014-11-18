Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbaKROy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:54:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbaKROJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 106/206] kvm: x86: don't kill guest on unknown exit reason
Date: Tue, 18 Nov 2014 15:07:41 +0100
Message-Id: <3f119d66b95c31910a5363b15308ff3d18bba29d.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2bc19dc3754fc066c43799659f0d848631c44cfe upstream.

KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
triggered by a priveledged application.  Let's not kill the guest: WARN
and inject #UD instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/svm.c | 6 +++---
 arch/x86/kvm/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8466c33e5f53..5dcdff58b679 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3486,9 +3486,9 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
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
index 87e910934286..d1e87ae48513 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6815,10 +6815,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
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
2.1.3

