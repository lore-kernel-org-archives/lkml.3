Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaGHEaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaGHEad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:30:33 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@kernel.org>
Subject: [PATCH] KVM: x86: Check for nested events if there is an injectable interrupt
Date: Tue, 08 Jul 2014 00:30:23 -0400
Message-ID: <jpgd2dgfp5s.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With commit b6b8a1451fc40412c57d1 that introduced
vmx_check_nested_events, checks for injectable interrupts happen
at different points in time for L1 and L2 that could potentially
cause a race. The regression occurs because KVM_REQ_EVENT is always
set when nested_run_pending is set even if there's no pending interrupt.
Consequently, there could be a small window when check_nested_events
returns without exiting to L1, but an interrupt comes through soon
after and it incorrectly, gets injected to L2 by inject_pending_event
Fix this by adding a call to check for nested events too when a check
for injectable interrupt returns true

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 73537ec..56327a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5907,6 +5907,19 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 			kvm_x86_ops->set_nmi(vcpu);
 		}
 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
+		/*
+		 * TODO/FIXME: We are calling check_nested_events again
+		 * here to avoid a race condition. We should really be
+		 * setting KVM_REQ_EVENT only on certain events
+		 * and not unconditionally.
+		 * See https://lkml.org/lkml/2014/7/2/60 for discussion
+		 * about this proposal and current concerns
+		 */
+		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
+			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+			if (r != 0)
+				return r;
+		}
 		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
 					    false);
-- 
1.8.3.1

