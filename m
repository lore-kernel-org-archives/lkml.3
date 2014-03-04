Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaCDUCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:02:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaCDUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 018/172] ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev
Date: Tue,  4 Mar 2014 12:01:42 -0800
Message-Id: <20140304200300.307057494@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/spinlock.h |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -37,18 +37,9 @@
 
 static inline void dsb_sev(void)
 {
-#if __LINUX_ARM_ARCH__ >= 7
-	__asm__ __volatile__ (
-		"dsb ishst\n"
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


