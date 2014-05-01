Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaEARuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:50:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:38451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaEARum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,966,1389772800"; 
   d="scan'208";a="533235029"
Subject: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 May 2014 10:50:37 -0700
Message-ID: <1398966637.2970.129.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It takes me a while to understand how rwsem's count field mainifest
itself in different scenarios.  I'm adding comments to provide a quick
reference on the the rwsem's count field for each scenario where readers
and writers are contending/holding the lock.  Hopefully it will be useful
for future maintenance of the code and for people to get up to speed on
how the logic in the code works.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/locking/rwsem-xadd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 1d66e08..305c15f 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -12,6 +12,28 @@
 #include <linux/export.h>
 
 /*
+ * Meaning of the rw_semaphore's count field:
+ * (32 bit case illustrated, similar for 64 bit)
+ *
+ * (listed in decreasing order)
+ * 0x0000000X  X readers active, no writer waiting (X*ACTIVE_BIAS)
+ * 0x00000000  rwsem is unlocked, and no one is waiting for the lock
+ * 0xffff000X  X readers active, writer and/or reader waiting.
+ *	       (X*ACTIVE_BIAS + WAITING_BIAS)
+ * 0xffff0001  (1) one writer active, nobody queued. (ACTIVE_WRITE_BIAS)
+ *	       or
+ *	       (2) one reader active, writer(s) queued.
+ *		   (WAITING_BIAS + ACTIVE_BIAS)
+ * 0xffff0000  There are writers or readers queued but none active
+ *	       (WAITING_BIAS), a writer can try to grab the lock and
+ *	       take itself off wait list if awake.  Writer who has just
+ *	       completed its task seeing this count will try to
+ *	       wake people up from wait list.
+ * 0xfffe0001  Writer active, readers/writer queued
+ *	       (ACTIVE_WRITE_BIAS + WAITING_BIAS)
+ */
+
+/*
  * Initialize an rwsem:
  */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
-- 
1.7.11.7


