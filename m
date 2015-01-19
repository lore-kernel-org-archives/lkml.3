Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbASQpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:45:34 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36645 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbASQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:45:30 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v8 2/5] KVM: introduce kvm_arch_intc_initialized and use it in irqfd
Date: Mon, 19 Jan 2015 17:43:10 +0100
Message-Id: <1421685793-3547-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
References: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce __KVM_HAVE_ARCH_INTC_INITIALIZED define and
associated kvm_arch_intc_initialized function. This latter
allows to test whether the virtual interrupt controller is initialized
and ready to accept virtual IRQ injection. On some architectures,
the virtual interrupt controller is dynamically instantiated, justifying
that kind of check.

The new function can now be used by irqfd to check whether the
virtual interrupt controller is ready on KVM_IRQFD request. If not,
KVM_IRQFD returns -EAGAIN.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

---
v7 -> v8:
- correct typo in comment
- add Andre's Reviewed-by

v6 -> v7:
- From now on, kvm_irqfd_assign calls kvm_arch_intc_initialized
  (previously introduced in subsequent patch file).
- add Christoffer's ack

v5 -> v6:
- rename function name and macro
- add kvm_arch_intc_initialized declaration in case the archi defines
  the macro
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 virt/kvm/eventfd.c       |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 26f1060..7f5858d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -706,6 +706,20 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 #endif
 }
 
+#ifdef __KVM_HAVE_ARCH_INTC_INITIALIZED
+/*
+ * returns true if the virtual interrupt controller is initialized and
+ * ready to accept virtual IRQ. On some architectures the virtual interrupt
+ * controller is dynamically instantiated and this is not always true.
+ */
+bool kvm_arch_intc_initialized(struct kvm *kvm);
+#else
+static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
+{
+	return true;
+}
+#endif
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 148b239..fc5f43e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -311,6 +311,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	unsigned int events;
 	int idx;
 
+	if (!kvm_arch_intc_initialized(kvm))
+		return -EAGAIN;
+
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
 	if (!irqfd)
 		return -ENOMEM;
-- 
1.9.1

