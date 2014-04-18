Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaDRNEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:04:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaDRNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:04:46 -0400
Date: Fri, 18 Apr 2014 06:03:44 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-akevfh136um9dqvb1ohm55ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tony.luck@intel.com, akinobu.mita@gmail.com,
        paulmck@linux.vnet.ibm.com, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akinobu.mita@gmail.com, tony.luck@intel.com,
        paulmck@linux.vnet.ibm.com, fenghua.yu@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] ia64: Fix up smp_mb__{before,after}_clear_bit(
 )
Git-Commit-ID: e4f9bfb3feaeaca55cf177dadb7e3313836b10f4
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

Commit-ID:  e4f9bfb3feaeaca55cf177dadb7e3313836b10f4
Gitweb:     http://git.kernel.org/tip/e4f9bfb3feaeaca55cf177dadb7e3313836b10f4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 4 Feb 2014 20:36:01 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:29 +0200

ia64: Fix up smp_mb__{before,after}_clear_bit()

IA64 doesn't actually have acquire/release barriers, its a lie!

Add a comment explaining this and fix up the bitop barriers.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-akevfh136um9dqvb1ohm55ca@git.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/ia64/include/asm/bitops.h       | 7 ++-----
 arch/ia64/include/uapi/asm/cmpxchg.h | 9 +++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index c27eccd..feb8117 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -65,11 +65,8 @@ __set_bit (int nr, volatile void *addr)
 	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
 }
 
-/*
- * clear_bit() has "acquire" semantics.
- */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	do { /* skip */; } while (0)
+#define smp_mb__before_clear_bit()	barrier();
+#define smp_mb__after_clear_bit()	barrier();
 
 /**
  * clear_bit - Clears a bit in memory
diff --git a/arch/ia64/include/uapi/asm/cmpxchg.h b/arch/ia64/include/uapi/asm/cmpxchg.h
index 4f37dbb..f35109b 100644
--- a/arch/ia64/include/uapi/asm/cmpxchg.h
+++ b/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -118,6 +118,15 @@ extern long ia64_cmpxchg_called_with_bad_pointer(void);
 #define cmpxchg_rel(ptr, o, n)	\
 	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
 
+/*
+ * Worse still - early processor implementations actually just ignored
+ * the acquire/release and did a full fence all the time.  Unfortunately
+ * this meant a lot of badly written code that used .acq when they really
+ * wanted .rel became legacy out in the wild - so when we made a cpu
+ * that strictly did the .acq or .rel ... all that code started breaking - so
+ * we had to back-pedal and keep the "legacy" behavior of a full fence :-(
+ */
+
 /* for compatibility with other platforms: */
 #define cmpxchg(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
 #define cmpxchg64(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
