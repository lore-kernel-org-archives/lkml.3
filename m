Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533Ab3CTJ3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:29:31 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43020 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3CTJ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:29:28 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 19/30] compat: embrace LINUX_BACKPORT() for v3.1
Date: Wed, 20 Mar 2013 02:22:44 -0700
Message-Id: <1363771375-31715-20-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 compat/compat-3.1.c        |   12 ++++++------
 include/linux/compat-3.1.h |   12 +++---------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/compat/compat-3.1.c b/compat/compat-3.1.c
index bfaf8ea..cb5d596 100644
--- a/compat/compat-3.1.c
+++ b/compat/compat-3.1.c
@@ -19,7 +19,7 @@
  * 	cpufreq: expose a cpufreq_quick_get_max routine
  */
 #ifdef CONFIG_CPU_FREQ
-unsigned int compat_cpufreq_quick_get_max(unsigned int cpu)
+unsigned int cpufreq_quick_get_max(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	unsigned int ret_freq = 0;
@@ -31,7 +31,7 @@ unsigned int compat_cpufreq_quick_get_max(unsigned int cpu)
 
 	return ret_freq;
 }
-EXPORT_SYMBOL_GPL(compat_cpufreq_quick_get_max);
+EXPORT_SYMBOL_GPL(cpufreq_quick_get_max);
 #endif
 
 static DEFINE_SPINLOCK(compat_simple_ida_lock);
@@ -48,7 +48,7 @@ static DEFINE_SPINLOCK(compat_simple_ida_lock);
  *
  * Use ida_simple_remove() to get rid of an id.
  */
-int compat_ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask)
 {
 	int ret, id;
@@ -86,14 +86,14 @@ again:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(compat_ida_simple_get);
+EXPORT_SYMBOL_GPL(ida_simple_get);
 
 /**
  * ida_simple_remove - remove an allocated id.
  * @ida: the (initialized) ida.
  * @id: the id returned by ida_simple_get.
  */
-void compat_ida_simple_remove(struct ida *ida, unsigned int id)
+void ida_simple_remove(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
@@ -102,6 +102,6 @@ void compat_ida_simple_remove(struct ida *ida, unsigned int id)
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&compat_simple_ida_lock, flags);
 }
-EXPORT_SYMBOL_GPL(compat_ida_simple_remove);
+EXPORT_SYMBOL_GPL(ida_simple_remove);
 /* source lib/idr.c */
 
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index 2b5eb8b..3e8be33 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -88,21 +88,15 @@ static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
 #include <asm-generic/atomic64.h>
 #endif
 
-/* mask ida_simple_get as RHEL6 backports this */
-#define ida_simple_get(a,b,c,d) compat_ida_simple_get(a,b,c,d)
-
+#define ida_simple_get LINUX_BACKPORT(ida_simple_get)
 int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask);
 
-/* mask ida_simple_remove as RHEL6 backports this */
-#define ida_simple_remove(a,b) compat_ida_simple_remove(a,b)
-
+#define ida_simple_remove LINUX_BACKPORT(ida_simple_remove)
 void ida_simple_remove(struct ida *ida, unsigned int id);
 
 #ifdef CONFIG_CPU_FREQ
-/* mask cpufreq_quick_get_max as RHEL6 backports this */
-#define cpufreq_quick_get_max(a) compat_cpufreq_quick_get_max(a)
-
+#define cpufreq_quick_get_max LINUX_BACKPORT(cpufreq_quick_get_max)
 unsigned int cpufreq_quick_get_max(unsigned int cpu);
 #endif
 
-- 
1.7.10.4

