Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaAPWV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:21:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:52398 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAPWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:21:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] cpuidle: don't use modular platform register in non-modular ARM drivers
Date: Thu, 16 Jan 2014 17:19:27 -0500
Message-ID: <1389910767-4040-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two drivers are configured with Kconfig options that are
both declared as bool.  Hence it is not possible for the code
to be built as modular.  However the code is currently using the
module_platform_driver() macro for driver registration.

While this currently works, we really don't want to be including
the module.h header in non-modular code, which we'll be forced
to do, pending some upcoming code relocation from init.h into
module.h.  So we fix it now by using the non-modular equivalent.

With some macro detangulation, and a little help from cpp, we can
see that module_platform_driver(calxeda_cpuidle_plat_driver) gets
roughly translated into:

  static int __init calxeda_cpuidle_plat_driver_init(void)
  {
        return platform_driver_register(&calxeda_cpuidle_plat_driver);
  }
  module_init(calxeda_cpuidle_plat_driver_init);

  static void __exit calxeda_cpuidle_plat_driver_exit(void)
  {
        platform_driver_unregister(&calxeda_cpuidle_plat_driver);
  }
  module_exit(calxeda_cpuidle_plat_driver_exit);

[and similarly for the other file, cpuidle-zynq.c]

And since we've already established that the code is non-modular,
we can completely drop any code relating to module_exit.  For non
modular code, module_init beomes __initcall.  But direct use of
__initcall is discouraged, vs. one of the priority categorized
subgroups.  As __initcall gets mapped onto device_initcall, our
use of device_initcall directly in this change means that the
runtime impact is zero -- they will remain at level 6 in the
initcall ordering.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
index 6e51114057d0..631e2cd9bce6 100644
--- a/drivers/cpuidle/cpuidle-calxeda.c
+++ b/drivers/cpuidle/cpuidle-calxeda.c
@@ -78,4 +78,8 @@ static struct platform_driver calxeda_cpuidle_plat_driver = {
         .probe = calxeda_cpuidle_probe,
 };
 
-module_platform_driver(calxeda_cpuidle_plat_driver);
+static int __init calxeda_cpuidle_plat_driver_init(void)
+{
+	return platform_driver_register(&calxeda_cpuidle_plat_driver);
+}
+device_initcall(calxeda_cpuidle_plat_driver_init);
diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-zynq.c
index aded75928028..a1aae519a573 100644
--- a/drivers/cpuidle/cpuidle-zynq.c
+++ b/drivers/cpuidle/cpuidle-zynq.c
@@ -85,4 +85,8 @@ static struct platform_driver zynq_cpuidle_driver = {
 	.probe = zynq_cpuidle_probe,
 };
 
-module_platform_driver(zynq_cpuidle_driver);
+static int __init zynq_cpuidle_driver_init(void)
+{
+	return platform_driver_register(&zynq_cpuidle_driver);
+}
+device_initcall(zynq_cpuidle_driver_init);
-- 
1.8.5.2

