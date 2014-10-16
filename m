Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaJPJlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:41:06 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36452 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJPJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:41:04 -0400
MIME-Version: 1.0
Date: Thu, 16 Oct 2014 17:41:01 +0800
Message-ID: <CAGZxSSSBpCvJt=PFbihTmPneJqiocU8VZSDHpXgkf5dhWZ850Q@mail.gmail.com>
Subject: [PATCH v2] arm64: mm: use macro instead of if judgement of ZONE_DMA
From: Yifan Zhang <yifan.zhangm@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, mark.rutland@arm.com,
        lauraa@codeaurora.org, ganapatrao.kulkarni@caviumnetworks.com,
        robh@kernel.org, leif.lindholm@linaro.org, Yalin.Wang@sonymobile.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Yifan Zhang <zhangyf@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if disable CONFIG_ZONE_DMA, ZONE_DMA becomes undefined.

Signed-off-by: Yifan Zhang <zhangyf@marvell.com>
---
 arch/arm64/mm/init.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 494297c..887ca5d 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -82,10 +82,10 @@ static void __init zone_sizes_init(unsigned long
min, unsigned long max)
    memset(zone_size, 0, sizeof(zone_size));

    /* 4GB maximum for 32-bit only capable devices */
-   if (IS_ENABLED(CONFIG_ZONE_DMA)) {
-       max_dma = PFN_DOWN(max_zone_dma_phys());
-       zone_size[ZONE_DMA] = max_dma - min;
-   }
+#ifdef CONFIG_ZONE_DMA
+   max_dma = PFN_DOWN(max_zone_dma_phys());
+   zone_size[ZONE_DMA] = max_dma - min;
+#endif
    zone_size[ZONE_NORMAL] = max - max_dma;

    memcpy(zhole_size, zone_size, sizeof(zhole_size));
@@ -97,10 +97,12 @@ static void __init zone_sizes_init(unsigned long
min, unsigned long max)
        if (start >= max)
            continue;

-       if (IS_ENABLED(CONFIG_ZONE_DMA) && start < max_dma) {
+#ifdef CONFIG_ZONE_DMA
+       if (start < max_dma) {
            unsigned long dma_end = min(end, max_dma);
            zhole_size[ZONE_DMA] -= dma_end - start;
        }
+#endif

        if (end > max_dma) {
            unsigned long normal_end = min(end, max);
--
1.7.9.5
