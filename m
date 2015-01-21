Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbbAUQHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:07:51 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65112 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbAUQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:07:43 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Joseph Lo <josephl@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>, linux-tegra@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] ARM: l2c: Maintain CPU endianness for early resume function
Date: Wed, 21 Jan 2015 19:07:19 +0300
Message-Id: <1421856440-28097-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In big endian CPU mode l2x0_saved_regs structure stores registers values in BE
format. In order to maintain BE CPU mode, these values and immediate constants
must be converted back to LE format before writing them to cache controller.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
V2: no code change, fixed patch numbering, extended mail recipients list

 arch/arm/mm/l2c-l2x0-resume.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mm/l2c-l2x0-resume.S b/arch/arm/mm/l2c-l2x0-resume.S
index fda415e..9f99c7e 100644
--- a/arch/arm/mm/l2c-l2x0-resume.S
+++ b/arch/arm/mm/l2c-l2x0-resume.S
@@ -30,6 +30,15 @@ ENTRY(l2c310_early_resume)
 	teq	r1, #0
 	reteq	lr
 
+	@ Reverse for big endian kernel
+ARM_BE8(rev	r2, r2)
+ARM_BE8(rev	r3, r3)
+ARM_BE8(rev	r4, r4)
+ARM_BE8(rev	r5, r5)
+ARM_BE8(rev	r6, r6)
+ARM_BE8(rev	r7, r7)
+ARM_BE8(rev	r8, r8)
+
 	@ The prefetch and power control registers are revision dependent
 	@ and can be written whether or not the L2 cache is enabled
 	ldr	r0, [r1, #L2X0_CACHE_ID]
@@ -51,6 +60,7 @@ ENTRY(l2c310_early_resume)
 
 	str	r2, [r1, #L2X0_AUX_CTRL]
 	mov	r9, #L2X0_CTRL_EN
+ARM_BE8(rev	r9, r9)
 	str	r9, [r1, #L2X0_CTRL]
 	ret	lr
 ENDPROC(l2c310_early_resume)
-- 
2.2.1

