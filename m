Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3I0NZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:25:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33207 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3I0NZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:25:20 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] regulator: ti-abb: Fix bias voltage glitch in transition to bypass mode with ldo voltage override
Date: Fri, 27 Sep 2013 08:25:14 -0500
Message-ID: <1380288314-24064-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380288314-24064-1-git-send-email-nm@ti.com>
References: <1380288314-24064-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As documented in Application Note SWPA117 v2.1(NDA), LDO override has a
requirement that when switching from Bias active + override active
mode(FBB/RBB) to Bypass(nominal) mode, LDO reset must be performed
*after* LDO transitions to Bypass(nominal) mode.

The same rule in reverse applies when switching from a ABB bypass mode
to ABB enabled - LDO override *must* be performed prior to transition to
required ABB mode, if we do not do that, the same glitch takes place.

Currently while transitioning to ABB bypass, we reset the LDO overide
prior to the transition which causes a few milliseconds where ABB LDO
voltage could go all the way to 800mV(based on SoC process node),
during this period, the delta voltage between VDD rail and VBB rail
could cause the system to improperly function.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/ti-abb-regulator.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 1e02805..b951a84 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -279,8 +279,12 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 	ti_abb_rmw(regs->opp_sel_mask, info->opp_sel, regs->control_reg,
 		   abb->base);
 
-	/* program LDO VBB vset override if needed */
-	if (abb->ldo_base)
+	/*
+	 * program LDO VBB vset override if needed for !bypass mode
+	 * XXX: Do not switch sequence - for !bypass, LDO override reset *must*
+	 * be performed *before* switch to bias mode else VBB glitches.
+	 */
+	if (abb->ldo_base && info->opp_sel != TI_ABB_NOMINAL_OPP)
 		ti_abb_program_ldovbb(dev, abb, info);
 
 	/* Initiate ABB ldo change */
@@ -295,6 +299,14 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 	if (ret)
 		goto out;
 
+	/*
+	 * Reset LDO VBB vset override bypass mode
+	 * XXX: Do not switch sequence - for bypass, LDO override reset *must*
+	 * be performed *after* switch to bypass else VBB glitches.
+	 */
+	if (abb->ldo_base && info->opp_sel == TI_ABB_NOMINAL_OPP)
+		ti_abb_program_ldovbb(dev, abb, info);
+
 out:
 	return ret;
 }
-- 
1.7.9.5

