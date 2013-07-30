Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3G3PLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:11:48 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43263 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G3PLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:11:45 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: rename EMULATE_DO_MMIO
Date: Tue, 30 Jul 2013 17:11:34 +0200
Message-Id: <1375197096-2454-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
References: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch will reuse it for other userspace exits than MMIO,
namely debug events.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/mmu.c              | 2 +-
 arch/x86/kvm/vmx.c              | 2 +-
 arch/x86/kvm/x86.c              | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1f98c1b..b33e9dc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -795,8 +795,8 @@ extern u32  kvm_min_guest_tsc_khz;
 extern u32  kvm_max_guest_tsc_khz;
 
 enum emulation_result {
-	EMULATE_DONE,       /* no further processing */
-	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
+	EMULATE_DONE,         /* no further processing */
+	EMULATE_USER_EXIT,    /* kvm_run ready for userspace exit */
 	EMULATE_FAIL,         /* can't emulate this instruction */
 };
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6941fa7..7ee30d4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4096,7 +4096,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
 	switch (er) {
 	case EMULATE_DONE:
 		return 1;
-	case EMULATE_DO_MMIO:
+	case EMULATE_USER_EXIT:
 		++vcpu->stat.mmio_exits;
 		/* fall through */
 	case EMULATE_FAIL:
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 260a919..0c87015 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5422,7 +5422,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		err = emulate_instruction(vcpu, EMULTYPE_NO_REEXECUTE);
 
-		if (err == EMULATE_DO_MMIO) {
+		if (err == EMULATE_USER_EXIT) {
 			ret = 0;
 			goto out;
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 737c804..c2a0674 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5038,11 +5038,11 @@ restart:
 			writeback = false;
 			vcpu->arch.complete_userspace_io = complete_emulated_pio;
 		}
-		r = EMULATE_DO_MMIO;
+		r = EMULATE_USER_EXIT;
 	} else if (vcpu->mmio_needed) {
 		if (!vcpu->mmio_is_write)
 			writeback = false;
-		r = EMULATE_DO_MMIO;
+		r = EMULATE_USER_EXIT;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
 	} else if (r == EMULATION_RESTART)
 		goto restart;
-- 
1.8.1.4


