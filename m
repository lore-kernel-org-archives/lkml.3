Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaIDOM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:12:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54596 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaIDOMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:12:25 -0400
Message-ID: <54087343.5050409@redhat.com>
Date: Thu, 04 Sep 2014 16:12:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@cloudius-systems.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jroedel@suse.de,
        agraf@suse.de, valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        avi@cloudius-systems.com
Subject: Re: [PATCH 3/4] KVM: x86: inject nested page faults on emulated instructions
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <1409670830-14544-4-git-send-email-pbonzini@redhat.com> <20140904070220.GL9842@cloudius-systems.com>
In-Reply-To: <20140904070220.GL9842@cloudius-systems.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2014 09:02, Gleb Natapov ha scritto:
> On Tue, Sep 02, 2014 at 05:13:49PM +0200, Paolo Bonzini wrote:
>> > This is required for the following patch to work correctly.  If a nested page
>> > fault happens during emulation, we must inject a vmexit, not a page fault.
>> > Luckily we already have the required machinery: it is enough to return
>> > X86EMUL_INTERCEPTED instead of X86EMUL_PROPAGATE_FAULT.
>> > 
> I wonder why this patch is needed. X86EMUL_PROPAGATE_FAULT causes
> ctxt->have_exception to be set to true in x86_emulate_insn().
> x86_emulate_instruction() checks ctxt->have_exception and calls
> inject_emulated_exception() if it is true. inject_emulated_exception()
> calls kvm_propagate_fault() where we check if the fault was nested and
> generate vmexit or a page fault accordingly.

Good question. :)

If you do that, KVM gets down to the "if (writeback)" and writes the 
ctxt->eip from L2 into the L1 EIP.

Possibly this patch can be replaced by just this?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 022513b..475e979 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5312,7 +5312,7 @@ restart:
 
        if (ctxt->have_exception) {
                inject_emulated_exception(vcpu);
-               r = EMULATE_DONE;
+               return EMULATE_DONE;
        } else if (vcpu->arch.pio.count) {
                if (!vcpu->arch.pio.in) {
                        /* FIXME: return into emulator if single-stepping.  */

But I'm not sure how to test it, and I like the idea of treating nested page
faults like other nested vmexits during emulation (which is what this patch
does).

If I included this patch, I could then remove kvm_propagate_fault
like (I think) this:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92493e10937c..e096db566ac2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4910,9 +4902,10 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
-	if (ctxt->exception.vector == PF_VECTOR)
-		kvm_propagate_fault(vcpu, &ctxt->exception);
-	else if (ctxt->exception.error_code_valid)
+	if (ctxt->exception.vector == PF_VECTOR) {
+		WARN_ON(fault->nested_page_fault);
+		vcpu->arch.walk_mmu->inject_page_fault(vcpu, fault);
+	} else if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
 				      ctxt->exception.error_code);
 	else

What do you think?

Paolo
