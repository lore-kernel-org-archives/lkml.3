Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab3EQWSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:18:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab3EQVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 039/102] ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldnt clear upper 32 bits of the old/new value
Date: Fri, 17 May 2013 14:35:54 -0700
Message-Id: <20130517213248.427046921@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/cmpxchg.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/cmpxchg.h
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -233,15 +233,15 @@ static inline unsigned long __cmpxchg_lo
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
 


