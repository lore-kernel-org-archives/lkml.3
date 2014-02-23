Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBWOZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:25:16 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:50251 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBWOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:27 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/16] pinctrl: mvebu: add common mpp reg helper to mvebu pinctrl include
Date: Sun, 23 Feb 2014 15:21:03 +0100
Message-Id: <1393165274-32492-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some defines and helper functions for the common mpp reg
layout to mvebu pinctrl include.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
---
Changelog:
v3->v4:
- add helper functions provided by Thomas Petazzoni

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index b20d1d778c75..c73f4eea62ac 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -186,6 +186,34 @@ struct mvebu_pinctrl_soc_info {
 		.npins = _npins,				\
 	}
 
+#define MVEBU_MPPS_PER_REG	8
+#define MVEBU_MPP_BITS		4
+#define MVEBU_MPP_MASK		0xf
+
+static inline int default_mpp_ctrl_get(void __iomem *base, unsigned int pid,
+				       unsigned long *config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static inline int default_mpp_ctrl_set(void __iomem *base, unsigned int pid,
+				       unsigned long config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(base + off) & ~(MVEBU_MPP_MASK << shift);
+	writel(reg | (config << shift), base + off);
+
+	return 0;
+}
+
 int mvebu_pinctrl_probe(struct platform_device *pdev);
 int mvebu_pinctrl_remove(struct platform_device *pdev);
 
-- 
1.8.5.3

