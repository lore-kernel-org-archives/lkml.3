Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab3LGAmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:42:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879Ab3LGAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:41:26 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-arch@vger.kernel.org, rostedt@goodmis.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, arnd@arndb.de, rusty@rustcorp.com.au,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 3/5] static_key: add static_key_slow_inc_deferred()
Date: Sat,  7 Dec 2013 01:40:04 +0100
Message-Id: <1386376806-924-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
References: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complement the static_key_slow_dec_deferred().
This avoids asymmetrical API, and prepares us for future optimizations
and bug fixes.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c                 | 7 ++++---
 include/linux/jump_label_ratelimit.h | 5 +++++
 kernel/events/core.c                 | 6 +++---
 kernel/jump_label.c                  | 7 +++++++
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5f01547..86973ac 100644
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
 
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index 112ba5f..a18aded 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -18,6 +18,7 @@ struct static_key_deferred {
 #endif
 
 #ifdef HAVE_JUMP_LABEL
+extern void static_key_slow_inc_deferred(struct static_key_deferred *key);
 extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void
 jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
@@ -26,6 +27,10 @@ jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 struct static_key_deferred {
 	struct static_key  key;
 };
+static inline void static_key_slow_inc_deferred(struct static_key_deferred *key)
+{
+	static_key_slow_inc(&key->key);
+}
 static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
 	STATIC_KEY_CHECK_USE();
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ee64d26..b3fb4c2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6597,7 +6597,7 @@ static void account_event(struct perf_event *event)
 		return;
 
 	if (event->attach_state & PERF_ATTACH_TASK)
-		static_key_slow_inc(&perf_sched_events.key);
+		static_key_slow_inc_deferred(&perf_sched_events);
 	if (event->attr.mmap || event->attr.mmap_data)
 		atomic_inc(&nr_mmap_events);
 	if (event->attr.comm)
@@ -6609,9 +6609,9 @@ static void account_event(struct perf_event *event)
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
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 02d610a..41592ba 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -74,6 +74,13 @@ void static_key_slow_inc(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
 
+void static_key_slow_inc_deferred(struct static_key_deferred *key)
+{
+	STATIC_KEY_CHECK_USE();
+	static_key_slow_inc(&key->key);
+}
+EXPORT_SYMBOL_GPL(static_key_slow_inc_deferred);
+
 static void __static_key_slow_dec(struct static_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
-- 
1.8.4.2

