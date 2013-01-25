Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3AYNoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:44:46 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:49743 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756715Ab3AYNom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:44:42 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
Date: Fri, 25 Jan 2013 14:44:29 +0100
Message-Id: <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch>
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calls to some external PWM chips can sleep. To help users,
add pwm_cansleep() API.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/pwm/core.c  |   12 ++++++++++++
 include/linux/pwm.h |   10 ++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 4a13da4..e737f5f 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -763,6 +763,18 @@ void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
 }
 EXPORT_SYMBOL_GPL(devm_pwm_put);
 
+/**
+  * pwm_cansleep() - report whether pwm access will sleep
+  * @pwm: PWM device
+  *
+  * It returns nonzero if accessing the PWM can sleep.
+  */
+int pwm_cansleep(struct pwm_device *pwm)
+{
+	return pwm->chip->can_sleep;
+}
+EXPORT_SYMBOL_GPL(pwm_cansleep);
+
 #ifdef CONFIG_DEBUG_FS
 static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
 {
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 70655a2..e2cb5c7 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -146,6 +146,8 @@ struct pwm_ops {
  * @base: number of first PWM controlled by this chip
  * @npwm: number of PWMs controlled by this chip
  * @pwms: array of PWM devices allocated by the framework
+ * @can_sleep: flag must be set iff config()/enable()/disable() methods sleep,
+ *      as they must while accessing PWM chips over I2C or SPI
  */
 struct pwm_chip {
 	struct device		*dev;
@@ -159,6 +161,7 @@ struct pwm_chip {
 	struct pwm_device *	(*of_xlate)(struct pwm_chip *pc,
 					    const struct of_phandle_args *args);
 	unsigned int		of_pwm_n_cells;
+	unsigned int		can_sleep:1;
 };
 
 #if IS_ENABLED(CONFIG_PWM)
@@ -182,6 +185,8 @@ struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id);
 struct pwm_device *devm_of_pwm_get(struct device *dev, struct device_node *np,
 				   const char *con_id);
 void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
+
+int pwm_cansleep(struct pwm_device *pwm);
 #else
 static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
 {
@@ -242,6 +247,11 @@ static inline struct pwm_device *devm_of_pwm_get(struct device *dev,
 static inline void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
 {
 }
+
+static inline int pwm_cansleep(struct pwm_device *pwm)
+{
+	return 0;
+}
 #endif
 
 struct pwm_lookup {
-- 
1.7.5.4

