Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3HTODn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:03:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:16691 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3HTODk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:03:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,920,1367996400"; 
   d="scan'208";a="365563490"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH 2/2] i2c: attach/detach I2C client device to the ACPI power domain
Date: Tue, 20 Aug 2013 17:03:36 +0300
Message-Id: <1377007416-13851-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1377007416-13851-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1377007416-13851-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

If the I2C client device is enumerated from ACPI namespace it might have
ACPI methods that needs to be called in order to transition the device to
a different power states (such as _PSx).

Implement this for I2C client devices by checking if the device has an ACPI
handle and if that's the case, attach it to the ACPI power domain. In
addition we make sure that the device is fully powered when its ->probe()
function gets called.

For non-ACPI devices this patch is a no-op.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/i2c-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 8fad5ac..fdf086b 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -257,6 +257,9 @@ static int i2c_device_probe(struct device *dev)
 	/* Make sure the adapter is active */
 	pm_runtime_get_sync(&client->adapter->dev);
 
+	if (ACPI_HANDLE(&client->dev))
+		acpi_dev_pm_attach(&client->dev, true);
+
 	/*
 	 * Enable runtime PM for the client device. If the client wants to
 	 * participate on runtime PM it should call pm_runtime_put() in its
@@ -278,6 +281,9 @@ static int i2c_device_probe(struct device *dev)
 		pm_runtime_disable(&client->dev);
 		pm_runtime_set_suspended(&client->dev);
 		pm_runtime_put_noidle(&client->dev);
+
+		if (ACPI_HANDLE(&client->dev))
+			acpi_dev_pm_detach(&client->dev, true);
 	}
 
 	pm_runtime_put(&client->adapter->dev);
@@ -314,6 +320,9 @@ static int i2c_device_remove(struct device *dev)
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
 
+	if (ACPI_HANDLE(&client->dev))
+		acpi_dev_pm_detach(&client->dev, true);
+
 	pm_runtime_put(&client->adapter->dev);
 	return status;
 }
-- 
1.8.4.rc2

