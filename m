Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaKNIvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:51:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21083 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaKNIup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:50:45 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-9d-5465c262c060
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v12 6/6] amba: Use inlines instead of macros for
 amba_pclk_enable/disable
Date: Fri, 14 Nov 2014 09:50:33 +0100
Message-id: <1415955033-29093-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7pJh1JDDB7uMrXYOGM9q8X0qRcY
	LVZP/ctq8fqFocXTzY+ZLM42vWG36Jy4hN1i1pS9TBaXd81hs/jce4TR4vZlXou1R+6yW9w9
	dZTN4szpS6wWE35fYLM4vjbc4mXffhYHQY+W5h42j9kdM1k9Fu95yeSxaVUnm8eda3vYPLZc
	bWfxmH33B6NH35ZVjB4rVn9n9/i8SS6AK4rLJiU1J7MstUjfLoEr4/GeSywFtzgrpqyaxN7A
	OJ+ji5GTQ0LARGL5yTtMELaYxIV769m6GLk4hASWMkocP/2fDSQhJNDHJHFuWxGIzSZgLLF5
	+RKwIhGBdmaJvnVTwYqYBRYxSTRNVQSxhQWiJV5MO8IMYrMIqEpcPLqREcTmFXCXmLT7HNQ2
	OYmTxyazgticAh4SkzeuYoFY5i7x+fIf5gmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn
	525ihIT51x2MS49ZHWIU4GBU4uHVyEwNEWJNLCuuzD3EKMHBrCTCq7QbKMSbklhZlVqUH19U
	mpNafIiRiYNTqoFx777Pr+svN9hFrneMKtunU39w+hov67wnZ65PtVZbdLdx902xbyWn5tfb
	fvQz3D7Zp2dK/1/rS45Fyx1WpO0ombOpZoMTy+tl5r/tPrfo7Lj85eURCdFfR+favF/78JTH
	xf1p1Z7vdsz0ydg/u03wz6MLazef49RYtqRchMkp9s2591M/TjXqeKvEUpyRaKjFXFScCACw
	pezTUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the amba_pclk_enable and amba_pclk_disable macros with static
inline functions and remove checks for IS_ERR. The amba bus clock won't
be ERR because probe would fail before the use of these functions.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/amba/bus.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 2afc618b15ce..0ab5f8e0dea2 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -92,11 +92,15 @@ struct amba_device *amba_find_device(const char *, struct device *, unsigned int
 int amba_request_regions(struct amba_device *, const char *);
 void amba_release_regions(struct amba_device *);
 
-#define amba_pclk_enable(d)	\
-	(IS_ERR((d)->pclk) ? 0 : clk_enable((d)->pclk))
+static inline int amba_pclk_enable(struct amba_device *dev)
+{
+	return clk_enable(dev->pclk);
+}
 
-#define amba_pclk_disable(d)	\
-	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
+static inline void amba_pclk_disable(struct amba_device *dev)
+{
+	clk_disable(dev->pclk);
+}
 
 static inline int amba_pclk_prepare(struct amba_device *dev)
 {
-- 
1.9.1

