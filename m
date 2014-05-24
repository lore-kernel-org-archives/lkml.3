Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaEXHgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:36:16 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:58892 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbaEXHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:36:15 -0400
Message-ID: <1400916970.31526.78.camel@x220>
Subject: [PATCH] pcmcia: m8xx: remove checks for four macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 09:36:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2014 07:36:13.0995 (UTC) FILETIME=[D73127B0:01CF7722]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver contains checks for four Kconfig macros. But the related
Kconfig symbols have never been part of the tree. Remove these checks
and the code they hide.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

This has been an issue ever since this driver was added in v2.6.15. Note
that there is no header named "*/cpld.h", so setting PRxK can't possibly
work.

 drivers/pcmcia/m8xx_pcmcia.c | 75 --------------------------------------------
 1 file changed, 75 deletions(-)

diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 182034d2ef58..53b71fe50767 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -78,24 +78,14 @@ MODULE_LICENSE("Dual MPL/GPL");
 
 /* The FADS series are a mess */
 #ifdef CONFIG_FADS
-#if defined(CONFIG_MPC860T) || defined(CONFIG_MPC860) || defined(CONFIG_MPC821)
-#define CONFIG_PCMCIA_SLOT_A
-#else
 #define CONFIG_PCMCIA_SLOT_B
 #endif
-#endif
 
 #if defined(CONFIG_MPC885ADS)
 #define CONFIG_PCMCIA_SLOT_A
 #define PCMCIA_GLITCHY_CD
 #endif
 
-/* Cyclades ACS uses both slots */
-#ifdef CONFIG_PRxK
-#define CONFIG_PCMCIA_SLOT_A
-#define CONFIG_PCMCIA_SLOT_B
-#endif
-
 #endif				/* !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B) */
 
 #if defined(CONFIG_PCMCIA_SLOT_A) && defined(CONFIG_PCMCIA_SLOT_B)
@@ -340,71 +330,6 @@ static inline int voltage_set(int slot, int vcc, int vpp)
 
 #endif
 
-#if defined(CONFIG_PRxK)
-#include <asm/cpld.h>
-extern volatile fpga_pc_regs *fpga_pc;
-
-#define PCMCIA_BOARD_MSG "MPC855T"
-
-static int voltage_set(int slot, int vcc, int vpp)
-{
-	u8 reg = 0;
-	u8 regread;
-	cpld_regs *ccpld = get_cpld();
-
-	switch (vcc) {
-	case 0:
-		break;
-	case 33:
-		reg |= PCMCIA_VCC_33;
-		break;
-	case 50:
-		reg |= PCMCIA_VCC_50;
-		break;
-	default:
-		return 1;
-	}
-
-	switch (vpp) {
-	case 0:
-		break;
-	case 33:
-	case 50:
-		if (vcc == vpp)
-			reg |= PCMCIA_VPP_VCC;
-		else
-			return 1;
-		break;
-	case 120:
-		if ((vcc == 33) || (vcc == 50))
-			reg |= PCMCIA_VPP_12;
-		else
-			return 1;
-	default:
-		return 1;
-	}
-
-	reg = reg >> (slot << 2);
-	regread = in_8(&ccpld->fpga_pc_ctl);
-	if (reg !=
-	    (regread & ((PCMCIA_VCC_MASK | PCMCIA_VPP_MASK) >> (slot << 2)))) {
-		/* enable new powersettings */
-		regread =
-		    regread & ~((PCMCIA_VCC_MASK | PCMCIA_VPP_MASK) >>
-				(slot << 2));
-		out_8(&ccpld->fpga_pc_ctl, reg | regread);
-		msleep(100);
-	}
-
-	return 0;
-}
-
-#define socket_get(_slot_) PCMCIA_SOCKET_KEY_LV
-#define hardware_enable(_slot_)	/* No hardware to enable */
-#define hardware_disable(_slot_)	/* No hardware to disable */
-
-#endif				/* CONFIG_PRxK */
-
 static u32 pending_events[PCMCIA_SOCKETS_NO];
 static DEFINE_SPINLOCK(pending_event_lock);
 
-- 
1.9.0

