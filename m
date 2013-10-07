Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3JGG4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:56:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3JGGz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:55:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 03/11] PNP: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:42 -0700
Message-Id: <1381128950-28125-4-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the PNP bus code to use the
correct field.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Rafael, I can take this through my driver-core tree if you like, just let
me know what would be the easiest for you.

 drivers/pnp/base.h      |  2 +-
 drivers/pnp/driver.c    |  2 +-
 drivers/pnp/interface.c | 43 ++++++++++++++++++++++++++-----------------
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index ffd53e3..c8873b0 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -4,7 +4,7 @@
  */
 
 extern spinlock_t pnp_lock;
-extern struct device_attribute pnp_interface_attrs[];
+extern const struct attribute_group *pnp_dev_groups[];
 void *pnp_alloc(long size);
 
 int pnp_register_protocol(struct pnp_protocol *protocol);
diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index a39ee38..6936e0a 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -246,7 +246,7 @@ struct bus_type pnp_bus_type = {
 	.remove  = pnp_device_remove,
 	.shutdown = pnp_device_shutdown,
 	.pm	 = &pnp_bus_dev_pm_ops,
-	.dev_attrs = pnp_interface_attrs,
+	.dev_groups = pnp_dev_groups,
 };
 
 int pnp_register_driver(struct pnp_driver *drv)
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index 0c20131..e6c403b 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -203,8 +203,8 @@ static void pnp_print_option(pnp_info_buffer_t * buffer, char *space,
 	}
 }
 
-static ssize_t pnp_show_options(struct device *dmdev,
-				struct device_attribute *attr, char *buf)
+static ssize_t options_show(struct device *dmdev, struct device_attribute *attr,
+			    char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	pnp_info_buffer_t *buffer;
@@ -241,10 +241,10 @@ static ssize_t pnp_show_options(struct device *dmdev,
 	kfree(buffer);
 	return ret;
 }
+static DEVICE_ATTR_RO(options);
 
-static ssize_t pnp_show_current_resources(struct device *dmdev,
-					  struct device_attribute *attr,
-					  char *buf)
+static ssize_t resources_show(struct device *dmdev,
+			      struct device_attribute *attr, char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	pnp_info_buffer_t *buffer;
@@ -331,9 +331,9 @@ static char *pnp_get_resource_value(char *buf,
 	return buf;
 }
 
-static ssize_t pnp_set_current_resources(struct device *dmdev,
-					 struct device_attribute *attr,
-					 const char *ubuf, size_t count)
+static ssize_t resources_store(struct device *dmdev,
+			       struct device_attribute *attr, const char *ubuf,
+			       size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;
@@ -434,9 +434,10 @@ done:
 		return retval;
 	return count;
 }
+static DEVICE_ATTR_RW(resources);
 
-static ssize_t pnp_show_current_ids(struct device *dmdev,
-				    struct device_attribute *attr, char *buf)
+static ssize_t id_show(struct device *dmdev, struct device_attribute *attr,
+		       char *buf)
 {
 	char *str = buf;
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
@@ -448,12 +449,20 @@ static ssize_t pnp_show_current_ids(struct device *dmdev,
 	}
 	return (str - buf);
 }
+static DEVICE_ATTR_RO(id);
 
-struct device_attribute pnp_interface_attrs[] = {
-	__ATTR(resources, S_IRUGO | S_IWUSR,
-		   pnp_show_current_resources,
-		   pnp_set_current_resources),
-	__ATTR(options, S_IRUGO, pnp_show_options, NULL),
-	__ATTR(id, S_IRUGO, pnp_show_current_ids, NULL),
-	__ATTR_NULL,
+static struct attribute *pnp_dev_attrs[] = {
+	&dev_attr_resources.attr,
+	&dev_attr_options.attr,
+	&dev_attr_id.attr,
+	NULL,
+};
+
+static const struct attribute_group pnp_dev_group = {
+	.attrs = pnp_dev_attrs,
+};
+
+const struct attribute_group *pnp_dev_groups[] = {
+	&pnp_dev_group,
+	NULL,
 };
-- 
1.8.4.6.g82e253f.dirty

