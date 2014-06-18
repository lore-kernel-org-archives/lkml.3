Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966688AbaFROTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:43 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:23258 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966617AbaFROTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiRMHFoQtBIo5mzqLbQ
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiRMHFoQtBIo5mzqLbQ
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034543"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 8/9] KVM: vmx: handle_cr ignores 32/64-bit mode
Date: Wed, 18 Jun 2014 17:19:25 +0300
Message-Id: <1403101166-23616-9-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
References: <539F059F.8050501@redhat.com>
 <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit mode only bits [31:0] of the CR should be used for setting the CR
value.  Otherwise, the host may incorrectly assume the value is invalid if bits
[63:32] are not zero.  Moreover, the CR is currently being read twice when CR8
is used.  Last, nested mov-cr exiting is modified to handle the CR value
correctly as well.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c0f53a0..cbfbb8b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5039,7 +5039,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_register_readl(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -5056,7 +5056,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 			return 1;
 		case 8: {
 				u8 cr8_prev = kvm_get_cr8(vcpu);
-				u8 cr8 = kvm_register_read(vcpu, reg);
+				u8 cr8 = (u8)val;
 				err = kvm_set_cr8(vcpu, cr8);
 				kvm_complete_insn_gp(vcpu, err);
 				if (irqchip_in_kernel(vcpu->kvm))
@@ -6751,7 +6751,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	int cr = exit_qualification & 15;
 	int reg = (exit_qualification >> 8) & 15;
-	unsigned long val = kvm_register_read(vcpu, reg);
+	unsigned long val = kvm_register_readl(vcpu, reg);
 
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-- 
1.9.1

