Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab3EGEab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:30:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3EGEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:57 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BeX6n8KoOMYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TymciAGTofkA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=-cyeKQDD62-ZVCI4:21 a=oJRY0AgXXGG1ERsd:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035852.058901437@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [067/126] KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME
 (CVE-2013-1796)
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0067-KVM-x86-fix-for-buffer-overflow-in-handling-of-MSR_K.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

[ Upstream commit c300aa64ddf57d9c5d9c898a64b36877345dd4a9 ]

If the guest sets the GPA of the time_page so that the request to update the
time straddles a page then KVM will write onto an incorrect page.  The
write is done byusing kmap atomic to get a pointer to the page for the time
structure and then performing a memcpy to that page starting at an offset
that the guest controls.  Well behaved guests always provide a 32-byte aligned
address, however a malicious guest could use this to corrupt host kernel
memory.

Tested: Tested against kvmclock unit test.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/x86.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a201790..142e18a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1636,6 +1636,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		/* ...but clean it before doing the actual write */
 		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
 
+		/* Check that the address is 32-byte aligned. */
+		if (vcpu->arch.time_offset &
+				(sizeof(struct pvclock_vcpu_time_info) - 1))
+			break;
+
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
 
-- 
1.7.10.4


