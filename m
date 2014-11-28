Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaK1S1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:27:14 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58537 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaK1SYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:51 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 22/30] u64_stats_sync: Introduce preempt-unsafe readers
Date: Fri, 28 Nov 2014 19:23:52 +0100
Message-Id: <1417199040-21044-23-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is going to be used by irqtime accounting. The scheduler accesses
irqtime from fast-path where preemption is already disabled.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/u64_stats_sync.h | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 4b4439e..20c26dc 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -88,29 +88,40 @@ static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
 #endif
 }
 
+/* Preempt-unsafe version of u64_stats_fetch_begin */
+static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	return read_seqcount_begin(&syncp->seq);
+#endif
+	return 0;
+}
+
+/* Preempt-unsafe version of u64_stats_fetch_retry */
+static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
+					 unsigned int start)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	return read_seqcount_retry(&syncp->seq, start);
+#endif
+	return false;
+}
+
 static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
-	return read_seqcount_begin(&syncp->seq);
-#else
-#if BITS_PER_LONG==32
+#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
 	preempt_disable();
 #endif
-	return 0;
-#endif
+	return __u64_stats_fetch_begin(syncp);
 }
 
 static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
-	return read_seqcount_retry(&syncp->seq, start);
-#else
-#if BITS_PER_LONG==32
+#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
 	preempt_enable();
 #endif
-	return false;
-#endif
+	return __u64_stats_fetch_retry(syncp, start);
 }
 
 /*
-- 
2.1.3

