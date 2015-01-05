Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbbAEBNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:13:34 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45347 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbbAEBNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:13:30 -0500
From: Tim Kryger <tim.kryger@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        Jonathan Richardson <jonathar@broadcom.com>
Cc: Tim Kryger <tim.kryger@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Linux PWM <linux-pwm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 1/2] drivers: pwm: core: Add pwmchip_add_inversed
Date: Sun,  4 Jan 2015 17:12:55 -0800
Message-Id: <1420420376-13087-2-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420420376-13087-1-git-send-email-tim.kryger@gmail.com>
References: <1420420376-13087-1-git-send-email-tim.kryger@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to register a PWM chip with channels that have their
initial polarity as inversed.  This benefits drivers of controllers that
by default operate with inversed polarity by removing the need to modify
the polarity during initialization.

Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
---
 drivers/pwm/core.c  | 36 ++++++++++++++++++++++++++++--------
 include/linux/pwm.h |  6 ++++++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 966497d..f28c4ce 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -222,14 +222,8 @@ void *pwm_get_chip_data(struct pwm_device *pwm)
 }
 EXPORT_SYMBOL_GPL(pwm_get_chip_data);
 
-/**
- * pwmchip_add() - register a new PWM chip
- * @chip: the PWM chip to add
- *
- * Register a new PWM chip. If chip->base < 0 then a dynamically assigned base
- * will be used.
- */
-int pwmchip_add(struct pwm_chip *chip)
+static int pwmchip_add_with_polarity(struct pwm_chip *chip,
+				     enum pwm_polarity polarity)
 {
 	struct pwm_device *pwm;
 	unsigned int i;
@@ -259,6 +253,7 @@ int pwmchip_add(struct pwm_chip *chip)
 		pwm->chip = chip;
 		pwm->pwm = chip->base + i;
 		pwm->hwpwm = i;
+		pwm->polarity = polarity;
 
 		radix_tree_insert(&pwm_tree, pwm->pwm, pwm);
 	}
@@ -279,9 +274,34 @@ out:
 	mutex_unlock(&pwm_lock);
 	return ret;
 }
+
+/**
+ * pwmchip_add() - register a new PWM chip
+ * @chip: the PWM chip to add
+ *
+ * Register a new PWM chip. If chip->base < 0 then a dynamically assigned base
+ * will be used.  The initial polarity for all channels is normal.
+ */
+int pwmchip_add(struct pwm_chip *chip)
+{
+	return pwmchip_add_with_polarity(chip, PWM_POLARITY_NORMAL);
+}
 EXPORT_SYMBOL_GPL(pwmchip_add);
 
 /**
+ * pwmchip_add_inversed() - register a new PWM chip
+ * @chip: the PWM chip to add
+ *
+ * Register a new PWM chip. If chip->base < 0 then a dynamically assigned base
+ * will be used.  The initial polarity for all channels is inversed.
+ */
+int pwmchip_add_inversed(struct pwm_chip *chip)
+{
+	return pwmchip_add_with_polarity(chip, PWM_POLARITY_INVERSED);
+}
+EXPORT_SYMBOL_GPL(pwmchip_add_inversed);
+
+/**
  * pwmchip_remove() - remove a PWM chip
  * @chip: the PWM chip to remove
  *
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index e90628c..358547f 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -183,6 +183,7 @@ int pwm_set_chip_data(struct pwm_device *pwm, void *data);
 void *pwm_get_chip_data(struct pwm_device *pwm);
 
 int pwmchip_add(struct pwm_chip *chip);
+int pwmchip_add_inversed(struct pwm_chip *chip);
 int pwmchip_remove(struct pwm_chip *chip);
 struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 					 unsigned int index,
@@ -217,6 +218,11 @@ static inline int pwmchip_add(struct pwm_chip *chip)
 	return -EINVAL;
 }
 
+static inline int pwmchip_add_inversed(struct pwm_chip *chip)
+{
+	return -EINVAL;
+}
+
 static inline int pwmchip_remove(struct pwm_chip *chip)
 {
 	return -EINVAL;
-- 
1.9.1

