Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaDDDls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:41:48 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:49223 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaDDDlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:41:45 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 23:41:45 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0FACUSPlOERM5e/2dsb2JhbABXgwYBvU+HPIEfFnSCU1KBPxKHeckXhksXjnGEPwSJVKFGgzM6
X-IPAS-Result: Ak0FACUSPlOERM5e/2dsb2JhbABXgwYBvU+HPIEfFnSCU1KBPxKHeckXhksXjnGEPwSJVKFGgzM6
X-IronPort-AV: E=Sophos;i="4.97,792,1389736800"; 
   d="scan'208";a="101311325"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Fix page-tables reserved bits
Date: Fri,  4 Apr 2014 06:31:04 +0300
Message-Id: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM does not handle the reserved bits of x86 page tables correctly:
In PAE, bits 5:8 are reserved in the PDPTE.
In IA-32e, bit 8 is not reserved.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f5704d9..3993976 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3538,7 +3538,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 	case PT32E_ROOT_LEVEL:
 		context->rsvd_bits_mask[0][2] =
 			rsvd_bits(maxphyaddr, 63) |
-			rsvd_bits(7, 8) | rsvd_bits(1, 2);	/* PDPTE */
+			rsvd_bits(5, 8) | rsvd_bits(1, 2);	/* PDPTE */
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 62);	/* PDE */
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
@@ -3550,9 +3550,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 		break;
 	case PT64_ROOT_LEVEL:
 		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
+			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
 		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
+			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
-- 
1.7.10.4

