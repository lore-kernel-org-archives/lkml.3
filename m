Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaLEOWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:22:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61596 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaLEOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:21:59 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a1-5481bf859482
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable
 failure due to domain being gated
Date: Fri, 05 Dec 2014 15:15:34 +0100
Message-id: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Nd3W/Y0hBteXCVpsnLGe1eLo7wKL
	1y8MLfofv2a2eLr5MZPF2aY37BabHl9jtbi8aw6bxYzz+5gs1h65y27xdMJFNovDb9pZLX6c
	6WaxWLXrD6MDn8flvl4mj7/Pr7N47Jx1l91j06pONo871/aweWxeUu/Rt2UVo8fnTXIBHFFc
	NimpOZllqUX6dglcGRuOdLAX3BWvOHB/IWsD4xzhLkYODgkBE4m3kwy7GDmBTDGJC/fWs3Ux
	cnEICSxllPi97C4ThNPHJPF70nZGkCo2AWOJzcuXsIHYIgITmCVuXncHKWIWOMooMb33LRNI
	QligSGLPhKVsIBtYBFQlZv/xBwnzCrhLdJ1/zA6xTU7i5LHJrBMYuRcwMqxiFE0tTS4oTkrP
	NdIrTswtLs1L10vOz93ECAnBrzsYlx6zOsQowMGoxMP7I64xRIg1say4MvcQowQHs5IIb/Js
	oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGB4eJVlp2RXVsjxUbVJIyn6h2+dys3zX3vNqpTa8a
	rVLcNPW+vaorVM1hPRPxK0ewfXLhruQWCYusS2ezX+QHHv9uuSnn2Jap7QpHKiMe6Rl5mm74
	u2aGkY+2xe3g+Ssm92Xwnd6bmvUyvyA712uVHOvlq/ulm3k+zy9VWf94jVn9+cvH30YpsRRn
	JBpqMRcVJwIAClSwAB8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audio subsystem clocks are located in separate block. On Exynos 5420 if
clock for this block (from main clock domain) 'mau_epll' is gated then
any read or write to audss registers will block.

This kind of boot hang was observed on Arndale Octa and Peach Pi/Pit
after introducing runtime PM to pl330 DMA driver. After that commit the
'mau_epll' was gated, because the "amba" clock was disabled and there
were no more users of mau_epll.

The system hang on one of steps:
1. Disabling unused clocks from audss block.
2. During audss GPIO setup (just before probing i2s0 because
   samsung_pinmux_setup() tried to access memory from audss block which was
   gated.

Add a workaround for this by enabling the 'mau_epll' clock in probe.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos-audss.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index acce708ace18..0916a81fa932 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -29,6 +29,13 @@ static DEFINE_SPINLOCK(lock);
 static struct clk **clk_table;
 static void __iomem *reg_base;
 static struct clk_onecell_data clk_data;
+/*
+ * On Exynos5420 this will be a clock which has to be enabled before any
+ * access to audss registers. Typically a child of EPLL.
+ *
+ * On other platforms this will be -ENODEV.
+ */
+static struct clk *epll;
 
 #define ASS_CLK_SRC 0x0
 #define ASS_CLK_DIV 0x4
@@ -98,6 +105,8 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to map audss registers\n");
 		return PTR_ERR(reg_base);
 	}
+	/* EPLL don't have to be enabled for boards other than Exynos5420 */
+	epll = ERR_PTR(-ENODEV);
 
 	clk_table = devm_kzalloc(&pdev->dev,
 				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
@@ -115,8 +124,20 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	pll_in = devm_clk_get(&pdev->dev, "pll_in");
 	if (!IS_ERR(pll_ref))
 		mout_audss_p[0] = __clk_get_name(pll_ref);
-	if (!IS_ERR(pll_in))
+	if (!IS_ERR(pll_in)) {
 		mout_audss_p[1] = __clk_get_name(pll_in);
+
+		if (variant == TYPE_EXYNOS5420) {
+			epll = pll_in;
+
+			ret = clk_prepare_enable(epll);
+			if (ret) {
+				dev_err(&pdev->dev,
+						"failed to prepare the epll clock\n");
+				return ret;
+			}
+		}
+	}
 	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
 				mout_audss_p, ARRAY_SIZE(mout_audss_p),
 				CLK_SET_RATE_NO_REPARENT,
@@ -203,6 +224,9 @@ unregister:
 			clk_unregister(clk_table[i]);
 	}
 
+	if (!IS_ERR(epll))
+		clk_disable_unprepare(epll);
+
 	return ret;
 }
 
@@ -217,6 +241,9 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
 			clk_unregister(clk_table[i]);
 	}
 
+	if (!IS_ERR(epll))
+		clk_disable_unprepare(epll);
+
 	return 0;
 }
 
-- 
1.9.1

