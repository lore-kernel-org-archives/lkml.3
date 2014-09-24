Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIXLIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:08:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41338 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaIXLFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:05:51 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3b-5422a58cdfa2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com
Subject: [PATCH v5 3/7] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Wed, 24 Sep 2014 13:05:37 +0200
Message-id: <1411556741-5810-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xa7o9S5VCDA7u1bd4NP8xs0Xvgqts
	Fmeb3rBbbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaLGef3MVncvsxrcW77FhaLtUfuslu8
	7lvDbLFq1x9Gi/1XvBz4PVqae9g8vn2dxOJxua+XyWPR9yyPnbPusnvcubaHzWPzknqPvi2r
	GD2O39jO5PF5k1wAVxSXTUpqTmZZapG+XQJXxrdPt9kLfnNWzL1zg6WBcStHFyMnh4SAicSu
	phtsELaYxIV764FsLg4hgaWMEnsm/meHcPqYJFZP2g9WxSZgKNH1tgvMFhHIlvjxbTILSBGz
	QCuzxOMn31hBEsIC6RIX9m1iBLFZBFQlZn9aABbnFXCX+H/gBgvEOjmJ/y9XMIHYnAIeEo8f
	/wOq5wDa5i7RtMllAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghAf1lB+PiY1aH
	GAU4GJV4eCeIK4UIsSaWFVfmHmKU4GBWEuF91QMU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFhR
	f+c6x1TXyVelAv31Nq77OEnrRZHGmej1W7d2t78tNg5a+7zpXMr+wK+69ctDzqsyrDP1s5XO
	0xacxJnCrpR/5caqWWJ8jduDWPe3+AZach2uKjd2r/coy+lk3Flsz3yNU0p3hdmripXSdkl1
	vyYZzPu9p/u5apd0w6+tfOtr1A7rHTDfqMRSnJFoqMVcVJwIAN2Ya49GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Certain platforms (i.e. Exynos) might need to set .write_sec callback
from firmware initialization which is happenning in .init_early callback
of machine descriptor. However current code will overwrite the pointer
with whatever is present in machine descriptor, even though it can be
already set earlier. This patch fixes this by making the assignment
conditional, depending on whether current .write_sec callback is NULL.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/kernel/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 5c4d38e32a51..015152a780df 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -125,7 +125,8 @@ void __init init_IRQ(void)
 
 	if (IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_CACHE_L2X0) &&
 	    (machine_desc->l2c_aux_mask || machine_desc->l2c_aux_val)) {
-		outer_cache.write_sec = machine_desc->l2c_write_sec;
+		if (!outer_cache.write_sec)
+			outer_cache.write_sec = machine_desc->l2c_write_sec;
 		ret = l2x0_of_init(machine_desc->l2c_aux_val,
 				   machine_desc->l2c_aux_mask);
 		if (ret)
-- 
1.9.2

