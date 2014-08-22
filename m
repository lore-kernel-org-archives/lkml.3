Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaHVNuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:50:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60928 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbaHVNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:50:17 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5/7] ARM: OMAP4+: PM: Make logic state programmable
Date: Fri, 22 Aug 2014 08:49:31 -0500
Message-ID: <1408715373-25791-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the logic state as different for each power domain. This allows us
to customize the deepest power state we should target over all for each
powerdomain in the follow on patches.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/pm44xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index 0dda6cf..b377b03 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -29,6 +29,7 @@ u16 pm44xx_errata;
 struct power_state {
 	struct powerdomain *pwrdm;
 	u32 next_state;
+	u32 next_logic_state;
 #ifdef CONFIG_SUSPEND
 	u32 saved_state;
 	u32 saved_logic_state;
@@ -54,7 +55,7 @@ static int omap4_pm_suspend(void)
 	/* Set targeted power domain states by suspend */
 	list_for_each_entry(pwrst, &pwrst_list, node) {
 		omap_set_pwrdm_state(pwrst->pwrdm, pwrst->next_state);
-		pwrdm_set_logic_retst(pwrst->pwrdm, PWRDM_POWER_OFF);
+		pwrdm_set_logic_retst(pwrst->pwrdm, pwrst->next_logic_state);
 	}
 
 	/*
@@ -121,6 +122,8 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *unused)
 
 	pwrst->pwrdm = pwrdm;
 	pwrst->next_state = PWRDM_POWER_RET;
+	pwrst->next_logic_state = PWRDM_POWER_OFF;
+
 	list_add(&pwrst->node, &pwrst_list);
 
 	return omap_set_pwrdm_state(pwrst->pwrdm, pwrst->next_state);
-- 
1.7.9.5

