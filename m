Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaCaVBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:01:53 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24460 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCaVBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:01:49 -0400
X-IronPort-AV: E=Sophos;i="4.97,767,1389772800"; 
   d="scan'208";a="22525923"
From: Markus Mayer <markus.mayer@linaro.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: Delay the card_event callback into the mmc_rescan worker
Date: Mon, 31 Mar 2014 14:01:45 -0700
Message-ID: <1396299705-29268-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change removes the callback from atomic context which it doesn't
need to be in, and puts it in line with the debounced rescan.

This code is based on these e-mail threads with Christian Daudt:

  https://lkml.org/lkml/2013/8/19/539
  https://lkml.org/lkml/2014/3/19/79

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/mmc/core/core.c      |    5 +++++
 drivers/mmc/core/slot-gpio.c |    4 +---
 include/linux/mmc/host.h     |    2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 098374b..ff7fd2e 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2421,6 +2421,11 @@ void mmc_rescan(struct work_struct *work)
 		container_of(work, struct mmc_host, detect.work);
 	int i;
 
+	if (host->trigger_card_event && host->ops->card_event) {
+		host->ops->card_event(host);
+		host->trigger_card_event = false;
+	}
+
 	if (host->rescan_disable)
 		return;
 
diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index 46596b71..4029c85 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -29,9 +29,7 @@ static irqreturn_t mmc_gpio_cd_irqt(int irq, void *dev_id)
 	/* Schedule a card detection after a debounce timeout */
 	struct mmc_host *host = dev_id;
 
-	if (host->ops->card_event)
-		host->ops->card_event(host);
-
+	host->trigger_card_event = true;
 	mmc_detect_change(host, msecs_to_jiffies(200));
 
 	return IRQ_HANDLED;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 99f5709..63b983b 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -322,6 +322,8 @@ struct mmc_host {
 	int			rescan_disable;	/* disable card detection */
 	int			rescan_entered;	/* used with nonremovable devices */
 
+	bool			trigger_card_event; /* card_event necessary */
+
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
-- 
1.7.9.5

