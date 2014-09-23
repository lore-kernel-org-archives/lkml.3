Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaIWCk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:38433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIWCkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:22 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 31/45] ARM: 8128/1: abort: don't clear the exclusive monitors
Date: Tue, 23 Sep 2014 10:31:33 +0800
Message-Id: <1411439507-30391-31-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/arm/mm/abort-ev6.S |    6 ------
 arch/arm/mm/abort-ev7.S |    6 ------
 2 files changed, 12 deletions(-)

diff --git a/arch/arm/mm/abort-ev6.S b/arch/arm/mm/abort-ev6.S
index 8074199..5d777a5 100644
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
diff --git a/arch/arm/mm/abort-ev7.S b/arch/arm/mm/abort-ev7.S
index 7033752..4812ad0 100644
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
 
-- 
1.7.9.5

