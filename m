Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaHTUyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaHTUyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:54:23 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 6/6] KVM: VMX: runtime knobs for dynamic PLE window
Date: Wed, 20 Aug 2014 22:53:17 +0200
Message-Id: <1408567997-21222-7-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
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
 arch/x86/kvm/vmx.c | 48 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f63ac5d..bd73fa1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -132,24 +132,29 @@ module_param(nested, bool, S_IRUGO);
 #define KVM_VMX_DEFAULT_PLE_WINDOW_MAX    \
 		INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW
 
+static struct kernel_param_ops param_ops_ple_t;
+#define param_check_ple_t(name, p) __param_check(name, p, int)
+
+static DEFINE_SEQLOCK(ple_window_seqlock);
+
 static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
 module_param(ple_gap, int, S_IRUGO);
 
 static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
-module_param(ple_window, int, S_IRUGO);
+module_param(ple_window, ple_t, S_IRUGO | S_IWUSR);
 
 /* Default doubles per-vcpu window every exit. */
 static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
-module_param(ple_window_grow, int, S_IRUGO);
+module_param(ple_window_grow, ple_t, S_IRUGO | S_IWUSR);
 
 /* Default resets per-vcpu window every exit to ple_window. */
 static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
-module_param(ple_window_shrink, int, S_IRUGO);
+module_param(ple_window_shrink, int, S_IRUGO | S_IWUSR);
 
 /* Default is to compute the maximum so we can never overflow. */
 static int ple_window_actual_max = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
 static int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
-module_param(ple_window_max, int, S_IRUGO);
+module_param(ple_window_max, ple_t, S_IRUGO | S_IWUSR);
 
 extern const ulong vmx_return;
 
@@ -5730,13 +5735,19 @@ static void modify_ple_window(struct kvm_vcpu *vcpu, int grow)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int old = vmx->ple_window;
 	int new;
+	unsigned seq;
 
-	if (grow)
-		new = __grow_ple_window(old)
-	else
-		new = __shrink_ple_window(old, ple_window_shrink, ple_window);
+	do {
+		seq = read_seqbegin(&ple_window_seqlock);
 
-	vmx->ple_window = max(new, ple_window);
+		if (grow)
+			new = __grow_ple_window(old);
+		else
+			new = __shrink_ple_window(old, ple_window_shrink,
+			                          ple_window);
+
+		vmx->ple_window = max(new, ple_window);
+	} while (read_seqretry(&ple_window_seqlock, seq));
 
 	trace_kvm_ple_window(grow, vcpu->vcpu_id, vmx->ple_window, old);
 }
@@ -5750,6 +5761,23 @@ static void update_ple_window_actual_max(void)
 			                    ple_window_grow, INT_MIN);
 }
 
+static int param_set_ple_t(const char *arg, const struct kernel_param *kp)
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
+static struct kernel_param_ops param_ops_ple_t = {
+	.set = param_set_ple_t,
+	.get = param_get_int,
+};
+
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
@@ -9153,8 +9181,6 @@ static int __init vmx_init(void)
 	} else
 		kvm_disable_tdp();
 
-	update_ple_window_actual_max();
-
 	return 0;
 
 out7:
-- 
2.0.4

