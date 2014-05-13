Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaEMCsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:48:05 -0400
Received: from ns.horizon.com ([71.41.210.147]:16673 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751524AbaEMCsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:48:02 -0400
Date: 12 May 2014 22:48:01 -0400
Message-ID: <20140513024801.31728.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org, linux@horizon.com
Subject: [PATCH 2/2] timekeeping: Mark struct timekeeper * passed to notifiers as const
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com
In-Reply-To: <537109AB.8010609@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add const delcarations where possible to make clear that the call chains
are not permitted to write to the structure.

It is not expected to improve generated code; the purpose is to document
the rules for who's allowed to modify the timekeeper state (and must
hold the associated locks) more clearly.

There are two code paths affected:
- update_vsyscall() (and update_vsyscall_old(), if used)
- update_pvclock_gtod() and the functions notified

This touches arch code that I have not tested, but only in a very safe
way: to add const declarations whose only effect is to add compile-time
complaints.

Signed-off-by: George Spelvin <linux@horizon.com>
---
One style issue: Some people prefer "const struct timekeeper *", when
I'm in the habit of writing "struct timekeeper const *".  This is due
to an example I had pointed out to me:
typedef char *charp;
const char *a;
char const *b;
char * const c;
const charp d;
charp const e;

Which of these variables are the same type?  The answer is that a and b
are writable pointers to const chars, while c through e are const pointers
to writeable chars.  But if you're in the habit of writing const first,
a and d are easy to confuse.  If you get in the habit of writing const
last, e looks like c, which is correct.  Due to the typedef, there's
no way write a declaration with the const "between the char and the *"
that looks like b.

I found this persuasive, and have adopted the style.  If it causes
violent reactions, I can change.

 arch/arm64/kernel/vdso.c            |  2 +-
 arch/ia64/kernel/time.c             |  2 +-
 arch/powerpc/kernel/time.c          |  2 +-
 arch/s390/kernel/time.c             |  2 +-
 arch/tile/kernel/time.c             |  2 +-
 arch/x86/kernel/vsyscall_gtod.c     |  2 +-
 arch/x86/kvm/x86.c                  |  4 ++--
 include/linux/timekeeper_internal.h | 10 +++++-----
 kernel/time/timekeeping.c           |  8 ++++----
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 50384fec56..dafdc36845 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -208,7 +208,7 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 /*
  * Update the vDSO data page to keep in sync with kernel timekeeping.
  */
-void update_vsyscall(struct timekeeper *tk)
+void update_vsyscall(struct timekeeper const *tk)
 {
 	struct timespec xtime_coarse;
 	u32 use_syscall = strcmp(tk->clock->name, "arch_sys_counter");
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 71c52bc7c2..353d5847f1 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -440,7 +440,7 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
+void update_vsyscall_old(struct timespec *wall, struct timespec const *wtm,
 			struct clocksource *c, u32 mult)
 {
 	write_seqcount_begin(&fsyscall_gtod_data.seq);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 122a580f73..42ffd2309d 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -740,7 +740,7 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
+void update_vsyscall_old(struct timespec *wall_time, struct timespec const *wtm,
 			struct clocksource *clock, u32 mult)
 {
 	u64 new_tb_to_xs, new_stamp_xsec;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 386d37a228..ea1c8d3137 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -210,7 +210,7 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timekeeper *tk)
+void update_vsyscall(struct timekeeper const *tk)
 {
 	u64 nsecps;
 
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 462dcd0c17..7202570ad8 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -258,7 +258,7 @@ void update_vsyscall_tz(void)
 	++vdso_data->tz_update_count;
 }
 
-void update_vsyscall(struct timekeeper *tk)
+void update_vsyscall(struct timekeeper const *tk)
 {
 	struct timespec wall_time = tk_xtime(tk);
 	struct timespec *wtm = &tk->wall_to_monotonic;
diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
index f9c6e56e14..fa12766b38 100644
--- a/arch/x86/kernel/vsyscall_gtod.c
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -24,7 +24,7 @@ void update_vsyscall_tz(void)
 	vsyscall_gtod_data.tz_dsttime = sys_tz.tz_dsttime;
 }
 
-void update_vsyscall(struct timekeeper *tk)
+void update_vsyscall(struct timekeeper const *tk)
 {
 	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b8fc0b792..0c42561f52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1003,7 +1003,7 @@ struct pvclock_gtod_data {
 
 static struct pvclock_gtod_data pvclock_gtod_data;
 
-static void update_pvclock_gtod(struct timekeeper *tk)
+static void update_pvclock_gtod(struct timekeeper const *tk)
 {
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
 
@@ -5552,7 +5552,7 @@ static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
 			       void *priv)
 {
 	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
-	struct timekeeper *tk = priv;
+	struct timekeeper const *tk = priv;
 
 	update_pvclock_gtod(tk);
 
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb436..96e39501d8 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -71,7 +71,7 @@ struct timekeeper {
 
 };
 
-static inline struct timespec tk_xtime(struct timekeeper *tk)
+static inline struct timespec tk_xtime(struct timekeeper const *tk)
 {
 	struct timespec ts;
 
@@ -83,16 +83,16 @@ static inline struct timespec tk_xtime(struct timekeeper *tk)
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 
-extern void update_vsyscall(struct timekeeper *tk);
+extern void update_vsyscall(struct timekeeper const *tk);
 extern void update_vsyscall_tz(void);
 
 #elif defined(CONFIG_GENERIC_TIME_VSYSCALL_OLD)
 
-extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
+extern void update_vsyscall_old(struct timespec *ts, struct timespec const *wtm,
 				struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 
-static inline void update_vsyscall(struct timekeeper *tk)
+static inline void update_vsyscall(struct timekeeper const *tk)
 {
 	struct timespec xt;
 
@@ -102,7 +102,7 @@ static inline void update_vsyscall(struct timekeeper *tk)
 
 #else
 
-static inline void update_vsyscall(struct timekeeper *tk)
+static inline void update_vsyscall(struct timekeeper const *tk)
 {
 }
 static inline void update_vsyscall_tz(void)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 14e703e5bd..2e0fb0f617 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -165,7 +165,7 @@ u32 get_arch_timeoffset(void)
 static inline u32 get_arch_timeoffset(void) { return 0; }
 #endif
 
-static inline s64 timekeeping_get_ns(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns(struct timekeeper const *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
@@ -185,7 +185,7 @@ static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 	return nsec + get_arch_timeoffset();
 }
 
-static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns_raw(struct timekeeper const *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
@@ -207,9 +207,9 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
-static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
+static void update_pvclock_gtod(struct timekeeper const *tk, bool was_set)
 {
-	raw_notifier_call_chain(&pvclock_gtod_chain, was_set, tk);
+	raw_notifier_call_chain(&pvclock_gtod_chain, was_set, (void *)tk);
 }
 
 /**
-- 
1.9.2

