Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbaCSHWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:22:09 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58186 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbaCSHWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:22:06 -0400
MIME-Version: 1.0
In-Reply-To: <1394079958-11697-1-git-send-email-markus.mayer@linaro.org>
References: <1394079958-11697-1-git-send-email-markus.mayer@linaro.org>
Date: Wed, 19 Mar 2014 00:22:04 -0700
Message-ID: <CAEPRUYojhHD4DtqDP38smhVytC3VSR=3Fsh7cEOSY4xRCfuR1A@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-bcm-kona: Fix locking in sdhci_bcm_kona_sd_card_emulate()
From: Christian Daudt <bcm@fixthebug.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Chris Ball <chris@printf.net>, Matt Porter <matt.porter@linaro.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 8:25 PM, Markus Mayer <markus.mayer@linaro.org> wrote:
> Since sdhci_bcm_kona_sd_card_emulate() can be called from interrupt
> context, we must use a spinlock instead of a mutex. This change
> essentially restores the way things worked before the change to
> mutexes in http://www.spinics.net/lists/linux-mmc/msg20276.html.
>
> Without this change, we see "scheduling while atomic" errors.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> ---

So digging back in memory (since I no longer have the
broadcom-internal email threads on this topic), I think I recall what
the problem is. card_event is being called directly from
mmc_gpio_cd_irqt, which is atomic context. My plan for this was to
delay the card_event callback into the mmc_rescan worker, as that
would have 2 nice results: remove the callback from atomic context
which it doesn't need to be in, and put it in line with the debounced
rescan (which I think it should be). I made mention of that option in
this thread (https://lkml.org/lkml/2013/8/19/539) but seems I never
followed up with code...
 Something along the lines of the (untested) code below might do the trick:

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 098374b..d4ffba8 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2421,6 +2421,11 @@ void mmc_rescan(struct work_struct *work)
  container_of(work, struct mmc_host, detect.work);
  int i;

+ if (host->trigger_card_event && host->ops->card_event) {
+ host->ops->card_event(host);
+ host->trigger_card_event = 0;
+ }
+
  if (host->rescan_disable)
  return;

diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index 46596b71..fc648ae 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -29,9 +29,7 @@ static irqreturn_t mmc_gpio_cd_irqt(int irq, void *dev_id)
  /* Schedule a card detection after a debounce timeout */
  struct mmc_host *host = dev_id;

- if (host->ops->card_event)
- host->ops->card_event(host);
-
+ host->trigger_card_event = 1;
  mmc_detect_change(host, msecs_to_jiffies(200));

  return IRQ_HANDLED;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 99f5709..0b6bddf 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -322,6 +322,8 @@ struct mmc_host {
  int rescan_disable; /* disable card detection */
  int rescan_entered; /* used with nonremovable devices */

+ int trigger_card_event; /* card_event necessary */
+
  struct mmc_card *card; /* device attached to this host */

  wait_queue_head_t wq;


Of course there are (a few) more users of card_event callback than
bcm_kona that need to be confirmed ok such a change
 Thanks,
   csd
