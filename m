Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaIJRdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:33:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaIJRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:33:16 -0400
Date: Wed, 10 Sep 2014 10:31:37 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-da4c54457e6d8262423aded4bcbccc4103049506@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        markos.chandras@imgtec.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        paul.burton@imgtec.com, macro@codesourcery.com, linux@roeck-us.net,
        bvanassche@acm.org, ralf@linux-mips.org, hare@suse.de,
        sfr@canb.auug.org.au, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        markos.chandras@imgtec.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, bvanassche@acm.org,
        linux@roeck-us.net, macro@codesourcery.com, paul.burton@imgtec.com,
        hare@suse.de, ralf@linux-mips.org, tglx@linutronix.de,
        sfr@canb.auug.org.au
In-Reply-To: <20140902202126.GA3190@worktop.ger.corp.intel.com>
References: <20140902202126.GA3190@worktop.ger.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking, mips: Fix atomics
Git-Commit-ID: da4c54457e6d8262423aded4bcbccc4103049506
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da4c54457e6d8262423aded4bcbccc4103049506
Gitweb:     http://git.kernel.org/tip/da4c54457e6d8262423aded4bcbccc4103049506
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 2 Sep 2014 22:21:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Sep 2014 11:45:06 +0200

locking, mips: Fix atomics

The patch folding the atomic ops had two silly fails in the _return
primitives.

Fixes: ef31563e950c ("locking,arch,mips: Fold atomic_ops")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maciej W. Rozycki <macro@codesourcery.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/20140902202126.GA3190@worktop.ger.corp.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/include/asm/atomic.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 476fe3b..f3ee721 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -93,7 +93,7 @@ static __inline__ int atomic_##op##_return(int i, atomic_t * v)			\
 		"	" #asm_op " %0, %1, %3				\n"	\
 		"	sc	%0, %2					\n"	\
 		"	beqzl	%0, 1b					\n"	\
-		"	addu	%0, %1, %3				\n"	\
+		"	" #asm_op " %0, %1, %3				\n"	\
 		"	.set	mips0					\n"	\
 		: "=&r" (result), "=&r" (temp), "+m" (v->counter)		\
 		: "Ir" (i));							\
@@ -111,7 +111,7 @@ static __inline__ int atomic_##op##_return(int i, atomic_t * v)			\
 			: "Ir" (i));						\
 		} while (unlikely(!result));					\
 										\
-		result = temp + i;						\
+		result = temp; result c_op i;					\
 	} else {								\
 		unsigned long flags;						\
 										\
@@ -387,7 +387,7 @@ static __inline__ long atomic64_##op##_return(long i, atomic64_t * v)		\
 			: "memory");						\
 		} while (unlikely(!result));					\
 										\
-		result = temp + i;						\
+		result = temp; result c_op i;					\
 	} else {								\
 		unsigned long flags;						\
 										\
