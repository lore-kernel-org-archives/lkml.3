Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaAUVYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:24:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:56291 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaAUVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 29/73] drivers/platform: don't use modular register in non-modular pdev_bus.c
Date: Tue, 21 Jan 2014 16:22:32 -0500
Message-ID: <1390339396-3479-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is configured with a Kconfig option that is
declared as a bool.  Hence it is not possible for the code
to be built as modular.  However the code is currently using
the module_platform_driver() macro for driver registration.

While this currently works, we really don't want to be including
the module.h header in non-modular code, which we'll be forced
to do, pending some upcoming code relocation from init.h into
module.h.  So we fix it now by using the non-modular equivalent.

With some macro detangulation, and a little help from cpp, we can
see that module_platform_driver(goldfish_pdev_bus_driver) gets
roughly translated into:

  static int __init goldfish_pdev_bus_driver_init(void)
  {
        return platform_driver_register(&goldfish_pdev_bus_driver);
  }
  module_init(goldfish_pdev_bus_driver_init);

  static void __exit goldfish_pdev_bus_driver_exit(void)
  {
        platform_driver_unregister(&goldfish_pdev_bus_driver);
  }
  module_exit(goldfish_pdev_bus_driver_exit);

And since we've already established that the code is non-modular,
we can completely drop any code relating to module_exit.  For non
modular code, module_init beomes __initcall.  But direct use of
__initcall is discouraged, vs. one of the priority categorized
subgroups.  As __initcall gets mapped onto device_initcall, our
use of device_initcall directly in this change means that the
runtime impact is zero -- they will remain at level 6 in the
initcall ordering.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/platform/goldfish/pdev_bus.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/goldfish/pdev_bus.c b/drivers/platform/goldfish/pdev_bus.c
index 92cc4cf..e4e999f 100644
--- a/drivers/platform/goldfish/pdev_bus.c
+++ b/drivers/platform/goldfish/pdev_bus.c
@@ -221,20 +221,15 @@ free_resources:
 	return ret;
 }
 
-static int goldfish_pdev_bus_remove(struct platform_device *pdev)
-{
-	iounmap(pdev_bus_base);
-	free_irq(pdev_bus_irq, pdev);
-	release_mem_region(pdev_bus_addr, pdev_bus_len);
-	return 0;
-}
-
 static struct platform_driver goldfish_pdev_bus_driver = {
 	.probe = goldfish_pdev_bus_probe,
-	.remove = goldfish_pdev_bus_remove,
 	.driver = {
 		.name = "goldfish_pdev_bus"
 	}
 };
 
-module_platform_driver(goldfish_pdev_bus_driver);
+static int __init goldfish_pdev_bus_driver_init(void)
+{
+	return platform_driver_register(&goldfish_pdev_bus_driver);
+}
+device_initcall(goldfish_pdev_bus_driver_init);
-- 
1.8.4.1

