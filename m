Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3JJCgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:36:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6539 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JJCgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:36:22 -0400
X-Spam-Score: -100.7
Message-ID: <52561269.60900@asianux.com>
Date: Thu, 10 Oct 2013 10:35:21 +0800
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
Subject: [PATCH 3/3] arm64: include: asm: atomic.h: use 'unsigned int' and
 'atomic_t' instead of 'unsigned long' for atomic_clear_mask()
References: <52561137.3070608@asianux.com> <5256117A.4000009@asianux.com> <5256121A.9030504@asianux.com>
In-Reply-To: <5256121A.9030504@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current kernel wide source, for arm64, only s390 scsi drivers use
atomic_clear_mask(), now, s390 itself need use 'unsigned int' and
'atomic_t', so need match s390's atomic_clear_mask().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/atomic.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 8363644..58808fc 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -126,16 +126,17 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 	return oldval;
 }
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *ptr)
 {
-	unsigned long tmp, tmp2;
+	unsigned int tmp;
+	unsigned long tmp2;
 
 	asm volatile("// atomic_clear_mask\n"
-"1:	ldxr	%0, %2\n"
-"	bic	%0, %0, %3\n"
-"	stxr	%w1, %0, %2\n"
+"1:	ldxr	%w0, %2\n"
+"	bic	%w0, %w0, %w3\n"
+"	stxr	%w1, %w0, %2\n"
 "	cbnz	%w1, 1b"
-	: "=&r" (tmp), "=&r" (tmp2), "+Q" (*addr)
+	: "=&r" (tmp), "=&r" (tmp2), "+Q" (ptr->counter)
 	: "Ir" (mask)
 	: "cc");
 }
-- 
1.7.7.6
