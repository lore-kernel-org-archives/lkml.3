Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3HPWYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:24:39 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51744 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3HPWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:24:36 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 1/4] driver core: Register SoC bus after platform bus
Date: Fri, 16 Aug 2013 22:39:20 +0200
Message-Id: <1376685563-1053-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376685563-1053-1-git-send-email-treding@nvidia.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of registering the SoC bus as a core initcall, call it directly
from driver_init() to make it explicit when it is called. This is done
in preparation for early device registration support.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/base.h |  5 +++++
 drivers/base/init.c |  1 +
 drivers/base/soc.c  | 11 +----------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 2cbc677..77e0722 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -99,6 +99,11 @@ extern int hypervisor_init(void);
 static inline int hypervisor_init(void) { return 0; }
 #endif
 extern int platform_bus_init(void);
+#ifdef CONFIG_SOC_BUS
+extern int soc_bus_init(void);
+#else
+static inline int soc_bus_init(void) { return 0; }
+#endif
 extern void cpu_dev_init(void);
 
 struct kobject *virtual_device_parent(struct device *dev);
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c16f0b8..a4c4090 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -31,6 +31,7 @@ void __init driver_init(void)
 	 * core core pieces.
 	 */
 	platform_bus_init();
+	soc_bus_init();
 	cpu_dev_init();
 	memory_dev_init();
 }
diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 72b5e72..ea116f4 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -166,16 +166,7 @@ void soc_device_unregister(struct soc_device *soc_dev)
 	device_unregister(&soc_dev->dev);
 }
 
-static int __init soc_bus_register(void)
+int __init soc_bus_init(void)
 {
 	return bus_register(&soc_bus_type);
 }
-core_initcall(soc_bus_register);
-
-static void __exit soc_bus_unregister(void)
-{
-	ida_destroy(&soc_ida);
-
-	bus_unregister(&soc_bus_type);
-}
-module_exit(soc_bus_unregister);
-- 
1.8.3.4

