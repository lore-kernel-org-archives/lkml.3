Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaHSUiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaHSUiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:38:01 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 9/9] KVM: VMX: automatic PLE window maximum
Date: Tue, 19 Aug 2014 22:35:36 +0200
Message-Id: <1408480536-8240-10-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every increase of ple_window_grow creates potential overflows.
They are not serious, because we clamp ple_window and userspace is
expected to fix ple_window_max within a second.
---
 arch/x86/kvm/vmx.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d7f58e8..6873a0b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -138,7 +138,9 @@ module_param(ple_window, int, S_IRUGO | S_IWUSR);
 
 /* Default doubles per-vcpu window every exit. */
 static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
-module_param(ple_window_grow, int, S_IRUGO | S_IWUSR);
+static struct kernel_param_ops ple_window_grow_ops;
+module_param_cb(ple_window_grow, &ple_window_grow_ops,
+                &ple_window_grow, S_IRUGO | S_IWUSR);
 
 /* Default resets per-vcpu window every exit to ple_window. */
 static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
@@ -5717,6 +5719,36 @@ static void type##_ple_window(struct kvm_vcpu *vcpu) \
 make_ple_window_modifier(grow,   *, +) /* grow_ple_window */
 make_ple_window_modifier(shrink, /, -) /* shrink_ple_window */
 
+static void clamp_ple_window_max(void)
+{
+	int maximum;
+
+	if (ple_window_grow < 1)
+		return;
+
+	if (ple_window_grow < ple_window)
+		maximum = INT_MAX / ple_window_grow;
+	else
+		maximum = INT_MAX - ple_window_grow;
+
+	ple_window_max = clamp(ple_window_max, ple_window, maximum);
+}
+
+static int set_ple_window_grow(const char *arg, const struct kernel_param *kp)
+{
+	int ret;
+
+	clamp_ple_window_max();
+	ret = param_set_int(arg, kp);
+
+	return ret;
+}
+
+static struct kernel_param_ops ple_window_grow_ops = {
+	.set = set_ple_window_grow,
+	.get = param_get_int,
+};
+
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
-- 
2.0.4

