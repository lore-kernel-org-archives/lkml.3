Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaC3X4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:56:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600AbaC3Xn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Rutland" <mark.rutland@arm.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.424665253@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 099/200] ARM: 7955/1: spinlock: ensure we have a
 compiler barrier before sev
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: 'ishst' variant is not used here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/spinlock.h | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

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
+	dsb();
+	__asm__(SEV);
 }
 
 /*

