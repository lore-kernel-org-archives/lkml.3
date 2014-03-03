Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaCCTwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:52:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51017 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaCCTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:52:00 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 5/5] ARM: tegra: fix Dalmore PMIC IRQ polarity
Date: Mon,  3 Mar 2014 12:51:40 -0700
Message-Id: <1393876300-3061-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The Tegra PMC's resume-from-sleep logic wants an active-low IRQ input
from the PMIC. However, the PMIC IRQ is also routed to the GIC, which
only supports active high IRQs (or rising edge). Hence, the signal must
be inverted in the PMC before being routed to the GIC. This implies that
the PMC DT property nvidia,invert-interrupt must be set, and it is.

The PMIC's DT interrupts property must represent the IRQ level at the
GIC, since that is the PMIC's parent IRQ controller. Fix the PMIC's
interrupts property to correctly describe the GIC input polarity.

However, the PMIC IRQ output's polarity is programmable in HW, and by
default follows the parent IRQ controller's input polarity. We need to
have an active-low output due to the inversion inside the Tegra PMC.
Hence, add the IRQ specifier flag which request that to the PMIC.

Reported-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3: Update to match changes to IRQ specifier DT binding.
v2: No change.
---
 arch/arm/boot/dts/tegra114-dalmore.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 8de543777882..f4319ac1a401 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -893,7 +893,8 @@
 		palmas: tps65913@58 {
 			compatible = "ti,palmas";
 			reg = <0x58>;
-			interrupts = <0 86 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <0 86
+				(IRQ_TYPE_LEVEL_HIGH | IRQ_SRC_DST_INVERTED)>;
 
 			#interrupt-cells = <2>;
 			interrupt-controller;
-- 
1.8.1.5

