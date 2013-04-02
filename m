Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891Ab3DBQ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:29:08 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:23937 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965Ab3DBQ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:29:05 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/3] Support memory hot-delete to boot memory
Date: Tue,  2 Apr 2013 10:17:27 -0600
Message-Id: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hot-delete a memory range present at boot causes an
error message in __release_region(), such as:

 Trying to free nonexistent resource <0000000070000000-0000000077ffffff>

Hot-delete operation still continues since __release_region() is 
a void function, but the target memory range is not freed from
iomem_resource as the result.  This also leads a failure in a 
subsequent hot-add operation to the same memory range since the
address range is still in-use in iomem_resource.

This problem happens because the granularity of memory resource ranges
may be different between boot and hot-delete.  During bootup,
iomem_resource is set up from the boot descriptor table, such as EFI
Memory Table and e820.  Each resource entry usually covers the whole
contiguous memory range.  Hot-delete request, on the other hand, may
target to a particular range of memory resource, and its size can be
much smaller than the whole contiguous memory.  Since the existing
release interfaces like __release_region() require a requested region
to be exactly matched to a resource entry, they do not allow a partial
resource to be released.

This patchset introduces release_mem_region_adjustable() for memory
hot-delete operations, which allows releasing a partial memory range
and adjusts remaining resource accordingly.  This patchset makes no
changes to the existing interfaces since their restriction is still
valid for I/O resources.

---
Toshi Kani (3):
 resource: Add __adjust_resource() for internal use
 resource: Add release_mem_region_adjustable()
 mm: Change __remove_pages() to call release_mem_region_adjustable()

---
 include/linux/ioport.h |   2 +
 kernel/resource.c      | 122 +++++++++++++++++++++++++++++++++++++++++++------
 mm/memory_hotplug.c    |  11 ++++-
 3 files changed, 120 insertions(+), 15 deletions(-)
