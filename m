Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab3EBOvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:51:00 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:56426 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3EBOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:50:59 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 May 2013 10:50:58 EDT
From: dirk.eibach@gdsys.cc
To: linux-kernel@vger.kernel.org
Cc: Dirk Eibach <dirk.eibach@gdsys.cc>, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH] powerpc: Make Book E watchdog reset type configurable
Date: Thu,  2 May 2013 16:45:13 +0200
Message-Id: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc>
X-Mailer: git-send-email 1.7.2.5
X-Df-Sender: ZGlyay5laWJhY2hAZ2RzeXMuY2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Eibach <dirk.eibach@gdsys.cc>

Signed-off-by: Dirk Eibach <dirk.eibach@gdsys.cc>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
---
 drivers/watchdog/Kconfig     |   32 ++++++++++++++++++++++++++++++++
 drivers/watchdog/booke_wdt.c |   10 +++++++++-
 2 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index e89fc31..6048593 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1172,6 +1172,38 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
 
 	  The value can be overridden by the wdt_period command-line parameter.
 
+choice
+	prompt "PowerPC Book-E Watchdog reset type"
+	depends on BOOKE_WDT
+	default BOOKE_WDT_RESET_CHIP
+	help
+	  Specify what kind of reset will be executed on watchdog timeout.
+
+	config BOOKE_WDT_RESET_CORE
+		bool "Core reset"
+	help
+	  Watchdog timeout will trigger a core reset.
+	  The exact function of any of these settings is implementation-de-
+	  pendent.
+	  See the User's Manual for the implementation for further details.
+
+	config BOOKE_WDT_RESET_CHIP
+		bool "Chip reset"
+	help
+	  Watchdog timeout will trigger a chip reset.
+	  The exact function of any of these settings is implementation-de-
+	  pendent.
+	  See the User's Manual for the implementation for further details.
+
+	config BOOKE_WDT_RESET_SYSTEM
+		bool "System reset"
+	help
+	  Watchdog timeout will trigger a system reset.
+	  The exact function of any of these settings is implementation-de-
+	  pendent.
+	  See the User's Manual for the implementation for further details.
+endchoice
+
 # PPC64 Architecture
 
 config WATCHDOG_RTAS
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index a8dbceb3..7791d19 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -22,6 +22,14 @@
 #include <asm/time.h>
 #include <asm/div64.h>
 
+#if defined(CONFIG_BOOKE_WDT_RESET_CORE)
+#define WRC		WRC_CORE
+#elif defined(CONFIG_BOOKE_WDT_RESET_CHIP)
+#define WRC		WRC_CHIP
+#elif defined(CONFIG_BOOKE_WDT_RESET_SYSTEM)
+#define WRC		WRC_SYSTEM
+#endif
+
 /* If the kernel parameter wdt=1, the watchdog will be enabled at boot.
  * Also, the wdt_period sets the watchdog timer period timeout.
  * For E500 cpus the wdt_period sets which bit changing from 0->1 will
@@ -136,7 +144,7 @@ static void __booke_wdt_enable(void *data)
 	__booke_wdt_ping(NULL);
 	val = mfspr(SPRN_TCR);
 	val &= ~WDTP_MASK;
-	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(booke_wdt_period));
+	val |= (TCR_WIE|TCR_WRC(WRC)|WDTP(booke_wdt_period));
 
 	mtspr(SPRN_TCR, val);
 }
-- 
1.7.2.5

