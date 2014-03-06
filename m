Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaCFR4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:56:52 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57886 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaCFR4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:56:50 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] cputime: Bring cputime -> nsecs conversion
Date: Thu,  6 Mar 2014 18:56:38 +0100
Message-Id: <1394128601-26034-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have nsecs_to_cputime(). Now we need to be able to convert
the other way around in order to fix a bug on steal time accounting.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/asm-generic/cputime_jiffies.h | 4 +++-
 include/asm-generic/cputime_nsecs.h   | 2 ++
 include/linux/cputime.h               | 5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
index 272ecba..d5cb78f5 100644
--- a/include/asm-generic/cputime_jiffies.h
+++ b/include/asm-generic/cputime_jiffies.h
@@ -15,8 +15,10 @@ typedef u64 __nocast cputime64_t;
 
 
 /*
- * Convert nanoseconds to cputime
+ * Convert nanoseconds <-> cputime
  */
+#define cputime_to_nsecs(__ct)		\
+	jiffies_to_nsecs(cputime_to_jiffies(__ct))
 #define nsecs_to_cputime64(__nsec)	\
 	jiffies64_to_cputime64(nsecs_to_jiffies64(__nsec))
 #define nsecs_to_cputime(__nsec)	\
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index 768294f..4e81760 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -44,6 +44,8 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> nanoseconds
  */
+#define cputime_to_nsecs(__ct)		\
+	(__force u64)(__ct)
 #define nsecs_to_cputime(__nsecs)	\
 	(__force cputime_t)(__nsecs)
 
diff --git a/include/linux/cputime.h b/include/linux/cputime.h
index 2842ebe..f2eb2ee 100644
--- a/include/linux/cputime.h
+++ b/include/linux/cputime.h
@@ -3,6 +3,11 @@
 
 #include <asm/cputime.h>
 
+#ifndef cputime_to_nsecs
+# define cputime_to_nsecs(__ct)	\
+	(cputime_to_usecs(__ct) * NSEC_PER_USEC)
+#endif
+
 #ifndef nsecs_to_cputime
 # define nsecs_to_cputime(__nsecs)	\
 	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
-- 
1.8.3.1

