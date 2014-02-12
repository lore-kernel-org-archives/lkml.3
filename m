Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBLQAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:00:16 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:32870 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaBLQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:00:13 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/13] pinctrl: mvebu: armada-xp: provide generic mpp callbacks
Date: Wed, 12 Feb 2014 16:59:32 +0100
Message-Id: <1392220776-30851-10-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to get rid of passing register addresses to common pinctrl
driver, so provide set/get callbacks for generic mpp pins that will
be used later.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
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
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index 843a51f9d129..b5381b421284 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -33,6 +33,30 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
+static int armada_xp_mpp_ctrl_get(unsigned pid, unsigned long *config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int armada_xp_mpp_ctrl_set(unsigned pid, unsigned long config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(mpp_base + off) & ~(MVEBU_MPP_MASK << shift);
+	writel(reg | (config << shift), mpp_base + off);
+
+	return 0;
+}
+
 enum armada_xp_variant {
 	V_MV78230	= BIT(0),
 	V_MV78260	= BIT(1),
-- 
1.8.5.3

