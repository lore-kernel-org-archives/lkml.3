Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaIIPsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:48:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63518 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaIIPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:48:37 -0400
Message-ID: <540F2152.4070406@plexistor.com>
Date: Tue, 09 Sep 2014 18:48:34 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org, Toshi Kani <toshi.kani@hp.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] pmem: Add support for page structs
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

One of the current shortcomings of the NVDIMM/PMEM
support is that this memory does not have a page-struct(s)
associated with its memory and therefor cannot be passed
to a block-device or network or DMAed in any way through
another device in the system.

The use of add_persistent_memory() fixes all this. After this patch
an FS can do:
	bdev_direct_access(,&pfn,);
	page = pfn_to_page(pfn);
And use that page for a lock_page(), set_page_dirty(), and/or
anything else one might do with a page *.
(Note that with brd one can already do this)

[pmem-pages-ref-count]
pmem will serve it's pages with ref==0. Once an FS does
an blkdev_get_XXX(,FMODE_EXCL,), that memory is own by the FS.
The FS needs to manage its allocation, just as it already does
for its disk blocks. The fs should set page->count = 2, before
submission to any Kernel subsystem so when it returns it will
never be released to the Kernel's page-allocators. (page_freeze)

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/Kconfig | 13 +++++++++++++
 drivers/block/pmem.c  | 19 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 5da8cbf..8a5929c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -416,6 +416,19 @@ config BLK_DEV_PMEM
 	  Most normal users won't need this functionality, and can thus say N
 	  here.
 
+config BLK_DEV_PMEM_USE_PAGES
+	bool "Enable use of page struct pages with pmem"
+	depends on BLK_DEV_PMEM
+	depends on PERSISTENT_MEMORY_DEPENDENCY
+	select DRIVER_NEEDS_PERSISTENT_MEMORY
+	default y
+	help
+	  If a user of PMEM device needs "struct page" associated
+	  with its memory, so this memory can be sent to other
+	  block devices, or sent on the network, or be DMA transferred
+	  to other devices in the system, then you must say "Yes" here.
+	  If unsure leave as Yes.
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index e07a373..b415b61 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -221,6 +221,23 @@ MODULE_PARM_DESC(map,
 static LIST_HEAD(pmem_devices);
 static int pmem_major;
 
+#ifdef CONFIG_BLK_DEV_PMEM_USE_PAGES
+/* pmem->phys_addr and pmem->size need to be set.
+ * Will then set pmem->virt_addr if successful.
+ */
+int pmem_mapmem(struct pmem_device *pmem)
+{
+	return add_persistent_memory(pmem->phys_addr, pmem->size,
+				     &pmem->virt_addr);
+}
+
+static void pmem_unmapmem(struct pmem_device *pmem)
+{
+	remove_persistent_memory(pmem->phys_addr, pmem->size);
+}
+
+#else /* !CONFIG_BLK_DEV_PMEM_USE_PAGES */
+
 /* pmem->phys_addr and pmem->size need to be set.
  * Will then set virt_addr if successful.
  */
@@ -258,6 +275,8 @@ void pmem_unmapmem(struct pmem_device *pmem)
 	release_mem_region(pmem->phys_addr, pmem->size);
 	pmem->virt_addr = NULL;
 }
+#endif /* ! CONFIG_BLK_DEV_PMEM_USE_PAGES */
+
 
 static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
 				      int i)
-- 
1.9.3


