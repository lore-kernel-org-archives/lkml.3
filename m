Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBWO0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:26:33 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:36609 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaBWOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:25 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/16] pinctrl: mvebu: remove passing mvebu_mpp_ctrl to callbacks
Date: Sun, 23 Feb 2014 15:21:02 +0100
Message-Id: <1393165274-32492-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only valuable information a special callback can derive from
mvebu_mpp_ctrl passed to it, is the pin id. Instead of passing
the struct, pass the pid directly.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c  | 61 ++++++++++++++---------------------
 drivers/pinctrl/mvebu/pinctrl-mvebu.c |  8 ++---
 drivers/pinctrl/mvebu/pinctrl-mvebu.h |  8 ++---
 3 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 47268393af34..c7d365f9009c 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -55,15 +55,14 @@
 
 #define CONFIG_PMU	BIT(4)
 
-static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-				 unsigned long *config)
+static int dove_pmu_mpp_ctrl_get(unsigned pid, unsigned long *config)
 {
-	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned off = (pid / MPPS_PER_REG) * MPP_BITS;
+	unsigned shift = (pid % MPPS_PER_REG) * MPP_BITS;
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
-	if (pmu & (1 << ctrl->pid)) {
+	if (pmu & (1 << pid)) {
 		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
 		*config = (func >> shift) & MPP_MASK;
 		*config |= CONFIG_PMU;
@@ -74,22 +73,21 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
-				 unsigned long config)
+static int dove_pmu_mpp_ctrl_set(unsigned pid, unsigned long config)
 {
-	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned off = (pid / MPPS_PER_REG) * MPP_BITS;
+	unsigned shift = (pid % MPPS_PER_REG) * MPP_BITS;
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if (config & CONFIG_PMU) {
-		writel(pmu | (1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
+		writel(pmu | (1 << pid), DOVE_PMU_MPP_GENERAL_CTRL);
 		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
 		func &= ~(MPP_MASK << shift);
 		func |= (config & MPP_MASK) << shift;
 		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
 	} else {
-		writel(pmu & ~(1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
+		writel(pmu & ~(1 << pid), DOVE_PMU_MPP_GENERAL_CTRL);
 		func = readl(DOVE_MPP_VIRT_BASE + off);
 		func &= ~(MPP_MASK << shift);
 		func |= (config & MPP_MASK) << shift;
@@ -98,13 +96,12 @@ static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-			      unsigned long *config)
+static int dove_mpp4_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
 	unsigned long mask;
 
-	switch (ctrl->pid) {
+	switch (pid) {
 	case 24: /* mpp_camera */
 		mask = DOVE_CAM_GPIO_SEL;
 		break;
@@ -129,13 +126,12 @@ static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_mpp4_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
-			      unsigned long config)
+static int dove_mpp4_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
 	unsigned long mask;
 
-	switch (ctrl->pid) {
+	switch (pid) {
 	case 24: /* mpp_camera */
 		mask = DOVE_CAM_GPIO_SEL;
 		break;
@@ -164,8 +160,7 @@ static int dove_mpp4_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_nand_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-			      unsigned long *config)
+static int dove_nand_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 
@@ -174,8 +169,7 @@ static int dove_nand_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_nand_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
-			      unsigned long config)
+static int dove_nand_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 
@@ -188,8 +182,7 @@ static int dove_nand_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-				unsigned long *config)
+static int dove_audio0_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 
@@ -198,8 +191,7 @@ static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_audio0_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
-				unsigned long config)
+static int dove_audio0_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 
@@ -211,8 +203,7 @@ static int dove_audio0_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-				unsigned long *config)
+static int dove_audio1_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
 	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
@@ -238,8 +229,7 @@ static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
-				unsigned long config)
+static int dove_audio1_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
 	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
@@ -276,11 +266,11 @@ static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
  * break other functions. If you require all mpps as gpio
  * enforce gpio setting by pinctrl mapping.
  */
-static int dove_audio1_ctrl_gpio_req(struct mvebu_mpp_ctrl *ctrl, u8 pid)
+static int dove_audio1_ctrl_gpio_req(unsigned pid)
 {
 	unsigned long config;
 
-	dove_audio1_ctrl_get(ctrl, &config);
+	dove_audio1_ctrl_get(pid, &config);
 
 	switch (config) {
 	case 0x02: /* i2s1 : gpio[56:57] */
@@ -303,16 +293,14 @@ static int dove_audio1_ctrl_gpio_req(struct mvebu_mpp_ctrl *ctrl, u8 pid)
 }
 
 /* mpp[52:57] has gpio pins capable of in and out */
-static int dove_audio1_ctrl_gpio_dir(struct mvebu_mpp_ctrl *ctrl, u8 pid,
-				bool input)
+static int dove_audio1_ctrl_gpio_dir(unsigned pid, bool input)
 {
 	if (pid < 52 || pid > 57)
 		return -ENOTSUPP;
 	return 0;
 }
 
-static int dove_twsi_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-			      unsigned long *config)
+static int dove_twsi_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
@@ -328,8 +316,7 @@ static int dove_twsi_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	return 0;
 }
 
-static int dove_twsi_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
-				unsigned long config)
+static int dove_twsi_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 2be432444124..873aef5bdd9c 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -185,7 +185,7 @@ static int mvebu_pinconf_group_get(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	if (grp->ctrl->mpp_get)
-		return grp->ctrl->mpp_get(grp->ctrl, config);
+		return grp->ctrl->mpp_get(grp->pins[0], config);
 
 	return mvebu_common_mpp_get(pctl, grp, config);
 }
@@ -203,7 +203,7 @@ static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
 
 	for (i = 0; i < num_configs; i++) {
 		if (grp->ctrl->mpp_set)
-			ret = grp->ctrl->mpp_set(grp->ctrl, configs[i]);
+			ret = grp->ctrl->mpp_set(grp->pins[0], configs[i]);
 		else
 			ret = mvebu_common_mpp_set(pctl, grp, configs[i]);
 
@@ -347,7 +347,7 @@ static int mvebu_pinmux_gpio_request_enable(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	if (grp->ctrl->mpp_gpio_req)
-		return grp->ctrl->mpp_gpio_req(grp->ctrl, offset);
+		return grp->ctrl->mpp_gpio_req(offset);
 
 	setting = mvebu_pinctrl_find_gpio_setting(pctl, grp);
 	if (!setting)
@@ -370,7 +370,7 @@ static int mvebu_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	if (grp->ctrl->mpp_gpio_dir)
-		return grp->ctrl->mpp_gpio_dir(grp->ctrl, offset, input);
+		return grp->ctrl->mpp_gpio_dir(offset, input);
 
 	setting = mvebu_pinctrl_find_gpio_setting(pctl, grp);
 	if (!setting)
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index 90bd3beee860..b20d1d778c75 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -38,10 +38,10 @@ struct mvebu_mpp_ctrl {
 	u8 pid;
 	u8 npins;
 	unsigned *pins;
-	int (*mpp_get)(struct mvebu_mpp_ctrl *ctrl, unsigned long *config);
-	int (*mpp_set)(struct mvebu_mpp_ctrl *ctrl, unsigned long config);
-	int (*mpp_gpio_req)(struct mvebu_mpp_ctrl *ctrl, u8 pid);
-	int (*mpp_gpio_dir)(struct mvebu_mpp_ctrl *ctrl, u8 pid, bool input);
+	int (*mpp_get)(unsigned pid, unsigned long *config);
+	int (*mpp_set)(unsigned pid, unsigned long config);
+	int (*mpp_gpio_req)(unsigned pid);
+	int (*mpp_gpio_dir)(unsigned pid, bool input);
 };
 
 /**
-- 
1.8.5.3

