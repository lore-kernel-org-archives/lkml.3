Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaKYLlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:41:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaKYKlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Fu Zhonghui <zhonghui.fu@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 078/254] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
Date: Tue, 25 Nov 2014 10:37:08 +0000
Message-Id: <1416912004-5928-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fu Zhonghui <zhonghui.fu@linux.intel.com>

commit dea67c4ec8218b301d7cac7ee6e63dac0bc566cb upstream.

781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
the use of our own custom threaded IRQ handler, but left in an
unconditional wake_up_process() on that handler at resume-time.
Link: https://bugzilla.kernel.org/show_bug.cgi?id=80151

In addition, the check for MMC_CAP_SDIO_IRQ capability is added
before enable sdio IRQ.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/core/sdio.c     | 12 ++++++++++--
 drivers/mmc/core/sdio_irq.c |  4 ++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index e636d9e99e4a..3fc40a7140a8 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -992,8 +992,16 @@ static int mmc_sdio_resume(struct mmc_host *host)
 		}
 	}
 
-	if (!err && host->sdio_irqs)
-		wake_up_process(host->sdio_irq_thread);
+	if (!err && host->sdio_irqs) {
+		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
+			wake_up_process(host->sdio_irq_thread);
+		} else if (host->caps & MMC_CAP_SDIO_IRQ) {
+			mmc_host_clk_hold(host);
+			host->ops->enable_sdio_irq(host, 1);
+			mmc_host_clk_release(host);
+		}
+	}
+
 	mmc_release_host(host);
 
 	host->pm_flags &= ~MMC_PM_KEEP_POWER;
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 5cc13c8d35bb..696eca493844 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -208,7 +208,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
 				host->sdio_irqs--;
 				return err;
 			}
-		} else {
+		} else if (host->caps & MMC_CAP_SDIO_IRQ) {
 			mmc_host_clk_hold(host);
 			host->ops->enable_sdio_irq(host, 1);
 			mmc_host_clk_release(host);
@@ -229,7 +229,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
 		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
 			atomic_set(&host->sdio_irq_thread_abort, 1);
 			kthread_stop(host->sdio_irq_thread);
-		} else {
+		} else if (host->caps & MMC_CAP_SDIO_IRQ) {
 			mmc_host_clk_hold(host);
 			host->ops->enable_sdio_irq(host, 0);
 			mmc_host_clk_release(host);
-- 
2.1.0

