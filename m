Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3AYWsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:48:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3AYWs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:48:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 18/19] ARM: at91: suspend both memory controllers on at91sam9263
Date: Fri, 25 Jan 2013 22:44:17 +0000
Message-Id: <1359153858-31992-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:98kGnuZbiLxU9XO5z0R2kdqbQT5IDiNr33pgWJOU45O
 0Dyg5ZMWfktPQ7ODDaZGKogfHlHRcqN1YZMCJ1ooeyBrNFztDa
 0f7odulWxP2189CxXzQUmN2/nprhJEztLwdm84dBLYS5QDHndc
 qEAvPjR4lLy31BivDqr8V3xVGIA5F7o3ZG4X0u8fq/9Zg/kcLb
 ZUu+VzQicKbXa3HPfv7vp1inW9PbNcgLmCHoFfJYojmbnFs7nU
 dj0ictd+ZgYty09Elt0LRVX4CGrP3HdOOwCMi9SEQIQ8I9eSzD
 qMvmCYqTt7X+9a62Ibww4HIJIFGSvtzYLakIheNb09pAvWjI8U
 w6zmxmU6FQc3iseUotaD6aYBX80evuvyMvt7EkKT0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the past three years, we have had a #warning in
mach-at91 about the sdram_selfrefresh_enable or
at91sam9_standby functions possibly not working on
at91sam9263. In the meantime a function was added
to do the right thing on at91sam9g45, which looks like
it should also work on '9263.

This patch blindly removes the warning and changes the
at91sam9263 to use the same code at at91sam9g45, which
may or may not be the right solution. If it is not,
maybe someone could provide a better fix.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-at91/cpuidle.c |  2 ++
 arch/arm/mach-at91/pm.c      |  2 ++
 arch/arm/mach-at91/pm.h      | 30 ++++++++++++++++++++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index 0c63815..4c67946 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -38,6 +38,8 @@ static int at91_enter_idle(struct cpuidle_device *dev,
 		at91rm9200_standby();
 	else if (cpu_is_at91sam9g45())
 		at91sam9g45_standby();
+	else if (cpu_is_at91sam9263())
+		at91sam9263_standby();
 	else
 		at91sam9_standby();
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index adb6db8..b8017c1 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -267,6 +267,8 @@ static int at91_pm_enter(suspend_state_t state)
 				at91rm9200_standby();
 			else if (cpu_is_at91sam9g45())
 				at91sam9g45_standby();
+			else if (cpu_is_at91sam9263())
+				at91sam9263_standby();
 			else
 				at91sam9_standby();
 			break;
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 38f467c..2f5908f 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -70,13 +70,31 @@ static inline void at91sam9g45_standby(void)
 	at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1);
 }
 
-#ifdef CONFIG_SOC_AT91SAM9263
-/*
- * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
- * handle those cases both here and in the Suspend-To-RAM support.
+/* We manage both DDRAM/SDRAM controllers, we need more than one value to
+ * remember.
  */
-#warning Assuming EB1 SDRAM controller is *NOT* used
-#endif
+static inline void at91sam9263_standby(void)
+{
+	u32 lpr0, lpr1;
+	u32 saved_lpr0, saved_lpr1;
+
+	saved_lpr1 = at91_ramc_read(1, AT91_SDRAMC_LPR);
+	lpr1 = saved_lpr1 & ~AT91_SDRAMC_LPCB;
+	lpr1 |= AT91_SDRAMC_LPCB_SELF_REFRESH;
+
+	saved_lpr0 = at91_ramc_read(0, AT91_SDRAMC_LPR);
+	lpr0 = saved_lpr0 & ~AT91_SDRAMC_LPCB;
+	lpr0 |= AT91_SDRAMC_LPCB_SELF_REFRESH;
+
+	/* self-refresh mode now */
+	at91_ramc_write(0, AT91_SDRAMC_LPR, lpr0);
+	at91_ramc_write(1, AT91_SDRAMC_LPR, lpr1);
+
+	cpu_do_idle();
+
+	at91_ramc_write(0, AT91_SDRAMC_LPR, saved_lpr0);
+	at91_ramc_write(1, AT91_SDRAMC_LPR, saved_lpr1);
+}
 
 static inline void at91sam9_standby(void)
 {
-- 
1.8.0

