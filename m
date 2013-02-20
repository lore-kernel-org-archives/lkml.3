Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3BTIbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:31:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59851 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3BTIbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:31:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] base: core: WARN() about bogus permissions on device attributes
Date: Wed, 20 Feb 2013 10:31:42 +0200
Message-ID: <1361349102-15061-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130220050122.GD2869@kroah.com>
References: <20130220050122.GD2869@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever a struct device_attribute is registered
with mismatched permissions - read permission without
a show routine or write permission without store
routine - we will issue a big warning so we catch
those early enough.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/base/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..14e6a92 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -563,8 +563,15 @@ int device_create_file(struct device *dev,
 		       const struct device_attribute *attr)
 {
 	int error = 0;
-	if (dev)
+
+	if (dev) {
+		WARN(((attr->attr.mode & S_IWUGO) && !attr->store),
+				"Write permission without 'store'\n");
+		WARN(((attr->attr.mode & S_IRUGO) && !attr->show),
+				"Read permission without 'show'\n");
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
+	}
+
 	return error;
 }
 
-- 
1.8.1.rc1.5.g7e0651a

