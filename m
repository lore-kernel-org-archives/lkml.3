Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaBWOV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:21:57 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55115 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaBWOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:33 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 16/16] pinctrl: mvebu: dove: reuse mpp_{set,get} in pmu callbacks
Date: Sun, 23 Feb 2014 15:21:14 +0100
Message-Id: <1393165274-32492-17-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dove has pins that can be switched between normal and pmu functions.
Rework pmu_mpp callbacks to reuse default mpp ctrl helpers.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- directly use generic mpp helpers instead of normal dove mpp functions

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 37 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 89fd3a5a1df1..da9ca26360fd 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -70,14 +70,13 @@ static int dove_pmu_mpp_ctrl_get(unsigned pid, unsigned long *config)
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
-	if (pmu & (1 << pid)) {
-		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
-		*config = (func >> shift) & MVEBU_MPP_MASK;
-		*config |= CONFIG_PMU;
-	} else {
-		func = readl(DOVE_MPP_VIRT_BASE + off);
-		*config = (func >> shift) & MVEBU_MPP_MASK;
-	}
+	if ((pmu & BIT(pid)) == 0)
+		return default_mpp_ctrl_get(mpp_base, pid, config);
+
+	func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+	*config = (func >> shift) & MVEBU_MPP_MASK;
+	*config |= CONFIG_PMU;
+
 	return 0;
 }
 
@@ -88,19 +87,17 @@ static int dove_pmu_mpp_ctrl_set(unsigned pid, unsigned long config)
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
-	if (config & CONFIG_PMU) {
-		writel(pmu | (1 << pid), DOVE_PMU_MPP_GENERAL_CTRL);
-		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
-		func &= ~(MVEBU_MPP_MASK << shift);
-		func |= (config & MVEBU_MPP_MASK) << shift;
-		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
-	} else {
-		writel(pmu & ~(1 << pid), DOVE_PMU_MPP_GENERAL_CTRL);
-		func = readl(DOVE_MPP_VIRT_BASE + off);
-		func &= ~(MVEBU_MPP_MASK << shift);
-		func |= (config & MVEBU_MPP_MASK) << shift;
-		writel(func, DOVE_MPP_VIRT_BASE + off);
+	if ((config & CONFIG_PMU) == 0) {
+		writel(pmu & ~BIT(pid), DOVE_PMU_MPP_GENERAL_CTRL);
+		return default_mpp_ctrl_set(mpp_base, pid, config);
 	}
+
+	writel(pmu | BIT(pid), DOVE_PMU_MPP_GENERAL_CTRL);
+	func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+	func &= ~(MVEBU_MPP_MASK << shift);
+	func |= (config & MVEBU_MPP_MASK) << shift;
+	writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
+
 	return 0;
 }
 
-- 
1.8.5.3

