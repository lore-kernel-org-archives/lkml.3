Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaHSUiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaHSUh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:37:58 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 8/9] KVM: VMX: runtime knobs for dynamic PLE window
Date: Tue, 19 Aug 2014 22:35:35 +0200
Message-Id: <1408480536-8240-9-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ple_window is updated on every vmentry, so there is no reason to have it
read-only anymore.
ple_window_* weren't writable to prevent runtime overflow races;
they are mitigated by clamping the value of ple_window.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 If we decide to ignore insane overflows, last two hunks can be dropped.

 arch/x86/kvm/vmx.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6cfb71..d7f58e8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -134,19 +134,19 @@ static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
 module_param(ple_gap, int, S_IRUGO);
 
 static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
-module_param(ple_window, int, S_IRUGO);
+module_param(ple_window, int, S_IRUGO | S_IWUSR);
 
 /* Default doubles per-vcpu window every exit. */
 static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
-module_param(ple_window_grow, int, S_IRUGO);
+module_param(ple_window_grow, int, S_IRUGO | S_IWUSR);
 
 /* Default resets per-vcpu window every exit to ple_window. */
 static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
-module_param(ple_window_shrink, int, S_IRUGO);
+module_param(ple_window_shrink, int, S_IRUGO | S_IWUSR);
 
 /* Default is to compute the maximum so we can never overflow. */
 static int ple_window_max = INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
-module_param(ple_window_max, int, S_IRUGO);
+module_param(ple_window_max, int, S_IRUGO | S_IWUSR);
 
 extern const ulong vmx_return;
 
@@ -5694,7 +5694,8 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 out:
 	return ret;
 }
-#define make_ple_window_modifier(type, oplt, opge, cmp, bound) \
+
+#define make_ple_window_modifier(type, oplt, opge) \
 static void type##_ple_window(struct kvm_vcpu *vcpu) \
 { \
 	struct vcpu_vmx *vmx = to_vmx(vcpu); \
@@ -5708,13 +5709,13 @@ static void type##_ple_window(struct kvm_vcpu *vcpu) \
 	else \
 		new = old opge ple_window_##type; \
 \
-	vmx->ple_window = cmp(new, bound); \
+	vmx->ple_window = clamp(new, ple_window, ple_window_max); \
 \
 	trace_kvm_ple_window_##type(vcpu->vcpu_id, vmx->ple_window, old); \
 }
 
-make_ple_window_modifier(grow,   *, +, min, ple_window_max)
-make_ple_window_modifier(shrink, /, -, max, ple_window)
+make_ple_window_modifier(grow,   *, +) /* grow_ple_window */
+make_ple_window_modifier(shrink, /, -) /* shrink_ple_window */
 
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
-- 
2.0.4

