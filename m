Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3HWVY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:24:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3HWVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 05/15] PPC: VIO: convert bus code to use bus_groups
Date: Fri, 23 Aug 2013 14:24:31 -0700
Message-Id: <1377293081-10957-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the VIO bus code to use the
correct field.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vio.c | 66 ++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 536016d7..5e34f20b 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -997,21 +997,36 @@ static struct device_attribute vio_cmo_dev_attrs[] = {
 /* sysfs bus functions and data structures for CMO */
 
 #define viobus_cmo_rd_attr(name)                                        \
-static ssize_t                                                          \
-viobus_cmo_##name##_show(struct bus_type *bt, char *buf)                \
+static ssize_t cmo_##name##_show(struct bus_type *bt, char *buf)        \
 {                                                                       \
 	return sprintf(buf, "%lu\n", vio_cmo.name);                     \
-}
+}                                                                       \
+static BUS_ATTR_RO(cmo_##name)
 
 #define viobus_cmo_pool_rd_attr(name, var)                              \
 static ssize_t                                                          \
-viobus_cmo_##name##_pool_show_##var(struct bus_type *bt, char *buf)     \
+cmo_##name##_##var##_show(struct bus_type *bt, char *buf)               \
 {                                                                       \
 	return sprintf(buf, "%lu\n", vio_cmo.name.var);                 \
+}                                                                       \
+static BUS_ATTR_RO(cmo_##name##_##var)
+
+viobus_cmo_rd_attr(entitled);
+viobus_cmo_rd_attr(spare);
+viobus_cmo_rd_attr(min);
+viobus_cmo_rd_attr(desired);
+viobus_cmo_rd_attr(curr);
+viobus_cmo_pool_rd_attr(reserve, size);
+viobus_cmo_pool_rd_attr(excess, size);
+viobus_cmo_pool_rd_attr(excess, free);
+
+static ssize_t cmo_high_show(struct bus_type *bt, char *buf)
+{
+	return sprintf(buf, "%lu\n", vio_cmo.high);
 }
 
-static ssize_t viobus_cmo_high_reset(struct bus_type *bt, const char *buf,
-                                     size_t count)
+static ssize_t cmo_high_store(struct bus_type *bt, const char *buf,
+			      size_t count)
 {
 	unsigned long flags;
 
@@ -1021,35 +1036,26 @@ static ssize_t viobus_cmo_high_reset(struct bus_type *bt, const char *buf,
 
 	return count;
 }
-
-viobus_cmo_rd_attr(entitled);
-viobus_cmo_pool_rd_attr(reserve, size);
-viobus_cmo_pool_rd_attr(excess, size);
-viobus_cmo_pool_rd_attr(excess, free);
-viobus_cmo_rd_attr(spare);
-viobus_cmo_rd_attr(min);
-viobus_cmo_rd_attr(desired);
-viobus_cmo_rd_attr(curr);
-viobus_cmo_rd_attr(high);
-
-static struct bus_attribute vio_cmo_bus_attrs[] = {
-	__ATTR(cmo_entitled, S_IRUGO, viobus_cmo_entitled_show, NULL),
-	__ATTR(cmo_reserve_size, S_IRUGO, viobus_cmo_reserve_pool_show_size, NULL),
-	__ATTR(cmo_excess_size, S_IRUGO, viobus_cmo_excess_pool_show_size, NULL),
-	__ATTR(cmo_excess_free, S_IRUGO, viobus_cmo_excess_pool_show_free, NULL),
-	__ATTR(cmo_spare,   S_IRUGO, viobus_cmo_spare_show,   NULL),
-	__ATTR(cmo_min,     S_IRUGO, viobus_cmo_min_show,     NULL),
-	__ATTR(cmo_desired, S_IRUGO, viobus_cmo_desired_show, NULL),
-	__ATTR(cmo_curr,    S_IRUGO, viobus_cmo_curr_show,    NULL),
-	__ATTR(cmo_high,    S_IWUSR|S_IRUSR|S_IWGRP|S_IRGRP|S_IROTH,
-	       viobus_cmo_high_show, viobus_cmo_high_reset),
-	__ATTR_NULL
+static BUS_ATTR_RW(cmo_high);
+
+static struct attribute *vio_bus_attrs[] = {
+	&bus_attr_cmo_entitled.attr,
+	&bus_attr_cmo_spare.attr,
+	&bus_attr_cmo_min.attr,
+	&bus_attr_cmo_desired.attr,
+	&bus_attr_cmo_curr.attr,
+	&bus_attr_cmo_high.attr,
+	&bus_attr_cmo_reserve_size.attr,
+	&bus_attr_cmo_excess_size.attr,
+	&bus_attr_cmo_excess_free.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(vio_bus);
 
 static void vio_cmo_sysfs_init(void)
 {
 	vio_bus_type.dev_attrs = vio_cmo_dev_attrs;
-	vio_bus_type.bus_attrs = vio_cmo_bus_attrs;
+	vio_bus_type.bus_groups = vio_bus_groups;
 }
 #else /* CONFIG_PPC_SMLPAR */
 int vio_cmo_entitlement_update(size_t new_entitlement) { return 0; }
-- 
1.8.3.rc0.20.gb99dd2e

