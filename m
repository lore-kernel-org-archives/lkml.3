Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbaEaXEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:04:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37642 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaEaXEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:04:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: kvm: x86.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 01:05:05 +0200
Message-Id: <1401577506-4112-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/kvm/x86.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20316c6..88bf642 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5691,13 +5691,17 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
 			(kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
 	}
-#ifdef CONFIG_X86_64
 	else {
+#ifdef CONFIG_X86_64
 		param = kvm_register_read(vcpu, VCPU_REGS_RCX);
 		ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
 		outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
-	}
+#else
+		param = 0;
+		ingpa = 0;
+		outgpa = 0;
 #endif
+	}
 
 	code = param & 0xffff;
 	fast = (param >> 16) & 0x1;
-- 
1.7.10.4

