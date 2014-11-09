Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaKIL4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:56:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59356 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaKIL4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:56:39 -0500
Date: Sun, 9 Nov 2014 12:56:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, B38611@freescale.com,
        jg1.han@samsung.com, linux-input@vger.kernel.org
Subject: tsc2005 touchscreen: implement disable attribute
Message-ID: <20141109115636.GA3106@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement disable attribute for tsc2005 touchscreen. It is useful to
avoid wakeups when phone is in the pocket.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

[This is from Pali's n900 tree that is GPL, so that is okay, but maybe
I should get his sign-off here?]

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 52380b6..ec1c276 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -147,6 +147,7 @@ struct tsc2005 {
 
 	unsigned int		x_plate_ohm;
 
+	bool			disabled;
 	bool			opened;
 	bool			suspended;
 
@@ -384,6 +385,48 @@ static void __tsc2005_enable(struct tsc2005 *ts)
 
 }
 
+static ssize_t tsc2005_disable_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct tsc2005 *ts = spi_get_drvdata(spi);
+
+	return sprintf(buf, "%u\n", ts->disabled);
+}
+
+static ssize_t tsc2005_disable_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct tsc2005 *ts = spi_get_drvdata(spi);
+	unsigned long val;
+	int error;
+
+	error = kstrtoul(buf, 10, &val);
+	if (error)
+		return error;
+
+	mutex_lock(&ts->mutex);
+
+	if (!ts->suspended && ts->opened) {
+		if (val) {
+			if (!ts->disabled)
+				__tsc2005_disable(ts);
+		} else {
+			if (ts->disabled)
+				__tsc2005_enable(ts);
+		}
+	}
+
+	ts->disabled = !!val;
+
+	mutex_unlock(&ts->mutex);
+
+	return count;
+}
+static DEVICE_ATTR(disable, 0664, tsc2005_disable_show, tsc2005_disable_store);
+
 static ssize_t tsc2005_selftest_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
@@ -466,6 +509,7 @@ out:
 static DEVICE_ATTR(selftest, S_IRUGO, tsc2005_selftest_show, NULL);
 
 static struct attribute *tsc2005_attrs[] = {
+	&dev_attr_disable.attr,
 	&dev_attr_selftest.attr,
 	NULL
 };
@@ -551,7 +595,7 @@ static int tsc2005_open(struct input_dev *input)
 
 	mutex_lock(&ts->mutex);
 
-	if (!ts->suspended)
+	if (!ts->suspended && !ts->disabled)
 		__tsc2005_enable(ts);
 
 	ts->opened = true;
@@ -567,7 +611,7 @@ static void tsc2005_close(struct input_dev *input)
 
 	mutex_lock(&ts->mutex);
 
-	if (!ts->suspended)
+	if (!ts->suspended && !ts->disabled)
 		__tsc2005_disable(ts);
 
 	ts->opened = false;
@@ -781,7 +825,7 @@ static int tsc2005_suspend(struct device *dev)
 
 	mutex_lock(&ts->mutex);
 
-	if (!ts->suspended && ts->opened)
+	if (!ts->suspended && !ts->disabled && ts->opened)
 		__tsc2005_disable(ts);
 
 	ts->suspended = true;
@@ -798,7 +842,7 @@ static int tsc2005_resume(struct device *dev)
 
 	mutex_lock(&ts->mutex);
 
-	if (ts->suspended && ts->opened)
+	if (ts->suspended && !ts->disabled && ts->opened)
 		__tsc2005_enable(ts);
 
 	ts->suspended = false;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
