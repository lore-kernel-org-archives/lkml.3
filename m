Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaKLOdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:33:07 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60986 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaKLOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:32:41 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-2f-54636f85e7f5
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
Subject: [PATCH v11 6/6] amba: Use inlines instead of macros for
 amba_pclk_enable/disable
Date: Wed, 12 Nov 2014 15:32:28 +0100
Message-id: <1415802748-30530-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7qt+ckhBnd6DCw2zljPajF96gVG
	i9VT/7JavH5haPF082Mmi7NNb9gtOicuYbeYNWUvk8XlXXPYLD73HmG0uH2Z12LtkbvsFndP
	HWWzOHP6EqvFhN8X2CyOrw23eNm3n8VB0KOluYfNY3bHTFaPxXteMnlsWtXJ5nHn2h42jy1X
	21k8Zt/9wejRt2UVo8eK1d/ZPT5vkgvgiuKySUnNySxLLdK3S+DKWH/2MnvBLc6KzvUbWBoY
	53N0MXJySAiYSGzrX88IYYtJXLi3nq2LkYtDSGApo8SCJ8eZQRJCAn1MEtveFYHYbALGEpuX
	LwErEhFoZ5boWzeVDSTBLLCISaJpqmIXIweHsEC0xKFfoiBhFgFViSubDoGV8Aq4S7w584Md
	YpmcxMljk1lBbE4BD4kv2/6yQexylzhz+SDLBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1
	kvNzNzFCgvzrDsalx6wOMQpwMCrx8H7QSg4RYk0sK67MPcQowcGsJMK7KwcoxJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgfH2wjLV7bdXrvPpWDH51j1X1/scO+p/OnU39/YcdLz8yLdfyWR157QZ
	nv2yKudLNu1XerQ5O1/pjOAztVc+TGdftHKaFMQvnWb1fvVUg9uK3w+5WS3KKmTRstpU4p2a
	WrCfrSCf9cCz+NURU/Yo309U+3V0RsZulh57Ke6L9XMOyy0p/vjm0zQlluKMREMt5qLiRACA
	z6gdUAIAAA==
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
index 2afc618b15ce..7daba00ddabd 100644
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

