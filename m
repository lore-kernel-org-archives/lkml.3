Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaIEGhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:37:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34982 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaIEGhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:37:39 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, hare@suse.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de, santosh@chelsio.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 1/6] driver-core: generalize freeing driver private member
Date: Thu,  4 Sep 2014 23:37:22 -0700
Message-Id: <1409899047-13045-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will be used later.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/bus.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a..a5f41e4 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -657,6 +657,15 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
 }
 static DRIVER_ATTR_WO(uevent);
 
+static void remove_driver_private(struct device_driver *drv)
+{
+	struct driver_private *priv = drv->p;
+
+	kobject_put(&priv->kobj);
+	kfree(priv);
+	drv->p = NULL;
+}
+
 /**
  * bus_add_driver - Add a driver to the bus.
  * @drv: driver.
@@ -719,9 +728,7 @@ int bus_add_driver(struct device_driver *drv)
 	return 0;
 
 out_unregister:
-	kobject_put(&priv->kobj);
-	kfree(drv->p);
-	drv->p = NULL;
+	remove_driver_private(drv);
 out_put_bus:
 	bus_put(bus);
 	return error;
-- 
2.0.3

