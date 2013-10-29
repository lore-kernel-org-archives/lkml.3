Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab3J2TwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:52:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21631 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3J2TwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:52:11 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-59-527011ea812b
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org
Cc: linux@arm.linux.org.uk, jiada_wang@mentor.com, kyungmin.park@samsung.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v7 1/5] omap3isp: Modify clocks registration to avoid circular
 references
Date: Tue, 29 Oct 2013 20:51:04 +0100
Message-id: <1383076268-8984-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd1XggVBBssPKVj0/Km0ONv0ht2i
	c+ISdotNj6+xWlzeNYfNYsLUSewWc/5MYba4fZnX4umEi2wWh9+0s1osbPjC7sDt0dLcw+ax
	crq3x+yOmawed67tYfM4unItk8fmJfUeu782MXr0bVnF6PF5k1wAZxSXTUpqTmZZapG+XQJX
	xrY7+1kKGiQqHs4KaGC8KNzFyMkhIWAi8eLNeiYIW0ziwr31bF2MXBxCAosYJR60/INyOpgk
	tn3fA1bFJmAo0Xu0jxHEFhGwl/gx4SULSBGzwDwmiTkfDrCBJIQFoiUO7NsFZrMIqEoce3Wd
	HcTmFXCV2PVzMlADB9A6BYk5k2xATE4BN4n9i0VBKoSAKk7dusw8gZF3ASPDKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzg0HwmtYNxZYPFIUYBDkYlHl6DB/lBQqyJZcWVuYcYJTiYlUR4
	px8HCvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamB0sHz1
	5uSKP1O9Uw1dWI595ZwuWtzakuKjKN3at9LJ8u3Kju1pX3d4ut3g/yj138eyMWRT6JZrtoLe
	PNySTC+5MuuXLvuuff1/+2qmk2bHP8/bdsnvcP7jgIIHNb6LO2Til93JtFxynt/VT2JG9iMD
	v6Z/K9lP1a3u/hwmInf5z/tFL7128XEpsRRnJBpqMRcVJwIAZpMGvkkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock core code is going to be modified so clk_get() takes
reference on the clock provider module. Until the potential circular
reference issue is properly addressed, we pass NULL as as the first
argument to clk_register(), in order to disallow sub-devices taking
a reference on the ISP module back trough clk_get(). This should
prevent locking the modules in memory.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch has been "compile tested" only.

---
 drivers/media/platform/omap3isp/isp.c |   22 ++++++++++++++++------
 drivers/media/platform/omap3isp/isp.h |    1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index df3a0ec..286027a 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -290,9 +290,11 @@ static int isp_xclk_init(struct isp_device *isp)
 	struct clk_init_data init;
 	unsigned int i;

+	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
+		isp->xclks[i].clk = ERR_PTR(-EINVAL);
+
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
 		struct isp_xclk *xclk = &isp->xclks[i];
-		struct clk *clk;

 		xclk->isp = isp;
 		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
@@ -305,10 +307,15 @@ static int isp_xclk_init(struct isp_device *isp)
 		init.num_parents = 1;

 		xclk->hw.init = &init;
-
-		clk = devm_clk_register(isp->dev, &xclk->hw);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
+		/*
+		 * The first argument is NULL in order to avoid circular
+		 * reference, as this driver takes reference on the
+		 * sensor subdevice modules and the sensors would take
+		 * reference on this module through clk_get().
+		 */
+		xclk->clk = clk_register(NULL, &xclk->hw);
+		if (IS_ERR(xclk->clk))
+			return PTR_ERR(xclk->clk);

 		if (pdata->xclks[i].con_id == NULL &&
 		    pdata->xclks[i].dev_id == NULL)
@@ -320,7 +327,7 @@ static int isp_xclk_init(struct isp_device *isp)

 		xclk->lookup->con_id = pdata->xclks[i].con_id;
 		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
-		xclk->lookup->clk = clk;
+		xclk->lookup->clk = xclk->clk;

 		clkdev_add(xclk->lookup);
 	}
@@ -335,6 +342,9 @@ static void isp_xclk_cleanup(struct isp_device *isp)
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
 		struct isp_xclk *xclk = &isp->xclks[i];

+		if (!IS_ERR(xclk->clk))
+			clk_unregister(xclk->clk);
+
 		if (xclk->lookup)
 			clkdev_drop(xclk->lookup);
 	}
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index cd3eff4..1498f2b 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -135,6 +135,7 @@ struct isp_xclk {
 	struct isp_device *isp;
 	struct clk_hw hw;
 	struct clk_lookup *lookup;
+	struct clk *clk;
 	enum isp_xclk_id id;

 	spinlock_t lock;	/* Protects enabled and divider */
--
1.7.9.5

