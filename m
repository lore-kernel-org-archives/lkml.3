Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3LOSbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 13:31:17 -0500
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:34450 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842Ab3LOSa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 13:30:58 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 1/2] pinctrl: at91: fix clk_unprepare and clk_disable order
Date: Sun, 15 Dec 2013 19:30:51 +0100
Message-Id: <1387132252-2584-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
References: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 17700272435941374125
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_unprepare shall be called before clk_disable.
Fix the issue by replacing the clk_unprepare and clk_disable calls by a
single clk_disable_unprepare call.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index a7549c4..82f6301 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1339,13 +1339,11 @@ void at91_pinctrl_gpio_suspend(void)
 		__raw_writel(backups[i], pio + PIO_IDR);
 		__raw_writel(wakeups[i], pio + PIO_IER);
 
-		if (!wakeups[i]) {
-			clk_unprepare(gpio_chips[i]->clock);
-			clk_disable(gpio_chips[i]->clock);
-		} else {
+		if (!wakeups[i])
+			clk_disable_unprepare(gpio_chips[i]->clock);
+		else
 			printk(KERN_DEBUG "GPIO-%c may wake for %08x\n",
 			       'A'+i, wakeups[i]);
-		}
 	}
 }
 
-- 
1.7.9.5

