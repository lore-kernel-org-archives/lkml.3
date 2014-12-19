Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaLSXp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:45:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaLSXp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:45:57 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Sat, 20 Dec 2014 10:07:38 +1100
Subject: [PATCH 2a/3] mmc: core: Allow host driver to provide isr for
 card-detect interrupts.
Cc: GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Message-ID: <20141219230732.7511.28103.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the reasons omap_hsmmc doesn't use the slot-gpio library
is that it has some non-standard functionality in the card-detect
interrupt service routine.

To make it possible for omap_hsmmc (and maybe others) to be converted
to use slot-gpio, add 'mmc_gpio_request_cd_isr' which provide an
alternate isr to be register by the slot-gpio code.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/core/slot-gpio.c  |   24 +++++++++++++++++++++++-
 include/linux/mmc/slot-gpio.h |    2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

This and following are the result of splitting the previous
'2/3' into to patches: core and omap_hsmmc as requested.

NeilBrown


diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index 69bbf2adb329..f56323f5a996 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -23,6 +23,7 @@ struct mmc_gpio {
 	struct gpio_desc *cd_gpio;
 	bool override_ro_active_level;
 	bool override_cd_active_level;
+	irqreturn_t (*cd_gpio_isr)(int irq, void *dev_id);
 	char *ro_label;
 	char cd_label[0];
 };
@@ -156,8 +157,10 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *host)
 		irq = -EINVAL;
 
 	if (irq >= 0) {
+		if (ctx->cd_gpio_isr == NULL)
+			ctx->cd_gpio_isr = mmc_gpio_cd_irqt;
 		ret = devm_request_threaded_irq(&host->class_dev, irq,
-			NULL, mmc_gpio_cd_irqt,
+			NULL, ctx->cd_gpio_isr,
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			ctx->cd_label, host);
 		if (ret < 0)
@@ -171,6 +174,25 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *host)
 }
 EXPORT_SYMBOL(mmc_gpiod_request_cd_irq);
 
+/* Register an alternate interrupt service routine for
+ * the card-detect GPIO.
+ */
+int mmc_gpio_request_cd_isr(struct mmc_host *host,
+			    irqreturn_t (*isr)(int irq, void *dev_id))
+{
+	struct mmc_gpio *ctx;
+	int ret;
+
+	ret = mmc_gpio_alloc(host);
+	if (ret < 0)
+		return ret;
+	ctx = host->slot.handler_priv;
+	if (ctx->cd_gpio_isr)
+		return -EBUSY;
+	ctx->cd_gpio_isr = isr;
+	return 0;
+}
+
 /**
  * mmc_gpio_request_cd - request a gpio for card-detection
  * @host: mmc host
diff --git a/include/linux/mmc/slot-gpio.h b/include/linux/mmc/slot-gpio.h
index e56fa24c9322..9e55db60deb0 100644
--- a/include/linux/mmc/slot-gpio.h
+++ b/include/linux/mmc/slot-gpio.h
@@ -28,6 +28,8 @@ int mmc_gpiod_request_cd(struct mmc_host *host, const char *con_id,
 int mmc_gpiod_request_ro(struct mmc_host *host, const char *con_id,
 			 unsigned int idx, bool override_active_level,
 			 unsigned int debounce, bool *gpio_invert);
+int mmc_gpio_request_cd_isr(struct mmc_host *host,
+			    irqreturn_t (*isr)(int irq, void *dev_id));
 void mmc_gpiod_free_cd(struct mmc_host *host);
 void mmc_gpiod_request_cd_irq(struct mmc_host *host);
 


