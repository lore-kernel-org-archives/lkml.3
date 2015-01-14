Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbbANPHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:07:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50395 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbbANPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:07:14 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v7 03/17] ARM64 / ACPI: Introduce sleep-arm.c
Date: Wed, 14 Jan 2015 23:04:51 +0800
Message-Id: <1421247905-3749-4-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

ACPI 5.1 does not currently support S states for ARM64 hardware but
ACPI code will call acpi_target_system_state() for device power
managment, so introduce sleep-arm.c to allow other drivers to function
until S states are defined.

Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Tested-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/Makefile    |  4 ++++
 drivers/acpi/sleep-arm.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 drivers/acpi/sleep-arm.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index f74317c..39f3ec1 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -23,7 +23,11 @@ acpi-y				+= nvs.o
 
 # Power management related files
 acpi-y				+= wakeup.o
+ifeq ($(ARCH), arm64)
+acpi-y				+= sleep-arm.o
+else # X86, IA64
 acpi-y				+= sleep.o
+endif
 acpi-y				+= device_pm.o
 acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 
diff --git a/drivers/acpi/sleep-arm.c b/drivers/acpi/sleep-arm.c
new file mode 100644
index 0000000..54578ef
--- /dev/null
+++ b/drivers/acpi/sleep-arm.c
@@ -0,0 +1,28 @@
+/*
+ *  ARM64 Specific Sleep Functionality
+ *
+ *  Copyright (C) 2013-2014, Linaro Ltd.
+ *      Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+
+/*
+ * Currently the ACPI 5.1 standard does not define S states in a
+ * manner which is usable for ARM64. These two stubs are sufficient
+ * that system initialises and device PM works.
+ */
+u32 acpi_target_system_state(void)
+{
+	return ACPI_STATE_S0;
+}
+EXPORT_SYMBOL_GPL(acpi_target_system_state);
+
+int __init acpi_sleep_init(void)
+{
+	return -ENOSYS;
+}
-- 
1.9.1

