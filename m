Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3JQKR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab3JQKRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:17:54 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        kvm@vger.kernel.org
Subject: [PATCH 4/7] static_key: use static_key_slow_inc_deferred()
Date: Thu, 17 Oct 2013 12:10:27 +0200
Message-Id: <1382004631-25895-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple replacement where possible.
Saves us problematic access to the structure and allows optimalizations
and bug fixes to take place.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 7 ++++---
 kernel/events/core.c | 6 +++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5439117..eff85f6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -121,7 +121,7 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 		if (val & APIC_SPIV_APIC_ENABLED)
 			static_key_slow_dec_deferred(&apic_sw_disabled);
 		else
-			static_key_slow_inc(&apic_sw_disabled.key);
+			static_key_slow_inc_deferred(&apic_sw_disabled);
 	}
 	apic_set_reg(apic, APIC_SPIV, val);
 }
@@ -1351,7 +1351,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		if (value & MSR_IA32_APICBASE_ENABLE)
 			static_key_slow_dec_deferred(&apic_hw_disabled);
 		else
-			static_key_slow_inc(&apic_hw_disabled.key);
+			static_key_slow_inc_deferred(&apic_hw_disabled);
 		recalculate_apic_map(vcpu->kvm);
 	}
 
@@ -1546,7 +1546,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	kvm_lapic_set_base(vcpu,
 			APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE);
 
-	static_key_slow_inc(&apic_sw_disabled.key); /* sw disabled at reset */
+	/* sw disabled at reset */
+	static_key_slow_inc_deferred(&apic_sw_disabled);
 	kvm_lapic_reset(vcpu);
 	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d49a9d2..ade89a1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6565,7 +6565,7 @@ static void account_event(struct perf_event *event)
 		return;
 
 	if (event->attach_state & PERF_ATTACH_TASK)
-		static_key_slow_inc(&perf_sched_events.key);
+		static_key_slow_inc_deferred(&perf_sched_events);
 	if (event->attr.mmap || event->attr.mmap_data)
 		atomic_inc(&nr_mmap_events);
 	if (event->attr.comm)
@@ -6577,9 +6577,9 @@ static void account_event(struct perf_event *event)
 			tick_nohz_full_kick_all();
 	}
 	if (has_branch_stack(event))
-		static_key_slow_inc(&perf_sched_events.key);
+		static_key_slow_inc_deferred(&perf_sched_events);
 	if (is_cgroup_event(event))
-		static_key_slow_inc(&perf_sched_events.key);
+		static_key_slow_inc_deferred(&perf_sched_events);
 
 	account_event_cpu(event, event->cpu);
 }
-- 
1.8.3.1

