Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3GCIpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:45:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34001 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab3GCIp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:45:27 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <tony@atomide.com>, <benoit.cousson@gmail.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>
Subject: [Patch V2 1/4] rtc: omap: restore back (hard-code) wakeup support
Date: Wed, 3 Jul 2013 14:17:02 +0530
Message-ID: <1372841225-18813-2-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc-omap driver modules is used both by OMAP1/2, Davinci SoC platforms.

However, rtc wake support on OMAP1 is broken. Hence the
device_init_wakeup() was removed from rtc-omap driver and moved to
platform board files that supported it (DA850/OMAP-L138). [1]

However, recently [2] it was suggested that driver should always do a
device_init_wakeup(dev, true). Platforms that don't want/need
wakeup support can disable it from userspace via:

    echo disabled > /sys/devices/.../power/wakeup

Also, with the new DT boot-up, board file doesn't exist and hence there
is no way to have device wakeup support rtc.

The fix for above issues, is to hard code device_init_wakeup() inside
driver and let platforms that don't need this, handle it through the
sysfs power entry.

[1]
https://patchwork.kernel.org/patch/136731/

[2]
http://www.mail-archive.com/davinci-linux-open-source@linux.
davincidsp.com/msg26077.html

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
:100644 100644 b0ba3fc... 761919d... M	drivers/rtc/rtc-omap.c
 drivers/rtc/rtc-omap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index b0ba3fc..761919d 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -423,6 +423,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	 *    is write-only, and always reads as zero...)
 	 */
 
+	device_init_wakeup(&pdev->dev, true);
+
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
-- 
1.7.9.5

