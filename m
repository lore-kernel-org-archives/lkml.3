Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab3BFULC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:11:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab3BFUJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:09:12 -0500
Date: Wed, 6 Feb 2013 15:06:47 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, eric.dumazet@gmail.com, lwoodman@redhat.com,
        knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: [PATCH -v5 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
Message-ID: <20130206150647.633f7b1c@cuia.bos.redhat.com>
In-Reply-To: <20130206150311.19cd1e52@cuia.bos.redhat.com>
References: <20130206150311.19cd1e52@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

Eric Dumazet found a regression with the first version of the spinlock
backoff code, in a workload where multiple spinlocks were contended,
each having a different wait time.

This patch has multiple delay values per cpu, indexed on a hash
of the lock address, to avoid that problem.

Eric Dumazet wrote:

I did some tests with your patches with following configuration :

tc qdisc add dev eth0 root htb r2q 1000 default 3
(to force a contention on qdisc lock, even with a multi queue net
device)

and 24 concurrent "netperf -t UDP_STREAM -H other_machine -- -m 128"

Machine : 2 Intel(R) Xeon(R) CPU X5660  @ 2.80GHz
(24 threads), and a fast NIC (10Gbps)

Resulting in a 13 % regression (676 Mbits -> 595 Mbits)

In this workload we have at least two contended spinlocks, with
different delays. (spinlocks are not held for the same duration)

It clearly defeats your assumption of a single per cpu delay being OK :
Some cpus are spinning too long while the lock was released.

We might try to use a hash on lock address, and an array of 16 different
delays so that different spinlocks have a chance of not sharing the same
delay.

With following patch, I get 982 Mbits/s with same bench, so an increase
of 45 % instead of a 13 % regression.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>

---
 arch/x86/kernel/smp.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index a7255a7..64e33ef 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/hash.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -116,6 +117,18 @@ static bool smp_no_nmi_ipi = false;
 #define DELAY_FIXED_1			(1<<DELAY_SHIFT)
 #define MIN_SPINLOCK_DELAY		(1 * DELAY_FIXED_1)
 #define MAX_SPINLOCK_DELAY		(16000 * DELAY_FIXED_1)
+#define DELAY_HASH_SHIFT		6
+struct delay_entry {
+	u32 hash;
+	u32 delay;
+};
+static DEFINE_PER_CPU(struct delay_entry [1 << DELAY_HASH_SHIFT], spinlock_delay) = {
+	[0 ... (1 << DELAY_HASH_SHIFT) - 1] = {
+		.hash = 0,
+		.delay = MIN_SPINLOCK_DELAY,
+	},
+};
+
 /*
  * Wait on a congested ticket spinlock. Many spinlocks are embedded in
  * data structures; having many CPUs pounce on the cache line with the
@@ -134,12 +147,14 @@ static bool smp_no_nmi_ipi = false;
  * the queue, to slowly increase the delay if we sleep for too short a
  * time, and to decrease the delay if we slept for too long.
  */
-DEFINE_PER_CPU(unsigned, spinlock_delay) = { MIN_SPINLOCK_DELAY };
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
 	__ticket_t waiters_ahead;
-	unsigned delay = __this_cpu_read(spinlock_delay);
+	u32 hash = hash32_ptr(lock);
+	u32 slot = hash_32(hash, DELAY_HASH_SHIFT);
+	struct delay_entry *ent = &__get_cpu_var(spinlock_delay[slot]);
+	u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;
 	unsigned loops;
 
 	for (;;) {
@@ -171,11 +186,12 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 			 * to get it back to a good value quickly.
 			 */
 			if (delay >= 2 * DELAY_FIXED_1)
-				delay -= max(delay/32, DELAY_FIXED_1);
+				delay -= max_t(u32, delay/32, DELAY_FIXED_1);
 			break;
 		}
 	}
-	__this_cpu_write(spinlock_delay, delay);
+	ent->hash = hash;
+	ent->delay = delay;
 }
 
 /*
