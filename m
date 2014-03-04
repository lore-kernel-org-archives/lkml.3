Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaCDUFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:05:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbaCDUFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Thompson <anthony.thompson@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.10 87/97] ARM: 7749/1: spinlock: retry trylock operation if strex fails on free lock
Date: Tue,  4 Mar 2014 12:04:40 -0800
Message-Id: <20140304200348.875416170@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 15e7e5c1ebf556cd620c9b091e121091ac760f6d upstream.

An exclusive store instruction may fail for reasons other than lock
contention (e.g. a cache eviction during the critical section) so, in
line with other architectures using similar exclusive instructions
(alpha, mips, powerpc), retry the trylock operation if the lock appears
to be free but the strex reported failure.

Reported-by: Tony Thompson <anthony.thompson@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/spinlock.h |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -97,19 +97,22 @@ static inline void arch_spin_lock(arch_s
 
 static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
-	unsigned long tmp;
+	unsigned long contended, res;
 	u32 slock;
 
-	__asm__ __volatile__(
-"	ldrex	%0, [%2]\n"
-"	subs	%1, %0, %0, ror #16\n"
-"	addeq	%0, %0, %3\n"
-"	strexeq	%1, %0, [%2]"
-	: "=&r" (slock), "=&r" (tmp)
-	: "r" (&lock->slock), "I" (1 << TICKET_SHIFT)
-	: "cc");
+	do {
+		__asm__ __volatile__(
+		"	ldrex	%0, [%3]\n"
+		"	mov	%2, #0\n"
+		"	subs	%1, %0, %0, ror #16\n"
+		"	addeq	%0, %0, %4\n"
+		"	strexeq	%2, %0, [%3]"
+		: "=&r" (slock), "=&r" (contended), "=r" (res)
+		: "r" (&lock->slock), "I" (1 << TICKET_SHIFT)
+		: "cc");
+	} while (res);
 
-	if (tmp == 0) {
+	if (!contended) {
 		smp_mb();
 		return 1;
 	} else {


