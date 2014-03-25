Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaCYWsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:48:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49788 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108AbaCYWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:48:49 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v5 01/14] ARM: PJ4B: Add cpu_suspend/cpu_resume hooks for PJ4B
Date: Tue, 25 Mar 2014 23:48:12 +0100
Message-Id: <1395787705-31061-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PJ4B needs extra instructions for suspend and resume, so instead of
using the armv7 version, this commit introduces specific versions for
PJ4B.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mm/proc-v7.S | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index bd1781979a39..3c49ac86d9d2 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -169,9 +169,31 @@ ENDPROC(cpu_pj4b_do_idle)
 	globl_equ	cpu_pj4b_do_idle,  	cpu_v7_do_idle
 #endif
 	globl_equ	cpu_pj4b_dcache_clean_area,	cpu_v7_dcache_clean_area
-	globl_equ	cpu_pj4b_do_suspend,	cpu_v7_do_suspend
-	globl_equ	cpu_pj4b_do_resume,	cpu_v7_do_resume
-	globl_equ	cpu_pj4b_suspend_size,	cpu_v7_suspend_size
+#ifdef CONFIG_ARM_CPU_SUSPEND
+ENTRY(cpu_pj4b_do_suspend)
+	stmfd	sp!, {r6 - r10}
+	mrc	p15, 1, r6, c15, c1, 0  @ save CP15 - extra features
+	mrc	p15, 1, r7, c15, c2, 0	@ save CP15 - Aux Func Modes Ctrl 0
+	mrc	p15, 1, r8, c15, c1, 2	@ save CP15 - Aux Debug Modes Ctrl 2
+	mrc	p15, 1, r9, c15, c1, 1  @ save CP15 - Aux Debug Modes Ctrl 1
+	mrc	p15, 0, r10, c9, c14, 0  @ save CP15 - PMC
+	stmia	r0!, {r6 - r10}
+	ldmfd	sp!, {r6 - r10}
+	b cpu_v7_do_suspend
+ENDPROC(cpu_pj4b_do_suspend)
+
+ENTRY(cpu_pj4b_do_resume)
+	ldmia	r0!, {r6 - r10}
+	mcr	p15, 1, r6, c15, c1, 0  @ save CP15 - extra features
+	mcr	p15, 1, r7, c15, c2, 0	@ save CP15 - Aux Func Modes Ctrl 0
+	mcr	p15, 1, r8, c15, c1, 2	@ save CP15 - Aux Debug Modes Ctrl 2
+	mcr	p15, 1, r9, c15, c1, 1  @ save CP15 - Aux Debug Modes Ctrl 1
+	mcr	p15, 0, r10, c9, c14, 0  @ save CP15 - PMC
+	b cpu_v7_do_resume
+ENDPROC(cpu_pj4b_do_resume)
+#endif
+.globl	cpu_pj4b_suspend_size
+.equ	cpu_pj4b_suspend_size, 4 * 14
 
 #endif
 
-- 
1.8.1.2

