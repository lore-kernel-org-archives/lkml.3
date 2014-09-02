Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaIBA1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:27:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:61283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaIBA1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,446,1406617200"; 
   d="scan'208";a="474510606"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 5/6] ACPICA: ACPI 5.1: Add support for runtime validation of _DSD package.
Date: Tue,  2 Sep 2014 08:27:33 +0800
Message-Id: <b4aeef74be48f34e44ff898c542436f55c77d717.1409617516.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1409617516.git.lv.zheng@intel.com>
References: <cover.1409617516.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Adds ACPICA kernel runtime support to validate contents/format
of the _DSD package, similar to the iASL support. Ported by
Mika Westerberg.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/nsprepkg.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/acpi/acpica/nsprepkg.c b/drivers/acpi/acpica/nsprepkg.c
index 68f7258..1b13b92 100644
--- a/drivers/acpi/acpica/nsprepkg.c
+++ b/drivers/acpi/acpica/nsprepkg.c
@@ -316,6 +316,45 @@ acpi_ns_check_package(struct acpi_evaluate_info *info,
 		    acpi_ns_check_package_list(info, package, elements, count);
 		break;
 
+	case ACPI_PTYPE2_UUID_PAIR:
+
+		/* The package must contain pairs of (UUID + type) */
+
+		if (count & 1) {
+			expected_count = count + 1;
+			goto package_too_small;
+		}
+
+		while (count > 0) {
+			status = acpi_ns_check_object_type(info, elements,
+							   package->ret_info.
+							   object_type1, 0);
+			if (ACPI_FAILURE(status)) {
+				return (status);
+			}
+
+			/* Validate length of the UUID buffer */
+
+			if ((*elements)->buffer.length != 16) {
+				ACPI_WARN_PREDEFINED((AE_INFO,
+						      info->full_pathname,
+						      info->node_flags,
+						      "Invalid length for UUID Buffer"));
+				return (AE_AML_OPERAND_VALUE);
+			}
+
+			status = acpi_ns_check_object_type(info, elements + 1,
+							   package->ret_info.
+							   object_type2, 0);
+			if (ACPI_FAILURE(status)) {
+				return (status);
+			}
+
+			elements += 2;
+			count -= 2;
+		}
+		break;
+
 	default:
 
 		/* Should not get here if predefined info table is correct */
-- 
1.7.10

