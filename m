Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaHSUhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaHSUhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:37:40 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 4/9] KVM: VMX: dynamise PLE window
Date: Tue, 19 Aug 2014 22:35:31 +0200
Message-Id: <1408480536-8240-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
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

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/vmx.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index eaa5574..66259fd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -125,14 +125,25 @@ module_param(nested, bool, S_IRUGO);
  * Time is measured based on a counter that runs at the same rate as the TSC,
  * refer SDM volume 3b section 21.6.13 & 22.1.3.
  */
-#define KVM_VMX_DEFAULT_PLE_GAP    128
-#define KVM_VMX_DEFAULT_PLE_WINDOW 4096
+#define KVM_VMX_DEFAULT_PLE_GAP           128
+#define KVM_VMX_DEFAULT_PLE_WINDOW        4096
+#define KVM_VMX_DEFAULT_PLE_WINDOW_GROW   2
+#define KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK 0
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
 extern const ulong vmx_return;
 
 #define NR_AUTOLOAD_MSRS 8
@@ -5680,12 +5691,47 @@ out:
 	return ret;
 }
 
+static void grow_ple_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int old = vmx->ple_window;
+	int new;
+
+	if (ple_window_grow < 1)
+		new = ple_window;
+	else if (ple_window_grow < ple_window)
+		new = old * ple_window_grow;
+	else
+		new = old + ple_window_grow;
+
+	vmx->ple_window = new;
+}
+
+static void shrink_ple_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int old = vmx->ple_window;
+	int new;
+
+	if (ple_window_shrink < 1)
+		new = ple_window;
+	else if (ple_window_shrink < ple_window)
+		new = old / ple_window_shrink;
+	else
+		new = old - ple_window_shrink;
+
+	vmx->ple_window = new;
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
 
@@ -8855,6 +8901,8 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 
 void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	if (ple_gap)
+		shrink_ple_window(vcpu);
 }
 
 static struct kvm_x86_ops vmx_x86_ops = {
-- 
2.0.4

