Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbaCDUG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:06:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbaCDUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.10 88/97] ARM: 7812/1: rwlocks: retry trylock operation if strex fails on free lock
Date: Tue,  4 Mar 2014 12:04:41 -0800
Message-Id: <20140304200348.905927391@linuxfoundation.org>
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

commit 00efaa0250939dc148e2d3104fb3c18395d24a2d upstream.

Commit 15e7e5c1ebf5 ("ARM: 7749/1: spinlock: retry trylock operation if
strex fails on free lock") modifying our arch_spin_trylock to retry the
acquisition if the lock appeared uncontended, but the strex failed.

This patch does the same for rwlocks, which were missed by the original
patch.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/spinlock.h |   49 ++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 19 deletions(-)

--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -168,17 +168,20 @@ static inline void arch_write_lock(arch_
 
 static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
-	unsigned long tmp;
+	unsigned long contended, res;
 
-	__asm__ __volatile__(
-"	ldrex	%0, [%1]\n"
-"	teq	%0, #0\n"
-"	strexeq	%0, %2, [%1]"
-	: "=&r" (tmp)
-	: "r" (&rw->lock), "r" (0x80000000)
-	: "cc");
+	do {
+		__asm__ __volatile__(
+		"	ldrex	%0, [%2]\n"
+		"	mov	%1, #0\n"
+		"	teq	%0, #0\n"
+		"	strexeq	%1, %3, [%2]"
+		: "=&r" (contended), "=&r" (res)
+		: "r" (&rw->lock), "r" (0x80000000)
+		: "cc");
+	} while (res);
 
-	if (tmp == 0) {
+	if (!contended) {
 		smp_mb();
 		return 1;
 	} else {
@@ -254,18 +257,26 @@ static inline void arch_read_unlock(arch
 
 static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
-	unsigned long tmp, tmp2 = 1;
+	unsigned long contended, res;
 
-	__asm__ __volatile__(
-"	ldrex	%0, [%2]\n"
-"	adds	%0, %0, #1\n"
-"	strexpl	%1, %0, [%2]\n"
-	: "=&r" (tmp), "+r" (tmp2)
-	: "r" (&rw->lock)
-	: "cc");
+	do {
+		__asm__ __volatile__(
+		"	ldrex	%0, [%2]\n"
+		"	mov	%1, #0\n"
+		"	adds	%0, %0, #1\n"
+		"	strexpl	%1, %0, [%2]"
+		: "=&r" (contended), "=&r" (res)
+		: "r" (&rw->lock)
+		: "cc");
+	} while (res);
 
-	smp_mb();
-	return tmp2 == 0;
+	/* If the lock is negative, then it is already held for write. */
+	if (contended < 0x80000000) {
+		smp_mb();
+		return 1;
+	} else {
+		return 0;
+	}
 }
 
 /* read_can_lock - would read_trylock() succeed? */


