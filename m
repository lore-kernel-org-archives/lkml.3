Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3HWV2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:28:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3HWVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 04/15] PPC: ibmebus: convert bus code to use bus_groups
Date: Fri, 23 Aug 2013 14:24:30 -0700
Message-Id: <1377293081-10957-4-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the ibmebus bus code to use the
correct field.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/ibmebus.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 16a7c232..1114d13a 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -292,6 +292,7 @@ out:
 		return rc;
 	return count;
 }
+static BUS_ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe);
 
 static ssize_t ibmebus_store_remove(struct bus_type *bus,
 				    const char *buf, size_t count)
@@ -317,13 +318,14 @@ static ssize_t ibmebus_store_remove(struct bus_type *bus,
 		return -ENODEV;
 	}
 }
+static BUS_ATTR(remove, S_IWUSR, NULL, ibmebus_store_remove);
 
-
-static struct bus_attribute ibmebus_bus_attrs[] = {
-	__ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe),
-	__ATTR(remove, S_IWUSR, NULL, ibmebus_store_remove),
-	__ATTR_NULL
+static struct attribute *ibmbus_bus_attrs[] = {
+	&bus_attr_probe.attr,
+	&bus_attr_remove.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(ibmbus_bus);
 
 static int ibmebus_bus_bus_match(struct device *dev, struct device_driver *drv)
 {
@@ -713,7 +715,7 @@ static struct dev_pm_ops ibmebus_bus_dev_pm_ops = {
 struct bus_type ibmebus_bus_type = {
 	.name      = "ibmebus",
 	.uevent    = of_device_uevent_modalias,
-	.bus_attrs = ibmebus_bus_attrs,
+	.bus_groups = ibmbus_bus_groups,
 	.match     = ibmebus_bus_bus_match,
 	.probe     = ibmebus_bus_device_probe,
 	.remove    = ibmebus_bus_device_remove,
-- 
1.8.3.rc0.20.gb99dd2e

