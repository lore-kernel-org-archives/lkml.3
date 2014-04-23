Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaDWBZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:25:33 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:54950 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaDWBZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:25:30 -0400
Message-ID: <53571685.5060403@gmail.com>
Date: Tue, 22 Apr 2014 18:25:25 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Rob Herring <robh+dt@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH] sysfs, device-tree: aid for debugging device tree boot problems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create some infrastructure to aid trouble shooting device tree related
boot issues.

Add a %driver_name file to each device tree node sysfs directory which has had
a driver bound to it.  This allows detecting device tree nodes which failed
to be bound to any driver.

Examples of using the %driver_name file (note that /proc/device-tree is a
link to the base of the device tree sysfs tree):


  1) To find list of device tree nodes with no driver:

  # A few false positives may be reported.  For example,
  #   node_full_path of "." is the board.
  #
  # output is: node_full_path compatible_string
  #
  cd /proc/device-tree
  for k in `find . -type d`; do
     if [[ -f ${k}/compatible && ! -f ${k}/%driver_name ]] ; then
        if [[ "`cat ${k}/compatible`" != "simple-bus" ]] ; then
           echo `echo ${k} | sed -e 's|./||'` `cat ${k}/compatible`
        fi
     fi
  done | sort


  2) To find list of device tree nodes with a bound driver:

  # output is:  node_full_path driver_name
  #
  cd /proc/device-tree
  for k in `find . -name %driver_name` ; do
     echo `echo ${k} | sed -e 's|./||' -e 's|/%driver_name$||'` `cat ${k}`
  done | sort


  3) To find list of device tree nodes with a bound driver:

  # output is:  driver_name node_full_path
  #
  cd /proc/device-tree
  for k in `find . -name %driver_name` ; do
     echo `cat ${k}` `echo ${k} | sed -e 's|./||' -e 's|/%driver_name$||'`
  done | sort


Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---

 Documentation/ABI/testing/sysfs-firmware-ofw |   17 +++++++-
 drivers/base/dd.c                            |    5 ++
 drivers/of/base.c                            |   55 +++++++++++++++++++++++++++
 include/linux/of.h                           |    9 ++++
 4 files changed, 85 insertions(+), 1 deletion(-)

Index: b/drivers/base/dd.c
===================================================================
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/async.h>
+#include <linux/of.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
 
@@ -194,6 +195,8 @@ static void driver_bound(struct device *
 
 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 
+	of_notify_driver_bound(dev);
+
 	/*
 	 * Make sure the device is no longer in one of the deferred lists and
 	 * kick off retrying all pending devices
@@ -505,6 +508,8 @@ static void __device_release_driver(stru
 
 		pm_runtime_put_sync(dev);
 
+		of_notify_driver_released(dev);
+
 		if (dev->bus && dev->bus->remove)
 			dev->bus->remove(dev);
 		else if (drv->remove)
Index: b/drivers/of/base.c
===================================================================
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -19,6 +19,7 @@
  */
 #include <linux/ctype.h>
 #include <linux/cpu.h>
+#include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
@@ -168,7 +169,61 @@ static void of_node_release(struct kobje
 }
 #endif /* CONFIG_OF_DYNAMIC */
 
+static ssize_t driver_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%s\n", dev->driver->name);
+}
+
+static const struct device_attribute of_driver_attr =
+	__ATTR(%driver_name, S_IRUGO, driver_show, NULL);
+
+void of_notify_driver_bound(struct device *dev)
+{
+	int err;
+
+	if (dev->of_node) {
+		dev->of_node->bound_dev = dev;
+		err = sysfs_create_file(&dev->of_node->kobj, &of_driver_attr.attr);
+	}
+
+}
+
+void of_notify_driver_released(struct device *dev)
+{
+	if (dev->of_node) {
+		sysfs_remove_file(&dev->of_node->kobj, &of_driver_attr.attr);
+		dev->of_node->bound_dev = NULL;
+	}
+}
+
+#define to_dev_attr(_attr) container_of(_attr, struct device_attribute, attr)
+
+static ssize_t of_node_attr_show(struct kobject *kobj, struct attribute *attr,
+				 char *buf)
+{
+	struct device_attribute *dev_attr = to_dev_attr(attr);
+	struct device_node *np = container_of(kobj, struct device_node, kobj);
+	struct device *dev = np->bound_dev;
+
+	ssize_t ret = -EIO;
+
+	if (dev_attr->show)
+		ret = dev_attr->show(dev, dev_attr, buf);
+	if (ret >= (ssize_t)PAGE_SIZE) {
+		print_symbol("dev_attr_show: %s returned bad count\n",
+			(unsigned long)dev_attr->show);
+	}
+	return ret;
+}
+
+
+static const struct sysfs_ops of_node_sysfs_ops = {
+	.show	= of_node_attr_show,
+};
+
 struct kobj_type of_node_ktype = {
+	.sysfs_ops = &of_node_sysfs_ops,
 	.release = of_node_release,
 };
 
Index: b/include/linux/of.h
===================================================================
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -60,6 +60,7 @@ struct device_node {
 	struct	kobject kobj;
 	unsigned long _flags;
 	void	*data;
+	struct device *bound_dev;
 #if defined(CONFIG_SPARC)
 	const char *path_component_name;
 	unsigned int unique_id;
@@ -347,6 +348,9 @@ const char *of_prop_next_string(struct p
 
 int of_device_is_stdout_path(struct device_node *dn);
 
+void of_notify_driver_bound(struct device *dev);
+void of_notify_driver_released(struct device *dev);
+
 #else /* CONFIG_OF */
 
 static inline const char* of_node_full_name(struct device_node *np)
@@ -571,6 +575,11 @@ static inline const char *of_prop_next_s
 
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
+
+void of_notify_driver_bound(struct device *dev) { }
+
+void of_notify_driver_released(struct device *dev) { }
+
 #endif /* CONFIG_OF */
 
 #if defined(CONFIG_OF) && defined(CONFIG_NUMA)
Index: b/Documentation/ABI/testing/sysfs-firmware-ofw
===================================================================
--- a/Documentation/ABI/testing/sysfs-firmware-ofw
+++ b/Documentation/ABI/testing/sysfs-firmware-ofw
@@ -25,4 +25,19 @@ Description:
 		directory name is the resolved path component name (node
 		name plus address). Properties are represented as files
 		in the directory. The contents of each file is the exact
-		binary data from the device tree.
+		binary data from the device tree.  Files that are exceptions
+		to this description will be described separately in this file.
+
+What:		/sys/firmware/devicetree/.../%driver_name
+Date:		April 2014
+KernelVersion:  3.15
+Contact:	Frank Rowand <frank.rowand@sonymobile.com>
+Description:
+		This file does not represent a device tree property.  The file
+		will exist only if a driver is bound to the device tree node.
+		Reading from this file returns the name of the driver.
+
+		The apparently bizarre choice of prefixing the file name with
+		"%" is to avoid any possible conflict with a valid device tree
+		property name.  ePAPR version 1.1 does not allow a property
+		name to contain the character "%".
