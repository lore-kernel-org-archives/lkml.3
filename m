Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaBLQBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:01:50 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52469 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaBLQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:00:21 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/13] pinctrl: mvebu: armada-370: provide generic mpp callbacks
Date: Wed, 12 Feb 2014 16:59:31 +0100
Message-Id: <1392220776-30851-9-git-send-email-sebastian.hesselbarth@gmail.com>
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
 drivers/pinctrl/mvebu/pinctrl-armada-370.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index ae1f760cbdd2..bcde42ce598f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -23,6 +23,30 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
+static int armada_370_mpp_ctrl_get(unsigned pid, unsigned long *config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int armada_370_mpp_ctrl_set(unsigned pid, unsigned long config)
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
 static struct mvebu_mpp_mode mv88f6710_mpp_modes[] = {
 	MPP_MODE(0,
 	   MPP_FUNCTION(0x0, "gpio", NULL),
-- 
1.8.5.3

