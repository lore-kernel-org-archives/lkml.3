Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3HUGYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:24:54 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:8158
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab3HUGYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:24:53 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/3 v3] blackfin: pinctrl-adi2: Enable PINCTRL framework for BF54x and BF60x.
Date: Wed, 21 Aug 2013 14:30:07 +0800
Message-ID: <1377066607-19061-3-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

- Remove unused macro MAX_RESOURCES
- Override blackfin legacy peripheral pinmux request and free APIs by
devm_pinctrl_get_select_default() to init the peripheral portmux setting.

v2-chagnes:
- Move pinctrl soc data out of blackfin arch folder.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 arch/blackfin/Kconfig                           |  4 ++++
 arch/blackfin/include/asm/portmux.h             | 19 +++++++++++++++++--
 arch/blackfin/mach-bf548/include/mach/portmux.h |  2 --
 arch/blackfin/mach-bf609/include/mach/portmux.h |  2 --
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9eff25b..ed7157f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -324,6 +324,10 @@ config GPIO_ADI
 	def_bool y
 	depends on (BF51x || BF52x || BF53x || BF538 || BF539 || BF561)
 
+config PINCTRL
+	def_bool y
+	depends on BF54x || BF60x
+
 config MEM_MT48LC64M4A2FB_7E
 	bool
 	depends on (BFIN533_STAMP)
diff --git a/arch/blackfin/include/asm/portmux.h b/arch/blackfin/include/asm/portmux.h
index 9b1e2c3..7aa2043 100644
--- a/arch/blackfin/include/asm/portmux.h
+++ b/arch/blackfin/include/asm/portmux.h
@@ -17,14 +17,29 @@
 #define P_MAYSHARE	0x2000
 #define P_DONTCARE	0x1000
 
-
+#ifdef CONFIG_PINCTRL
+#include <asm/irq_handler.h>
+
+#define gpio_pint_regs bfin_pint_regs
+#define adi_internal_set_wake bfin_internal_set_wake
+
+#define peripheral_request(per, label) 0
+#define peripheral_free(per)
+#define peripheral_request_list(per, label) \
+	(pdev ? (IS_ERR(devm_pinctrl_get_select_default(&pdev->dev)) \
+	? -EINVAL : 0) : 0)
+#define peripheral_free_list(per)
+#else
 int peripheral_request(unsigned short per, const char *label);
 void peripheral_free(unsigned short per);
 int peripheral_request_list(const unsigned short per[], const char *label);
 void peripheral_free_list(const unsigned short per[]);
+#endif
 
-#include <asm/gpio.h>
+#include <linux/err.h>
+#include <linux/pinctrl/pinctrl.h>
 #include <mach/portmux.h>
+#include <linux/gpio.h>
 
 #ifndef P_SPORT2_TFS
 #define P_SPORT2_TFS P_UNDEF
diff --git a/arch/blackfin/mach-bf548/include/mach/portmux.h b/arch/blackfin/mach-bf548/include/mach/portmux.h
index e222462..d9f8632 100644
--- a/arch/blackfin/mach-bf548/include/mach/portmux.h
+++ b/arch/blackfin/mach-bf548/include/mach/portmux.h
@@ -7,8 +7,6 @@
 #ifndef _MACH_PORTMUX_H_
 #define _MACH_PORTMUX_H_
 
-#define MAX_RESOURCES	MAX_BLACKFIN_GPIOS
-
 #define P_SPORT2_TFS	(P_DEFINED | P_IDENT(GPIO_PA0) | P_FUNCT(0))
 #define P_SPORT2_DTSEC	(P_DEFINED | P_IDENT(GPIO_PA1) | P_FUNCT(0))
 #define P_SPORT2_DTPRI	(P_DEFINED | P_IDENT(GPIO_PA2) | P_FUNCT(0))
diff --git a/arch/blackfin/mach-bf609/include/mach/portmux.h b/arch/blackfin/mach-bf609/include/mach/portmux.h
index 2e1a51c..fe34191 100644
--- a/arch/blackfin/mach-bf609/include/mach/portmux.h
+++ b/arch/blackfin/mach-bf609/include/mach/portmux.h
@@ -7,8 +7,6 @@
 #ifndef _MACH_PORTMUX_H_
 #define _MACH_PORTMUX_H_
 
-#define MAX_RESOURCES	MAX_BLACKFIN_GPIOS
-
 /* EMAC RMII Port Mux */
 #define P_MII0_MDC	(P_DEFINED | P_IDENT(GPIO_PC6) | P_FUNCT(0))
 #define P_MII0_MDIO	(P_DEFINED | P_IDENT(GPIO_PC7) | P_FUNCT(0))
-- 
1.8.2.3


