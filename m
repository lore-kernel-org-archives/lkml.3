Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaLBQrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:47:36 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60741 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaLBQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:47:34 -0500
From: Stefan Agner <stefan@agner.ch>
To: chris@printf.net, ulf.hansson@linaro.org, anton@enomsg.org
Cc: rmk+kernel@arm.linux.org.uk, b29396@freescale.com, shawn.guo@linaro.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 1/2] mmc: sdhci-pltfm: fix abort due to missing runtime PM
Date: Tue,  2 Dec 2014 17:47:24 +0100
Message-Id: <1417538845-10867-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When entering suspend while the device is in runtime PM, the
sdhci_[suspend|resume]_host function are called without taking
care of runtime PM. On Vybrid SoC this leads to external abort
since during runtime suspend, the clocks for this peripheral
are disabled.

[   37.772967] Unhandled fault: imprecise external abort (0x1c06) at 0x76f5f000
[   37.780304] Internal error: : 1c06 [#1] ARM
[   37.784670] Modules linked in:
[   37.787908] CPU: 0 PID: 428 Comm: sh Not tainted 3.18.0-rc5-00119-geefd097-dirty #1540
[   37.796142] task: 8e246c00 ti: 8ca6c000 task.ti: 8ca6c000
[   37.801785] PC is at esdhc_writel_le+0x40/0xec
[   37.806431] LR is at sdhci_set_card_detection+0xe0/0xe4
[   37.811877] pc : [<803f0584>]    lr : [<803eaaa0>]    psr: 400f0013
[   37.811877] sp : 8ca6dd28  ip : 00000001  fp : 8ca6dd3c
[   37.823766] r10: 807a233c  r9 : 00000000  r8 : 8e8b7210
[   37.829194] r7 : 802d8a08  r6 : 8082e928  r5 : 00000000  r4 : 00000002
[   37.835974] r3 : 8ea34e90  r2 : 00000038  r1 : 00000000  r0 : 8ea32ac0
...

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
Not really sure this is the right place to fix this. The function now
ended up to be identically to the implementations in sdhci-pxav3.c...

 drivers/mmc/host/sdhci-pltfm.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index c5b01d6..0bc864e 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -31,6 +31,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/pm_runtime.h>
 #ifdef CONFIG_PPC
 #include <asm/machdep.h>
 #endif
@@ -237,17 +238,29 @@ EXPORT_SYMBOL_GPL(sdhci_pltfm_unregister);
 #ifdef CONFIG_PM
 int sdhci_pltfm_suspend(struct device *dev)
 {
+	int ret;
 	struct sdhci_host *host = dev_get_drvdata(dev);
 
-	return sdhci_suspend_host(host);
+	pm_runtime_get_sync(dev);
+	ret = sdhci_suspend_host(host);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(sdhci_pltfm_suspend);
 
 int sdhci_pltfm_resume(struct device *dev)
 {
+	int ret;
 	struct sdhci_host *host = dev_get_drvdata(dev);
 
-	return sdhci_resume_host(host);
+	pm_runtime_get_sync(dev);
+	ret = sdhci_resume_host(host);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(sdhci_pltfm_resume);
 
-- 
2.1.3

