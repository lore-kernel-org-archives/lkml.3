Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaB0WBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:01:16 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52274 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaB0WBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:01:14 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kchamart@redhat.com, stefan.bader@canonical.com, bourgeois@bertin.fr,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] kvm, vmx: Really fix lazy FPU on nested guest
Date: Thu, 27 Feb 2014 23:01:06 +0100
Message-Id: <1393538466-7523-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e504c9098ed6 (kvm, vmx: Fix lazy FPU on nested guest, 2013-11-13)
highlighted a real problem, but the fix was subtly wrong.

nested_read_cr0 is the CR0 as read by L2, but here we want to look at
the CR0 value reflecting L1's setup.  In other words, L2 might think
that TS=0 (so nested_read_cr0 has the bit clear); but if L1 is actually
running it with TS=1, we should inject the fault into L1.

The effective value of CR0 in L2 is contained in vmcs12->guest_cr0, use
it.

Fixes: e504c9098ed6acd9e1079c5e10e4910724ad429f
Reported-by: Kashyap Chamarty <kchamart@redhat.com>
Reported-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Kashyap Chamarty <kchamart@redhat.com>
Tested-by: Anthoine Bourgeois <bourgeois@bertin.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a06f101ef64b..392752834751 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6688,7 +6688,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 		else if (is_page_fault(intr_info))
 			return enable_ept;
 		else if (is_no_device(intr_info) &&
-			 !(nested_read_cr0(vmcs12) & X86_CR0_TS))
+			 !(vmcs12->guest_cr0 & X86_CR0_TS))
 			return 0;
 		return vmcs12->exception_bitmap &
 				(1u << (intr_info & INTR_INFO_VECTOR_MASK));
-- 
1.8.3.1

