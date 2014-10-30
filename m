Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbaJ3OJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760163AbaJ3OI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:08:57 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3/3] KVM: x86: optimize some accesses to LVTT and SPIV
Date: Thu, 30 Oct 2014 15:06:47 +0100
Message-Id: <1414678007-9377-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
References: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We mirror a subset of these registers in separate variables.
Using them directly should be faster.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 10 +++-------
 arch/x86/kvm/lapic.h |  6 +++---
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d3a3a1c..67af5d2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -239,21 +239,17 @@ static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
 
 static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
 {
-	return ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		apic->lapic_timer.timer_mode_mask) == APIC_LVT_TIMER_ONESHOT);
+	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_ONESHOT;
 }
 
 static inline int apic_lvtt_period(struct kvm_lapic *apic)
 {
-	return ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		apic->lapic_timer.timer_mode_mask) == APIC_LVT_TIMER_PERIODIC);
+	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_PERIODIC;
 }
 
 static inline int apic_lvtt_tscdeadline(struct kvm_lapic *apic)
 {
-	return ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		apic->lapic_timer.timer_mode_mask) ==
-			APIC_LVT_TIMER_TSCDEADLINE);
+	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_TSCDEADLINE;
 }
 
 static inline int apic_lvt_nmi_mode(u32 lvt_val)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 755a954..2c56885 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -121,11 +121,11 @@ static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
 
 extern struct static_key_deferred apic_sw_disabled;
 
-static inline int kvm_apic_sw_enabled(struct kvm_lapic *apic)
+static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
 {
 	if (static_key_false(&apic_sw_disabled.key))
-		return kvm_apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_APIC_ENABLED;
-	return APIC_SPIV_APIC_ENABLED;
+		return apic->sw_enabled;
+	return true;
 }
 
 static inline bool kvm_apic_present(struct kvm_vcpu *vcpu)
-- 
2.1.0

