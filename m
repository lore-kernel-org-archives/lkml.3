Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3LKWAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:00:13 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58615 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LKV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:59:24 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 tip/core/locking 8/8] powerpc: Full barrier for smp_mb__after_unlock_lock()
Date: Wed, 11 Dec 2013 13:59:11 -0800
Message-Id: <1386799151-2219-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131211215850.GA810@linux.vnet.ibm.com>
 <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121121-9332-0000-0000-0000027641DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The powerpc lock acquisition sequence is as follows:

	lwarx; cmpwi; bne; stwcx.; lwsync;

Lock release is as follows:

	lwsync; stw;

If CPU 0 does a store (say, x=1) then a lock release, and CPU 1 does a
lock acquisition then a load (say, r1=y), then there is no guarantee of
a full memory barrier between the store to 'x' and the load from 'y'.
To see this, suppose that CPUs 0 and 1 are hardware threads in the same
core that share a store buffer, and that CPU 2 is in some other core,
and that CPU 2 does the following:

	y = 1; sync; r2 = x;

If 'x' and 'y' are both initially zero, then the lock acquisition and
release sequences above can result in r1 and r2 both being equal to
zero, which could not happen if unlock+lock was a full barrier.

This commit therefore makes powerpc's smp_mb__after_unlock_lock() be a
full barrier.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/spinlock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5f54a744dcc5..f6e78d63fb6a 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -28,6 +28,8 @@
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
 
+#define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
+
 #define arch_spin_is_locked(x)		((x)->slock != 0)
 
 #ifdef CONFIG_PPC64
-- 
1.8.1.5

