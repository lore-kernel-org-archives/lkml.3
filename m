Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3JJCfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:35:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6522 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3JJCfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:35:03 -0400
X-Spam-Score: -100.8
Message-ID: <5256121A.9030504@asianux.com>
Date: Thu, 10 Oct 2013 10:34:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] arm: include: asm: atomic.h: use 'unsigned int' and 'atomic'
 instead of 'unsigned long' for atomic_clear_mask()
References: <52561137.3070608@asianux.com> <5256117A.4000009@asianux.com>
In-Reply-To: <5256117A.4000009@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current kernel wide source, for arm, only s390 scsi drivers use
atomic_clear_mask(), now, s390 itself need use 'unsigned int' and
'atomic_t', so need match s390's atomic_clear_mask().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/include/asm/atomic.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index da1c77d..0832a7f 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -134,9 +134,10 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 	return oldval;
 }
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *ptr)
 {
-	unsigned long tmp, tmp2;
+	unsigned int tmp;
+	unsigned long tmp2;
 
 	__asm__ __volatile__("@ atomic_clear_mask\n"
 "1:	ldrex	%0, [%3]\n"
@@ -144,8 +145,8 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 "	strex	%1, %0, [%3]\n"
 "	teq	%1, #0\n"
 "	bne	1b"
-	: "=&r" (tmp), "=&r" (tmp2), "+Qo" (*addr)
-	: "r" (addr), "Ir" (mask)
+	: "=&r" (tmp), "=&r" (tmp2), "+Qo" (ptr->counter)
+	: "r" (&ptr->counter), "Ir" (mask)
 	: "cc");
 }
 
@@ -197,12 +198,12 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return ret;
 }
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
 	unsigned long flags;
 
 	raw_local_irq_save(flags);
-	*addr &= ~mask;
+	v->counter &= ~mask;
 	raw_local_irq_restore(flags);
 }
 
-- 
1.7.7.6
