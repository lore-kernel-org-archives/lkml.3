Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbaGXNBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:01:07 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51382 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758995AbaGXNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:01:04 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Al Stone <al.stone@linaro.org>, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 02/19] ARM64 / ACPI: Introduce early_param for "acpi"
Date: Thu, 24 Jul 2014 21:00:08 +0800
Message-Id: <1406206825-15590-3-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Stone <al.stone@linaro.org>

Introduce two early parameters for "acpi", one is the parameter
to disable ACPI on ARM64 and another one is acpi=strict to disable
out-of-spec workarounds.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 Documentation/kernel-parameters.txt |    3 ++-
 arch/arm64/kernel/acpi.c            |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b7fa2f5..d130bd5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -165,7 +165,7 @@ multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
 bytes respectively. Such letter suffixes can also be entirely omitted.
 
 
-	acpi=		[HW,ACPI,X86]
+	acpi=		[HW,ACPI,X86,ARM]
 			Advanced Configuration and Power Interface
 			Format: { force | off | strict | noirq | rsdt }
 			force -- enable ACPI if default was off
@@ -175,6 +175,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				strictly ACPI specification compliant.
 			rsdt -- prefer RSDT over (default) XSDT
 			copy_dsdt -- copy DSDT to memory
+			For ARM64, ONLY "off" and "strict" are available.
 
 			See also Documentation/power/runtime_pm.txt, pci=noacpi
 
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index c62fce6..ac78e4e 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -74,3 +74,24 @@ void __init acpi_boot_table_init(void)
 		return;
 	}
 }
+
+static int __init parse_acpi(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	/* "acpi=off" disables both ACPI table parsing and interpreter */
+	if (strcmp(arg, "off") == 0) {
+		disable_acpi();
+	}
+	/* acpi=strict disables out-of-spec workarounds */
+	else if (strcmp(arg, "strict") == 0) {
+		acpi_strict = 1;
+	} else {
+		/* Core will printk when we return error */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+early_param("acpi", parse_acpi);
-- 
1.7.9.5

