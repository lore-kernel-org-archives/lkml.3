Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbbAFOdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:33:49 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61157 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbbAFOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:33:46 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] w1: slaves: w1_therm: Add temp attribute
Date: Tue,  6 Jan 2015 15:29:56 +0100
Message-Id: <1420554596-10250-3-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new attribute to simplify reading of current temperature.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/w1/slaves/w1_therm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 3bad3d6..65af193 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -76,10 +76,15 @@ static void w1_therm_remove_slave(struct w1_slave *sl)
 static ssize_t w1_slave_show(struct device *device,
 	struct device_attribute *attr, char *buf);
 
+static ssize_t temp_show(struct device *device,
+	struct device_attribute *attr, char *buf);
+
 static DEVICE_ATTR_RO(w1_slave);
+static DEVICE_ATTR_RO(temp);
 
 static struct attribute *w1_therm_attrs[] = {
 	&dev_attr_w1_slave.attr,
+	&dev_attr_temp.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(w1_therm);
@@ -299,6 +304,33 @@ static ssize_t w1_slave_show(struct device *device,
 	return PAGE_SIZE - c;
 }
 
+static ssize_t temp_show(struct device *device,
+	struct device_attribute *attr, char *buf)
+{
+	struct w1_slave *sl = dev_to_w1_slave(device);
+	struct w1_master *dev = sl->master;
+	u8 rom[9], verdict;
+	int temp;
+
+	if (mutex_lock_interruptible(&dev->bus_mutex))
+		return -EINTR;
+
+	memset(rom, 0, sizeof(rom));
+
+	verdict = read_rom(device, rom);
+
+	if (verdict < 0)
+		return verdict;
+
+	mutex_unlock(&dev->bus_mutex);
+
+	if (!verdict)
+		return -EIO;
+
+	temp = w1_convert_temp(rom, sl->family->fid);
+	return snprintf(buf, PAGE_SIZE, "%d\n", temp);
+}
+
 static int __init w1_therm_init(void)
 {
 	int err, i;
-- 
2.2.1

