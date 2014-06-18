Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaFRSqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:46:07 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34124 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaFRSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:46:04 -0400
Date: Wed, 18 Jun 2014 14:46:01 -0400
From: "Gabriel L. Somlo" <gsomlo@gmail.com>
To: Eric Northup <digitaleric@google.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        gleb@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, joro@8bytes.org, mst@redhat.com,
        agraf@suse.de
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
Message-ID: <20140618184601.GE1695@ERROL.INI.CMU.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 10:59:14AM -0700, Eric Northup wrote:
> On Wed, Jun 18, 2014 at 7:19 AM, Nadav Amit <namit@cs.technion.ac.il> wrote:
> > mwait and monitor are currently handled as nop. Considering this behavior, they
> > should still be handled correctly, i.e., check execution conditions and generate
> > exceptions when required. mwait and monitor may also be executed in real-mode
> > and are not handled in that case.  This patch performs the emulation of
> > monitor-mwait according to Intel SDM (other than checking whether interrupt can
> > be used as a break event).
> >
> > Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>

How about this instead (details in the commit log below) ? Please let
me know what you think, and if you'd prefer me to send it out as a
separate patch rather than a reply to this thread.

Thanks,
--Gabriel


>From 0375a0aceb54cdbc26a6c0e5b43c46324f830ec3 Mon Sep 17 00:00:00 2001
From: "Gabriel L. Somlo" <somlo@cmu.edu>
Date: Wed, 18 Jun 2014 14:39:15 -0400
Subject: [PATCH] kvm: x86: revert "emulate monitor and mwait instructions as nop"

This reverts commit 87c00572ba05aa8c9db118da75c608f47eb10b9e.

OS X <= 10.7.* are the only known guests which realistically required
this functionality. As it turns out, OS X can be told to forego using
monitor/mwait by passing it "idlehalt=0" as a kernel argument, so we're
better off removing this hack from KVM altogether.

Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>
---
 arch/x86/kvm/cpuid.c |  2 --
 arch/x86/kvm/svm.c   |  8 +++-----
 arch/x86/kvm/vmx.c   | 10 ++++------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 38a0afe..17b42fa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -283,8 +283,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
 	/* cpuid 1.ecx */
 	const u32 kvm_supported_word4_x86_features =
-		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
-		 * but *not* advertised to guests via CPUID ! */
 		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec8366c..0e8ef20 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3274,7 +3274,7 @@ static int pause_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int nop_interception(struct vcpu_svm *svm)
+static int invalid_op_interception(struct vcpu_svm *svm)
 {
 	skip_emulated_instruction(&(svm->vcpu));
 	return 1;
@@ -3282,14 +3282,12 @@ static int nop_interception(struct vcpu_svm *svm)
 
 static int monitor_interception(struct vcpu_svm *svm)
 {
-	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
-	return nop_interception(svm);
+	return invalid_op_interception(svm);
 }
 
 static int mwait_interception(struct vcpu_svm *svm)
 {
-	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
-	return nop_interception(svm);
+	return invalid_op_interception(svm);
 }
 
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332e..577c7df 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5672,22 +5672,20 @@ static int handle_pause(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_nop(struct kvm_vcpu *vcpu)
+static int handle_invalid_op(struct kvm_vcpu *vcpu)
 {
-	skip_emulated_instruction(vcpu);
+	kvm_queue_exception(vcpu, UD_VECTOR);
 	return 1;
 }
 
 static int handle_mwait(struct kvm_vcpu *vcpu)
 {
-	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
-	return handle_nop(vcpu);
+	return handle_invalid_op(vcpu);
 }
 
 static int handle_monitor(struct kvm_vcpu *vcpu)
 {
-	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
-	return handle_nop(vcpu);
+	return handle_invalid_op(vcpu);
 }
 
 /*
-- 
1.9.3

