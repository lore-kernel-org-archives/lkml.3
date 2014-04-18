Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaDRNMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:12:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39129 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbaDRNMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:12:34 -0400
Date: Fri, 18 Apr 2014 06:11:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-kme5dz5hcobpnufnnkh1ech2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        schwidefsky@de.ibm.com, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, gang.chen@asianux.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, schwidefsky@de.ibm.com,
        paulmck@linux.vnet.ibm.com, gang.chen@asianux.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,s390: Convert smp_mb__*()
Git-Commit-ID: 0e530747c69f1e191f101a925bb4051894e5c7b0
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

Commit-ID:  0e530747c69f1e191f101a925bb4051894e5c7b0
Gitweb:     http://git.kernel.org/tip/0e530747c69f1e191f101a925bb4051894e5c7b0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:42 +0200

arch,s390: Convert smp_mb__*()

As per the existing implementation; implement the new one using
smp_mb().

AFAICT the s390 compare-and-swap does imply a barrier, however there
are some immediate ops that seem to be singly-copy atomic and do not
imply a barrier. One such is the "ni" op (which would be
and-immediate) which is used for the constant clear_bit
implementation. Therefore s390 needs full barriers for the
{before,after} atomic ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-kme5dz5hcobpnufnnkh1ech2@git.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux390@de.ibm.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/include/asm/atomic.h  | 5 -----
 arch/s390/include/asm/barrier.h | 5 +++--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 1d47061..fa934fe 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -412,9 +412,4 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
 #define atomic64_dec_and_test(_v)	(atomic64_sub_return(1, _v) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #endif /* __ARCH_S390_ATOMIC__  */
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 578680f..19ff956 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -27,8 +27,9 @@
 #define smp_rmb()			rmb()
 #define smp_wmb()			wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+
+#define smp_mb__before_atomic()		smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
