Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbATITi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:19:38 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:32589 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751927AbbATITh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:19:37 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 04/12] pm: at91: move the copying the sram function to the sram initializationi phase
Date: Tue, 20 Jan 2015 16:16:57 +0800
Message-ID: <1421741825-18226-5-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To decrease the suspend time, move the copying the sram function
to the sram initialization phase, instead of every time go to suspend.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 0990486..609a4f8 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -169,10 +169,6 @@ static int at91_pm_enter(suspend_state_t state)
 			 * turning off the main oscillator; reverse on wakeup.
 			 */
 			if (slow_clock) {
-#ifdef CONFIG_AT91_SLOW_CLOCK
-				/* copy slow_clock handler to SRAM, and call it */
-				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
-#endif
 				slow_clock(at91_pmc_base, at91_ramc_base[0],
 					   at91_ramc_base[1],
 					   at91_pm_data.memctrl);
@@ -280,6 +276,9 @@ static void __init at91_pm_sram_init(void)
 	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
 	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz, false);
 
+	/* Copy slow_clock handler to SRAM, and call it */
+	memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
+
 put_node:
 	of_node_put(node);
 }
-- 
1.7.9.5

