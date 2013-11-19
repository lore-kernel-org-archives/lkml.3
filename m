Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3KSOy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:54:27 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39496 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3KSOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:54:08 -0500
From: Dan Aloni <alonid@stratoscale.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com,
        Muli Ben-Yehuda <muli@stratoscale.com>
Subject: [PATCH linux-next 2/2] kvm-x86: emulator: disable kgdb-x86 on fastop and fpe flush
Date: Tue, 19 Nov 2013 16:53:30 +0200
Message-Id: <1384872810-29492-3-git-send-email-alonid@stratoscale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
References: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have seen that when kvm-unit-tests runs with kgdb enabled, the
kernel halts on the debugger during the KVM x86 instruction emulation
that performs a test of a division by zero, and also during fwait.

This patch adds calls that temporarily disable the debugger trap.

Signed-off-by: Dan Aloni <alonid@stratoscale.com>
Signed-off-by: Muli Ben-Yehuda <muli@stratoscale.com>
---
 arch/x86/kvm/emulate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 07ffca0..05e8509 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -24,6 +24,7 @@
 #include "kvm_cache_regs.h"
 #include <linux/module.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kgdb.h>
 #include <linux/stringify.h>
 
 #include "x86.h"
@@ -4438,6 +4439,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 {
 	bool fault = false;
 
+	kgdb_ll_local_disable();
 	ctxt->ops->get_fpu(ctxt);
 	asm volatile("1: fwait \n\t"
 		     "2: \n\t"
@@ -4449,6 +4451,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 		     _ASM_EXTABLE(1b, 3b)
 		     : [fault]"+qm"(fault));
 	ctxt->ops->put_fpu(ctxt);
+	kgdb_ll_local_enable();
 
 	if (unlikely(fault))
 		return emulate_exception(ctxt, MF_VECTOR, 0, false);
@@ -4468,10 +4471,14 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
 	if (!(ctxt->d & ByteOp))
 		fop += __ffs(ctxt->dst.bytes) * FASTOP_SIZE;
+
+	kgdb_ll_local_disable();
 	asm("push %[flags]; popf; call *%[fastop]; pushf; pop %[flags]\n"
 	    : "+a"(ctxt->dst.val), "+d"(ctxt->src.val), [flags]"+D"(flags),
 	      [fastop]"+S"(fop)
 	    : "c"(ctxt->src2.val));
+	kgdb_ll_local_enable();
+
 	ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
 	if (!fop) /* exception is returned in fop variable */
 		return emulate_de(ctxt);
-- 
1.8.3.1

