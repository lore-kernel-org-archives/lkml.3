Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaCMWwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:52:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60889 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbaCMWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:48:12 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, catalin.marinas@arm.com,
        matt.fleming@intel.com
Cc: msalter@redhat.com, roy.franz@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 08/15] efi: Add get_dram_base() helper function
Date: Thu, 13 Mar 2014 22:47:01 +0000
Message-Id: <1394750828-16351-9-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Franz <roy.franz@linaro.org>

Add the get_dram_base() function, shared by arm/arm64.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4c8ab86..4a9986b 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -11,6 +11,10 @@
  */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -92,6 +96,32 @@ fail:
 	return status;
 }
 
+
+static unsigned long __init get_dram_base(efi_system_table_t *sys_table)
+{
+	efi_status_t status;
+	unsigned long map_size;
+	unsigned long membase  = EFI_ERROR;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
+
+	status = efi_get_memory_map(sys_table, (efi_memory_desc_t **)&map.map,
+				    &map_size, &map.desc_size, NULL, NULL);
+	if (status != EFI_SUCCESS)
+		return membase;
+
+	map.map_end = map.map + map_size;
+
+	for_each_efi_memory_desc(&map, md)
+		if (md->attribute & EFI_MEMORY_WB)
+			if (membase > md->phys_addr)
+				membase = md->phys_addr;
+
+	efi_call_phys1(sys_table->boottime->free_pool, map.map);
+
+	return membase;
+}
+
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-- 
1.7.10.4

