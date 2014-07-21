Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaGUIg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:36:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8760 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaGUIgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:36:38 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-b7-53ccd112c276
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] ARM: EXYNOS: Enable cpuidle in WFI on all SoCs
Date: Mon, 21 Jul 2014 10:36:10 +0200
Message-id: <1405931771-24100-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405931771-24100-1-git-send-email-k.kozlowski@samsung.com>
References: <1405931771-24100-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xy7pCF88EG6w9ZW2xccZ6Vot5n2Ut
	Xr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZ3L7Ma7H2yF12izOnL7FaXLl0
	is1i/YzXLBbtf/eyOfB7tDT3sHncubaHzWPzknqPLVfbWTz6tqxi9Pi8SS6ALYrLJiU1J7Ms
	tUjfLoEr4+v2k0wFT7kqPp/qYWxgfMbRxcjJISFgInFz0ypmCFtM4sK99WxdjFwcQgJLGSX2
	bHzOCuH0MUns23iCCaSKTcBYYvPyJWBVIgJNzBKvlp9mA0kwCzxnlHj6PRzEFhZwlug8d5wF
	xGYRUJU4tf4IO4jNK+AusfDLKVaIdXISJ49NBrM5BTwkLp//DGYLAdWs+L+LZQIj7wJGhlWM
	oqmlyQXFSem5RnrFibnFpXnpesn5uZsYIaH6dQfj0mNWhxgFOBiVeHg5XpwKFmJNLCuuzD3E
	KMHBrCTCeyLjTLAQb0piZVVqUX58UWlOavEhRiYOTqkGRiEzk8zYo7tUNizZezGtakYef0SR
	UMr0EzsqDsav3HTswY6cv71HjOv+OX3NfLrM9/ExucMJmQw9PMY5zdoT/sZ1cz5S/jrnAPsG
	xsDJYUn/HTz8f5/VcHi//7lks5DG+fnt9x+u2b97hvK6Repb188V5HnMe/4HX+pSzp9HxDqX
	l068d/iS7B0lluKMREMt5qLiRACkpGSSMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpuidle device for each SoC but set AFTR enter function only on
supported ones (for now these are only Exynos4210 and Exynos5250). For
other chipsets use only WFI.

This actually does not give any special energy-saving benefits but
allows to track the idle time of each core.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/exynos.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 2a43a1734eca..4109d592f6fc 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -171,14 +171,20 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 
 static struct platform_device exynos_cpuidle = {
 	.name              = "exynos_cpuidle",
-	.dev.platform_data = exynos_enter_aftr,
+	/*
+	 * Currently AFTR is not implemented for each SoC.
+	 * Set this to exynos_enter_aftr() only for supported SoCs.
+	 */
+	.dev.platform_data = NULL,
 	.id                = -1,
 };
 
 void __init exynos_cpuidle_init(void)
 {
 	if (soc_is_exynos4210() || soc_is_exynos5250())
-		platform_device_register(&exynos_cpuidle);
+		exynos_cpuidle.dev.platform_data = exynos_enter_aftr;
+
+	platform_device_register(&exynos_cpuidle);
 }
 
 void __init exynos_cpufreq_init(void)
-- 
1.9.1

