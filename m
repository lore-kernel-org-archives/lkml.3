Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaIZONn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:13:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:2158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaIZONk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597276986"
From: Loic Poulain <loic.poulain@intel.com>
To: mika.westerberg@intel.com, linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, samuel.ortiz@intel.com,
        mathias.nyman@linux.intel.com, heikki.krogerus@linux.intel.com,
        Loic Poulain <loic.poulain@intel.com>
Subject: [PATCHv3] pinctrl: baytrail: Clear DIRECT_IRQ bit
Date: Fri, 26 Sep 2014 16:14:51 +0200
Message-Id: <1411740891-3311-1-git-send-email-loic.poulain@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct irq en bit should be cleared for pads using io mode.
If not, the io based irq will never be detected.
However, this bit can sometimes be misconfigured (BIOS issue).
Force clearing of this bit in io mode and trigger a WARN.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning
 v3: Update commit message & warn message

 drivers/pinctrl/pinctrl-baytrail.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 701a646..d1e9484 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -230,10 +230,14 @@ static int byt_irq_type(struct irq_data *d, unsigned type)
 	spin_lock_irqsave(&vg->lock, flags);
 	value = readl(reg);

+	WARN(value & BYT_DIRECT_IRQ_EN,
+		"Bad pad config for io mode, force direct_irq_en bit clearing");
+
 	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
 	 * are used to indicate high and low level triggering
 	 */
-	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+	value &= ~(BYT_DIRECT_IRQ_EN | BYT_TRIG_POS | BYT_TRIG_NEG |
+		   BYT_TRIG_LVL);

 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
--
1.8.3.2

