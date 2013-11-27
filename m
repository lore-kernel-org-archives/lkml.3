Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab3K0TIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:08:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56904 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab3K0TI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 08/13] mfd: menelaus: pass menelaus_chip pointer to add/remove irq functions
Date: Wed, 27 Nov 2013 13:06:52 -0600
Message-ID: <1385579217-20127-9-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1385579217-20127-1-git-send-email-balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those functions are static and can receive a
menelaus_chip pointer very easily.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 57 ++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 8796e5e..8672d86 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -236,28 +236,28 @@ static int menelaus_ack_irq(struct menelaus_chip *m, int irq)
 }
 
 /* Adds a handler for an interrupt. Does not run in interrupt context */
-static int menelaus_add_irq_work(int irq,
+static int menelaus_add_irq_work(struct menelaus_chip *m, int irq,
 		void (*handler)(struct menelaus_chip *))
 {
 	int ret = 0;
 
-	mutex_lock(&the_menelaus->lock);
-	the_menelaus->handlers[irq] = handler;
-	ret = menelaus_enable_irq(the_menelaus, irq);
-	mutex_unlock(&the_menelaus->lock);
+	mutex_lock(&m->lock);
+	m->handlers[irq] = handler;
+	ret = menelaus_enable_irq(m, irq);
+	mutex_unlock(&m->lock);
 
 	return ret;
 }
 
 /* Removes handler for an interrupt */
-static int menelaus_remove_irq_work(int irq)
+static int menelaus_remove_irq_work(struct menelaus_chip *m, int irq)
 {
 	int ret = 0;
 
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_disable_irq(the_menelaus, irq);
-	the_menelaus->handlers[irq] = NULL;
-	mutex_unlock(&the_menelaus->lock);
+	mutex_lock(&m->lock);
+	ret = menelaus_disable_irq(m, irq);
+	m->handlers[irq] = NULL;
+	mutex_unlock(&m->lock);
 
 	return ret;
 }
@@ -412,23 +412,24 @@ EXPORT_SYMBOL(menelaus_set_mmc_slot);
 int menelaus_register_mmc_callback(void (*callback)(void *data, u8 card_mask),
 				   void *data)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int ret = 0;
 
-	the_menelaus->mmc_callback_data = data;
-	the_menelaus->mmc_callback = callback;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S1CD_IRQ,
+	m->mmc_callback_data = data;
+	m->mmc_callback = callback;
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S1CD_IRQ,
 				    menelaus_mmc_cd_work);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S2CD_IRQ,
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S2CD_IRQ,
 				    menelaus_mmc_cd_work);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S1D1_IRQ,
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S1D1_IRQ,
 				    menelaus_mmc_cd_work);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S2D1_IRQ,
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S2D1_IRQ,
 				    menelaus_mmc_cd_work);
 
 	return ret;
@@ -437,13 +438,15 @@ EXPORT_SYMBOL(menelaus_register_mmc_callback);
 
 void menelaus_unregister_mmc_callback(void)
 {
-	menelaus_remove_irq_work(MENELAUS_MMC_S1CD_IRQ);
-	menelaus_remove_irq_work(MENELAUS_MMC_S2CD_IRQ);
-	menelaus_remove_irq_work(MENELAUS_MMC_S1D1_IRQ);
-	menelaus_remove_irq_work(MENELAUS_MMC_S2D1_IRQ);
+	struct menelaus_chip *m = the_menelaus;
+
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S1CD_IRQ);
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S2CD_IRQ);
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S1D1_IRQ);
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S2D1_IRQ);
 
-	the_menelaus->mmc_callback = NULL;
-	the_menelaus->mmc_callback_data = NULL;
+	m->mmc_callback = NULL;
+	m->mmc_callback_data = NULL;
 }
 EXPORT_SYMBOL(menelaus_unregister_mmc_callback);
 
@@ -1070,8 +1073,8 @@ static int menelaus_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
 	case RTC_UIE_ON:
 		if (m->uie)
 			return 0;
-		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
-		status = menelaus_add_irq_work(MENELAUS_RTCTMR_IRQ,
+		status = menelaus_remove_irq_work(m, MENELAUS_RTCTMR_IRQ);
+		status = menelaus_add_irq_work(m, MENELAUS_RTCTMR_IRQ,
 				menelaus_rtc_update_work);
 		if (status == 0)
 			m->uie = 1;
@@ -1079,7 +1082,7 @@ static int menelaus_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
 	case RTC_UIE_OFF:
 		if (!m->uie)
 			return 0;
-		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
+		status = menelaus_remove_irq_work(m, MENELAUS_RTCTMR_IRQ);
 		if (status == 0)
 			m->uie = 0;
 		return status;
@@ -1127,7 +1130,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 
 	/* support RTC alarm; it can issue wakeups */
 	if (alarm) {
-		if (menelaus_add_irq_work(MENELAUS_RTCALM_IRQ,
+		if (menelaus_add_irq_work(m, MENELAUS_RTCALM_IRQ,
 				menelaus_rtc_alarm_work) < 0) {
 			dev_err(&m->client->dev, "can't handle RTC alarm\n");
 			return;
@@ -1154,7 +1157,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 			&menelaus_rtc_ops, THIS_MODULE);
 	if (IS_ERR(m->rtc)) {
 		if (alarm) {
-			menelaus_remove_irq_work(MENELAUS_RTCALM_IRQ);
+			menelaus_remove_irq_work(m, MENELAUS_RTCALM_IRQ);
 			device_init_wakeup(&m->client->dev, 0);
 		}
 		dev_err(&m->client->dev, "can't register RTC: %d\n",
-- 
1.8.4.GIT

