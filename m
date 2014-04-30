Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbaD3IdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:33:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:25461 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaD3IdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:33:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="503579686"
Subject: [PATCH] lib/spinlock_debug: Tweak the loop time to fit different
 _delay()
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: chuansheng.liu@intel.com, xiaoming.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 18:40:38 -0400
Message-ID: <1398897638.21870.8.camel@wxm-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loops_per_jiffy*Hz  is not always 1 second exactly
it depends on the realization of _delay() .
delay_tsc is used as _delay() in arch/x86/lib/delay.c
It makes loop loops_per_jiffy larger than exception
and causes one thread can not obtain the spin lock for
a long time which may trigger HARD LOCKUP in this case.
So we use cpu_clock() which is more accurate.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
---
 kernel/locking/spinlock_debug.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 0374a59..471d26c 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -105,10 +105,13 @@ static inline void debug_spin_unlock(raw_spinlock_t *lock)
 
 static void __spin_lock_debug(raw_spinlock_t *lock)
 {
-	u64 i;
-	u64 loops = loops_per_jiffy * HZ;
+	u64 t;
+	u64 one_second = 1000000000;
+	u32 this_cpu = raw_smp_processor_id();
+
+	t = cpu_clock(this_cpu);
 
-	for (i = 0; i < loops; i++) {
+	while (cpu_clock(this_cpu) - t < one_second) {
 		if (arch_spin_trylock(&lock->raw_lock))
 			return;
 		__delay(1);
-- 
1.7.1

