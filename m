Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaHUQK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:10:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbaHUQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:10:54 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: [PATCH v3 6/7] KVM: VMX: runtime knobs for dynamic PLE window
Date: Thu, 21 Aug 2014 18:08:10 +0200
Message-Id: <1408637291-18533-7-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ple_window is updated on every vmentry, so there is no reason to have it
read-only anymore.
ple_window* weren't writable to prevent runtime overflow races;
they are prevented by a seqlock.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/vmx.c | 46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 273cbd5..1318232 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -132,24 +132,29 @@ module_param(nested, bool, S_IRUGO);
 #define KVM_VMX_DEFAULT_PLE_WINDOW_MAX    \
 		INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW
 
+static struct kernel_param_ops param_ops_ple_int;
+#define param_check_ple_int(name, p) __param_check(name, p, int)
+
+static DEFINE_SEQLOCK(ple_window_seqlock);
+
 static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
 module_param(ple_gap, int, S_IRUGO);
 
 static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
-module_param(ple_window, int, S_IRUGO);
+module_param(ple_window, ple_int, S_IRUGO | S_IWUSR);
 
 /* Default doubles per-vcpu window every exit. */
 static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
-module_param(ple_window_grow, int, S_IRUGO);
+module_param(ple_window_grow, ple_int, S_IRUGO | S_IWUSR);
 
 /* Default resets per-vcpu window every exit to ple_window. */
 static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
-module_param(ple_window_shrink, int, S_IRUGO);
+module_param(ple_window_shrink, int, S_IRUGO | S_IWUSR);
 
 /* Default is to compute the maximum so we can never overflow. */
 static int ple_window_actual_max = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
 static int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
-module_param(ple_window_max, int, S_IRUGO);
+module_param(ple_window_max, ple_int, S_IRUGO | S_IWUSR);
 
 extern const ulong vmx_return;
 
@@ -5729,8 +5734,12 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int old = vmx->ple_window;
+	unsigned seq;
 
-	vmx->ple_window = __grow_ple_window(old);
+	do {
+		seq = read_seqbegin(&ple_window_seqlock);
+		vmx->ple_window = __grow_ple_window(old);
+	} while (read_seqretry(&ple_window_seqlock, seq));
 
 	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
 }
@@ -5739,9 +5748,13 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int old = vmx->ple_window;
+	unsigned seq;
 
-	vmx->ple_window = __shrink_ple_window(old,
-	                                      ple_window_shrink, ple_window);
+	do {
+		seq = read_seqbegin(&ple_window_seqlock);
+		vmx->ple_window = __shrink_ple_window(old, ple_window_shrink,
+		                                      ple_window);
+	} while (read_seqretry(&ple_window_seqlock, seq));
 
 	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
 }
@@ -5761,6 +5774,23 @@ static void update_ple_window_actual_max(void)
 			                    ple_window_grow, INT_MIN);
 }
 
+static int param_set_ple_int(const char *arg, const struct kernel_param *kp)
+{
+	int ret;
+
+	write_seqlock(&ple_window_seqlock);
+	ret = param_set_int(arg, kp);
+	update_ple_window_actual_max();
+	write_sequnlock(&ple_window_seqlock);
+
+	return ret;
+}
+
+static struct kernel_param_ops param_ops_ple_int = {
+	.set = param_set_ple_int,
+	.get = param_get_int,
+};
+
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
@@ -9164,8 +9194,6 @@ static int __init vmx_init(void)
 	} else
 		kvm_disable_tdp();
 
-	update_ple_window_actual_max();
-
 	return 0;
 
 out7:
-- 
2.1.0

