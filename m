Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaCaVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:50:12 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19436 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbaCaVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:50:08 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/4] pinctrl: msm: Make number of functions variable
Date: Mon, 31 Mar 2014 14:49:55 -0700
Message-ID: <1396302597-31801-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various pins may have different number of functions defined, so make this
number definable per pin instead of just increasing it to the largest one for
all of the platforms.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-msm.c     | 4 ++--
 drivers/pinctrl/pinctrl-msm.h     | 3 ++-
 drivers/pinctrl/pinctrl-msm8x74.c | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 706809e..7d67d34 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -145,12 +145,12 @@ static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
 	if (WARN_ON(g->mux_bit < 0))
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(g->funcs); i++) {
+	for (i = 0; i < g->nfuncs; i++) {
 		if (g->funcs[i] == function)
 			break;
 	}
 
-	if (WARN_ON(i == ARRAY_SIZE(g->funcs)))
+	if (WARN_ON(i == g->nfuncs))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
diff --git a/drivers/pinctrl/pinctrl-msm.h b/drivers/pinctrl/pinctrl-msm.h
index 6e26f1b..7b2a227 100644
--- a/drivers/pinctrl/pinctrl-msm.h
+++ b/drivers/pinctrl/pinctrl-msm.h
@@ -65,7 +65,8 @@ struct msm_pingroup {
 	const unsigned *pins;
 	unsigned npins;
 
-	unsigned funcs[8];
+	unsigned *funcs;
+	unsigned nfuncs;
 
 	s16 ctl_reg;
 	s16 io_reg;
diff --git a/drivers/pinctrl/pinctrl-msm8x74.c b/drivers/pinctrl/pinctrl-msm8x74.c
index dde5529..57766d5 100644
--- a/drivers/pinctrl/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/pinctrl-msm8x74.c
@@ -341,7 +341,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
 		.name = "gpio" #id,			\
 		.pins = gpio##id##_pins,		\
 		.npins = ARRAY_SIZE(gpio##id##_pins),	\
-		.funcs = {				\
+		.funcs = (int[]){			\
 			MSM_MUX_NA, /* gpio mode */	\
 			MSM_MUX_##f1,			\
 			MSM_MUX_##f2,			\
@@ -351,6 +351,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
 			MSM_MUX_##f6,			\
 			MSM_MUX_##f7			\
 		},					\
+		.nfuncs = 8,				\
 		.ctl_reg = 0x1000 + 0x10 * id,		\
 		.io_reg = 0x1004 + 0x10 * id,		\
 		.intr_cfg_reg = 0x1008 + 0x10 * id,	\
-- 
1.8.2.2

