Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab3BYW3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:29:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3BYWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 25/58] xen: Send spinlock IPI to all waiters
Date: Mon, 25 Feb 2013 14:19:21 -0800
Message-Id: <20130225221641.493997594@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/spinlock.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -328,7 +328,6 @@ static noinline void xen_spin_unlock_slo
 		if (per_cpu(lock_spinners, cpu) == xl) {
 			ADD_STATS(released_slow_kicked, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
-			break;
 		}
 	}
 }


