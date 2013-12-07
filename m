Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161330Ab3LGAlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:41:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758836Ab3LGAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:41:26 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-arch@vger.kernel.org, rostedt@goodmis.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, arnd@arndb.de, rusty@rustcorp.com.au,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 1/5] static_key: add a section for deferred keys
Date: Sat,  7 Dec 2013 01:40:02 +0100
Message-Id: <1386376806-924-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
References: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to know about all deferred keys if we want to correctly
 - initialize timers on kernel init/module load
 - destroy pending timers when unloading a module

We depend on section attribute, so direct definitions of struct
static_key_deferred should be avoided, which is suboptimal.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
More general solution would use compile-time magic to generate an array
of pointers to deferred structures, but I am not sure if it is
acceptable and possible.

Worse approach added an unload_callback_list to the struct module.
Callbacks of type void (*)(void *) were registered on
static_key_rate_limit(), to cancel the deferred key work from
module_unload_free().
(I have patches for this)

Jump labels are already notified for module changes, so we could keep track of
deferred keys in modules there, using a static global tree.
(in the worst case)

 arch/x86/kvm/lapic.c                 | 4 ++--
 arch/x86/kvm/lapic.h                 | 4 ++--
 include/asm-generic/vmlinux.lds.h    | 1 +
 include/linux/jump_label_ratelimit.h | 4 ++++
 include/linux/module.h               | 3 +++
 include/linux/perf_event.h           | 2 +-
 kernel/events/core.c                 | 2 +-
 kernel/module.c                      | 4 ++++
 8 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5439117..5f01547 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -112,8 +112,8 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
-struct static_key_deferred apic_hw_disabled __read_mostly;
-struct static_key_deferred apic_sw_disabled __read_mostly;
+static_key_deferred(apic_hw_disabled);
+static_key_deferred(apic_sw_disabled);
 
 static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c730ac9..4ae9a7a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -108,7 +108,7 @@ static inline bool kvm_vcpu_has_lapic(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-extern struct static_key_deferred apic_hw_disabled;
+extern static_key_deferred(apic_hw_disabled);
 
 static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
 {
@@ -117,7 +117,7 @@ static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
 	return MSR_IA32_APICBASE_ENABLE;
 }
 
-extern struct static_key_deferred apic_sw_disabled;
+extern static_key_deferred(apic_sw_disabled);
 
 static inline int kvm_apic_sw_enabled(struct kvm_lapic *apic)
 {
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bc2121f..572e583 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -214,6 +214,7 @@
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
 	*(.data..read_mostly)						\
+	*(__deferred_keys)                                              \
 	. = ALIGN(align);
 
 #define CACHELINE_ALIGNED_DATA(align)					\
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index 089f70f..1216db0 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -3,6 +3,10 @@
 
 #include <linux/jump_label.h>
 #include <linux/workqueue.h>
+#include <linux/compiler.h>
+
+#define static_key_deferred(name) \
+	struct static_key_deferred name __section(__deferred_keys)
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 struct static_key_deferred {
diff --git a/include/linux/module.h b/include/linux/module.h
index 46e548f..4cc7269 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -347,6 +347,9 @@ struct module
 #ifdef HAVE_JUMP_LABEL
 	struct jump_entry *jump_entries;
 	unsigned int num_jump_entries;
+
+	struct static_key_deferred *deferred_keys;
+	unsigned int num_deferred_keys;
 #endif
 #ifdef CONFIG_TRACING
 	unsigned int num_trace_bprintk_fmt;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8f4a70f..8baabca 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -672,7 +672,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 	}
 }
 
-extern struct static_key_deferred perf_sched_events;
+extern static_key_deferred(perf_sched_events);
 
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 403b781..ee64d26 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -138,7 +138,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-struct static_key_deferred perf_sched_events __read_mostly;
+static_key_deferred(perf_sched_events);
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
 
diff --git a/kernel/module.c b/kernel/module.c
index f5a3b1e..3e601ef 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2751,6 +2751,10 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 	mod->jump_entries = section_objs(info, "__jump_table",
 					sizeof(*mod->jump_entries),
 					&mod->num_jump_entries);
+	mod->deferred_keys = section_objs(info, "__deferred_keys",
+	                                  sizeof(*mod->deferred_keys),
+	                                  &mod->num_deferred_keys);
+
 #endif
 #ifdef CONFIG_EVENT_TRACING
 	mod->trace_events = section_objs(info, "_ftrace_events",
-- 
1.8.4.2

