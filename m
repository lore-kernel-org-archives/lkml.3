Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaEHSHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:07:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:9826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaEHSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:07:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1012,1389772800"; 
   d="scan'208";a="508544597"
From: Keith Busch <keith.busch@intel.com>
To: linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 1/2] driver-core: allow asynchronous device shutdown
Date: Thu,  8 May 2014 12:07:33 -0600
Message-Id: <1399572454-30239-2-git-send-email-keith.busch@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1399572454-30239-1-git-send-email-keith.busch@intel.com>
References: <1399572454-30239-1-git-send-email-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch to allow .shutdown to execute asynchronously. Some devices may
take a long time to complete a shutdown, so this patch lets a driver
safely shutdown multiple devices asynchronously.

This uses an exclusive asynchronous domain so other unrelated async
tasks can't cause shutdown to hold up indefinitely.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/base/core.c    |    4 ++++
 include/linux/device.h |    1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..71b83bb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/async.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -1926,6 +1927,8 @@ out:
 }
 EXPORT_SYMBOL_GPL(device_move);
 
+ASYNC_DOMAIN_EXCLUSIVE(shutdown_domain);
+EXPORT_SYMBOL(shutdown_domain);
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
@@ -1986,6 +1989,7 @@ void device_shutdown(void)
 		spin_lock(&devices_kset->list_lock);
 	}
 	spin_unlock(&devices_kset->list_lock);
+	async_synchronize_full_domain(&shutdown_domain);
 }
 
 /*
diff --git a/include/linux/device.h b/include/linux/device.h
index d1d1c05..95ed9f1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -997,6 +997,7 @@ static inline int devtmpfs_mount(const char *mountpoint) { return 0; }
 
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
+extern struct async_domain shutdown_domain;
 
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(const struct device *dev);
-- 
1.7.10.4

