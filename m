Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaDQSFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:05:32 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46937 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaDQSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:05:23 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Peter Senna <peter.senna@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] backports: transform group attribute backport to SmPL form
Date: Thu, 17 Apr 2014 11:04:50 -0700
Message-Id: <1397757896-32558-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397757896-32558-1-git-send-email-mcgrof@do-not-panic.com>
References: <1397757896-32558-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct attribute_group collateral evolution by Greg and Oliver
was introduced as of v3.11:

mcgrof@ergon ~/linux (git::master)$ git describe --contains f2f37f58b
v3.11-rc2~18^2~9
mcgrof@ergon ~/linux (git::master)$ git describe --contains 3493f69f4
v3.11-rc2~18^2~2

We backport them with our own respective set of helpers. Each new data
structure that gets an attribute group needs a respective SmPL set of
rules for the transformation, specially if they were introduced in
different kernel versions, which in this case we have two which were.
By using SmPL we can automatically backport the collateral evolutions
moving forward for *any* driver that makes use of these group
attributes on both data structure we are addressing in these SmPL
patches. This is a great example of the level of atomicity that we
want to ideally strive to reach for backporting, as it lets us
automatically backport a collateral evolution through grammer for
*any* device driver we backport, and lets us be lazier.

We provided backports of introduction of the group attribute onto
two data structures:

  * struct class: added via commit d05a6f96c
  * struct bus_type: added via commit fa6fdb33b

mcgrof@ergon ~/linux (git::master)$ git describe --contains d05a6f96c
v3.11-rc2~18^2~3

mcgrof@ergon ~/linux (git::master)$ git describe --contains fa6fdb33b
v3.12-rc1~184^2~89

This patch generalizes the backport the introduction of the group
attribute to each data structure into separate SmPL patch files.
One change the SmPL patches pick up on was #ifdef'ing over the
init_foogroup_attrs() calls which would only have been introduced when
ATTRIBUTE_GROUPS_BACKPORT() was used, which *is* #idefd's.

The changes that added the new APIs are below, the respective commits
for each data structure change are documented on each SmPL patch.

commit f2f37f58b1b933b06d6d84e80a31a1b500fb0db2
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sun Jul 14 16:05:52 2013 -0700

    sysfs.h: add ATTRIBUTE_GROUPS() macro

    To make it easier for driver subsystems to work with attribute groups,
    create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
    typing for the most common use for attribute groups.

    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Tested-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 3493f69f4c4e8703961919a9a56c2d2e6a25b46f
Author: Oliver Schinagl <oliver@schinagl.nl>
Date:   Sun Jul 14 16:05:59 2013 -0700

    sysfs: add more helper macro's for (bin_)attribute(_groups)

    With the recent changes to sysfs there's various helper macro's.
    However there's no RW, RO BIN_ helper macro's. This patch adds them.

    Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

mcgrof@drvbp1 ~/backports (git::master)$ time \
	./gentree.py --clean /home/mcgrof/linux-next /home/mcgrof/build/next-20140411
Copy original source files ...
Apply patches ...
Modify Kconfig tree ...
Rewrite Makefiles and Kconfig files ...
Done!

real    1m14.635s
user    5m17.308s
sys     0m39.216s

== ckmake-report.log ==

1   3.0.101             [  OK  ]
2   3.1.10              [  OK  ]
3   3.2.54              [  OK  ]
4   3.3.8               [  OK  ]
5   3.4.79              [  OK  ]
6   3.5.7               [  OK  ]
7   3.6.11              [  OK  ]
8   3.7.10              [  OK  ]
9   3.8.13              [  OK  ]
10  3.9.11              [  OK  ]
11  3.10.29             [  OK  ]
12  3.11.10             [  OK  ]
13  3.12.10             [  OK  ]
14  3.13.2              [  OK  ]
15  3.14-rc1            [  OK  ]

real    28m18.533s
user    785m28.844s
sys     86m25.548s

Cc: Peter Senna <peter.senna@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Schinagl <oliver@schinagl.nl>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 .../0001-group-attr/0001-group_attr_class.cocci    | 78 ++++++++++++++++++++++
 .../0001-group-attr/0002-group_attr_bus.cocci      | 77 +++++++++++++++++++++
 .../generic/0001-group-attr/INFO                   | 40 +++++++++++
 .../generic/0001-sysfs-api/INFO                    | 36 ----------
 .../generic/0001-sysfs-api/drivers_bcma.patch      | 35 ----------
 .../drivers_media_v4l2-core_v4l2-dev.patch         | 35 ----------
 .../generic/0001-sysfs-api/drivers_ssb.patch       | 35 ----------
 .../0001-sysfs-api/net_ieee802154_wpan-class.patch | 35 ----------
 .../0001-sysfs-api/net_wireless_sysfs.patch        | 35 ----------
 9 files changed, 195 insertions(+), 211 deletions(-)
 create mode 100644 patches/collateral-evolutions/generic/0001-group-attr/0001-group_attr_class.cocci
 create mode 100644 patches/collateral-evolutions/generic/0001-group-attr/0002-group_attr_bus.cocci
 create mode 100644 patches/collateral-evolutions/generic/0001-group-attr/INFO
 delete mode 100644 patches/collateral-evolutions/generic/0001-sysfs-api/INFO
 delete mode 100644 patches/collateral-evolutions/generic/0001-sysfs-api/drivers_bcma.patch
 delete mode 100644 patches/collateral-evolutions/generic/0001-sysfs-api/drivers_media_v4l2-core_v4l2-dev.patch
 delete mode 100644 patches/collateral-evolutions/generic/0001-sysfs-api/drivers_ssb.patch
 delete mode 100644 patches/collateral-evolutions/generic/0001-sysfs-api/net_ieee802154_wpan-class.patch
 delete mode 100644 patches/collateral-evolutions/generic/0001-sysfs-api/net_wireless_sysfs.patch

diff --git a/patches/collateral-evolutions/generic/0001-group-attr/0001-group_attr_class.cocci b/patches/collateral-evolutions/generic/0001-group-attr/0001-group_attr_class.cocci
new file mode 100644
index 0000000..fa700f8
--- /dev/null
+++ b/patches/collateral-evolutions/generic/0001-group-attr/0001-group_attr_class.cocci
@@ -0,0 +1,78 @@
+/*
+The new attribute sysfs group was added onto struct class via
+commit d05a6f96c
+
+mcgrof@ergon ~/linux (git::master)$ git describe --contains d05a6f96c
+v3.11-rc2~18^2~3
+
+This backpoort makes use of the helpers to backport this more efficiently.
+Refer to the INFO file for documentation there on that.
+
+commit d05a6f96c76062b5f25858ac02cf677602076f7e
+Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Date:   Sun Jul 14 16:05:58 2013 -0700
+
+    driver core: add default groups to struct class
+
+    We should be using groups, not attribute lists, for classes to allow
+    subdirectories, and soon, binary files.  Groups are just more flexible
+    overall, so add them.
+
+    The dev_attrs list will go away after all in-kernel users are converted
+    to use dev_groups.
+
+    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
+    Tested-by: Guenter Roeck <linux@roeck-us.net>
+    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+*/
+
+@ attribute_group @
+identifier group;
+declarer name ATTRIBUTE_GROUPS;
+@@
+
+ATTRIBUTE_GROUPS(group);
+
+@ class_group depends on attribute_group @
+identifier group_class;
+expression groups;
+fresh identifier group_dev_attr = attribute_group.group ## "_dev_attrs";
+@@
+
+struct class group_class = {
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
+	.dev_groups = groups,
++#else
++	.dev_attrs = group_dev_attr,
++#endif
+};
+
+@ attribute_group_mod depends on attribute_group && class_group @
+declarer name ATTRIBUTE_GROUPS_BACKPORT;
+identifier group;
+@@
+
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
+ATTRIBUTE_GROUPS(group);
++#else
++#define BP_ATTR_GRP_STRUCT device_attribute
++ATTRIBUTE_GROUPS_BACKPORT(group);
++#endif
+
+@ class_registering depends on class_group && attribute_group_mod @
+identifier class_register, ret;
+identifier class_group.group_class;
+fresh identifier group_class_init = "init_" ## attribute_group_mod.group ## "_attrs";
+@@
+
+(
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
++	group_class_init();
++#endif
+	return class_register(&group_class);
+|
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
++	group_class_init();
++#endif
+	ret = class_register(&group_class);
+)
diff --git a/patches/collateral-evolutions/generic/0001-group-attr/0002-group_attr_bus.cocci b/patches/collateral-evolutions/generic/0001-group-attr/0002-group_attr_bus.cocci
new file mode 100644
index 0000000..d4ae44c
--- /dev/null
+++ b/patches/collateral-evolutions/generic/0001-group-attr/0002-group_attr_bus.cocci
@@ -0,0 +1,77 @@
+/*
+The new attribute sysfs group was added onto struct bus_type via
+commit fa6fdb33b
+
+mcgrof@ergon ~/linux (git::master)$ git describe --contains fa6fdb33b
+v3.12-rc1~184^2~89
+
+This backport makes use of the helpers to backport this more efficiently.
+Refer to the INFO file for documentation there on that.
+
+commit fa6fdb33b486a8afc5439c504da8d581e142c77d
+Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Date:   Thu Aug 8 15:22:55 2013 -0700
+
+    driver core: bus_type: add dev_groups
+
+    attribute groups are much more flexible than just a list of attributes,
+    due to their support for visibility of the attributes, and binary
+    attributes. Add dev_groups to struct bus_type which should be used
+    instead of dev_attrs.
+
+    dev_attrs will be removed from the structure soon.
+
+    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+*/
+
+@ attribute_group @
+identifier group;
+declarer name ATTRIBUTE_GROUPS;
+@@
+
+ATTRIBUTE_GROUPS(group);
+
+@ bus_group depends on attribute_group @
+identifier group_bus;
+expression groups;
+fresh identifier group_dev_attr = attribute_group.group ## "_dev_attrs";
+@@
+
+struct bus_type group_bus = {
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
+	.dev_groups = groups,
++#else
++	.dev_attrs = group_dev_attr,
++#endif
+};
+
+@ attribute_group_mod depends on attribute_group && bus_group @
+declarer name ATTRIBUTE_GROUPS_BACKPORT;
+identifier group;
+@@
+
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
+ATTRIBUTE_GROUPS(group);
++#else
++#define BP_ATTR_GRP_STRUCT device_attribute
++ATTRIBUTE_GROUPS_BACKPORT(group);
++#endif
+
+@ bus_registering depends on bus_group && attribute_group_mod @
+identifier bus_register, ret;
+identifier bus_group.group_bus;
+fresh identifier group_bus_init = "init_" ## attribute_group_mod.group ## "_attrs";
+@@
+
+(
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
++       group_bus_init();
++#endif
+        return bus_register(&group_bus);
+|
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
++       group_bus_init();
++#endif
+        ret = bus_register(&group_bus);
+)
+
diff --git a/patches/collateral-evolutions/generic/0001-group-attr/INFO b/patches/collateral-evolutions/generic/0001-group-attr/INFO
new file mode 100644
index 0000000..87590d5
--- /dev/null
+++ b/patches/collateral-evolutions/generic/0001-group-attr/INFO
@@ -0,0 +1,40 @@
+The new attribute sysfs group was added via these commits:
+
+mcgrof@ergon ~/linux (git::master)$ git describe --contains f2f37f58b
+v3.11-rc2~18^2~9
+mcgrof@ergon ~/linux (git::master)$ git describe --contains 3493f69f4
+v3.11-rc2~18^2~2
+
+We backport them with our own respective set of helpers. Each new data
+structure that gets an attribute group needs a respective SmPL set of
+rules for the transformation. We might be able to share the rules for
+lookup / indexing between rules some how. These lookup reveal would
+be used for inherent structural searches, pivots, if you will.
+
+The changes that added the new APIs:
+
+commit f2f37f58b1b933b06d6d84e80a31a1b500fb0db2
+Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Date:   Sun Jul 14 16:05:52 2013 -0700
+
+    sysfs.h: add ATTRIBUTE_GROUPS() macro
+
+    To make it easier for driver subsystems to work with attribute groups,
+    create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
+    typing for the most common use for attribute groups.
+
+    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
+    Tested-by: Guenter Roeck <linux@roeck-us.net>
+    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+
+commit 3493f69f4c4e8703961919a9a56c2d2e6a25b46f
+Author: Oliver Schinagl <oliver@schinagl.nl>
+Date:   Sun Jul 14 16:05:59 2013 -0700
+
+    sysfs: add more helper macro's for (bin_)attribute(_groups)
+
+    With the recent changes to sysfs there's various helper macro's.
+    However there's no RW, RO BIN_ helper macro's. This patch adds them.
+
+    Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
+    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/patches/collateral-evolutions/generic/0001-sysfs-api/INFO b/patches/collateral-evolutions/generic/0001-sysfs-api/INFO
deleted file mode 100644
index 8539db8..0000000
--- a/patches/collateral-evolutions/generic/0001-sysfs-api/INFO
+++ /dev/null
@@ -1,36 +0,0 @@
-The new attribute sysfs group was added via these commits:
-
-mcgrof@ergon ~/linux (git::master)$ git describe --contains f2f37f58b
-v3.11-rc2~18^2~9
-mcgrof@ergon ~/linux (git::master)$ git describe --contains 3493f69f4
-v3.11-rc2~18^2~2
-
-We backport them with our own respective set of helpers but right now
-this is using old legacy patches, it should be possible to convert all
-this juju legacy backport to SmPL form.
-
-commit f2f37f58b1b933b06d6d84e80a31a1b500fb0db2
-Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-Date:   Sun Jul 14 16:05:52 2013 -0700
-
-    sysfs.h: add ATTRIBUTE_GROUPS() macro
-    
-    To make it easier for driver subsystems to work with attribute groups,
-    create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
-    typing for the most common use for attribute groups.
-    
-    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
-    Tested-by: Guenter Roeck <linux@roeck-us.net>
-    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-
-commit 3493f69f4c4e8703961919a9a56c2d2e6a25b46f
-Author: Oliver Schinagl <oliver@schinagl.nl>
-Date:   Sun Jul 14 16:05:59 2013 -0700
-
-    sysfs: add more helper macro's for (bin_)attribute(_groups)
-    
-    With the recent changes to sysfs there's various helper macro's.
-    However there's no RW, RO BIN_ helper macro's. This patch adds them.
-    
-    Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
-    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_bcma.patch b/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_bcma.patch
deleted file mode 100644
index cc3da6f..0000000
--- a/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_bcma.patch
+++ /dev/null
@@ -1,35 +0,0 @@
---- a/drivers/bcma/main.c
-+++ b/drivers/bcma/main.c
-@@ -60,7 +60,12 @@ static struct attribute *bcma_device_att
- 	&dev_attr_class.attr,
- 	NULL,
- };
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
- ATTRIBUTE_GROUPS(bcma_device);
-+#else
-+#define BP_ATTR_GRP_STRUCT device_attribute
-+ATTRIBUTE_GROUPS_BACKPORT(bcma_device);
-+#endif
- 
- static struct bus_type bcma_bus_type = {
- 	.name		= "bcma",
-@@ -68,7 +73,11 @@ static struct bus_type bcma_bus_type = {
- 	.probe		= bcma_device_probe,
- 	.remove		= bcma_device_remove,
- 	.uevent		= bcma_device_uevent,
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
- 	.dev_groups	= bcma_device_groups,
-+#else
-+	.dev_attrs	= bcma_device_dev_attrs,
-+#endif
- };
- 
- static u16 bcma_cc_core_id(struct bcma_bus *bus)
-@@ -482,6 +491,7 @@ static int __init bcma_modinit(void)
- {
- 	int err;
- 
-+	init_bcma_device_attrs();
- 	err = bus_register(&bcma_bus_type);
- 	if (err)
- 		return err;
diff --git a/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_media_v4l2-core_v4l2-dev.patch b/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_media_v4l2-core_v4l2-dev.patch
deleted file mode 100644
index 258144f..0000000
--- a/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_media_v4l2-core_v4l2-dev.patch
+++ /dev/null
@@ -1,35 +0,0 @@
---- a/drivers/media/v4l2-core/v4l2-dev.c
-+++ b/drivers/media/v4l2-core/v4l2-dev.c
-@@ -86,7 +86,12 @@ static struct attribute *video_device_at
- 	&dev_attr_index.attr,
- 	NULL,
- };
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
- ATTRIBUTE_GROUPS(video_device);
-+#else
-+#define BP_ATTR_GRP_STRUCT device_attribute
-+ATTRIBUTE_GROUPS_BACKPORT(video_device);
-+#endif
- 
- /*
-  *	Active devices
-@@ -221,7 +226,11 @@ static void v4l2_device_release(struct d
- 
- static struct class video_class = {
- 	.name = VIDEO_NAME,
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
- 	.dev_groups = video_device_groups,
-+#else
-+	.dev_attrs = video_device_dev_attrs,
-+#endif
- };
- 
- struct video_device *video_devdata(struct file *file)
-@@ -1014,6 +1023,7 @@ static int __init videodev_init(void)
- 		return ret;
- 	}
- 
-+	init_video_device_attrs();
- 	ret = class_register(&video_class);
- 	if (ret < 0) {
- 		unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
diff --git a/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_ssb.patch b/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_ssb.patch
deleted file mode 100644
index 5fa2e98..0000000
--- a/patches/collateral-evolutions/generic/0001-sysfs-api/drivers_ssb.patch
+++ /dev/null
@@ -1,35 +0,0 @@
---- a/drivers/ssb/main.c
-+++ b/drivers/ssb/main.c
-@@ -399,7 +399,12 @@ static struct attribute *ssb_device_attr
- 	&dev_attr_irq.attr,
- 	NULL,
- };
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
- ATTRIBUTE_GROUPS(ssb_device);
-+#else
-+#define BP_ATTR_GRP_STRUCT device_attribute
-+ATTRIBUTE_GROUPS_BACKPORT(ssb_device);
-+#endif
- 
- static struct bus_type ssb_bustype = {
- 	.name		= "ssb",
-@@ -410,7 +415,11 @@ static struct bus_type ssb_bustype = {
- 	.suspend	= ssb_device_suspend,
- 	.resume		= ssb_device_resume,
- 	.uevent		= ssb_device_uevent,
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,12,0)
- 	.dev_groups	= ssb_device_groups,
-+#else
-+	.dev_attrs	= ssb_device_dev_attrs,
-+#endif
- };
- 
- static void ssb_buses_lock(void)
-@@ -1459,6 +1468,7 @@ static int __init ssb_modinit(void)
- {
- 	int err;
- 
-+	init_ssb_device_attrs();
- 	/* See the comment at the ssb_is_early_boot definition */
- 	ssb_is_early_boot = 0;
- 	err = bus_register(&ssb_bustype);
diff --git a/patches/collateral-evolutions/generic/0001-sysfs-api/net_ieee802154_wpan-class.patch b/patches/collateral-evolutions/generic/0001-sysfs-api/net_ieee802154_wpan-class.patch
deleted file mode 100644
index a6338c6..0000000
--- a/patches/collateral-evolutions/generic/0001-sysfs-api/net_ieee802154_wpan-class.patch
+++ /dev/null
@@ -1,35 +0,0 @@
---- a/net/ieee802154/wpan-class.c
-+++ b/net/ieee802154/wpan-class.c
-@@ -75,7 +75,12 @@ static struct attribute *pmib_attrs[] =
- 	&dev_attr_cca_mode.attr,
- 	NULL,
- };
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
- ATTRIBUTE_GROUPS(pmib);
-+#else
-+#define BP_ATTR_GRP_STRUCT device_attribute
-+ATTRIBUTE_GROUPS_BACKPORT(pmib);
-+#endif
- 
- static void wpan_phy_release(struct device *d)
- {
-@@ -86,7 +91,11 @@ static void wpan_phy_release(struct devi
- static struct class wpan_phy_class = {
- 	.name = "ieee802154",
- 	.dev_release = wpan_phy_release,
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
- 	.dev_groups = pmib_groups,
-+#else
-+	.dev_attrs = pmib_dev_attrs,
-+#endif
- };
- 
- static DEFINE_MUTEX(wpan_phy_mutex);
-@@ -197,6 +206,7 @@ EXPORT_SYMBOL(wpan_phy_free);
- static int __init wpan_phy_class_init(void)
- {
- 	int rc;
-+	init_pmib_attrs();
- 	rc = class_register(&wpan_phy_class);
- 	if (rc)
- 		goto err;
diff --git a/patches/collateral-evolutions/generic/0001-sysfs-api/net_wireless_sysfs.patch b/patches/collateral-evolutions/generic/0001-sysfs-api/net_wireless_sysfs.patch
deleted file mode 100644
index 9c532c2..0000000
--- a/patches/collateral-evolutions/generic/0001-sysfs-api/net_wireless_sysfs.patch
+++ /dev/null
@@ -1,35 +0,0 @@
---- a/net/wireless/sysfs.c
-+++ b/net/wireless/sysfs.c
-@@ -71,7 +71,12 @@ static struct attribute *ieee80211_attrs
- 	&dev_attr_name.attr,
- 	NULL,
- };
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
- ATTRIBUTE_GROUPS(ieee80211);
-+#else
-+#define BP_ATTR_GRP_STRUCT device_attribute
-+ATTRIBUTE_GROUPS_BACKPORT(ieee80211);
-+#endif
- 
- static void wiphy_dev_release(struct device *dev)
- {
-@@ -149,7 +154,11 @@ struct class ieee80211_class = {
- 	.name = "ieee80211",
- 	.owner = THIS_MODULE,
- 	.dev_release = wiphy_dev_release,
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,11,0)
- 	.dev_groups = ieee80211_groups,
-+#else
-+	.dev_attrs = ieee80211_dev_attrs,
-+#endif
- 	.dev_uevent = wiphy_uevent,
- #ifdef CONFIG_PM
- 	.suspend = wiphy_suspend,
-@@ -161,6 +170,7 @@ struct class ieee80211_class = {
- 
- int wiphy_sysfs_init(void)
- {
-+	init_ieee80211_attrs();
- 	return class_register(&ieee80211_class);
- }
- 
-- 
1.9.1

