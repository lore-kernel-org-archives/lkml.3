Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965255Ab3DJR3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:29:35 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29149 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965200Ab3DJR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:29:34 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        linuxram@us.ibm.com, guz.fnst@cn.fujitsu.com, tmac@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 0/3] Support memory hot-delete to boot memory
Date: Wed, 10 Apr 2013 11:16:58 -0600
Message-Id: <1365614221-685-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hot-delete to a memory range present at boot causes an
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
v3:
- Added #ifdef CONFIG_MEMORY_HOTPLUG to release_mem_region_adjustable()
  as suggested by Andrew Morton.  This #ifdef will be changed to
  CONFIG_MEMORY_HOTREMOVE after David Rientjes's patch gets accepted.
- Updated comments & change log of release_mem_region_adjustable()
  per code reviews from Ram Pai and Andrew Morton. 

v2:
- Updated release_mem_region_adjustable() per code reviews from
  Yasuaki Ishimatsu, Ram Pai and Gu Zheng. 

---
Toshi Kani (3):
 resource: Add __adjust_resource() for internal use
 resource: Add release_mem_region_adjustable()
 mm: Change __remove_pages() to call release_mem_region_adjustable()

---
 include/linux/ioport.h |   4 ++
 kernel/resource.c      | 135 ++++++++++++++++++++++++++++++++++++++++++++-----
 mm/memory_hotplug.c    |  11 +++-
 3 files changed, 135 insertions(+), 15 deletions(-)

