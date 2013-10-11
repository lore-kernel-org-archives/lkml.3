Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3JKTle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3JKTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Mark Brown <broonie@linaro.org>
Subject: [ 051/135] regulator: ti-abb: Fix bias voltage glitch in transition to bypass mode
Date: Fri, 11 Oct 2013 12:38:52 -0700
Message-Id: <20131011193950.837894789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit bf00ca35cec8f0894dcfd90f88b03af1d5c7b86f upstream.

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
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/ti-abb-regulator.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -279,8 +279,12 @@ static int ti_abb_set_opp(struct regulat
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
@@ -295,6 +299,14 @@ static int ti_abb_set_opp(struct regulat
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


