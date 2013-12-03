Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3LCDsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:48:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39655 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab3LCDou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 12/15] mfd: menelaus: Switch all children to threaded_irq
Date: Mon, 2 Dec 2013 21:43:05 -0600
Message-ID: <1386042188-12246-12-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that we have our own irq_chip, all children
can use traditional request_threaded_irq().

While at that, also remove so functions which
became unused.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 161 +++++++++++++++----------------------------------
 1 file changed, 50 insertions(+), 111 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index e4f33b7..74eae19 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -175,7 +175,6 @@ struct menelaus_chip {
 	u8			mask1, mask2;
 	u8			ack1, ack2;
 
-	void			(*handlers[16])(struct menelaus_chip *);
 	void			(*mmc_callback)(void *data, u8 mask);
 	void			*mmc_callback_data;
 
@@ -209,42 +208,6 @@ static int menelaus_read_reg(struct menelaus_chip *m, int reg)
 	return val;
 }
 
-static int menelaus_enable_irq(struct menelaus_chip *m, int irq)
-{
-	if (irq > 7) {
-		irq -= 8;
-		m->mask2 &= ~(1 << irq);
-		return menelaus_write_reg(m, MENELAUS_INT_MASK2,
-				m->mask2);
-	} else {
-		m->mask1 &= ~(1 << irq);
-		return menelaus_write_reg(m, MENELAUS_INT_MASK1,
-				m->mask1);
-	}
-}
-
-static int menelaus_disable_irq(struct menelaus_chip *m, int irq)
-{
-	if (irq > 7) {
-		irq -= 8;
-		m->mask2 |= (1 << irq);
-		return menelaus_write_reg(m, MENELAUS_INT_MASK2,
-				m->mask2);
-	} else {
-		m->mask1 |= (1 << irq);
-		return menelaus_write_reg(m, MENELAUS_INT_MASK1,
-				m->mask1);
-	}
-}
-
-static int menelaus_ack_irq(struct menelaus_chip *m, int irq)
-{
-	if (irq > 7)
-		return menelaus_write_reg(m, MENELAUS_INT_ACK2, 1 << (irq - 8));
-	else
-		return menelaus_write_reg(m, MENELAUS_INT_ACK1, 1 << irq);
-}
-
 static void menelaus_irq_ack(struct irq_data *data)
 {
 	struct menelaus_chip *m = irq_data_get_irq_chip_data(data);
@@ -322,47 +285,15 @@ static struct irq_chip menelaus_irq_chip = {
 	.irq_bus_sync_unlock = menelaus_irq_bus_sync_unlock,
 };
 
-/* Adds a handler for an interrupt. Does not run in interrupt context */
-static int menelaus_add_irq_work(struct menelaus_chip *m, int irq,
-		void (*handler)(struct menelaus_chip *))
-{
-	int ret = 0;
-
-	mutex_lock(&m->lock);
-	m->handlers[irq] = handler;
-	ret = menelaus_enable_irq(m, irq);
-	mutex_unlock(&m->lock);
-
-	return ret;
-}
-
-/* Removes handler for an interrupt */
-static int menelaus_remove_irq_work(struct menelaus_chip *m, int irq)
-{
-	int ret = 0;
-
-	mutex_lock(&m->lock);
-	ret = menelaus_disable_irq(m, irq);
-	m->handlers[irq] = NULL;
-	mutex_unlock(&m->lock);
-
-	return ret;
-}
-
-/*
- * Gets scheduled when a card detect interrupt happens. Note that in some cases
- * this line is wired to card cover switch rather than the card detect switch
- * in each slot. In this case the cards are not seen by menelaus.
- * FIXME: Add handling for D1 too
- */
-static void menelaus_mmc_cd_work(struct menelaus_chip *m)
+static irqreturn_t menelaus_mmc_cd_irq(int irq, void *_m)
 {
-	int reg;
+	struct menelaus_chip *m = _m;
 	unsigned char card_mask = 0;
+	int reg;
 
 	reg = menelaus_read_reg(m, MENELAUS_MCT_PIN_ST);
 	if (reg < 0)
-		return;
+		return IRQ_NONE;
 
 	if (!(reg & 0x1))
 		card_mask |= MCT_PIN_ST_S1_CD_ST;
@@ -373,6 +304,8 @@ static void menelaus_mmc_cd_work(struct menelaus_chip *m)
 	if (m->mmc_callback)
 		m->mmc_callback(m->mmc_callback_data,
 					  card_mask);
+
+	return IRQ_HANDLED;
 }
 
 /*
@@ -504,20 +437,25 @@ int menelaus_register_mmc_callback(void (*callback)(void *data, u8 card_mask),
 
 	m->mmc_callback_data = data;
 	m->mmc_callback = callback;
-	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S1CD_IRQ,
-				    menelaus_mmc_cd_work);
+
+	ret = request_threaded_irq(MENELAUS_MMC_S1CD_IRQ + m->irq_base,
+			NULL, menelaus_mmc_cd_irq, IRQF_ONESHOT,
+			"mmc_s1cd", m);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S2CD_IRQ,
-				    menelaus_mmc_cd_work);
+	ret = request_threaded_irq(MENELAUS_MMC_S2CD_IRQ + m->irq_base,
+			NULL, menelaus_mmc_cd_irq, IRQF_ONESHOT,
+			"mmc_s2cd", m);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S1D1_IRQ,
-				    menelaus_mmc_cd_work);
+	ret = request_threaded_irq(MENELAUS_MMC_S1D1_IRQ + m->irq_base,
+			NULL, menelaus_mmc_cd_irq, IRQF_ONESHOT,
+			"mmc_s1d1", m);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S2D1_IRQ,
-				    menelaus_mmc_cd_work);
+	ret = request_threaded_irq(MENELAUS_MMC_S2D1_IRQ + m->irq_base,
+			NULL, menelaus_mmc_cd_irq, IRQF_ONESHOT,
+			"mmc_s2d1", m);
 
 	return ret;
 }
@@ -527,10 +465,10 @@ void menelaus_unregister_mmc_callback(void)
 {
 	struct menelaus_chip *m = the_menelaus;
 
-	menelaus_remove_irq_work(m, MENELAUS_MMC_S1CD_IRQ);
-	menelaus_remove_irq_work(m, MENELAUS_MMC_S2CD_IRQ);
-	menelaus_remove_irq_work(m, MENELAUS_MMC_S1D1_IRQ);
-	menelaus_remove_irq_work(m, MENELAUS_MMC_S2D1_IRQ);
+	free_irq(MENELAUS_MMC_S1CD_IRQ + m->irq_base, m);
+	free_irq(MENELAUS_MMC_S2CD_IRQ + m->irq_base, m);
+	free_irq(MENELAUS_MMC_S1D1_IRQ + m->irq_base, m);
+	free_irq(MENELAUS_MMC_S2D1_IRQ + m->irq_base, m);
 
 	m->mmc_callback = NULL;
 	m->mmc_callback_data = NULL;
@@ -899,7 +837,6 @@ out:
 static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 {
 	struct menelaus_chip *m = _menelaus;
-	void (*handler)(struct menelaus_chip *m);
 	unsigned long isr;
 	unsigned long i;
 
@@ -909,14 +846,9 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 		& ~m->mask1;
 
 	for_each_set_bit(i, &isr, 16) {
-		mutex_lock(&m->lock);
-		menelaus_disable_irq(m, i);
-		menelaus_ack_irq(m, i);
-		handler = m->handlers[i];
-		if (handler)
-			handler(m);
-		menelaus_enable_irq(m, i);
-		mutex_unlock(&m->lock);
+		int irq = i + m->irq_base;
+
+		handle_nested_irq(irq);
 	}
 
 	return IRQ_HANDLED;
@@ -1131,18 +1063,19 @@ static int menelaus_set_alarm(struct device *dev, struct rtc_wkalrm *w)
 
 #ifdef CONFIG_RTC_INTF_DEV
 
-static void menelaus_rtc_update_work(struct menelaus_chip *m)
+static irqreturn_t menelaus_rtc_update_irq(int irq, void *_m)
 {
-	/* report 1/sec update */
-	local_irq_disable();
+	struct menelaus_chip *m = _m;
+
 	rtc_update_irq(m->rtc, 1, RTC_IRQF | RTC_UF);
-	local_irq_enable();
+
+	return IRQ_HANDLED;
 }
 
 static int menelaus_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
 {
 	struct menelaus_chip *m = dev_get_drvdata(dev);
-	int	status;
+	int	status = 0;
 
 	if (m->client->irq <= 0)
 		return -ENOIOCTLCMD;
@@ -1163,18 +1096,18 @@ static int menelaus_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
 	case RTC_UIE_ON:
 		if (m->uie)
 			return 0;
-		status = menelaus_remove_irq_work(m, MENELAUS_RTCTMR_IRQ);
-		status = menelaus_add_irq_work(m, MENELAUS_RTCTMR_IRQ,
-				menelaus_rtc_update_work);
+		free_irq(MENELAUS_RTCTMR_IRQ + m->irq_base, m);
+		status = request_threaded_irq(MENELAUS_RTCTMR_IRQ + m->irq_base,
+				NULL, menelaus_rtc_update_irq, IRQF_ONESHOT,
+				"rtc-timer", m);
 		if (status == 0)
 			m->uie = 1;
 		return status;
 	case RTC_UIE_OFF:
 		if (!m->uie)
 			return 0;
-		status = menelaus_remove_irq_work(m, MENELAUS_RTCTMR_IRQ);
-		if (status == 0)
-			m->uie = 0;
+		free_irq(MENELAUS_RTCTMR_IRQ + m->irq_base, m);
+		m->uie = 0;
 		return status;
 	default:
 		return -ENOIOCTLCMD;
@@ -1196,16 +1129,18 @@ static const struct rtc_class_ops menelaus_rtc_ops = {
 	.set_alarm		= menelaus_set_alarm,
 };
 
-static void menelaus_rtc_alarm_work(struct menelaus_chip *m)
+static irqreturn_t menelaus_rtc_alarm_irq(int irq, void *_m)
 {
+	struct menelaus_chip *m = _m;
+
 	/* report alarm */
-	local_irq_disable();
 	rtc_update_irq(m->rtc, 1, RTC_IRQF | RTC_AF);
-	local_irq_enable();
 
 	/* then disable it; alarms are oneshot */
 	m->rtc_control &= ~RTC_CTRL_AL_EN;
 	menelaus_write_reg(m, MENELAUS_RTC_CTRL, m->rtc_control);
+
+	return IRQ_HANDLED;
 }
 
 static inline void menelaus_rtc_init(struct menelaus_chip *m)
@@ -1220,8 +1155,12 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 
 	/* support RTC alarm; it can issue wakeups */
 	if (alarm) {
-		if (menelaus_add_irq_work(m, MENELAUS_RTCALM_IRQ,
-				menelaus_rtc_alarm_work) < 0) {
+		int ret;
+
+		ret = request_threaded_irq(MENELAUS_RTCALM_IRQ + m->irq_base,
+				NULL, menelaus_rtc_alarm_irq, IRQF_ONESHOT,
+				"rtc-alarm", m);
+		if (ret < 0) {
 			dev_err(&m->client->dev, "can't handle RTC alarm\n");
 			return;
 		}
@@ -1247,7 +1186,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 			&menelaus_rtc_ops, THIS_MODULE);
 	if (IS_ERR(m->rtc)) {
 		if (alarm) {
-			menelaus_remove_irq_work(m, MENELAUS_RTCALM_IRQ);
+			free_irq(MENELAUS_RTCALM_IRQ + m->irq_base, m);
 			device_init_wakeup(&m->client->dev, 0);
 		}
 		dev_err(&m->client->dev, "can't register RTC: %d\n",
-- 
1.8.4.GIT

