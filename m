Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbaJ3OI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760163AbaJ3OIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:08:54 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/3] KVM: x86: detect LVTT changes under APICv
Date: Thu, 30 Oct 2014 15:06:46 +0100
Message-Id: <1414678007-9377-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
References: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APICv traps register writes, so we can't retrieve previous value and
omit timer cancelation when mode changes.

timer_mode_mask shouldn't be changing as it depends on cpuid.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
#define assign(a, b) (a == b ? false : (a = b, true))

 arch/x86/kvm/lapic.c | 12 ++++++++----
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f538b14..d3a3a1c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1205,17 +1205,20 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 		break;
 
-	case APIC_LVTT:
-		if ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		    apic->lapic_timer.timer_mode_mask) !=
-		   (val & apic->lapic_timer.timer_mode_mask))
+	case APIC_LVTT: {
+		u32 timer_mode = val & apic->lapic_timer.timer_mode_mask;
+
+		if (apic->lapic_timer.timer_mode != timer_mode) {
+			apic->lapic_timer.timer_mode = timer_mode;
 			hrtimer_cancel(&apic->lapic_timer.timer);
+		}
 
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
 		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
 		apic_set_reg(apic, APIC_LVTT, val);
 		break;
+	}
 
 	case APIC_TMICT:
 		if (apic_lvtt_tscdeadline(apic))
@@ -1449,6 +1452,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < APIC_LVT_NUM; i++)
 		apic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+	apic->lapic_timer.timer_mode = 0;
 	apic_set_reg(apic, APIC_LVT0,
 		     SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 5fcc3d3..755a954 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -11,6 +11,7 @@
 struct kvm_timer {
 	struct hrtimer timer;
 	s64 period; 				/* unit: ns */
+	u32 timer_mode;
 	u32 timer_mode_mask;
 	u64 tscdeadline;
 	atomic_t pending;			/* accumulated triggered timers */
-- 
2.1.0

