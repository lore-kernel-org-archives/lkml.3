Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbbA2I72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:59:28 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753555AbbA2I70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Tyler Baker <tyler.baker@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 170/176] mmc: sdhci: Don't signal the sdio irq if it's not setup
Date: Wed, 28 Jan 2015 15:30:00 +0100
Message-Id: <96972e2788b66ec3d99fa6b24fb96e0c275278a6.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[Not needed in newer kernels due to refactoring fixing this issue.]

With 3.14.29 (and older kernels) some of my I.mx6 Sabrelite boards were
crashing with the following oops:

  sdhci: Secure Digital Host Controller Interface driver
  sdhci: Copyright(c) Pierre Ossman
  sdhci-pltfm: SDHCI platform and OF driver helper
  sdhci-esdhc-imx 2198000.usdhc: could not get ultra high speed state, work on normal mode
  mmc0: no vqmmc regulator found
  mmc0: SDHCI controller on 2198000.usdhc [2198000.usdhc] using ADMA
  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = c0004000
  [00000000] *pgd=00000000
  Internal error: Oops: 5 [#1] SMP ARM
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.29 #1
  task: c08a7120 ti: c089c000 task.ti: c089c000
  PC is at wake_up_process+0x8/0x40
  LR is at sdhci_irq+0x748/0x9c4

Full boot log can be found at:
  http://storage.kernelci.org/stable/v3.14.29/arm-multi_v7_defconfig/lab-collabora/boot-imx6q-sabrelite.html

This happens if the sdhci interrupt status contains SDHCI_INT_CARD_INT,
while the sdio irq was never setup.  This patch fixes that in a minimal
way by checking if the sdio irq was setup.

In more recent kernels this bug went away due to refactoring done by
Russel King. So an alternative (potentially better?) fix for this patch
is to cherrypick the following patches from a recent kernel:

18258f7239a6 - genirq: Provide synchronize_hardirq()
bf3b5ec66bd0 - mmc: sdio_irq: rework sdio irq handling
41005003bcaf - mmc: sdhci: clean up interrupt handling
781e989cf593 - mmc: sdhci: convert to new SDIO IRQ handling

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tyler Baker <tyler.baker@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/sdhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6863e3274564..ff6e822d2b78 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2508,7 +2508,7 @@ out:
 	/*
 	 * We have to delay this as it calls back into the driver.
 	 */
-	if (cardint)
+	if (cardint && host->mmc->sdio_irqs)
 		mmc_signal_sdio_irq(host->mmc);
 
 	return result;
-- 
2.2.2

