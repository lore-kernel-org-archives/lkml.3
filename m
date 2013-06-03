Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3FCWMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:12:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3FCWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:54 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BRGqQAGCMrgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fQe5NQbQZWQA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=2U8qucZEIwFwzPCZ3EIA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221152.326071406@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tomas Papan <tomas.papan@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [01/65] KVM: VMX: fix halt emulation while emulating invalid guest sate
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0001-KVM-VMX-fix-halt-emulation-while-emulating-invalid-g.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

[ Upstream commit 8d76c49e9ffeee839bc0b7a3278a23f99101263e ]

The invalid guest state emulation loop does not check halt_request
which causes 100% cpu loop while guest is in halt and in invalid
state, but more serious issue is that this leaves halt_request set, so
random instruction emulated by vm86 #GP exit can be interpreted
as halt which causes guest hang. Fix both problems by handling
halt_request in emulation loop.

Reported-by: Tomas Papan <tomas.papan@gmail.com>
Tested-by: Tomas Papan <tomas.papan@gmail.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/vmx.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ff66a3b..a0f8dc3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5030,6 +5030,12 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 			return 0;
 		}
 
+		if (vcpu->arch.halt_request) {
+			vcpu->arch.halt_request = 0;
+			ret = kvm_emulate_halt(vcpu);
+			goto out;
+		}
+
 		if (signal_pending(current))
 			goto out;
 		if (need_resched())
-- 
1.7.10.4


