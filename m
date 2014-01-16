Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaAPEbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:31:44 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45765 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaAPEbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:31:42 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 04/15] w1: increase w1_max_slave_count, allow write access
Date: Wed, 15 Jan 2014 22:29:15 -0600
Message-Id: <1389846566-28862-5-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:31:35 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1_max_slave_count is only used to abort the search early
or take a fast search (when 1), so there isn't any reason to not allow
it to be updated through sysfs.  Memory is not allocated based on
the current value and 10 is a rather low base number, increasing to
64, and printing a message the first time the count is reached and
there were more devices to discover to let the user know why not
all the devices were found.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.c |   30 ++++++++++++++++++++++++++++--
 drivers/w1/w1.h |    2 ++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 92766a9..34ffdc6 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -46,7 +46,7 @@ MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol.");
 
 static int w1_timeout = 10;
-int w1_max_slave_count = 10;
+int w1_max_slave_count = 64;
 int w1_max_slave_ttl = 10;
 
 module_param_named(timeout, w1_timeout, int, 0);
@@ -316,6 +316,24 @@ static ssize_t w1_master_attribute_show_timeout(struct device *dev, struct devic
 	return count;
 }
 
+static ssize_t w1_master_attribute_store_max_slave_count(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	long tmp;
+	struct w1_master *md = dev_to_w1_master(dev);
+
+	if (kstrtol(buf, 0, &tmp) == -EINVAL || tmp < 1)
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	md->max_slave_count = tmp;
+	/* allow each time the max_slave_count is updated */
+	clear_bit(W1_WARN_MAX_COUNT, &md->flags);
+	mutex_unlock(&md->mutex);
+
+	return count;
+}
+
 static ssize_t w1_master_attribute_show_max_slave_count(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct w1_master *md = dev_to_w1_master(dev);
@@ -518,7 +536,7 @@ static ssize_t w1_master_attribute_store_remove(struct device *dev,
 static W1_MASTER_ATTR_RO(name, S_IRUGO);
 static W1_MASTER_ATTR_RO(slaves, S_IRUGO);
 static W1_MASTER_ATTR_RO(slave_count, S_IRUGO);
-static W1_MASTER_ATTR_RO(max_slave_count, S_IRUGO);
+static W1_MASTER_ATTR_RW(max_slave_count, S_IRUGO | S_IWUSR | S_IWGRP);
 static W1_MASTER_ATTR_RO(attempts, S_IRUGO);
 static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
@@ -976,6 +994,14 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			desc_bit = last_zero;
 			cb(dev, rn);
 		}
+
+		if (!last_device && slave_count == dev->max_slave_count &&
+			!test_bit(W1_WARN_MAX_COUNT, &dev->flags)) {
+			dev_info(&dev->dev, "%s: max_slave_count %d reached, "
+				"additional sensors ignored\n", __func__,
+				dev->max_slave_count);
+			set_bit(W1_WARN_MAX_COUNT, &dev->flags);
+		}
 	}
 }
 
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index bc329d2..bd10b3c 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -158,9 +158,11 @@ struct w1_bus_master
 /**
  * enum w1_master_flags - bitfields used in w1_master.flags
  * @W1_ABORT_SEARCH: abort searching early on shutdown
+ * @W1_WARN_MAX_COUNT: limit warning when the maximum count is reached
  */
 enum w1_master_flags {
 	W1_ABORT_SEARCH = 0,
+	W1_WARN_MAX_COUNT = 1,
 };
 
 struct w1_master
-- 
1.7.10.4

