Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaJJIYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:24:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62834 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaJJIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:24:10 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-0f-543797a5c257
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/4] extcon: max77693: Request only specific interrupts
Date: Fri, 10 Oct 2014 10:23:55 +0200
Message-id: <1412929436-22001-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
References: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7pLp5uHGFzrF7fYOGM9q8X1L89Z
	LV6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF7cYVbBanu1kdOD3uXNvD5jHvZKBH35ZVjB6f
	N8kFsERx2aSk5mSWpRbp2yVwZbR27mAs2CBW8ev/B+YGxgdCXYycHBICJhIrGq+xQdhiEhfu
	rQeyuTiEBJYySsxb+ZUZJCEk0MckcbhJGcRmEzCW2Lx8CViRiMBuRolvexcxgTjMAkcZJab3
	vmUCqRIWcJc4emwjexcjBweLgKrE/E+2IGFeoPC776eZILbJSZw8NpkVxOYU8JBoeb2LEWKZ
	u8TLngWsExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICa2vOxiXHrM6xCjAwajE
	w3tBxjxEiDWxrLgy9xCjBAezkgivvilQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2PyyqLHU+Pu
	3Gh29921PvTCpxDB+ScOLn1yf+3cI3vsk9+6pzOHLTUROvDhqHxdwu3usrNyjR4+a1YxFn5i
	K6hcdnP33MkBlxbp5B8ozbj0NGj3RNv6tFSVqScrFbfN/Sa9x7P8sPSfFeaPu6W3tbVx3Lyk
	cjzKIN6gVH7WyRSnGydEnzjElnMqsRRnJBpqMRcVJwIAoaw/9QsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was requesting all MUIC interrupts but then was masking most
of them manually at end of probe (with default_init_data). Since
default_init_data cannot be passed through DTS (no bindings for driver),
this was a conflicting behavior. First get everything, then mask what we
don't want.

This could change after adding DTS bindings for requesting specific
MUIC interrupts. Until then driver should request only these MUIC
interrupts which he is really interested in.

The commit does not introduce any functional change when the driver is
used with DTS (no platform data). However this changes the behavior with
platform data supplied. In such case the driver will request only 3
interrupts (ADC, ADC1K, ChgTyp). Platform data could still unmask other
interrupts but they won't be handled by the driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index d4b2dfab1888..68d6c7cccc4f 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -44,19 +44,6 @@ static struct max77693_reg_data default_init_data[] = {
 		.addr = MAX77693_MUIC_REG_STATUS2,
 		.data = STATUS2_CHGDETRUN_MASK,
 	}, {
-		/* INTMASK1 - Unmask [3]ADC1KM,[0]ADCM */
-		.addr = MAX77693_MUIC_REG_INTMASK1,
-		.data = INTMASK1_ADC1K_MASK
-			| INTMASK1_ADC_MASK,
-	}, {
-		/* INTMASK2 - Unmask [0]ChgTypM */
-		.addr = MAX77693_MUIC_REG_INTMASK2,
-		.data = INTMASK2_CHGTYP_MASK,
-	}, {
-		/* INTMASK3 - Mask all of interrupts */
-		.addr = MAX77693_MUIC_REG_INTMASK3,
-		.data = 0x0,
-	}, {
 		/* CDETCTRL2 */
 		.addr = MAX77693_MUIC_REG_CDETCTRL2,
 		.data = CDETCTRL2_VIDRMEN_MASK
@@ -135,21 +122,8 @@ struct max77693_muic_irq {
 
 static struct max77693_muic_irq muic_irqs[] = {
 	{ MAX77693_MUIC_IRQ_INT1_ADC,		"muic-ADC" },
-	{ MAX77693_MUIC_IRQ_INT1_ADC_LOW,	"muic-ADCLOW" },
-	{ MAX77693_MUIC_IRQ_INT1_ADC_ERR,	"muic-ADCError" },
 	{ MAX77693_MUIC_IRQ_INT1_ADC1K,		"muic-ADC1K" },
 	{ MAX77693_MUIC_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
-	{ MAX77693_MUIC_IRQ_INT2_CHGDETREUN,	"muic-CHGDETREUN" },
-	{ MAX77693_MUIC_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
-	{ MAX77693_MUIC_IRQ_INT2_DXOVP,		"muic-DXOVP" },
-	{ MAX77693_MUIC_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
-	{ MAX77693_MUIC_IRQ_INT2_VIDRM,		"muic-VIDRM" },
-	{ MAX77693_MUIC_IRQ_INT3_EOC,		"muic-EOC" },
-	{ MAX77693_MUIC_IRQ_INT3_CGMBC,		"muic-CGMBC" },
-	{ MAX77693_MUIC_IRQ_INT3_OVP,		"muic-OVP" },
-	{ MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR,	"muic-MBCCHG_ERR" },
-	{ MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,	"muic-CHG_ENABLED" },
-	{ MAX77693_MUIC_IRQ_INT3_BAT_DET,	"muic-BAT_DET" },
 };
 
 /* Define supported accessory type */
-- 
1.9.1

