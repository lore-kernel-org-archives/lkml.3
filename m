Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaKLBXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:23:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaKLBXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Fu Zhonghui <zhonghui.fu@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.17 039/319] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
Date: Wed, 12 Nov 2014 10:12:57 +0900
Message-Id: <20141112010959.148205706@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio.c     |   12 ++++++++++--
 drivers/mmc/core/sdio_irq.c |    4 ++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -992,8 +992,16 @@ static int mmc_sdio_resume(struct mmc_ho
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
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -208,7 +208,7 @@ static int sdio_card_irq_get(struct mmc_
 				host->sdio_irqs--;
 				return err;
 			}
-		} else {
+		} else if (host->caps & MMC_CAP_SDIO_IRQ) {
 			mmc_host_clk_hold(host);
 			host->ops->enable_sdio_irq(host, 1);
 			mmc_host_clk_release(host);
@@ -229,7 +229,7 @@ static int sdio_card_irq_put(struct mmc_
 		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
 			atomic_set(&host->sdio_irq_thread_abort, 1);
 			kthread_stop(host->sdio_irq_thread);
-		} else {
+		} else if (host->caps & MMC_CAP_SDIO_IRQ) {
 			mmc_host_clk_hold(host);
 			host->ops->enable_sdio_irq(host, 0);
 			mmc_host_clk_release(host);


