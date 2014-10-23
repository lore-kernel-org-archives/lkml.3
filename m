Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaJWCMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:12:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:18562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbaJWCMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:12:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,773,1406617200"; 
   d="scan'208";a="618927050"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 3/6] ACPI/OSL: Cleanup memory access functions by merging duplicate code.
Date: Thu, 23 Oct 2014 10:12:16 +0800
Message-Id: <ac6f4ab97c46fab2a4d5580d12a71f154f6a2826.1414029477.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414029477.git.lv.zheng@intel.com>
References: <cover.1414029477.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges duplicate code to cleanup ACPI memory access
implementations. No functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Fei Yang <fei.yang@intel.com>
---
 drivers/acpi/mem.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/mem.c b/drivers/acpi/mem.c
index defd317..ba74086 100644
--- a/drivers/acpi/mem.c
+++ b/drivers/acpi/mem.c
@@ -260,7 +260,6 @@ EXPORT_SYMBOL(acpi_os_map_generic_address);
 void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 {
 	u64 addr;
-	struct acpi_ioremap *map;
 
 	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
@@ -270,16 +269,8 @@ void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 	if (!addr || !gas->bit_width)
 		return;
 
-	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup_phys(addr, gas->bit_width / 8);
-	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
-		return;
-	}
-	acpi_map_put(map);
-	mutex_unlock(&acpi_ioremap_lock);
-
-	acpi_map_cleanup(map);
+	acpi_os_unmap_iomem((void __iomem *)((unsigned long)addr),
+			    gas->bit_width / 8);
 }
 EXPORT_SYMBOL(acpi_os_unmap_generic_address);
 
-- 
1.7.10

