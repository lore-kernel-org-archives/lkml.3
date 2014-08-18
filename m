Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaHRJ6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:58:50 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:55032 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaHRJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:58:47 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux@arm.linux.org.uk
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <ed124cd295a7ea8fa514a31ff4bcde66>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Kever Yang <kever.yang@rock-chips.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Shawn Guo <shawn.guo@linaro.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Mahesh Sivasubramanian <msivasub@codeaurora.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>, heiko@sntech.de,
        addy.ke@rock-chips.com, xjq@rock-chips.com, cf@rock-chips.com,
        hj@rock-chips.com, huangtao@rock-chips.com,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kever Yang <kever.yang@rock-chips.com>
Subject: [PATCH] ARM: errata: Workaround for Cortex-A12 erratum 818325
Date: Mon, 18 Aug 2014 17:58:09 +0800
Message-Id: <1408355889-4176-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Tao <huangtao@rock-chips.com>

On Cortex-A12 (r0p0..r0p1-00lac0-rc11), when a CPU executes a sequence of
two conditional store instructions with opposite condition code and
updating the same register, the system might enter a deadlock if the
second conditional instruction is an UNPREDICTABLE STR or STM
instruction. This workaround setting bit[12] of the Feature Register
prevents the erratum. This bit disables an optimisation applied to a
sequence of 2 instructions that use opposing condition codes.

Signed-off-by: Huang Tao <huangtao@rock-chips.com>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 arch/arm/Kconfig      | 13 +++++++++++++
 arch/arm/mm/proc-v7.S | 15 ++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 32cbbd5..4545835 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1245,6 +1245,19 @@ config ARM_ERRATA_773022
 	  loop buffer may deliver incorrect instructions. This
 	  workaround disables the loop buffer to avoid the erratum.
 
+config ARM_ERRATA_818325
+	bool "ARM errata: Execution of an UNPREDICTABLE STR or STM instruction might deadlock"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the 818325 Cortex-A12
+	  (r0p0..r0p1-00lac0-rc11) erratum. When a CPU executes a sequence of
+	  two conditional store instructions with opposite condition code and
+	  updating the same register, the system might enter a deadlock if the
+	  second conditional instruction is an UNPREDICTABLE STR or STM
+	  instruction. This workaround setting bit[12] of the Feature Register
+	  prevents the erratum. This bit disables an optimisation applied to a
+	  sequence of 2 instructions that use opposing condition codes.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index b5d67db..5ffdf97 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -408,7 +408,20 @@ __v7_setup:
 	mcrle	p15, 0, r10, c1, c0, 1		@ write aux control register
 #endif
 
-4:	mov	r10, #0
+	/* Cortex-A12 Errata */
+4:	ldr	r10, =0x00000c0d		@ Cortex-A12 primary part number
+	teq	r0, r10
+	bne	5f
+#ifdef CONFIG_ARM_ERRATA_818325
+	teq	r6, #0x00			@ present in r0p0
+	teqne	r6, #0x01			@ present in r0p1-00lac0-rc11
+	mrceq	p15, 0, r10, c15, c0, 1		@ read diagnostic register
+	orreq	r10, r10, #1 << 12		@ set bit #12
+	mcreq	p15, 0, r10, c15, c0, 1		@ write diagnostic register
+	isb
+#endif
+
+5:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
-- 
1.8.3.2


