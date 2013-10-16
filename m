Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885Ab3JPSAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:00:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934527Ab3JPRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 16/50] ARC: Workaround spinlock livelock in SMP SystemC simulation
Date: Wed, 16 Oct 2013 10:45:02 -0700
Message-Id: <20131016174400.343767632@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 6c00350b573c0bd3635436e43e8696951dd6e1b6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/spinlock.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arc/include/asm/spinlock.h
+++ b/arch/arc/include/asm/spinlock.h
@@ -45,7 +45,14 @@ static inline int arch_spin_trylock(arch
 
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
 


