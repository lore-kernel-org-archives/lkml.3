Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3EaGcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:32:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45279 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3EaGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:32:27 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux@arm.linux.org.uk>, <zonque@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <davinci-linux-open-source@linux.davincidsp.com>, <khilman@linaro.org>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: [PATCH 1/2] rtc: omap: add option to indicate wakeup support through DT
Date: Fri, 31 May 2013 12:03:24 +0530
Message-ID: <1369982005-8572-2-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though RTC-IP is wakeup capable, Not all Boards support it.

For example
The rtc alarm wakeup is available in rtc-ip since omap1 days but alarm
was not wired properly in previous ompa1 boards.

	commit fa5b07820fe3a0fc06ac368516e71f10a59b9539
	Author: Sekhar Nori <nsekhar@ti.com>
	Date:   Wed Oct 27 15:33:05 2010 -0700

	rtc: omap: let device wakeup capability be configured from chip
	init logic

	The rtc-omap driver currently hardcodes the RTC wakeup
	capability to be "not capable".  While this seems to be true for
	existing OMAP1 boards which are not wired for this, the
	DA850/OMAP-L138 SoC, the RTC can always be wake up source from
	its "deep sleep" mode.

Current rtc-omap driver expects the rtc module wake-up capabilities to
be set up by board specific code. However, in case of DT, this is not
possible.

So, add a DT property "ti,wakeup_capable" to indicate that the module is
wake-up capable.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
---
:100644 100644 b47aa41... 108a629... M	Documentation/devicetree/bindings/rtc/rtc-omap.txt
:100644 100644 b0ba3fc... 000a02f... M	drivers/rtc/rtc-omap.c
 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    4 ++++
 drivers/rtc/rtc-omap.c                             |    5 +++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
index b47aa41..108a629 100644
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
+++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -6,6 +6,10 @@ Required properties:
 - interrupts: rtc timer, alarm interrupts in order
 - interrupt-parent: phandle for the interrupt controller
 
+Optional properties:
+- ti,wakeup_capable: Inform the rtc driver that this module is wake-up
+  capable so that rtcwake and suspend tests can work.
+
 Example:
 
 rtc@1c23000 {
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index b0ba3fc..000a02f 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -423,6 +423,11 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	 *    is write-only, and always reads as zero...)
 	 */
 
+	/* Fixup wakeup-enable feature based on the device tree */
+	if (of_id && of_find_property(pdev->dev.of_node,
+				      "ti,wakeup_capable", NULL))
+		device_init_wakeup(&pdev->dev, 1);
+
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
-- 
1.7.9.5

