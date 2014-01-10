Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaAJFJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:09:43 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39786 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaAJFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:08:59 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jesse Barker <jesse.barker@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 1/2] ion: Add dummy driver for testing
Date: Thu,  9 Jan 2014 21:08:37 -0800
Message-Id: <1389330518-31919-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389330518-31919-1-git-send-email-john.stultz@linaro.org>
References: <1389330518-31919-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a basic dummy driver to register the ion device
and to install basic SYSTEM and SYSTEM_CONTIG heaps.

This allows for basic testing with ION without having
access to drivers or systems that have been enabled to use
ION.

Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jesse Barker <jesse.barker@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Kconfig            | 10 +++
 drivers/staging/android/ion/Makefile           |  3 +
 drivers/staging/android/ion/ion_dummy_driver.c | 93 ++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)
 create mode 100644 drivers/staging/android/ion/ion_dummy_driver.c

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index a9a64ea..0f8fec1 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -17,6 +17,16 @@ config ION_TEST
 	  Choose this option to create a device that can be used to test the
 	  kernel and device side ION functions.
 
+config ION_DUMMY
+	bool "Dummy Ion driver"
+	depends on ION
+	help
+	  Provides a dummy ION driver that registers the
+	  /dev/ion device and some basic heaps. This can
+	  be used for testing the ION infrastructure if
+	  one doesn't have access to hardware drivers that
+	  use ION.
+
 config ION_TEGRA
 	tristate "Ion for Tegra"
 	depends on ARCH_TEGRA && ION
diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index 75039b9..b56fd2b 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -4,4 +4,7 @@ obj-$(CONFIG_ION_TEST) += ion_test.o
 ifdef CONFIG_COMPAT
 obj-$(CONFIG_ION) += compat_ion.o
 endif
+
+obj-$(CONFIG_ION_DUMMY) += ion_dummy_driver.o
 obj-$(CONFIG_ION_TEGRA) += tegra/
+
diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
new file mode 100644
index 0000000..6749d29
--- /dev/null
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -0,0 +1,93 @@
+/*
+ * drivers/gpu/ion/ion_dummy_driver.c
+ *
+ * Copyright (C) 2013 Linaro, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/sizes.h>
+#include "ion.h"
+#include "ion_priv.h"
+
+struct ion_device *idev;
+struct ion_heap **heaps;
+
+struct ion_platform_heap dummy_heaps[] = {
+		{
+			.id	= ION_HEAP_TYPE_SYSTEM,
+			.type	= ION_HEAP_TYPE_SYSTEM,
+			.name	= "system",
+		},
+		{
+			.id	= ION_HEAP_TYPE_SYSTEM_CONTIG,
+			.type	= ION_HEAP_TYPE_SYSTEM_CONTIG,
+			.name	= "system contig",
+		},
+};
+
+struct ion_platform_data dummy_ion_pdata = {
+	.nr = 2,
+	.heaps = dummy_heaps,
+};
+
+static int __init ion_dummy_init(void)
+{
+	int i, err;
+
+	idev = ion_device_create(NULL);
+	heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
+			GFP_KERNEL);
+	if (!heaps)
+		return PTR_ERR(heaps);
+
+	for (i = 0; i < dummy_ion_pdata.nr; i++) {
+		struct ion_platform_heap *heap_data = &dummy_ion_pdata.heaps[i];
+
+		heaps[i] = ion_heap_create(heap_data);
+		if (IS_ERR_OR_NULL(heaps[i])) {
+			err = PTR_ERR(heaps[i]);
+			goto err;
+		}
+		ion_device_add_heap(idev, heaps[i]);
+	}
+	return 0;
+err:
+	for (i = 0; i < dummy_ion_pdata.nr; i++) {
+		if (heaps[i])
+			ion_heap_destroy(heaps[i]);
+	}
+	kfree(heaps);
+
+	return err;
+}
+
+static void __exit ion_dummy_exit(void)
+{
+	int i;
+
+	ion_device_destroy(idev);
+
+	for (i = 0; i < dummy_ion_pdata.nr; i++)
+		ion_heap_destroy(heaps[i]);
+	kfree(heaps);
+
+	return;
+}
+
+module_init(ion_dummy_init);
+module_exit(ion_dummy_exit);
+
-- 
1.8.3.2

