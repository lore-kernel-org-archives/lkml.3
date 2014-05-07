Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaEGMdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:33:08 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:24967 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:33:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjWYIZAeEPwSKApo1izKBagkX
X-IPAS-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjWYIZAeEPwSKApo1izKBagkX
X-IronPort-AV: E=Sophos;i="4.97,1003,1389736800"; 
   d="scan'208";a="105236353"
From: Nadav Amit <namit@cs.technion.ac.il>
To: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/5] KVM: vmx: handle_dr does not handle RSP correctly
Date: Wed,  7 May 2014 15:32:49 +0300
Message-Id: <1399465972-4026-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RSP register is not automatically cached, causing mov DR instruction with
RSP to fail.  Instead the regular register accessing interface should be used.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 72b8012..0e2793f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5142,7 +5142,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			return 1;
 		kvm_register_write(vcpu, reg, val);
 	} else
-		if (kvm_set_dr(vcpu, dr, vcpu->arch.regs[reg]))
+		if (kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg)))
 			return 1;
 
 	skip_emulated_instruction(vcpu);
-- 
1.9.1

