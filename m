Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaLJPvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:51:54 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60985 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbaLJPtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:08 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ba-54886b722820
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 07/15] clk: add DT parsing function
Date: Wed, 10 Dec 2014 16:48:25 +0100
Message-id: <1418226513-14105-8-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7pF2R0hBisuKlrcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlfDjTzV5wmqPixuyLLA2Mn9m6GDk4JARMJD7Mtepi5AQyxSQu3FsPFObi
	EBJYyiix+Pc1Zginj0ni/eRWRpAqNgFNib+bb7KB2CICOhLXe7rBipgFNrBLrJu+DywhLGAo
	8eLWYhaQDSwCqhJfLiiChHkFnCW2XpvFCrFNTuLksclgNqeAi8Tf53vB5gsB1SzZ9p51AiPv
	AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghkfFlB+PiY1aHGAU4GJV4eM0VW0OEWBPL
	iitzDzFKcDArifAuTO4IEeJNSaysSi3Kjy8qzUktPsTIxMEp1cBYvZOxb9LnvNntX1i9ft+Q
	1ToYWhLVz6a+LOzwHRbpyNTHB/mzVvqwn2o40PFL3W1fVmNk6OGWxFy1W/r8v3j3tUmceeJl
	eVwg8wlD69LLbM94vLqytOaJNihe2tKnKXt5/Y5pNz43psho1Jgp/Tw4s9DC7RxTWYFX7BmJ
	kpyv9rvDpASLtZVYijMSDbWYi4oTAfUIKadqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds function for parsing Device Tree to get
clock specifier. The function could be ultimately used
by clock core.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/clk/clkdev.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index da4bda8..bd22750 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -120,6 +120,29 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 	return clk;
 }
 EXPORT_SYMBOL(of_clk_get_by_name);
+
+static int of_get_clock_spec(struct device *dev, const char *name,
+		struct of_phandle_args *spec)
+{
+	struct device_node *np = dev->of_node;
+
+	while (np) {
+		int idx = 0;
+
+		if (name)
+			idx = of_property_match_string(np, "clock-names", name);
+
+		if (!of_parse_phandle_with_args(np, "clocks", "#clock-cells",
+						idx, spec))
+			return 0;
+
+		np = np->parent;
+		if (np && !of_get_property(np, "clock-ranges", NULL))
+			break;
+	}
+
+	return -ENOENT;
+}
 #endif
 
 /*
-- 
1.9.1

