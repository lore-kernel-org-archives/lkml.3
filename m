Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaKYQgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:36:03 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:48203
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaKYQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:34:05 -0500
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com,
        bp@suse.de, pbonzini@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/7] KVM: arm: guest debug, define API headers
Date: Tue, 25 Nov 2014 16:10:00 +0000
Message-Id: <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
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

This commit defines the API headers for guest debugging. There are two
architecture specific debug structures:

  - kvm_guest_debug_arch, allows us to pass in HW debug registers
  - kvm_debug_exit_arch, signals the exact debug exit and address

The type of debugging being used is control by the architecture specific
control bits of the kvm_guest_debug->control flags in the ioctl
structure.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8e38878..de2450c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -93,10 +93,30 @@ struct kvm_sregs {
 struct kvm_fpu {
 };
 
+/* See ARM ARM D7.3: Debug Registers
+ *
+ * The control registers are stored as 64bit values as the setup code
+ * is shared with the normal cpu context restore code in hyp.S which
+ * is 64 bit only.
+ */
+#define KVM_ARM_NDBG_REGS 16
 struct kvm_guest_debug_arch {
+	__u64 dbg_bcr[KVM_ARM_NDBG_REGS];
+	__u64 dbg_bvr[KVM_ARM_NDBG_REGS];
+	__u64 dbg_wcr[KVM_ARM_NDBG_REGS];
+	__u64 dbg_wvr[KVM_ARM_NDBG_REGS];
 };
 
+/* Exit types which define why we did a debug exit */
+#define KVM_DEBUG_EXIT_ERROR		0x0
+#define KVM_DEBUG_EXIT_SINGLE_STEP	0x1
+#define KVM_DEBUG_EXIT_SW_BKPT		0x2
+#define KVM_DEBUG_EXIT_HW_BKPT		0x3
+#define KVM_DEBUG_EXIT_HW_WTPT		0x4
+
 struct kvm_debug_exit_arch {
+	__u64 address;
+	__u32 exit_type;
 };
 
 struct kvm_sync_regs {
@@ -198,4 +218,12 @@ struct kvm_arch_memory_slot {
 
 #endif
 
+/* Architecture related debug defines - upper 16 bits of
+ * kvm_guest_debug->control
+ */
+#define KVM_GUESTDBG_USE_SW_BP_SHIFT	16
+#define KVM_GUESTDBG_USE_SW_BP		(1 << KVM_GUESTDBG_USE_SW_BP_SHIFT)
+#define KVM_GUESTDBG_USE_HW_BP_SHIFT	17
+#define KVM_GUESTDBG_USE_HW_BP		(1 << KVM_GUESTDBG_USE_HW_BP_SHIFT)
+
 #endif /* __ARM_KVM_H__ */
-- 
2.1.3

