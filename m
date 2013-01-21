Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3AUMEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:52 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57192 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3AUMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/24] abx500-chargalg: Add new sysfs interface to get current charge status
Date: Mon, 21 Jan 2013 12:03:49 +0000
Message-Id: <1358769840-4763-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a user to check on AB8500 charging status from debugfs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c  |    3 +++
 drivers/power/abx500_chargalg.c |   22 +++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 0483e7c..d834566 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2764,6 +2764,9 @@ static int ab8500_charger_usb_notifier_call(struct notifier_block *nb,
 	enum ab8500_usb_state bm_usb_state;
 	unsigned mA = *((unsigned *)power);
 
+	if (!di)
+		return NOTIFY_DONE;
+
 	if (event != USB_EVENT_VBUS) {
 		dev_dbg(di->dev, "not a standard host, returning\n");
 		return NOTIFY_DONE;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 7defb3e..694f592 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1654,6 +1654,25 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 /* Exposure to the sysfs interface */
 
 /**
+ * ab8500_chargalg_sysfs_show() - sysfs show operations
+ * @kobj:      pointer to the struct kobject
+ * @attr:      pointer to the struct attribute
+ * @buf:       buffer that holds the parameter to send to userspace
+ *
+ * Returns a buffer to be displayed in user space
+ */
+static ssize_t ab8500_chargalg_sysfs_show(struct kobject *kobj,
+					  struct attribute *attr, char *buf)
+{
+	struct ab8500_chargalg *di = container_of(kobj,
+               struct ab8500_chargalg, chargalg_kobject);
+
+	return sprintf(buf, "%d\n",
+		       di->susp_status.ac_suspended &&
+		       di->susp_status.usb_suspended);
+}
+
+/**
  * abx500_chargalg_sysfs_charger() - sysfs store operations
  * @kobj:      pointer to the struct kobject
  * @attr:      pointer to the struct attribute
@@ -1721,7 +1740,7 @@ static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
 static struct attribute abx500_chargalg_en_charger = \
 {
 	.name = "chargalg",
-	.mode = S_IWUSR,
+	.mode = S_IRUGO | S_IWUSR,
 };
 
 static struct attribute *abx500_chargalg_chg[] = {
@@ -1730,6 +1749,7 @@ static struct attribute *abx500_chargalg_chg[] = {
 };
 
 static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
+	.show = ab8500_chargalg_sysfs_show,
 	.store = abx500_chargalg_sysfs_charger,
 };
 
-- 
1.7.9.5

