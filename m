Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3FJHNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:13:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:22993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3FJHNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,835,1363158000"; 
   d="scan'208";a="326909820"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.10] mei: init: Flush scheduled work before resetting the device
Date: Mon, 10 Jun 2013 10:10:25 +0300
Message-Id: <1370848226-5910-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Flushing pending work items before resetting the device makes more
sense than doing so afterwards. Some of them, like e.g. the NFC
initialization one, find themselves with client IDs changed after
the reset, eventually leading to trigger a client.c:mei_me_cl_by_id()
warning after a few modprobe/rmmod cycles.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 713d89f..f580d30 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -197,6 +197,8 @@ void mei_stop(struct mei_device *dev)
 {
 	dev_dbg(&dev->pdev->dev, "stopping the device.\n");
 
+	flush_scheduled_work();
+
 	mutex_lock(&dev->device_lock);
 
 	cancel_delayed_work(&dev->timer_work);
@@ -210,8 +212,6 @@ void mei_stop(struct mei_device *dev)
 
 	mutex_unlock(&dev->device_lock);
 
-	flush_scheduled_work();
-
 	mei_watchdog_unregister(dev);
 }
 EXPORT_SYMBOL_GPL(mei_stop);
-- 
1.8.1.2

