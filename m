Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3LPKlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:41:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3LPKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:41:06 -0500
Date: Mon, 16 Dec 2013 02:40:40 -0800
From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-919fc6e34831d1c2b58bfb5ae261dc3facc9b269@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-arch@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-arch@vger.kernel.org
In-Reply-To: <1386799151-2219-8-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1386799151-2219-8-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] powerpc:
  Full barrier for smp_mb__after_unlock_lock()
Git-Commit-ID: 919fc6e34831d1c2b58bfb5ae261dc3facc9b269
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 02:40:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  919fc6e34831d1c2b58bfb5ae261dc3facc9b269
Gitweb:     http://git.kernel.org/tip/919fc6e34831d1c2b58bfb5ae261dc3facc9b269
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 11 Dec 2013 13:59:11 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Dec 2013 11:36:18 +0100

powerpc: Full barrier for smp_mb__after_unlock_lock()

The powerpc lock acquisition sequence is as follows:

	lwarx; cmpwi; bne; stwcx.; lwsync;

Lock release is as follows:

	lwsync; stw;

If CPU 0 does a store (say, x=1) then a lock release, and CPU 1
does a lock acquisition then a load (say, r1=y), then there is
no guarantee of a full memory barrier between the store to 'x'
and the load from 'y'. To see this, suppose that CPUs 0 and 1
are hardware threads in the same core that share a store buffer,
and that CPU 2 is in some other core, and that CPU 2 does the
following:

	y = 1; sync; r2 = x;

If 'x' and 'y' are both initially zero, then the lock
acquisition and release sequences above can result in r1 and r2
both being equal to zero, which could not happen if unlock+lock
was a full barrier.

This commit therefore makes powerpc's
smp_mb__after_unlock_lock() be a full barrier.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: <linux-arch@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1386799151-2219-8-git-send-email-paulmck@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/include/asm/spinlock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5f54a74..f6e78d6 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -28,6 +28,8 @@
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
 
+#define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
+
 #define arch_spin_is_locked(x)		((x)->slock != 0)
 
 #ifdef CONFIG_PPC64
