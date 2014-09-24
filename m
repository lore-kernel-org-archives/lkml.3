Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaIXJRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:17:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:55243 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaIXJGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="596081705"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Will Arthur <will.c.arthur@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 02/12] tpm: TPM2 support for tpm_calc_ordinal_durations()
Date: Wed, 24 Sep 2014 12:05:52 +0300
Message-Id: <1411549562-24242-3-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Arthur <will.c.arthur@intel.com>

Implemented TPM2 support for tpm_calc_ordinal_duration(). TPM2 version
is encapsulated into tpm2_calc_ordinal_duration() that is called by
tpm_calc_ordinal_duration() for TPM2 chips.

[jarkko.sakkinen: implemented tpm2_calc_ordinal_duration() based on
 the Wills original patch. Updated durations table to use worst case
 estimates.]

Signed-off-by: Will Arthur <will.c.arthur@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-interface.c |   7 +-
 drivers/char/tpm/tpm.h           |   1 +
 drivers/char/tpm/tpm2-commands.c | 159 +++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          |  26 +++++++
 5 files changed, 193 insertions(+), 2 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-commands.c
 create mode 100644 drivers/char/tpm/tpm2.h

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 837da04..5ff5f3d 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-commands.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 3c54570..07a2fc5 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -309,7 +309,12 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 {
 	int duration_idx = TPM_UNDEFINED;
 	int duration = 0;
-	u8 category = (ordinal >> 24) & 0xFF;
+	u8 category;
+
+	if (chip->tpm2)
+		return tpm2_calc_ordinal_duration(chip, ordinal);
+
+	category = (ordinal >> 24) & 0xFF;
 
 	if ((category == TPM_PROTECTED_COMMAND && ordinal < TPM_MAX_ORDINAL) ||
 	    (category == TPM_CONNECTION_COMMAND && ordinal < TSC_MAX_ORDINAL))
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index cc95a52..bda88aa 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/tpm.h>
+#include "tpm2.h"
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
new file mode 100644
index 0000000..14b3ae7
--- /dev/null
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -0,0 +1,159 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This file contains TPM2 protocol implementations of the commands
+ * used by the kernel internally.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include "tpm.h"
+
+/*
+ * Array with one entry per ordinal defining the maximum amount
+ * of time the chip could take to return the result. The values
+ * of the SHORT, MEDIUM, and LONG durations are retrieved from 
+ * the chip during initialization with a call to tpm_get_timeouts.
+ */
+static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
+	TPM_UNDEFINED,		/* 11F */
+	TPM_UNDEFINED,		/* 120 */
+	TPM_LONG,		/* 121 */
+	TPM_UNDEFINED,		/* 122 */
+	TPM_UNDEFINED,		/* 123 */
+	TPM_UNDEFINED,		/* 124 */
+	TPM_UNDEFINED,		/* 125 */
+	TPM_UNDEFINED,		/* 126 */
+	TPM_UNDEFINED,		/* 127 */
+	TPM_UNDEFINED,		/* 128 */
+	TPM_LONG,		/* 129 */
+	TPM_UNDEFINED,		/* 12a */
+	TPM_UNDEFINED,		/* 12b */
+	TPM_UNDEFINED,		/* 12c */
+	TPM_UNDEFINED,		/* 12d */
+	TPM_UNDEFINED,		/* 12e */
+	TPM_UNDEFINED,		/* 12f */
+	TPM_UNDEFINED,		/* 130 */
+	TPM_UNDEFINED,		/* 131 */
+	TPM_UNDEFINED,		/* 132 */
+	TPM_UNDEFINED,		/* 133 */
+	TPM_UNDEFINED,		/* 134 */
+	TPM_UNDEFINED,		/* 135 */
+	TPM_UNDEFINED,		/* 136 */
+	TPM_UNDEFINED,		/* 137 */
+	TPM_UNDEFINED,		/* 138 */
+	TPM_UNDEFINED,		/* 139 */
+	TPM_UNDEFINED,		/* 13a */
+	TPM_UNDEFINED,		/* 13b */
+	TPM_UNDEFINED,		/* 13c */
+	TPM_UNDEFINED,		/* 13d */
+	TPM_MEDIUM,		/* 13e */
+	TPM_UNDEFINED,		/* 13f */
+	TPM_UNDEFINED,		/* 140 */
+	TPM_UNDEFINED,		/* 141 */
+	TPM_UNDEFINED,		/* 142 */
+	TPM_LONG,		/* 143 */
+	TPM_MEDIUM,		/* 144 */
+	TPM_UNDEFINED,		/* 145 */
+	TPM_UNDEFINED,		/* 146 */
+	TPM_UNDEFINED,		/* 147 */
+	TPM_UNDEFINED,		/* 148 */
+	TPM_UNDEFINED,		/* 149 */
+	TPM_UNDEFINED,		/* 14a */
+	TPM_UNDEFINED,		/* 14b */
+	TPM_UNDEFINED,		/* 14c */
+	TPM_UNDEFINED,		/* 14d */
+	TPM_LONG,		/* 14e */
+	TPM_UNDEFINED,		/* 14f */
+	TPM_UNDEFINED,		/* 150 */
+	TPM_UNDEFINED,		/* 151 */
+	TPM_UNDEFINED,		/* 152 */
+	TPM_UNDEFINED,		/* 153 */
+	TPM_UNDEFINED,		/* 154 */
+	TPM_UNDEFINED,		/* 155 */
+	TPM_UNDEFINED,		/* 156 */
+	TPM_UNDEFINED,		/* 157 */
+	TPM_UNDEFINED,		/* 158 */
+	TPM_UNDEFINED,		/* 159 */
+	TPM_UNDEFINED,		/* 15a */
+	TPM_UNDEFINED,		/* 15b */
+	TPM_MEDIUM,		/* 15c */
+	TPM_UNDEFINED,		/* 15d */
+	TPM_UNDEFINED,		/* 15e */
+	TPM_UNDEFINED,		/* 15f */
+	TPM_UNDEFINED,		/* 160 */
+	TPM_UNDEFINED,		/* 161 */
+	TPM_UNDEFINED,		/* 162 */
+	TPM_UNDEFINED,		/* 163 */
+	TPM_UNDEFINED,		/* 164 */
+	TPM_UNDEFINED,		/* 165 */
+	TPM_UNDEFINED,		/* 166 */
+	TPM_UNDEFINED,		/* 167 */
+	TPM_UNDEFINED,		/* 168 */
+	TPM_UNDEFINED,		/* 169 */
+	TPM_UNDEFINED,		/* 16a */
+	TPM_UNDEFINED,		/* 16b */
+	TPM_UNDEFINED,		/* 16c */
+	TPM_UNDEFINED,		/* 16d */
+	TPM_UNDEFINED,		/* 16e */
+	TPM_UNDEFINED,		/* 16f */
+	TPM_UNDEFINED,		/* 170 */
+	TPM_UNDEFINED,		/* 171 */
+	TPM_UNDEFINED,		/* 172 */
+	TPM_UNDEFINED,		/* 173 */
+	TPM_UNDEFINED,		/* 174 */
+	TPM_UNDEFINED,		/* 175 */
+	TPM_UNDEFINED,		/* 176 */
+	TPM_LONG,		/* 177 */
+	TPM_UNDEFINED,		/* 178 */
+	TPM_UNDEFINED,		/* 179 */
+	TPM_MEDIUM,		/* 17a */
+	TPM_LONG,		/* 17b */
+	TPM_UNDEFINED,		/* 17c */
+	TPM_UNDEFINED,		/* 17d */
+	TPM_UNDEFINED,		/* 17e */
+	TPM_UNDEFINED,		/* 17f */
+	TPM_UNDEFINED,		/* 180 */
+	TPM_UNDEFINED,		/* 181 */
+	TPM_MEDIUM,		/* 182 */
+	TPM_UNDEFINED,		/* 183 */
+	TPM_UNDEFINED,		/* 184 */
+	TPM_MEDIUM,		/* 185 */
+	TPM_MEDIUM,		/* 186 */
+	TPM_UNDEFINED,		/* 187 */
+	TPM_UNDEFINED,		/* 188 */
+	TPM_UNDEFINED,		/* 189 */
+	TPM_UNDEFINED,		/* 18a */
+	TPM_UNDEFINED,		/* 18b */
+	TPM_UNDEFINED,		/* 18c */
+	TPM_UNDEFINED,		/* 18d */
+	TPM_UNDEFINED,		/* 18e */
+	TPM_UNDEFINED		/* 18f */
+};
+
+/*
+ * Returns max number of jiffies to wait
+ */
+unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
+{
+	int index = TPM_UNDEFINED;
+	int duration = 0;
+
+	if (ordinal >= TPM2_CC_FIRST && ordinal <= TPM2_CC_LAST)
+		index = tpm2_ordinal_duration[ordinal - TPM2_CC_FIRST];
+
+	if (index != TPM_UNDEFINED)
+		duration = chip->vendor.duration[index];
+	if (duration <= 0)
+		return 2 * 60 * HZ;
+	else
+		return duration;
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
new file mode 100644
index 0000000..dc0a2a2
--- /dev/null
+++ b/drivers/char/tpm/tpm2.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+
+#ifndef __DRIVERS_CHAR_TPM2_H__
+#define __DRIVERS_CHAR_TPM2_H__
+
+struct tpm_chip;
+
+#define TPM2_CC_FIRST	0x11F
+#define TPM2_CC_LAST	0x18F
+
+unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
+
+#endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

