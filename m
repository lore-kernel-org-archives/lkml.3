Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaC1LOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:14:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35389 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751965AbaC1LO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:14:26 -0400
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
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/11] ARM: mvebu: Low level function to disable HW coherency support
Date: Fri, 28 Mar 2014 12:13:26 +0100
Message-Id: <1396005211-15573-7-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
References: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When going to deep idle we need to disable the SoC snooping (aka
hardware coherency support). Playing with the coherency fabric
requires to use assembly code to be sure that the compiler doesn't
reorder the instructions nor do wrong optimization.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/coherency_ll.S | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
index f2e2e8677c4b..6828f9f157b0 100644
--- a/arch/arm/mach-mvebu/coherency_ll.S
+++ b/arch/arm/mach-mvebu/coherency_ll.S
@@ -102,6 +102,26 @@ ENTRY(ll_enable_coherency)
 	mov	pc, lr
 ENDPROC(ll_enable_coherency)
 
+ENTRY(ll_disable_coherency)
+	/*
+	 * r0 being untouched in ll_get_coherency_base and
+	 * ll_get_cpuid, we can use it to save lr modifing it with the
+	 * following bl
+	 */
+	mov r0, lr
+	bl	ll_get_coherency_base
+	bl	ll_get_cpuid
+	mov lr, r0
+	add	r0, r1, #ARMADA_XP_CFB_CTL_REG_OFFSET
+1:
+	ldrex	r2, [r0]
+	bic	r2, r2, r3
+	strex	r1, r2, [r0]
+	cmp	r1, #0
+	bne	1b
+	dsb
+	mov	pc, lr
+ENDPROC(ll_disable_coherency)
 
 	.align 2
 3:
-- 
1.8.1.2

