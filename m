Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaJJRP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaJJRPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:15:48 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 2/2] KVM: x86: fix deadline tsc interrupt injection
Date: Fri, 10 Oct 2014 19:15:09 +0200
Message-Id: <1412961309-16485-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1412961309-16485-1-git-send-email-rkrcmar@redhat.com>
References: <1412961309-16485-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check in kvm_set_lapic_tscdeadline_msr() was trying to prevent a
situation where we lose a pending deadline timer in a MSR write.
Losing it is fine, because it effectively occurs before the timer fired,
so we should be able to cancel or postpone it.

Another problem comes from interaction with QEMU, or other userspace
that can set deadline MSR without a good reason, when timer is already
pending:  one guest's deadline request results in more than one
interrupt because one is injected immediately on MSR write from
userspace and one through hrtimer later.

The solution is to remove the injection when replacing a pending timer
and to improve the usual QEMU path, we inject without a hrtimer when the
deadline has already passed.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reported-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/lapic.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a3cf68b..8b30099 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1116,9 +1116,10 @@ static void start_apic_timer(struct kvm_lapic *apic)
 		if (likely(tscdeadline > guest_tsc)) {
 			ns = (tscdeadline - guest_tsc) * 1000000ULL;
 			do_div(ns, this_tsc_khz);
-		}
-		hrtimer_start(&apic->lapic_timer.timer,
-			ktime_add_ns(now, ns), HRTIMER_MODE_ABS);
+			hrtimer_start(&apic->lapic_timer.timer,
+				ktime_add_ns(now, ns), HRTIMER_MODE_ABS);
+		} else
+			apic_timer_expired(apic);
 
 		local_irq_restore(flags);
 	}
@@ -1375,9 +1376,6 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 		return;
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
-	/* Inject here so clearing tscdeadline won't override new value */
-	if (apic_has_pending_timer(vcpu))
-		kvm_inject_apic_timer_irqs(vcpu);
 	apic->lapic_timer.tscdeadline = data;
 	start_apic_timer(apic);
 }
-- 
2.1.0

