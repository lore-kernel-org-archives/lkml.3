Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaHEKgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:36:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39753 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaHEKgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:36:09 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: agraf@suse.de, kvm@vger.kernel.org, linux-next@vger.kernel.org,
        kvm-ppc@vger.kernel.org, sfr@canb.auug.org.au
Subject: [PATCH] KVM: PPC: drop duplicate tracepoint
Date: Tue,  5 Aug 2014 12:35:56 +0200
Message-Id: <1407234956-743-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 29577fc00ba4 ("KVM: PPC: HV: Remove generic instruction emulation")
caused a build failure:

arch/powerpc/kvm/kvm-pr.o:(__tracepoints+0xa8): multiple definition of `__tracepoint_kvm_ppc_instr'
arch/powerpc/kvm/kvm.o:(__tracepoints+0x1c0): first defined here

due to a duplicate definition of the tracepoint in trace.h and
trace_pr.h.  Because the tracepoint is still used by Book3S HV
code, and because the PR code does include trace.h, just remove
the duplicate definition from trace_pr.h, and export it from
kvm.o.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/emulate.c  |  2 ++
 arch/powerpc/kvm/trace_pr.h | 20 --------------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index e96b50d0bdab..2325168ad1ff 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -300,3 +300,5 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	return emulated;
 }
 EXPORT_SYMBOL_GPL(kvmppc_emulate_instruction);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);
diff --git a/arch/powerpc/kvm/trace_pr.h b/arch/powerpc/kvm/trace_pr.h
index a674f090dfb8..e1357cd8dc1f 100644
--- a/arch/powerpc/kvm/trace_pr.h
+++ b/arch/powerpc/kvm/trace_pr.h
@@ -291,26 +291,6 @@ TRACE_EVENT(kvm_unmap_hva,
 	TP_printk("unmap hva 0x%lx\n", __entry->hva)
 );
 
-TRACE_EVENT(kvm_ppc_instr,
-	TP_PROTO(unsigned int inst, unsigned long _pc, unsigned int emulate),
-	TP_ARGS(inst, _pc, emulate),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	inst		)
-		__field(	unsigned long,	pc		)
-		__field(	unsigned int,	emulate		)
-	),
-
-	TP_fast_assign(
-		__entry->inst		= inst;
-		__entry->pc		= _pc;
-		__entry->emulate	= emulate;
-	),
-
-	TP_printk("inst %u pc 0x%lx emulate %u\n",
-		  __entry->inst, __entry->pc, __entry->emulate)
-);
-
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
-- 
1.8.3.1

