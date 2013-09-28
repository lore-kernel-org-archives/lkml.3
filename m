Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3I1K6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:58:42 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39039 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3I1K6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:58:18 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 2/3] lockref: use arch_mutex_cpu_relax() in CMPXCHG_LOOP()
Date: Sat, 28 Sep 2013 12:58:10 +0200
Message-Id: <1380365891-34457-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092810-5024-0000-0000-0000075A3B41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of arch_mutex_cpu_relax() so architectures can override the
default cpu_relax() semantics.
This is especially useful for s390, where cpu_relax() means that we
yield() the current (virtual) cpu and therefore is very expensive,
and would contradict the whole purpose of the lockless cmpxchg loop.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 lib/lockref.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index e294ae4..6f9d434 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -12,6 +12,14 @@
 #endif
 
 /*
+ * Allow architectures to override the default cpu_relax() within CMPXCHG_LOOP.
+ * This is useful for architectures with an expensive cpu_relax().
+ */
+#ifndef arch_mutex_cpu_relax
+# define arch_mutex_cpu_relax() cpu_relax()
+#endif
+
+/*
  * Note that the "cmpxchg()" reloads the "old" value for the
  * failure case.
  */
@@ -28,7 +36,7 @@
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-		cpu_relax();							\
+		arch_mutex_cpu_relax();						\
 	}									\
 } while (0)
 
-- 
1.8.3.4

