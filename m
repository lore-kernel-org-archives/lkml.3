Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaHUQKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbaHUQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:10:44 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: [PATCH v3 4/7] KVM: VMX: dynamise PLE window
Date: Thu, 21 Aug 2014 18:08:08 +0200
Message-Id: <1408637291-18533-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Window is increased on every PLE exit and decreased on every sched_in.
The idea is that we don't want to PLE exit if there is no preemption
going on.
We do this with sched_in() because it does not hold rq lock.

There are two new kernel parameters for changing the window:
 ple_window_grow and ple_window_shrink
ple_window_grow affects the window on PLE exit and ple_window_shrink
does it on sched_in;  depending on their value, the window is modifier
like this: (ple_window is kvm_intel's global)

  ple_window_shrink/ |
  ple_window_grow    | PLE exit           | sched_in
  -------------------+--------------------+---------------------
  < 1                |  = ple_window      |  = ple_window
  < ple_window       | *= ple_window_grow | /= ple_window_shrink
  otherwise          | += ple_window_grow | -= ple_window_shrink

A third new parameter, ple_window_max, controls the maximal ple_window;
it is internally rounded down to a closest multiple of ple_window_grow.

VCPU's PLE window is never allowed below ple_window.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/vmx.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 18e0e52..a2fa6ba 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -125,14 +125,32 @@ module_param(nested, bool, S_IRUGO);
  * Time is measured based on a counter that runs at the same rate as the TSC,
  * refer SDM volume 3b section 21.6.13 & 22.1.3.
  */
-#define KVM_VMX_DEFAULT_PLE_GAP    128
-#define KVM_VMX_DEFAULT_PLE_WINDOW 4096
+#define KVM_VMX_DEFAULT_PLE_GAP           128
+#define KVM_VMX_DEFAULT_PLE_WINDOW        4096
+#define KVM_VMX_DEFAULT_PLE_WINDOW_GROW   2
+#define KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK 0
+#define KVM_VMX_DEFAULT_PLE_WINDOW_MAX    \
+		INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW
+
 static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
 module_param(ple_gap, int, S_IRUGO);
 
 static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
 module_param(ple_window, int, S_IRUGO);
 
+/* Default doubles per-vcpu window every exit. */
+static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
+module_param(ple_window_grow, int, S_IRUGO);
+
+/* Default resets per-vcpu window every exit to ple_window. */
+static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
+module_param(ple_window_shrink, int, S_IRUGO);
+
+/* Default is to compute the maximum so we can never overflow. */
+static int ple_window_actual_max = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
+static int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
+module_param(ple_window_max, int, S_IRUGO);
+
 extern const ulong vmx_return;
 
 #define NR_AUTOLOAD_MSRS 8
@@ -5679,12 +5697,73 @@ out:
 	return ret;
 }
 
+static int __grow_ple_window(int val)
+{
+	if (ple_window_grow < 1)
+		return ple_window;
+
+	val = min(val, ple_window_actual_max);
+
+	if (ple_window_grow < ple_window)
+		val *= ple_window_grow;
+	else
+		val += ple_window_grow;
+
+	return val;
+}
+
+static int __shrink_ple_window(int val, int modifier, int minimum)
+{
+	if (modifier < 1)
+		return ple_window;
+
+	if (modifier < ple_window)
+		val /= modifier;
+	else
+		val -= modifier;
+
+	return max(val, minimum);
+}
+
+static void grow_ple_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->ple_window = __grow_ple_window(vmx->ple_window);
+}
+
+static void shrink_ple_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->ple_window = __shrink_ple_window(vmx->ple_window,
+	                                      ple_window_shrink, ple_window);
+}
+
+/*
+ * ple_window_actual_max is computed to be one grow_ple_window() below
+ * ple_window_max. (See __grow_ple_window for the reason.)
+ * This prevents overflows, because ple_window_max is int.
+ * ple_window_max effectively rounded down to a multiple of ple_window_grow in
+ * this process.
+ * ple_window_max is also prevented from setting vmx->ple_window < ple_window.
+ */
+static void update_ple_window_actual_max(void)
+{
+	ple_window_actual_max =
+			__shrink_ple_window(max(ple_window_max, ple_window),
+			                    ple_window_grow, INT_MIN);
+}
+
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
  */
 static int handle_pause(struct kvm_vcpu *vcpu)
 {
+	if (ple_gap)
+		grow_ple_window(vcpu);
+
 	skip_emulated_instruction(vcpu);
 	kvm_vcpu_on_spin(vcpu);
 
@@ -8854,6 +8933,8 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 
 void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	if (ple_gap)
+		shrink_ple_window(vcpu);
 }
 
 static struct kvm_x86_ops vmx_x86_ops = {
@@ -9077,6 +9158,8 @@ static int __init vmx_init(void)
 	} else
 		kvm_disable_tdp();
 
+	update_ple_window_actual_max();
+
 	return 0;
 
 out7:
-- 
2.1.0

