Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3GEQWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab3GEQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 1/8] clocksource: armada-xp: always register local_timer_ops
Date: Fri,  5 Jul 2013 18:23:30 +0200
Message-Id: <1373041417-217728-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Q+ArEakeHuTM6h1Fttj+KEdulViTpKC9Er1+3LHPx8n
 jACDgzsLSvnaKQA9KxbsmpaWaWFAxUxWTzL3TzfMtAVaB1pZDM
 t5nN5/mtUl28qsr7Sr8oFbk4AWPc66awFnusVbXWcLZwNWmdPs
 MCO5e48cSys2Z7GA0AFW9I/btugm2MhptjSARYnNmENjV2nbPP
 8Dx7Z8e7el0t/h0ugFRZK7i8SFzfCUFwDm2Rl/EfEVHW2Qd2pw
 jBm3N13L0e0znj0e6XZILAZ/xVCG5P4sWG+EHNDBatacDm3f8s
 h/s4SoN8RvXOWswUdJUuVtk5taM0ihqwvcuuQtnMGV6RpfCpOi
 nCM8WbnvprTXt8Eavfgjllti//YQc6+/2assoxoRN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to local_timer_register is hidden behind an #ifdef, which
turns the armada_370_xp_local_timer_ops into a potentially unused
variable, causing this warning:

time-armada-370-xp.c:208:31: warning: 'armada_370_xp_local_timer_ops' defined but not used [-Wunused-variable]
 static struct local_timer_ops armada_370_xp_local_timer_ops __cpuinitdata = {
                               ^

Since local_timer_register() itself doesn't do anything, just removing
the #ifdef makes the code look nicer and gets rid of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/clocksource/time-armada-370-xp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 47a6730..4cd8520 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -294,8 +294,6 @@ void __init armada_370_xp_timer_init(void)
 				percpu_armada_370_xp_evt);
 	if (!res) {
 		enable_percpu_irq(armada_370_xp_clkevt.irq, 0);
-#ifdef CONFIG_LOCAL_TIMERS
 		local_timer_register(&armada_370_xp_local_timer_ops);
-#endif
 	}
 }
-- 
1.8.3.1

