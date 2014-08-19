Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaHSUhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaHSUhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:37:52 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 7/9] KVM: VMX: abstract ple_window modifiers
Date: Tue, 19 Aug 2014 22:35:34 +0200
Message-Id: <1408480536-8240-8-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were almost identical and thus merged with a loathable macro.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 This solution is hopefully more acceptable than function pointers.

 arch/x86/kvm/vmx.c | 53 +++++++++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a236a9f..c6cfb71 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5694,42 +5694,27 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 out:
 	return ret;
 }
-
-static void grow_ple_window(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int old = vmx->ple_window;
-	int new;
-
-	if (ple_window_grow < 1)
-		new = ple_window;
-	else if (ple_window_grow < ple_window)
-		new = old * ple_window_grow;
-	else
-		new = old + ple_window_grow;
-
-	vmx->ple_window = min(new, ple_window_max);
-
-	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
+#define make_ple_window_modifier(type, oplt, opge, cmp, bound) \
+static void type##_ple_window(struct kvm_vcpu *vcpu) \
+{ \
+	struct vcpu_vmx *vmx = to_vmx(vcpu); \
+	int old = vmx->ple_window; \
+	int new; \
+\
+	if (ple_window_##type < 1) \
+		new = ple_window; \
+	else if (ple_window_##type < ple_window) \
+		new = old oplt ple_window_##type; \
+	else \
+		new = old opge ple_window_##type; \
+\
+	vmx->ple_window = cmp(new, bound); \
+\
+	trace_kvm_ple_window_##type(vcpu->vcpu_id, vmx->ple_window, old); \
 }
 
-static void shrink_ple_window(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int old = vmx->ple_window;
-	int new;
-
-	if (ple_window_shrink < 1)
-		new = ple_window;
-	else if (ple_window_shrink < ple_window)
-		new = old / ple_window_shrink;
-	else
-		new = old - ple_window_shrink;
-
-	vmx->ple_window = max(new, ple_window);
-
-	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
-}
+make_ple_window_modifier(grow,   *, +, min, ple_window_max)
+make_ple_window_modifier(shrink, /, -, max, ple_window)
 
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
-- 
2.0.4

