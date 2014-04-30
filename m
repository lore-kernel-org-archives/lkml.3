Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaD3C5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:57:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:2690 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbaD3C46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="425703185"
Subject: [PATCH] lib/spinlock_debug: avoid one thread can not obtain the
 spinlock for a long time.
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 13:04:31 -0400
Message-ID: <1398877471.21870.6.camel@wxm-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loops_per_jiffy is larger than expectation that possible
causes one thread can not obtain the spin lock for a long time.
So use cpu_clock() to reach timeout in one second which can
avoid HARD LOCKUP.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
---
 kernel/locking/spinlock_debug.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 0374a59..5d3c4f3 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -105,13 +105,19 @@ static inline void debug_spin_unlock(raw_spinlock_t *lock)
 
 static void __spin_lock_debug(raw_spinlock_t *lock)
 {
-	u64 i;
+	u64 i, t;
 	u64 loops = loops_per_jiffy * HZ;
+	u64 one_second = 1000000000;
+	u32 this_cpu = raw_smp_processor_id();
+
+	t = cpu_clock(this_cpu);
 
 	for (i = 0; i < loops; i++) {
 		if (arch_spin_trylock(&lock->raw_lock))
 			return;
 		__delay(1);
+		if (cpu_clock(this_cpu) - t > one_second)
+			break;
 	}
 	/* lockup suspected: */
 	spin_dump(lock, "lockup suspected");
-- 
1.7.1


