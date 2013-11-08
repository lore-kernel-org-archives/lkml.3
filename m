Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3KHXng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:43:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53196 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab3KHXnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:43:32 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 02/24] mm/memblock: debug: don't free reserved array if !ARCH_DISCARD_MEMBLOCK
Date: Fri, 8 Nov 2013 18:41:38 -0500
Message-ID: <1383954120-24368-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Now the Nobootmem allocator will always try to free memory allocated for
reserved memory regions (free_low_memory_core_early()) without taking
into to account current memblock debugging configuration
(CONFIG_ARCH_DISCARD_MEMBLOCK and CONFIG_DEBUG_FS state).
As result if:
 - CONFIG_DEBUG_FS defined
 - CONFIG_ARCH_DISCARD_MEMBLOCK not defined;
-  reserved memory regions array have been resized during boot

then:
- memory allocated for reserved memory regions array will be freed to
buddy allocator;
- debug_fs entry "sys/kernel/debug/memblock/reserved" will show garbage
instead of state of memory reservations. like:
   0: 0x98393bc0..0x9a393bbf
   1: 0xff120000..0xff11ffff
   2: 0x00000000..0xffffffff

Hence, do not free memory allocated for reserved memory regions if
defined(CONFIG_DEBUG_FS) && !defined(CONFIG_ARCH_DISCARD_MEMBLOCK).

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/memblock.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index e03918e..88a6a0e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -167,6 +167,19 @@ phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
 		return 0;
 
+	/*
+	 * Don't allow Nobootmem allocator to free reserved memory regions
+	 * array if
+	 *  - CONFIG_DEBUG_FS is enabled;
+	 *  - CONFIG_ARCH_DISCARD_MEMBLOCK is not enabled;
+	 *  - reserved memory regions array have been resized during boot.
+	 * Otherwise debug_fs entry "sys/kernel/debug/memblock/reserved"
+	 * will show garbage instead of state of memory reservations.
+	 */
+	if (IS_ENABLED(CONFIG_DEBUG_FS) &&
+	    !IS_ENABLED(CONFIG_ARCH_DISCARD_MEMBLOCK))
+		return 0;
+
 	*addr = __pa(memblock.reserved.regions);
 
 	return PAGE_ALIGN(sizeof(struct memblock_region) *
-- 
1.7.9.5

