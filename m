Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaIKMsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:48:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Deacon" <will.deacon@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Mark Rutland" <mark.rutland@arm.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.265647652@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 091/131] ARM: 8128/1: abort: don't clear the exclusive
 monitors
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 85868313177700d20644263a782351262d2aff84 upstream.

The ARMv6 and ARMv7 early abort handlers clear the exclusive monitors
upon entry to the kernel, but this is redundant:

  - We clear the monitors on every exception return since commit
    200b812d0084 ("Clear the exclusive monitor when returning from an
    exception"), so this is not necessary to ensure the monitors are
    cleared before returning from a fault handler.

  - Any dummy STREX will target a temporary scratch area in memory, and
    may succeed or fail without corrupting useful data. Its status value
    will not be used.

  - Any other STREX in the kernel must be preceded by an LDREX, which
    will initialise the monitors consistently and will not depend on the
    earlier state of the monitors.

Therefore we have no reason to care about the initial state of the
exclusive monitors when a data abort is taken, and clearing the monitors
prior to exception return (as we already do) is sufficient.

This patch removes the redundant clearing of the exclusive monitors from
the early abort handlers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/abort-ev6.S | 6 ------
 arch/arm/mm/abort-ev7.S | 6 ------
 2 files changed, 12 deletions(-)

--- a/arch/arm/mm/abort-ev6.S
+++ b/arch/arm/mm/abort-ev6.S
@@ -17,12 +17,6 @@
  */
 	.align	5
 ENTRY(v6_early_abort)
-#ifdef CONFIG_CPU_V6
-	sub	r1, sp, #4			@ Get unused stack location
-	strex	r0, r1, [r1]			@ Clear the exclusive monitor
-#elif defined(CONFIG_CPU_32v6K)
-	clrex
-#endif
 	mrc	p15, 0, r1, c5, c0, 0		@ get FSR
 	mrc	p15, 0, r0, c6, c0, 0		@ get FAR
 /*
--- a/arch/arm/mm/abort-ev7.S
+++ b/arch/arm/mm/abort-ev7.S
@@ -13,12 +13,6 @@
  */
 	.align	5
 ENTRY(v7_early_abort)
-	/*
-	 * The effect of data aborts on on the exclusive access monitor are
-	 * UNPREDICTABLE. Do a CLREX to clear the state
-	 */
-	clrex
-
 	mrc	p15, 0, r1, c5, c0, 0		@ get FSR
 	mrc	p15, 0, r0, c6, c0, 0		@ get FAR
 

