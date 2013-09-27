Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3I0K6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:58:35 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:36282 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3I0K6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:58:30 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: <arc-linux-dev@synopsys.com>, <u.kleine-koenig@pengutronix.de>,
        Noam Camus <noamc@ezchip.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 3/4] ARC: Workaround spinlock livelock in SMP SystemC simulation
Date: Fri, 27 Sep 2013 16:27:36 +0530
Message-ID: <1380279457-14299-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380279457-14299-1-git-send-email-vgupta@synopsys.com>
References: <1380279457-14299-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ARC SMP systems lack native atomic R-M-W (LLOCK/SCOND) insns and
can only use atomic EX insn (reg with mem) to build higher level R-M-W
primitives. This includes a SystemC based SMP simulation model.

So rwlocks need to use a protecting spinlock for atomic cmp-n-exchange
operation to update reader(s)/writer count.

The spinlock operation itself looks as follows:

	mov reg, 1		; 1=locked, 0=unlocked
retry:
	EX reg, [lock]		; load existing, store 1, atomically
	BREQ reg, 1, rety	; if already locked, retry

In single-threaded simulation, SystemC alternates between the 2 cores
with "N" insn each based scheduling. Additionally for insn with global
side effect, such as EX writing to shared mem, a core switch is
enforced too.

Given that, 2 cores doing a repeated EX on same location, Linux often
got into a livelock e.g. when both cores were fiddling with tasklist
lock (gdbserver / hackbench) for read/write respectively as the
sequence diagram below shows:

           core1                                   core2
         --------                                --------
1. spin lock [EX r=0, w=1] - LOCKED
2. rwlock(Read)            - LOCKED
3. spin unlock  [ST 0]     - UNLOCKED
                                         spin lock [EX r=0,w=1] - LOCKED
                      -- resched core 1----

5. spin lock [EX r=1] - ALREADY-LOCKED

                      -- resched core 2----
6.                                       rwlock(Write) - READER-LOCKED
7.                                       spin unlock [ST 0]
8.                                       rwlock failed, retry again

9.                                       spin lock  [EX r=0, w=1]
                      -- resched core 1----

10  spinlock locked in #9, retry #5
11. spin lock [EX gets 1]
                      -- resched core 2----
...
...

The fix was to unlock using the EX insn too (step 7), to trigger another
SystemC scheduling pass which would let core1 proceed, eliding the
livelock.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/spinlock.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arc/include/asm/spinlock.h b/arch/arc/include/asm/spinlock.h
index f158197..b6a8c2d 100644
--- a/arch/arc/include/asm/spinlock.h
+++ b/arch/arc/include/asm/spinlock.h
@@ -45,7 +45,14 @@ static inline int arch_spin_trylock(arch_spinlock_t *lock)
 
 static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	lock->slock = __ARCH_SPIN_LOCK_UNLOCKED__;
+	unsigned int tmp = __ARCH_SPIN_LOCK_UNLOCKED__;
+
+	__asm__ __volatile__(
+	"	ex  %0, [%1]		\n"
+	: "+r" (tmp)
+	: "r"(&(lock->slock))
+	: "memory");
+
 	smp_mb();
 }
 
-- 
1.8.1.2

