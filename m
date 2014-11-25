Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKYQeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:34:06 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:48202
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaKYQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:34:01 -0500
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com,
        bp@suse.de, pbonzini@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/7] KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG ioctl
Date: Tue, 25 Nov 2014 16:10:01 +0000
Message-Id: <1416931805-23223-4-git-send-email-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
ioctl. Currently any operation flag will return EINVAL. Actual
functionality will be added with further patches.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>.

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7610eaa..2c6386e 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2570,7 +2570,7 @@ handled.
 4.87 KVM_SET_GUEST_DEBUG
 
 Capability: KVM_CAP_SET_GUEST_DEBUG
-Architectures: x86, s390, ppc
+Architectures: x86, s390, ppc, arm64
 Type: vcpu ioctl
 Parameters: struct kvm_guest_debug (in)
 Returns: 0 on success; -1 on error
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9e193c8..a0ff410 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -180,6 +180,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
 	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -302,7 +303,34 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	return -EINVAL;
+	/* If it's not enabled clear all flags */
+	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
+		vcpu->guest_debug = 0;
+		return 0;
+	}
+
+	vcpu->guest_debug = dbg->control;
+	kvm_info("%s: guest_debug is 0x%lx\n", __func__, vcpu->guest_debug);
+
+	/* Single Step */
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+		kvm_info("SS requested, not yet implemented\n");
+		return -EINVAL;
+	}
+
+	/* Software Break Points */
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
+		kvm_info("SW BP support requested, not yet implemented\n");
+		return -EINVAL;
+	}
+
+	/* Hardware assisted Break and Watch points */
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+		kvm_info("HW BP support requested, not yet implemented\n");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 
-- 
2.1.3

