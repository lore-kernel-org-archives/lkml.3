Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3ETK5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:57:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3ETKyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 104/115] ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value
Date: Mon, 20 May 2013 11:51:44 +0100
Message-Id: <1369047116-9378-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>

commit 6eabb3301b1facee669d9938f7c5a0295c21d71d upstream.

The implementation of cmpxchg64() for the ARM v6 and v7 architecture
casts parameter 2 and 3 (the old and new 64bit values) to an unsigned
long before calling the atomic_cmpxchg64() function. This clears
the top 32 bits of the old and new values, resulting in the wrong
values being compare-exchanged. Luckily, this only appears to be used
for 64-bit sched_clock, which we don't (yet) have on ARM.

This bug was introduced by commit 3e0f5a15f500 ("ARM: 7404/1: cmpxchg64:
use atomic64 and local64 routines for cmpxchg64").

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/cmpxchg.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
index 7eb18c1..4f009c1 100644
--- a/arch/arm/include/asm/cmpxchg.h
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -233,15 +233,15 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
 	((__typeof__(*(ptr)))atomic64_cmpxchg(container_of((ptr),	\
 						atomic64_t,		\
 						counter),		\
-					      (unsigned long)(o),	\
-					      (unsigned long)(n)))
+					      (unsigned long long)(o),	\
+					      (unsigned long long)(n)))
 
 #define cmpxchg64_local(ptr, o, n)					\
 	((__typeof__(*(ptr)))local64_cmpxchg(container_of((ptr),	\
 						local64_t,		\
 						a),			\
-					     (unsigned long)(o),	\
-					     (unsigned long)(n)))
+					     (unsigned long long)(o),	\
+					     (unsigned long long)(n)))
 
 #endif	/* __LINUX_ARM_ARCH__ >= 6 */
 
-- 
1.8.1.2

