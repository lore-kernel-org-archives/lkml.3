Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaFBMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:38:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21068 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaFBMiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:38:01 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-10-538c7026d96d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 6/7] ARM: EXYNOS: PM: fix register setup on EXYNOS4x12 for
 AFTR mode code
Date: Mon, 02 Jun 2014 14:35:42 +0200
Message-id: <1401712543-14281-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQV21gp5ggxunuC02zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZMxr/
	MBVc4qho/n2dpYGxm72LkYNDQsBEYukmzS5GTiBTTOLCvfVsXYxcHEIC0xkltt9YygLhdDFJ
	nPhxlBWkik3ASmJi+ypGEFtEQE2iZ/FWRpAiZoG9zBJLuzexgySEBeIk/rQvYwGxWQRUJR61
	zGEGsXkFPCQOPP7MDrFOUaL72QQ2EJtTwFNi5b2HYAuEgGr2vdrFNIGRdwEjwypG0dSC5ILi
	pPRcQ73ixNzi0rx0veT83E2M4LB8JrWDcWWDxSFGAQ5GJR7en+o9wUKsiWXFlbmHGCU4mJVE
	eJdaAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwJrle
	flqf3L64+uKejdpSVlO+5Im/bjc7mfvphvfkE8JNenU20nFmU/ZKhlQ7JZp+OfAnu9p61RlG
	ldwLh7dUcJl/fdcX+5tFL0i8fPrKEh8x96cV5UEHWGZfC1sc2Dd3a9/EnX3iX86z5ufmv2+0
	ernW4Yto4wq721cPN1oxnTonKct1Z6myEktxRqKhFnNRcSIAFh2H5kcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add S5P_CENTRAL_SEQ_OPTION register setup for EXYNOS4x12 to AFTR
mode code.  Without this setup AFTR mode doesn't show any benefit
over WFI one.  When this setup is applied AFTR mode reduces power
consumption by ~12% (as measured on Trats2 board).

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/pm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index aeff99e..0fb9a5a 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -456,6 +456,10 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
 	case CPU_PM_ENTER:
 		if (cpu == 0) {
 			exynos_pm_central_suspend();
+			if (soc_is_exynos4212() || soc_is_exynos4412())
+				__raw_writel(S5P_USE_STANDBY_WFI0 |
+					     S5P_USE_STANDBY_WFE0,
+					     S5P_CENTRAL_SEQ_OPTION);
 			exynos_cpu_save_register();
 		}
 		break;
-- 
1.8.2.3

