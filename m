Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3HWV2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:28:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3HWVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH 03/15] rapidio: convert bus code to use bus_groups
Date: Fri, 23 Aug 2013 14:24:29 -0700
Message-Id: <1377293081-10957-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the rapidio bus code to use the
correct field.

Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio-driver.c |  2 +-
 drivers/rapidio/rio-sysfs.c  | 16 +++++++++++++---
 drivers/rapidio/rio.h        |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 3e9b6a78..2be2d24d 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -224,7 +224,7 @@ struct bus_type rio_bus_type = {
 	.name = "rapidio",
 	.match = rio_match_bus,
 	.dev_attrs = rio_dev_attrs,
-	.bus_attrs = rio_bus_attrs,
+	.bus_groups = rio_bus_groups,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
 	.uevent	= rio_uevent,
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 9331be64..795a4776 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -316,8 +316,18 @@ exit:
 
 	return rc;
 }
+static BUS_ATTR(scan, (S_IWUSR|S_IWGRP), NULL, bus_scan_store);
 
-struct bus_attribute rio_bus_attrs[] = {
-	__ATTR(scan, (S_IWUSR|S_IWGRP), NULL, bus_scan_store),
-	__ATTR_NULL
+static struct attribute *rio_bus_attrs[] = {
+	&bus_attr_scan.attr,
+	NULL,
+};
+
+static const struct attribute_group rio_bus_group = {
+	.attrs = rio_bus_attrs,
+};
+
+const struct attribute_group *rio_bus_groups[] = {
+	&rio_bus_group,
+	NULL,
 };
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index 085215cd..57d2ad06 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -49,7 +49,7 @@ extern int rio_mport_scan(int mport_id);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
-extern struct bus_attribute rio_bus_attrs[];
+extern const struct attribute_group *rio_bus_groups[];
 
 #define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
 #define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
-- 
1.8.3.rc0.20.gb99dd2e

