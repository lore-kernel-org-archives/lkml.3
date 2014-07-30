Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaG3EYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:24:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:39279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbaG3EVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="580994404"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 07/17] ACPICA: Utilities: Fix local printf issue.
Date: Wed, 30 Jul 2014 12:21:07 +0800
Message-Id: <b39009df2c06968bc016b992438ea84c1607225a.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug can be reproduced by using a format that do not have the width.prec
specified after a format that have the width.prec specified. The second
formatted output will be wrong. The root cause is acpi_ut_vsnprintf()
doesn't reset the specifiers to the default values.

This patch fixes this issue. BZ 1094. Reported by Yizhe Wang, fixed by
Lv Zheng.

Since acpi_ut_vprintf() is only enabled for specific OSPM now, this patch
doesn't affect Linux kernel.

Reference: https://bugs.acpica.org/show_bug.cgi?id=1094
Reported-and-tested-by: Yizhe Wang <yizhe.wang@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/utprint.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/utprint.c b/drivers/acpi/acpica/utprint.c
index 080e22a..0ce3f5a 100644
--- a/drivers/acpi/acpica/utprint.c
+++ b/drivers/acpi/acpica/utprint.c
@@ -401,6 +401,7 @@ acpi_ut_vsnprintf(char *string,
 
 		/* Process width */
 
+		width = -1;
 		if (ACPI_IS_DIGIT(*format)) {
 			format = acpi_ut_scan_number(format, &number);
 			width = (s32) number;
@@ -415,6 +416,7 @@ acpi_ut_vsnprintf(char *string,
 
 		/* Process precision */
 
+		precision = -1;
 		if (*format == '.') {
 			++format;
 			if (ACPI_IS_DIGIT(*format)) {
@@ -431,6 +433,7 @@ acpi_ut_vsnprintf(char *string,
 
 		/* Process qualifier */
 
+		qualifier = -1;
 		if (*format == 'h' || *format == 'l' || *format == 'L') {
 			qualifier = *format;
 			++format;
-- 
1.7.10

