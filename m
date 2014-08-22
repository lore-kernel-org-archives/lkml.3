Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaHVNvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:51:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33330 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbaHVNuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:50:18 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 6/7] ARM: OMAP4+: PM: use only valid low power state for suspend
Date: Fri, 22 Aug 2014 08:49:32 -0500
Message-ID: <1408715373-25791-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using power domain state as RET and logic state as OFF. This
state is OSWR. This may not always be supported on ALL power domains. In
fact, on certain power domains, this might result in a hang on certain
platforms. Instead, depend on powerdomain data to provide accurate
information about the supported powerdomain states and use the
appropriate function to query and use it as part of suspend path.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/pm44xx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index b377b03..0bfce38 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -121,8 +121,10 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *unused)
 		return -ENOMEM;
 
 	pwrst->pwrdm = pwrdm;
-	pwrst->next_state = PWRDM_POWER_RET;
-	pwrst->next_logic_state = PWRDM_POWER_OFF;
+	pwrst->next_state = pwrdm_get_valid_lp_state(pwrdm, false,
+						     PWRDM_POWER_RET);
+	pwrst->next_logic_state = pwrdm_get_valid_lp_state(pwrdm, true,
+							   PWRDM_POWER_OFF);
 
 	list_add(&pwrst->node, &pwrst_list);
 
-- 
1.7.9.5

