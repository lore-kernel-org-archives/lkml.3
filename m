Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaKXNDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:03:51 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:43720 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaKXNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:03:41 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 6/7] arm64: Replace ACCESS_ONCE for spinlock code with barriers
Date: Mon, 24 Nov 2014 14:03:29 +0100
Message-Id: <1416834210-61738-7-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112413-0025-0000-0000-0000028BFFF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the spinlock code to access the lock with a barrier.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/arm64/include/asm/spinlock.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index c45b7b1..f72dc64 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -99,12 +99,15 @@ static inline int arch_spin_value_unlocked(arch_spinlock_t lock)
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-	return !arch_spin_value_unlocked(ACCESS_ONCE(*lock));
+	arch_spinlock_t lockval = *lock;
+	barrier();
+	return !arch_spin_value_unlocked(lockval);
 }
 
 static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
-	arch_spinlock_t lockval = ACCESS_ONCE(*lock);
+	arch_spinlock_t lockval = *lock;
+	barrier();
 	return (lockval.next - lockval.owner) > 1;
 }
 #define arch_spin_is_contended	arch_spin_is_contended
-- 
1.9.3

