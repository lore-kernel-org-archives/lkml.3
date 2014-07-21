Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaGUVJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:09:42 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48083 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaGUVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:09:36 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Gregory Fong <gregory.0xf0@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v8 05/11] ARM: Enable erratum 798181 for Broadcom Brahma-B15
Date: Mon, 21 Jul 2014 14:08:00 -0700
Message-Id: <1405976886-27807-6-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Fong <gregory.0xf0@gmail.com>

Broadcom Brahma-B15 (r0p0..r0p2) is also affected by Cortex-A15
erratum 798181, so enable the workaround for Brahma-B15.

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
Acked-by: Marc Carino <marc.ceeeee@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/smp_tlb.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/smp_tlb.c b/arch/arm/kernel/smp_tlb.c
index 95d063620b76..2e72be4f623e 100644
--- a/arch/arm/kernel/smp_tlb.c
+++ b/arch/arm/kernel/smp_tlb.c
@@ -92,15 +92,19 @@ void erratum_a15_798181_init(void)
 	unsigned int midr = read_cpuid_id();
 	unsigned int revidr = read_cpuid(CPUID_REVIDR);
 
-	/* Cortex-A15 r0p0..r3p2 w/o ECO fix affected */
-	if ((midr & 0xff0ffff0) != 0x410fc0f0 || midr > 0x413fc0f2 ||
-	    (revidr & 0x210) == 0x210) {
-		return;
-	}
-	if (revidr & 0x10)
-		erratum_a15_798181_handler = erratum_a15_798181_partial;
-	else
+	/* Brahma-B15 r0p0..r0p2 affected
+	 * Cortex-A15 r0p0..r3p2 w/o ECO fix affected */
+	if ((midr & 0xff0ffff0) == 0x420f00f0 && midr <= 0x420f00f2)
 		erratum_a15_798181_handler = erratum_a15_798181_broadcast;
+	else if ((midr & 0xff0ffff0) == 0x410fc0f0 && midr <= 0x413fc0f2 &&
+		 (revidr & 0x210) != 0x210) {
+		if (revidr & 0x10)
+			erratum_a15_798181_handler =
+				erratum_a15_798181_partial;
+		else
+			erratum_a15_798181_handler =
+				erratum_a15_798181_broadcast;
+	}
 }
 #endif
 
-- 
1.9.1

