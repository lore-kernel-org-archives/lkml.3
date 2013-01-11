Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3AKONJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:13:09 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:47382 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab3AKONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:13:07 -0500
Message-ID: <50F01DEA.6000005@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 22:12:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 6/5] KVM: x86: clear write_fault_to_shadow_pgtable explicitly
References: <50EBBE54.1040007@linux.vnet.ibm.com> <50EBBEEC.2060100@linux.vnet.ibm.com> <20130110173036.GB24703@amt.cnet> <50EF056B.4040803@linux.vnet.ibm.com> <20130111131511.GA18558@amt.cnet>
In-Reply-To: <20130111131511.GA18558@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011114-3864-0000-0000-0000065D48DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 09:15 PM, Marcelo Tosatti wrote:

> 
> This is cryptic. Its not obvious at all for someone modifying the code, 
> for example.
> 
> Can you please clear it explicitly? 

Sure, this is the patch to apply your idea, is it good to you? :)

============================================
Subject: [PATCH 6/6] KVM: x86: clear write_fault_to_shadow_pgtable explicitly

Clear it explicitly when exiting x86_emulate_instruction to clarify the code,
it is suggested by Marcelo

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2957012..89d01a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4753,7 +4753,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 	return r;
 }

-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2)
+static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
+				  bool write_fault_to_shadow_pgtable)
 {
 	gpa_t gpa = cr2;
 	pfn_t pfn;
@@ -4816,7 +4817,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2)
 	 * be fixed by unprotecting shadow page and it should
 	 * be reported to userspace.
 	 */
-	return !vcpu->arch.write_fault_to_shadow_pgtable;
+	return !write_fault_to_shadow_pgtable;
 }

 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
@@ -4875,7 +4876,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	int r;
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	bool writeback = true;
+	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;

+	/*
+	 * Clear write_fault_to_shadow_pgtable here to ensure it is
+	 * never reused.
+	 */
+	vcpu->arch.write_fault_to_shadow_pgtable = false;
 	kvm_clear_exception_queue(vcpu);

 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
@@ -4894,7 +4901,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		if (r != EMULATION_OK)  {
 			if (emulation_type & EMULTYPE_TRAP_UD)
 				return EMULATE_FAIL;
-			if (reexecute_instruction(vcpu, cr2))
+			if (reexecute_instruction(vcpu, cr2,
+						  write_fault_to_spt))
 				return EMULATE_DONE;
 			if (emulation_type & EMULTYPE_SKIP)
 				return EMULATE_FAIL;
@@ -4924,7 +4932,7 @@ restart:
 		return EMULATE_DONE;

 	if (r == EMULATION_FAILED) {
-		if (reexecute_instruction(vcpu, cr2))
+		if (reexecute_instruction(vcpu, cr2, write_fault_to_spt))
 			return EMULATE_DONE;

 		return handle_emulation_failure(vcpu);
-- 
1.7.7.6


