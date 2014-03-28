Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaC1FVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 01:21:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46829 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaC1FUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 01:20:44 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rob@landley.net, olof@lixom.net, Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/2] regulator: core: Add reg_ignore_unused to keep boot time regulators enabled
Date: Fri, 28 Mar 2014 10:50:22 +0530
Message-Id: <1395984022-8284-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
References: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep all regulators already enabled by bootloader on, even if no
driver has claimed them. This is useful for debug and development, but
should not be needed on a platform with proper driver support.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Mark Brown <broonie@kernel.org>
---
 Documentation/kernel-parameters.txt |    8 ++++++++
 drivers/regulator/core.c            |   13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 96bb532..20448e0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -92,6 +92,7 @@ parameter is applicable:
 	PPT	Parallel port support is enabled.
 	PS2	Appropriate PS/2 support is enabled.
 	RAM	RAM disk support is enabled.
+	REG	Regulator support is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
 			A lot of drivers have their options described inside
@@ -2886,6 +2887,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			      reboot_cpu is s[mp]#### with #### being the processor
 					to be used for rebooting.
 
+	reg_ignore_unused
+			[REG]
+			Keep all regulators already enabled by bootloader on,
+			even if no driver has claimed them. This is useful
+			for debug and development, but should not be
+			needed on a platform with proper driver support.
+
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
 			See Documentation/cgroups/cpusets.txt.
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a09f3c..6e8305a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3800,6 +3800,14 @@ static int __init regulator_init(void)
 /* init early to allow our consumers to complete system booting */
 core_initcall(regulator_init);
 
+static bool reg_ignore_unused;
+static int __init reg_ignore_unused_setup(char *__unused)
+{
+	reg_ignore_unused = true;
+	return 1;
+}
+__setup("reg_ignore_unused", reg_ignore_unused_setup);
+
 static int __init regulator_init_complete(void)
 {
 	struct regulator_dev *rdev;
@@ -3807,6 +3815,11 @@ static int __init regulator_init_complete(void)
 	struct regulation_constraints *c;
 	int enabled, ret;
 
+	if (reg_ignore_unused) {
+		pr_warn("reg: Not disabling unused regulators\n");
+		return 0;
+	}
+
 	/*
 	 * Since DT doesn't provide an idiomatic mechanism for
 	 * enabling full constraints and since it's much more natural
-- 
1.7.9.5

