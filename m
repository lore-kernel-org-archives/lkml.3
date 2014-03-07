Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaCGLnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:43:19 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55124 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaCGLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:43:15 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 6/7] KVM: svm: set/clear all DR intercepts in one swoop
Date: Fri,  7 Mar 2014 12:42:50 +0100
Message-Id: <1394192571-11056-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike other intercepts, debug register intercepts will be modified
in hot paths if the guest OS is bad or otherwise gets tricked into
doing so.

Avoid calling recalc_intercepts 16 times for debug registers.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 64d9bb9590e3..5ed67e9739f6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -303,20 +303,35 @@ static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb->control.intercept_cr & (1U << bit);
 }
 
-static inline void set_dr_intercept(struct vcpu_svm *svm, int bit)
+static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr |= (1U << bit);
+	vmcb->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
+		| (1 << INTERCEPT_DR1_READ)
+		| (1 << INTERCEPT_DR2_READ)
+		| (1 << INTERCEPT_DR3_READ)
+		| (1 << INTERCEPT_DR4_READ)
+		| (1 << INTERCEPT_DR5_READ)
+		| (1 << INTERCEPT_DR6_READ)
+		| (1 << INTERCEPT_DR7_READ)
+		| (1 << INTERCEPT_DR0_WRITE)
+		| (1 << INTERCEPT_DR1_WRITE)
+		| (1 << INTERCEPT_DR2_WRITE)
+		| (1 << INTERCEPT_DR3_WRITE)
+		| (1 << INTERCEPT_DR4_WRITE)
+		| (1 << INTERCEPT_DR5_WRITE)
+		| (1 << INTERCEPT_DR6_WRITE)
+		| (1 << INTERCEPT_DR7_WRITE);
 
 	recalc_intercepts(svm);
 }
 
-static inline void clr_dr_intercept(struct vcpu_svm *svm, int bit)
+static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr &= ~(1U << bit);
+	vmcb->control.intercept_dr = 0;
 
 	recalc_intercepts(svm);
 }
@@ -1080,23 +1095,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
 	set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 
-	set_dr_intercept(svm, INTERCEPT_DR0_READ);
-	set_dr_intercept(svm, INTERCEPT_DR1_READ);
-	set_dr_intercept(svm, INTERCEPT_DR2_READ);
-	set_dr_intercept(svm, INTERCEPT_DR3_READ);
-	set_dr_intercept(svm, INTERCEPT_DR4_READ);
-	set_dr_intercept(svm, INTERCEPT_DR5_READ);
-	set_dr_intercept(svm, INTERCEPT_DR6_READ);
-	set_dr_intercept(svm, INTERCEPT_DR7_READ);
-
-	set_dr_intercept(svm, INTERCEPT_DR0_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR1_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR2_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR3_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR4_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR5_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR6_WRITE);
-	set_dr_intercept(svm, INTERCEPT_DR7_WRITE);
+	set_dr_intercepts(svm);
 
 	set_exception_intercept(svm, PF_VECTOR);
 	set_exception_intercept(svm, UD_VECTOR);
-- 
1.8.3.1


