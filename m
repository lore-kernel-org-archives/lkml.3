Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaLVQ3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:29:50 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29847 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaLVQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:54 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-84-549846c4e9be
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 6/8] hwmon: thermal: Extract __set_pwm() function to only
 modify PWM duty cycle
Date: Mon, 22 Dec 2014 17:27:46 +0100
Message-id: <1419265668-32283-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd0jbjNCDNZOVLV4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsniy
	8AyTxZ1pe9ksDr9pZ3Xg99g56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7F
	ZZOSmpNZllqkb5fAldH6czprwR3+ikUnz7E0MB7n6WLk5JAQMJFYuLyRDcIWk7hwbz2YLSSw
	iFGiY7N1FyMXkN3FJNH0aSZYgk1AT+Lz3adMIAkRgRmMEvubvrGDOMwCV5glvp1qZOli5OAQ
	FkiRWPojE6SBRUBVouHEUnYQm1fATeL80k2MENsUJbqfTWADKecUcJf4/YoXYlkzo8SpBY3M
	Exh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDtpn0jsYVzVYHGIU4GBU4uHlTJse
	IsSaWFZcmXuIUYKDWUmE96rljBAh3pTEyqrUovz4otKc1OJDjNIcLErivEr2bSFCAumJJanZ
	qakFqUUwWSYOTqkGxuR09++qa2p2J5iYGdbXvj+/JG15ytYzW100TvY+U+E+b3zD6sY2ycq3
	htMfKhpM2iN0be7CP+oi21pfs0TrlgveEjv1yufQc92C9n1n3M60veavE2bbbryqrMbpZ7RG
	9+ovEzwDtVbliT/uLbi6YrVMX9LDDazvgzl9zFdP5ZLN8Dn7UJzzqRJLcUaioRZzUXEiAATo
	kXBWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was necessary to decouple code handling writing to sysfs from the one
responsible for setting PWM of the fan.
Due to that, new __set_pwm() method was extracted, which is responsible for
only setting new PWM duty cycle.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- None
---
 drivers/hwmon/pwm-fan.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 1991d903..870e100 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -33,21 +33,15 @@ struct pwm_fan_ctx {
 	unsigned char pwm_value;
 };
 
-static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
-		       const char *buf, size_t count)
+static int  __set_pwm(struct pwm_fan_ctx *ctx, unsigned long pwm)
 {
-	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
-	unsigned long pwm, duty;
-	ssize_t ret;
-
-	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
-		return -EINVAL;
-
-	mutex_lock(&ctx->lock);
+	unsigned long duty;
+	int ret;
 
 	if (ctx->pwm_value == pwm)
-		goto exit_set_pwm_no_change;
+		return 0;
 
+	mutex_lock(&ctx->lock);
 	if (pwm == 0) {
 		pwm_disable(ctx->pwm);
 		goto exit_set_pwm;
@@ -66,13 +60,28 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 
 exit_set_pwm:
 	ctx->pwm_value = pwm;
-exit_set_pwm_no_change:
-	ret = count;
 exit_set_pwm_err:
 	mutex_unlock(&ctx->lock);
 	return ret;
 }
 
+static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+	unsigned long pwm;
+	int ret;
+
+	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
+		return -EINVAL;
+
+	ret = __set_pwm(ctx, pwm);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
 static ssize_t show_pwm(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-- 
2.0.0.rc2

