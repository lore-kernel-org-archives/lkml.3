Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaGVPkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:40:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58181 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbaGVPki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:40:38 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] pinctrl: dra: dt-bindings: Fix pull enable/disable
Date: Tue, 22 Jul 2014 10:39:54 -0500
Message-ID: <1406043594-14181-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DRA74/72 control module pins have a weak pull up and pull down.
This is configured by bit offset 17. if BIT(17) is 1, a pull up is
selected, else a pull down is selected.

However, this pull resisstor is applied based on BIT(16) -
PULLUDENABLE - if BIT(18) is *0*, then pull as defined in BIT(17) is
applied, else no weak pulls are applied. We defined this in reverse.

Reference: Table 18-5 (Description of the pad configuration register
bits) in Technical Reference Manual Revision (DRA74x revision Q:
SPRUHI2Q Revised June 2014 and DRA72x revision F: SPRUHP2F - Revised
June 2014)

Fixes: 6e58b8f1daaf1a ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Patch based on v3.16-rc5 tag

1: dra72x-evm:  Boot ok: http://slexy.org/raw/s20I6QXQa (needs MMC filesystem that current dts does not have.
	- Fails in plain Vanilla 3.16-rc5 kernel due to missing patch to handle USB IP instance delta (between dra72x and dra74x) appropriately.
	- Tested with fixes needed: https://patchwork.kernel.org/patch/4565431/ and https://patchwork.kernel.org/patch/4565461/

2: dra7xx-evm:  Boot PASS: http://slexy.org/raw/s21c6X2wOd

Equivalent testing on 3.14 based product kernel:
 dra72x-evm:  Boot PASS: http://slexy.org/raw/s21yIgttJw
 dra7xx-evm:  Boot PASS: http://slexy.org/raw/s20w7OZaJJ

It is obvious that current users of padconf have'nt had trouble with
the wrong definitions. I think I might have been the first to discover
this as emmc on beagleboard-X15 (an upcoming platform) exposed this problem.

 include/dt-bindings/pinctrl/dra.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/dt-bindings/pinctrl/dra.h b/include/dt-bindings/pinctrl/dra.h
index 002a285..3d33794 100644
--- a/include/dt-bindings/pinctrl/dra.h
+++ b/include/dt-bindings/pinctrl/dra.h
@@ -30,7 +30,8 @@
 #define MUX_MODE14	0xe
 #define MUX_MODE15	0xf
 
-#define PULL_ENA		(1 << 16)
+#define PULL_ENA		(0 << 16)
+#define PULL_DIS		(1 << 16)
 #define PULL_UP			(1 << 17)
 #define INPUT_EN		(1 << 18)
 #define SLEWCONTROL		(1 << 19)
@@ -38,10 +39,10 @@
 #define WAKEUP_EVENT		(1 << 25)
 
 /* Active pin states */
-#define PIN_OUTPUT		0
+#define PIN_OUTPUT		(0 | PULL_DIS)
 #define PIN_OUTPUT_PULLUP	(PIN_OUTPUT | PULL_ENA | PULL_UP)
 #define PIN_OUTPUT_PULLDOWN	(PIN_OUTPUT | PULL_ENA)
-#define PIN_INPUT		INPUT_EN
+#define PIN_INPUT		(INPUT_EN | PULL_DIS)
 #define PIN_INPUT_SLEW		(INPUT_EN | SLEWCONTROL)
 #define PIN_INPUT_PULLUP	(PULL_ENA | INPUT_EN | PULL_UP)
 #define PIN_INPUT_PULLDOWN	(PULL_ENA | INPUT_EN)
-- 
1.7.9.5

