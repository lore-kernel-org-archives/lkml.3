Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3FCWVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:21:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab3FCWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:01 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xhFQLsLKRa8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=BdxQlW7KQHsA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=drOt6m5kAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=MSl-tDqOz04A:10 a=ESTKKtUg-DoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221155.158605909@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [18/65] ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldnt clear upper 32 bits of
 the old/new value
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0018-ARM-7720-1-ARM-v6-v7-cmpxchg64-shouldn-t-clear-upper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>

[ Upstream commit 6eabb3301b1facee669d9938f7c5a0295c21d71d ]

The implementation of cmpxchg64() for the ARM v6 and v7 architecture
casts parameter 2 and 3 (the old and new 64bit values) to an unsigned
long before calling the atomic_cmpxchg64() function. This clears
the top 32 bits of the old and new values, resulting in the wrong
values being compare-exchanged. Luckily, this only appears to be used
for 64-bit sched_clock, which we don't (yet) have on ARM.

This bug was introduced by commit 3e0f5a15f500 ("ARM: 7404/1: cmpxchg64:
use atomic64 and local64 routines for cmpxchg64").

Cc: <stable@vger.kernel.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/cmpxchg.h |    8 ++++----
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
1.7.10.4


