Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaD3CIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:08:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:36761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbaD3CF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="532135384"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
Date: Wed, 30 Apr 2014 10:05:40 +0800
Message-Id: <c226eed72699ee1934426074b9d1c902ccfa0b48.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit of back porting Linux XSDT validation mechanism has introduced
a regreession:
  Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
  Subject: ACPICA: Back port and refine validation of the XSDT root table.
There is a pointer still accessed after unmapping.

This patch fixes this issue.  Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
Buglink: https://bugs.archlinux.org/task/39811
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
---
 drivers/acpi/acpica/tbutils.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 6c31d77..e1638ad 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -355,6 +355,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	u32 table_count;
 	struct acpi_table_header *table;
 	acpi_physical_address address;
+	acpi_physical_address rsdt_address;
 	u32 length;
 	u8 *table_entry;
 	acpi_status status;
@@ -383,11 +384,14 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 		 * as per the ACPI specification.
 		 */
 		address = (acpi_physical_address) rsdp->xsdt_physical_address;
+		rsdt_address =
+		    (acpi_physical_address) rsdp->rsdt_physical_address;
 		table_entry_size = ACPI_XSDT_ENTRY_SIZE;
 	} else {
 		/* Root table is an RSDT (32-bit physical addresses) */
 
 		address = (acpi_physical_address) rsdp->rsdt_physical_address;
+		rsdt_address = address;
 		table_entry_size = ACPI_RSDT_ENTRY_SIZE;
 	}
 
@@ -410,8 +414,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 
 			/* Fall back to the RSDT */
 
-			address =
-			    (acpi_physical_address) rsdp->rsdt_physical_address;
+			address = rsdt_address;
 			table_entry_size = ACPI_RSDT_ENTRY_SIZE;
 		}
 	}
-- 
1.7.10

