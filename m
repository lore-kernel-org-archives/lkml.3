Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaHULAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:00:22 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53551 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753849AbaHULAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:00:18 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 02/11] topology: replace custom attribute macros with standard DEVICE_ATTR*
Date: Thu, 21 Aug 2014 11:59:45 +0100
Message-Id: <1408618794-28497-3-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408618794-28497-1-git-send-email-sudeep.holla@arm.com>
References: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
 <1408618794-28497-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

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
index 39b294bd769b..71251ef96e0a 100644
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
-	return cpumap_copy_to_buf(false, topology_##name(dev->id), buf);\
+	return cpumap_copy_to_buf(false, topology_##mask(dev->id), buf);\
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
-	return cpumap_copy_to_buf(true, topology_##name(dev->id), buf);	\
+	return cpumap_copy_to_buf(true, topology_##mask(dev->id), buf);	\
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
1.8.3.2

