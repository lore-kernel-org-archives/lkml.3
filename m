Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaANLKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:10:16 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:34506 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbaANLKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:10:12 -0500
From: <srinivas.kandagatla@st.com>
To: <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1] media: st-rc: Add reset support
Date: Tue, 14 Jan 2014 11:04:21 +0000
Message-ID: <1389697461-21001-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Some of the SOCs hold the IRB IP in softreset state by default.
For this IP to work driver needs to bring it out of softreset.
This patch adds support to reset the IP via reset framework.

Without this patch the driver can not work with SoCs which holds the IP
in softreset.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/rc/st_rc.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 65120c2..8f0cddb 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <media/rc-core.h>
 #include <linux/pinctrl/consumer.h>
 
@@ -28,6 +29,7 @@ struct st_rc_device {
 	int				sample_mult;
 	int				sample_div;
 	bool				rxuhfmode;
+	struct	reset_control		*rstc;
 };
 
 /* Registers */
@@ -161,6 +163,10 @@ static void st_rc_hardware_init(struct st_rc_device *dev)
 	unsigned int rx_max_symbol_per = MAX_SYMB_TIME;
 	unsigned int rx_sampling_freq_div;
 
+	/* Enable the IP */
+	if (dev->rstc)
+		reset_control_deassert(dev->rstc);
+
 	clk_prepare_enable(dev->sys_clock);
 	baseclock = clk_get_rate(dev->sys_clock);
 
@@ -271,6 +277,11 @@ static int st_rc_probe(struct platform_device *pdev)
 	else
 		rc_dev->rx_base = rc_dev->base;
 
+
+	rc_dev->rstc = reset_control_get(dev, NULL);
+	if (IS_ERR(rc_dev->rstc))
+		rc_dev->rstc = NULL;
+
 	rc_dev->dev = dev;
 	platform_set_drvdata(pdev, rc_dev);
 	st_rc_hardware_init(rc_dev);
@@ -338,6 +349,8 @@ static int st_rc_suspend(struct device *dev)
 		writel(0x00, rc_dev->rx_base + IRB_RX_EN);
 		writel(0x00, rc_dev->rx_base + IRB_RX_INT_EN);
 		clk_disable_unprepare(rc_dev->sys_clock);
+		if (rc_dev->rstc)
+			reset_control_assert(rc_dev->rstc);
 	}
 
 	return 0;
-- 
1.7.6.5

