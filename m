Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaIKJvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:51:24 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57111 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaIKJvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:51:20 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: gleb@kernel.org
Subject: [PATCH] KVM: x86: make apic_accept_irq tracepoint more generic
Date: Thu, 11 Sep 2014 11:51:13 +0200
Message-Id: <1410429073-24014-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially the tracepoint was added only to the APIC_DM_FIXED case,
also because it reported coalesced interrupts that only made sense
for that case.  However, the coalesced argument is not used anymore
and tracing other delivery modes is useful, so hoist the call out
of the switch statement.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c |  4 ++--
 arch/x86/kvm/trace.h | 11 ++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fb919c574e23..b8345dd41b25 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -709,6 +709,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	int result = 0;
 	struct kvm_vcpu *vcpu = apic->vcpu;
 
+	trace_kvm_apic_accept_irq(vcpu->vcpu_id, delivery_mode,
+				  trig_mode, vector);
 	switch (delivery_mode) {
 	case APIC_DM_LOWEST:
 		vcpu->arch.apic_arb_prio++;
@@ -730,8 +732,6 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
 		}
-		trace_kvm_apic_accept_irq(vcpu->vcpu_id, delivery_mode,
-					  trig_mode, vector, false);
 		break;
 
 	case APIC_DM_REMRD:
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4c2868f36808..6b06ab8748dd 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -415,15 +415,14 @@ TRACE_EVENT(kvm_apic_ipi,
 );
 
 TRACE_EVENT(kvm_apic_accept_irq,
-	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec, bool coalesced),
-	    TP_ARGS(apicid, dm, tm, vec, coalesced),
+	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec),
+	    TP_ARGS(apicid, dm, tm, vec),
 
 	TP_STRUCT__entry(
 		__field(	__u32,		apicid		)
 		__field(	__u16,		dm		)
 		__field(	__u8,		tm		)
 		__field(	__u8,		vec		)
-		__field(	bool,		coalesced	)
 	),
 
 	TP_fast_assign(
@@ -431,14 +430,12 @@ TRACE_EVENT(kvm_apic_accept_irq,
 		__entry->dm		= dm;
 		__entry->tm		= tm;
 		__entry->vec		= vec;
-		__entry->coalesced	= coalesced;
 	),
 
-	TP_printk("apicid %x vec %u (%s|%s)%s",
+	TP_printk("apicid %x vec %u (%s|%s)",
 		  __entry->apicid, __entry->vec,
 		  __print_symbolic((__entry->dm >> 8 & 0x7), kvm_deliver_mode),
-		  __entry->tm ? "level" : "edge",
-		  __entry->coalesced ? " (coalesced)" : "")
+		  __entry->tm ? "level" : "edge")
 );
 
 TRACE_EVENT(kvm_eoi,
-- 
1.8.3.1

