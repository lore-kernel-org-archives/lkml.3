Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab3B1PIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:08:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42211 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3B1Osh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/139] xen: Send spinlock IPI to all waiters
Date: Thu, 28 Feb 2013 14:43:39 +0000
Message-Id: <1362062689-2567-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 76eaca031f0af2bb303e405986f637811956a422 upstream.

There is a loophole between Xen's current implementation of
pv-spinlocks and the scheduler. This was triggerable through
a testcase until v3.6 changed the TLB flushing code. The
problem potentially is still there just not observable in the
same way.

What could happen was (is):

1. CPU n tries to schedule task x away and goes into a slow
   wait for the runq lock of CPU n-# (must be one with a lower
   number).
2. CPU n-#, while processing softirqs, tries to balance domains
   and goes into a slow wait for its own runq lock (for updating
   some records). Since this is a spin_lock_irqsave in softirq
   context, interrupts will be re-enabled for the duration of
   the poll_irq hypercall used by Xen.
3. Before the runq lock of CPU n-# is unlocked, CPU n-1 receives
   an interrupt (e.g. endio) and when processing the interrupt,
   tries to wake up task x. But that is in schedule and still
   on_cpu, so try_to_wake_up goes into a tight loop.
4. The runq lock of CPU n-# gets unlocked, but the message only
   gets sent to the first waiter, which is CPU n-# and that is
   busily stuck.
5. CPU n-# never returns from the nested interruption to take and
   release the lock because the scheduler uses a busy wait.
   And CPU n never finishes the task migration because the unlock
   notification only went to CPU n-#.

To avoid this and since the unlocking code has no real sense of
which waiter is best suited to grab the lock, just send the IPI
to all of them. This causes the waiters to return from the hyper-
call (those not interrupted at least) and do active spinlocking.

BugLink: http://bugs.launchpad.net/bugs/1011792

Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/xen/spinlock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 83e866d..f7a080e 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -328,7 +328,6 @@ static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
 		if (per_cpu(lock_spinners, cpu) == xl) {
 			ADD_STATS(released_slow_kicked, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
-			break;
 		}
 	}
 }
-- 
1.8.1.2

