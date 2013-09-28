Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3I1K6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:58:45 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:37333 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3I1K6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:58:19 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 3/3] s390: enable ARCH_USE_CMPXCHG_LOCKREF
Date: Sat, 28 Sep 2013 12:58:11 +0200
Message-Id: <1380365891-34457-4-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092810-2966-0000-0000-000008E4442F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ARCH_USE_CMPXCHG_LOCKREF since it shows performance improvements
with Linus' simple stat() test case of up to 50% on a 30 cpu system.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig                | 1 +
 arch/s390/include/asm/spinlock.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d3fa840..7143793 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -93,6 +93,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
+	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS2
diff --git a/arch/s390/include/asm/spinlock.h b/arch/s390/include/asm/spinlock.h
index 701fe8c..83e5d216 100644
--- a/arch/s390/include/asm/spinlock.h
+++ b/arch/s390/include/asm/spinlock.h
@@ -44,6 +44,11 @@ extern void arch_spin_lock_wait_flags(arch_spinlock_t *, unsigned long flags);
 extern int arch_spin_trylock_retry(arch_spinlock_t *);
 extern void arch_spin_relax(arch_spinlock_t *lock);
 
+static inline int arch_spin_value_unlocked(arch_spinlock_t lock)
+{
+	return lock.owner_cpu == 0;
+}
+
 static inline void arch_spin_lock(arch_spinlock_t *lp)
 {
 	int old;
-- 
1.8.3.4

