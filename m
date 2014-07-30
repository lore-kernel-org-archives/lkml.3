Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaG3EVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:21:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:53343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbaG3EVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551068048"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 09/17] ACPICA: Debug object: Add current value of Timer() to debug line prefix.
Date: Wed, 30 Jul 2014 12:21:19 +0800
Message-Id: <0370f9c08e7e1853ca121e0b7e7b621a9a617e1b.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Simplifies timing of things like control method execution.

[zetalog: fixing 64-bit division link error]

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/exdebug.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/exdebug.c b/drivers/acpi/acpica/exdebug.c
index 4cfc3d3..6fbfad4 100644
--- a/drivers/acpi/acpica/exdebug.c
+++ b/drivers/acpi/acpica/exdebug.c
@@ -75,6 +75,7 @@ acpi_ex_do_debug_object(union acpi_operand_object *source_desc,
 			u32 level, u32 index)
 {
 	u32 i;
+	u32 timer;
 
 	ACPI_FUNCTION_TRACE_PTR(ex_do_debug_object, source_desc);
 
@@ -86,11 +87,19 @@ acpi_ex_do_debug_object(union acpi_operand_object *source_desc,
 	}
 
 	/*
+	 * We will emit the current timer value (in microseconds) with each
+	 * debug output. Only need the lower 26 bits. This allows for 67
+	 * million microseconds or 67 seconds before rollover.
+	 */
+	timer = ((u32)acpi_os_get_timer() / 10);	/* (100 nanoseconds to microseconds) */
+	timer &= 0x03FFFFFF;
+
+	/*
 	 * Print line header as long as we are not in the middle of an
 	 * object display
 	 */
 	if (!((level > 0) && index == 0)) {
-		acpi_os_printf("[ACPI Debug] %*s", level, " ");
+		acpi_os_printf("[ACPI Debug %.8u] %*s", timer, level, " ");
 	}
 
 	/* Display the index for package output only */
-- 
1.7.10

