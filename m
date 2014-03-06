Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaCFOmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:42:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55630 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbaCFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:39:43 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 08/13] phy: ti-pipe3: Fix suspend/resume and module reload
Date: Thu, 6 Mar 2014 16:38:44 +0200
Message-ID: <1394116729-28811-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394116729-28811-1-git-send-email-rogerq@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to Errata i783, SATA breaks if its DPLL is idled. The recommeded
workaround to issue a softreset to the SATA controller doesn't seem to
work. Here we just prevent SATA DPLL from Idling and hence avoid
the issue altogether.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-ti-pipe3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 12cc900..5913676 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -238,6 +238,10 @@ static int ti_pipe3_exit(struct phy *x)
 	u32 val;
 	unsigned long timeout;
 
+	/* SATA DPLL can't be powered down due to Errata i783 */
+	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata"))
+		return 0;
+
 	/* Put DPLL in IDLE mode */
 	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
 	val |= PLL_IDLE;
-- 
1.8.3.2

