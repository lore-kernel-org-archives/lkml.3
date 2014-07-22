Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaGVPgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:36:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21676 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaGVPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:36:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-63-53ce84fee43c
Subject: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Date: Tue, 22 Jul 2014 19:36:23 +0400
Message-id: <20140722153623.25088.37742.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xa7r/Ws4FG7zfqmQxf+dxVosfO3tZ
	LTY9vsZqcXnXHDaL25d5Lfo+3WexePnxBIsDu8eaeWsYPVqae9g8Ni+p9+jbsorR4/iN7Uwe
	nzfJBbBFcdmkpOZklqUW6dslcGWsnHSQvWAPV8WunxuYGhi3cnQxcnJICJhILFi3jw3CFpO4
	cG89kM3FISSwlFHib2c/M4TTyCRxt/U2I0iVsICLRMfXvWA2m4CZxLZ9EHERAX+J9VvOgzUw
	C3QxSlz8cpMdJMEioCrx/thHpi5GDg5eAWOJSb/BwqICchIrL7ewgti8AoISPybfYwEpYRZQ
	l5gyJRckzCwgL7F5zVvmCYx8s5BUzUKomoWkagEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT8
	3E2MkMD9uoNx6TGrQ4wCHIxKPLwcL04FC7EmlhVX5h5ilOBgVhLhTak/FyzEm5JYWZValB9f
	VJqTWnyIkYmDU6qBcdNs005dC8H7aV+dOnVDHto7tFy+mqsW8JxLReHiz7+CgsHHyzauv3W5
	R1zGcLn5ofc7976vPnzo4//YGi01gfqOldcZAs4dUOq6cLb4jKJ+bsqOLWyCdaeOaNT4zS/a
	ZNCb7dxbLys4O+J25LYSK4GD3A8sTaYIpHCIGGyS++VqPWPJ5mgVJZbijERDLeai4kQAP0Kp
	3DoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes booting when idmap pgd lays above 4gb. Commit
4756dcbfd37 mostly had fixed this, but it'd failed to load upper bits.

Also this fixes adding TTBR1_OFFSET to TTRR1: if lower part overflows
carry flag must be added to the upper part.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/mm/proc-v7-3level.S |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 22e3ad6..f0481dd 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -140,12 +140,11 @@ ENDPROC(cpu_v7_set_pte_ext)
 	mov	\tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
 	mov	\ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT		@ lower bits
 	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
-	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
+	adcls	\tmp, \tmp, #0
+	mcrr	p15, 1, \ttbr1, \tmp, c2			@ load TTBR1
 	mov	\tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
 	mov	\ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT		@ lower bits
-	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
-	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
-	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
+	mcrr	p15, 0, \ttbr0, \tmp, c2			@ load TTBR0
 	.endm
 
 	/*

