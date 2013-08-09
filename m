Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591Ab3HIOS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:18:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53225 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030556Ab3HIOSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:18:25 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <gleb@redhat.com>, <pbonzini@redhat.com>
Cc: <gregkh@suse.de>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <agraf@suse.de>, <riel@redhat.com>, <avi.kivity@gmail.com>,
        <habanero@linux.vnet.ibm.com>, <chegu_vinod@hp.com>,
        <ouyang@cs.pitt.edu>, <drjones@redhat.com>, <attilio.rao@citrix.com>,
        linux-doc@vger.kernel.org, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <andi@firstfloor.org>, <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>,
        <stefano.stabellini@eu.citrix.com>, <mtosatti@redhat.com>,
        <srivatsa.vaddagiri@gmail.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V13 09/14] jump_label: Split jumplabel ratelimit
Date: Fri,  9 Aug 2013 19:51:57 +0530
Message-Id: <1376058122-8248-10-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <y>
 <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080914-7182-0000-0000-000008089ABD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Commit b202952075f62603bea9bfb6ebc6b0420db11949 ("perf, core: Rate limit
perf_sched_events jump_label patching") introduced rate limiting
for jump label disabling. The changes were made in the jump label code
in order to be more widely available and to keep things tidier. This is
all fine, except now jump_label.h includes linux/workqueue.h, which
makes it impossible to include jump_label.h from anything that
workqueue.h needs. For example, it's now impossible to include
jump_label.h from asm/spinlock.h, which is done in proposed
pv-ticketlock patches. This patch splits out the rate limiting related
changes from jump_label.h into a new file, jump_label_ratelimit.h, to
resolve the issue.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/jump_label.h           | 28 +---------------------------
 include/linux/jump_label_ratelimit.h | 34 ++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h           |  1 +
 kernel/jump_label.c                  |  1 +
 4 files changed, 37 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/jump_label_ratelimit.h

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 0976fc4..a507907 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -48,7 +48,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/workqueue.h>
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
@@ -61,12 +60,6 @@ struct static_key {
 #endif
 };
 
-struct static_key_deferred {
-	struct static_key key;
-	unsigned long timeout;
-	struct delayed_work work;
-};
-
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
@@ -78,6 +71,7 @@ enum jump_label_type {
 
 struct module;
 
+#include <linux/atomic.h>
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_LABEL_TRUE_BRANCH 1UL
@@ -119,10 +113,7 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
 extern int jump_label_text_reserved(void *start, void *end);
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void jump_label_apply_nops(struct module *mod);
-extern void
-jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
 	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
@@ -131,8 +122,6 @@ jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
 #else  /* !HAVE_JUMP_LABEL */
 
-#include <linux/atomic.h>
-
 struct static_key {
 	atomic_t enabled;
 };
@@ -141,10 +130,6 @@ static __always_inline void jump_label_init(void)
 {
 }
 
-struct static_key_deferred {
-	struct static_key  key;
-};
-
 static __always_inline bool static_key_false(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
@@ -169,11 +154,6 @@ static inline void static_key_slow_dec(struct static_key *key)
 	atomic_dec(&key->enabled);
 }
 
-static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
-{
-	static_key_slow_dec(&key->key);
-}
-
 static inline int jump_label_text_reserved(void *start, void *end)
 {
 	return 0;
@@ -187,12 +167,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
-static inline void
-jump_label_rate_limit(struct static_key_deferred *key,
-		unsigned long rl)
-{
-}
-
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
 		{ .enabled = ATOMIC_INIT(1) })
 #define STATIC_KEY_INIT_FALSE ((struct static_key) \
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
new file mode 100644
index 0000000..1137883
--- /dev/null
+++ b/include/linux/jump_label_ratelimit.h
@@ -0,0 +1,34 @@
+#ifndef _LINUX_JUMP_LABEL_RATELIMIT_H
+#define _LINUX_JUMP_LABEL_RATELIMIT_H
+
+#include <linux/jump_label.h>
+#include <linux/workqueue.h>
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+struct static_key_deferred {
+	struct static_key key;
+	unsigned long timeout;
+	struct delayed_work work;
+};
+#endif
+
+#ifdef HAVE_JUMP_LABEL
+extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
+extern void
+jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
+
+#else	/* !HAVE_JUMP_LABEL */
+struct static_key_deferred {
+	struct static_key  key;
+};
+static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
+{
+	static_key_slow_dec(&key->key);
+}
+static inline void
+jump_label_rate_limit(struct static_key_deferred *key,
+		unsigned long rl)
+{
+}
+#endif	/* HAVE_JUMP_LABEL */
+#endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c43f6ea..226be8d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -48,6 +48,7 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
 #include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
 #include <linux/perf_regs.h>
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 60f48fa..297a924 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 
 #ifdef HAVE_JUMP_LABEL
 
-- 
1.7.11.7

