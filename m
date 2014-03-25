Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaCYSAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:00:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaCYRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 08/81] ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev
Date: Tue, 25 Mar 2014 10:15:21 -0700
Message-Id: <1395767794-5012-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 7c8746a9eb287642deaad0e7c2cdf482dce5e4be upstream.

When unlocking a spinlock, we require the following, strictly ordered
sequence of events:

	<barrier>	/* dmb */
	<unlock>
	<barrier>	/* dsb */
	<sev>

Whilst the code does indeed reflect this in terms of the architecture,
the final <barrier> + <sev> have been contracted into a single inline
asm without a "memory" clobber, therefore the compiler is at liberty to
reorder the unlock to the end of the above sequence. In such a case,
a waiting CPU may be woken up before the lock has been unlocked, leading
to extremely poor performance.

This patch reworks the dsb_sev() function to make use of the dsb()
macro and ensure ordering against the unlock.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/spinlock.h | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/spinlock.h b/arch/arm/include/asm/spinlock.h
index b4ca707..d429475 100644
--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -44,18 +44,9 @@
 
 static inline void dsb_sev(void)
 {
-#if __LINUX_ARM_ARCH__ >= 7
-	__asm__ __volatile__ (
-		"dsb\n"
-		SEV
-	);
-#else
-	__asm__ __volatile__ (
-		"mcr p15, 0, %0, c7, c10, 4\n"
-		SEV
-		: : "r" (0)
-	);
-#endif
+
+	dsb(ishst);
+	__asm__(SEV);
 }
 
 /*
-- 
1.8.3.2

