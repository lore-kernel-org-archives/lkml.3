Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaI3Nsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:48:32 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50971 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750972AbaI3Ns3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:48:29 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5 02/11] topology: replace custom attribute macros with standard DEVICE_ATTR*
Date: Tue, 30 Sep 2014 14:48:23 +0100
Message-Id: <1412084912-2767-3-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
References: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently couple of custom macros are defined to declare the
device attributes. However there are already standard macros
defined in device.h that suffice the need and these custom
macros can be removed.

This patch replaces custom attribute macros with standard
DEVICE_ATTR_RO attribute

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/topology.c | 53 ++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index f7c353843ddf..6491f45200a7 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -29,57 +29,52 @@
 #include <linux/hardirq.h>
 #include <linux/topology.h>
 
-#define define_one_ro_named(_name, _func)				\
-	static DEVICE_ATTR(_name, 0444, _func, NULL)
-
-#define define_one_ro(_name)				\
-	static DEVICE_ATTR(_name, 0444, show_##_name, NULL)
-
 #define define_id_show_func(name)				\
-static ssize_t show_##name(struct device *dev,			\
+static ssize_t name##_show(struct device *dev,			\
 		struct device_attribute *attr, char *buf)	\
 {								\
 	return sprintf(buf, "%d\n", topology_##name(dev->id));	\
 }
 
-#define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct device *dev,				\
+#define define_siblings_show_map(name, mask)				\
+static ssize_t name##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *buf)	\
 {									\
-	return cpumap_print_to_pagebuf(false, buf, topology_##name(dev->id));\
+	return cpumap_print_to_pagebuf(false, buf, topology_##mask(dev->id));\
 }
 
-#define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct device *dev,			\
-				  struct device_attribute *attr,	\
-				  char *buf)				\
+#define define_siblings_show_list(name, mask)				\
+static ssize_t name##_list_show(struct device *dev,			\
+				struct device_attribute *attr,		\
+				char *buf)				\
 {									\
-	return cpumap_print_to_pagebuf(true, buf, topology_##name(dev->id));\
+	return cpumap_print_to_pagebuf(true, buf, topology_##mask(dev->id));\
 }
 
-#define define_siblings_show_func(name)		\
-	define_siblings_show_map(name); define_siblings_show_list(name)
+#define define_siblings_show_func(name, mask)	\
+	define_siblings_show_map(name, mask);	\
+	define_siblings_show_list(name, mask)
 
 define_id_show_func(physical_package_id);
-define_one_ro(physical_package_id);
+static DEVICE_ATTR_RO(physical_package_id);
 
 define_id_show_func(core_id);
-define_one_ro(core_id);
+static DEVICE_ATTR_RO(core_id);
 
-define_siblings_show_func(thread_cpumask);
-define_one_ro_named(thread_siblings, show_thread_cpumask);
-define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
+define_siblings_show_func(thread_siblings, thread_cpumask);
+static DEVICE_ATTR_RO(thread_siblings);
+static DEVICE_ATTR_RO(thread_siblings_list);
 
-define_siblings_show_func(core_cpumask);
-define_one_ro_named(core_siblings, show_core_cpumask);
-define_one_ro_named(core_siblings_list, show_core_cpumask_list);
+define_siblings_show_func(core_siblings, core_cpumask);
+static DEVICE_ATTR_RO(core_siblings);
+static DEVICE_ATTR_RO(core_siblings_list);
 
 #ifdef CONFIG_SCHED_BOOK
 define_id_show_func(book_id);
-define_one_ro(book_id);
-define_siblings_show_func(book_cpumask);
-define_one_ro_named(book_siblings, show_book_cpumask);
-define_one_ro_named(book_siblings_list, show_book_cpumask_list);
+static DEVICE_ATTR_RO(book_id);
+define_siblings_show_func(book_siblings, book_cpumask);
+static DEVICE_ATTR_RO(book_siblings);
+static DEVICE_ATTR_RO(book_siblings_list);
 #endif
 
 static struct attribute *default_attrs[] = {
-- 
1.9.1

