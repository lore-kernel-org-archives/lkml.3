Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641Ab3BNNtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:49:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317Ab3BNNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/11] ARM: integrator: fix build with INTEGRATOR_AP off
Date: Thu, 14 Feb 2013 14:49:23 +0100
Message-Id: <1360849767-1463135-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Zh8zwQxgevF/LpXRyR/Lf06SrTjGTklU+3YPKEcRkLo
 FR6HhUmtoVuagev8og9FAvXBn1bCTPWgIG0kWkYo6h0eywuhtG
 JWlptfW9UTpLZb1CLxDNqu18OnhBPybOpdwNbLYBH+g/OHyWUd
 oksy4pGqVro5Xixt9pCeYYYVaYrKfEGyWnaH9EHJtUliv8/b7H
 Va1uPYqTFF/7i7kT1uZZQdKeNf/GZ720WWZF/rIn1+q01JMf3P
 8L5ABRyjcWHO0Mv2+1II9/aYTKniKVB48K7P0jADDhtHzdA7oH
 iNgQBfK2kTBTHudGtOJktS14i1QVFW22ZvG6/NmReziR01inxo
 /KgnpOillew1AenIjHI5ejluovX5Doipg5D5o7Izc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditional declaration of ap_uart_data is broken
and causes this build error:

In file included from arch/arm/mach-integrator/core.c:35:0:
arch/arm/mach-integrator/common.h:6:37: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token

Turning the check into an constant-expression if(IS_ENABLED()) statement
creates more readable code and solves this problem as well.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-integrator/common.h | 5 -----
 arch/arm/mach-integrator/core.c   | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-integrator/common.h b/arch/arm/mach-integrator/common.h
index 79197d8..72516658b 100644
--- a/arch/arm/mach-integrator/common.h
+++ b/arch/arm/mach-integrator/common.h
@@ -1,10 +1,5 @@
 #include <linux/amba/serial.h>
-#ifdef CONFIG_ARCH_INTEGRATOR_AP
 extern struct amba_pl010_data ap_uart_data;
-#else
-/* Not used without Integrator/AP support anyway */
-struct amba_pl010_data ap_uart_data {};
-#endif
 void integrator_init_early(void);
 int integrator_init(bool is_cp);
 void integrator_reserve(void);
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 39c060f..81461d2 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -71,7 +71,7 @@ int __init integrator_init(bool is_cp)
 	 * hard-code them. The Integator/CP and forward have proper cell IDs.
 	 * Else we leave them undefined to the bus driver can autoprobe them.
 	 */
-	if (!is_cp) {
+	if (!is_cp && IS_ENABLED(CONFIG_ARCH_INTEGRATOR_AP)) {
 		rtc_device.periphid	= 0x00041030;
 		uart0_device.periphid	= 0x00041010;
 		uart1_device.periphid	= 0x00041010;
-- 
1.8.1.2

