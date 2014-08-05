Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaHEPM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:12:59 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54980 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbaHEPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:12:54 -0400
From: Aurelio Colosimo <aurelio.colosimo@gmail.com>
X-Google-Original-From: Aurelio Colosimo <aurelio@aureliocolosimo.it>
To: Thierry Reding <thierry.reding@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Aurelio Colosimo <aurelio@aureliocolosimo.it>
Subject: [PATCH 2/2] pwm: new fields, max and resolution, added to sysfs
Date: Tue,  5 Aug 2014 17:12:18 +0200
Message-Id: <1407251538-17566-3-git-send-email-aurelio@aureliocolosimo.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407251538-17566-1-git-send-email-aurelio@aureliocolosimo.it>
References: <1407251538-17566-1-git-send-email-aurelio@aureliocolosimo.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max is the maximum number of nanoseconds accepted as duty or period by a
certain device. resolution is the minimum step actually handled by the
hardware output.

This couple of attributes permit users:
1) to know the capabilities of the pwm output;
2) to set a really supported value (by using of resolution, a precise
computation is possible);
3) to avoid them setting invalid (too big) periods.

A default value of resolution=1 and max=MAX_INT is provided in this
patch, but driver maintainers are encouraged to properly fill the new
fields in struct pwm_device.

Signed-off-by: Aurelio Colosimo <aurelio@aureliocolosimo.it>
---
 Documentation/pwm.txt |  7 +++++++
 drivers/pwm/core.c    |  2 ++
 drivers/pwm/sysfs.c   | 22 ++++++++++++++++++++++
 include/linux/pwm.h   |  2 ++
 4 files changed, 33 insertions(+)

diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
index ca895fd..dbb1a16 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.txt
@@ -74,6 +74,13 @@ period - The total period of the PWM signal (read/write).
 duty_cycle - The active time of the PWM signal (read/write).
 	Value is in nanoseconds and must be less than the period.
 
+resolution - The resolution of duty_cycle and period.
+	Value is in nanoseconds and is the min step period and duty can
+	change.
+
+max      - The max value for period.
+	Value is in nanoseconds.
+
 polarity - Changes the polarity of the PWM signal (read/write).
 	Writes to this property only work if the PWM chip supports changing
 	the polarity. The polarity can only be changed if the PWM is not
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 4b66bf0..d973ed7 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -259,6 +259,8 @@ int pwmchip_add(struct pwm_chip *chip)
 		pwm->chip = chip;
 		pwm->pwm = chip->base + i;
 		pwm->hwpwm = i;
+		pwm->resolution = 1;
+		pwm->max = UINT_MAX;
 
 		radix_tree_insert(&pwm_tree, pwm->pwm, pwm);
 	}
diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
index c1d6064..1bb77e2 100644
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -157,16 +157,38 @@ static ssize_t pwm_polarity_store(struct device *child,
 	return ret ? : size;
 }
 
+static ssize_t pwm_resolution_show(struct device *child,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	const struct pwm_device *pwm = child_to_pwm_device(child);
+
+	return sprintf(buf, "%u\n", pwm->resolution);
+}
+
+static ssize_t pwm_max_show(struct device *child,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	const struct pwm_device *pwm = child_to_pwm_device(child);
+
+	return sprintf(buf, "%u\n", pwm->max);
+}
+
 static DEVICE_ATTR(period, 0644, pwm_period_show, pwm_period_store);
 static DEVICE_ATTR(duty_cycle, 0644, pwm_duty_cycle_show, pwm_duty_cycle_store);
 static DEVICE_ATTR(enable, 0644, pwm_enable_show, pwm_enable_store);
 static DEVICE_ATTR(polarity, 0644, pwm_polarity_show, pwm_polarity_store);
+static DEVICE_ATTR(resolution, 0444, pwm_resolution_show, NULL);
+static DEVICE_ATTR(max, 0444, pwm_max_show, NULL);
 
 static struct attribute *pwm_attrs[] = {
 	&dev_attr_period.attr,
 	&dev_attr_duty_cycle.attr,
 	&dev_attr_enable.attr,
 	&dev_attr_polarity.attr,
+	&dev_attr_resolution.attr,
+	&dev_attr_max.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(pwm);
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 9bacf35..c4cc794 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -90,6 +90,8 @@ struct pwm_device {
 
 	unsigned int		period; 	/* in nanoseconds */
 	unsigned int		duty_cycle;	/* in nanoseconds */
+	unsigned int		resolution;	/* in nanoseconds */
+	unsigned int		max;		/* in nanoseconds */
 	enum pwm_polarity	polarity;
 };
 
-- 
1.9.1

