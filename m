Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259AbaGXHmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:42:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:49639 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbaGXHmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:42:10 -0400
Message-ID: <53D0B8B6.8040104@huawei.com>
Date: Thu, 24 Jul 2014 15:41:42 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>, <mgorman@suse.de>,
        <akpm@linux-foundation.org>, <dave.hansen@intel.com>,
        <zhangyanfei@cn.fujitsu.com>
CC: <wangnan0@huawei.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] memory-hotplug: add sysfs zone_index attribute
References: <1406187138-27911-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1406187138-27911-1-git-send-email-zhenzhang.zhang@huawei.com>
X-Forwarded-Message-Id: <1406187138-27911-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.53D0B8C5.00B8,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: cbe94adc8c0c7bd6a213c2d26cb1c6f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently memory-hotplug has two limits:
1. If the memory block is in ZONE_NORMAL, you can change it to
ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
2. If the memory block is in ZONE_MOVABLE, you can change it to
ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.

Without this patch, we don't know which zone a memory block is in.
So we don't know which memory block is adjacent to ZONE_MOVABLE or
ZONE_NORMAL.

On the other hand, with this patch, we can easy to know newly added
memory is added as ZONE_NORMAL (for powerpc, ZONE_DMA, for x86_32,
ZONE_HIGHMEM).

Updated the related Documentation.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 Documentation/ABI/testing/sysfs-devices-memory |  9 +++++++++
 Documentation/memory-hotplug.txt               |  4 +++-
 drivers/base/memory.c                          | 15 ++++++++++++++-
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index 7405de2..39d3423 100644
--- a/Documentation/ABI/testing/sysfs-devices-memory
+++ b/Documentation/ABI/testing/sysfs-devices-memory
@@ -61,6 +61,15 @@ Users:		hotplug memory remove tools
 		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils


+What:           /sys/devices/system/memory/memoryX/zone_index
+Date:           July 2014
+Contact:	Zhang Zhen <zhenzhang.zhang@huawei.com>
+Description:
+		The file /sys/devices/system/memory/memoryX/zone_index
+		is read-only and is designed to show which zone this memory block is in.
+Users:		hotplug memory remove tools
+		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils			
+
 What:		/sys/devices/system/memoryX/nodeY
 Date:		October 2009
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 45134dc..07019133 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -155,6 +155,7 @@ Under each memory block, you can see 4 files:
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
 /sys/devices/system/memory/memoryXXX/removable
+/sys/devices/system/memory/memoryXXX/zone_index

 'phys_index'      : read-only and contains memory block id, same as XXX.
 'state'           : read-write
@@ -170,6 +171,8 @@ Under each memory block, you can see 4 files:
                     block is removable and a value of 0 indicates that
                     it is not removable. A memory block is removable only if
                     every section in the block is removable.
+'zone_index' 	  : read-only: designed to show which zone this memory block
+		    is in.

 NOTE:
   These directories/files appear after physical memory hotplug phase.
@@ -408,7 +411,6 @@ node if necessary.
   - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
     sysctl or new control file.
   - showing memory block and physical device relationship.
-  - showing memory block is under ZONE_MOVABLE or not
   - test and make it better memory offlining.
   - support HugeTLB page migration and offlining.
   - memmap removing at memory offline.
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 89f752d..3434d97 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -373,11 +373,23 @@ static ssize_t show_phys_device(struct device *dev,
 	return sprintf(buf, "%d\n", mem->phys_device);
 }

+static ssize_t show_mem_zone_index(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct memory_block *mem = to_memory_block(dev);
+	struct page *first_page;
+	struct zone *zone;
+
+	first_page = pfn_to_page(mem->start_section_nr << PFN_SECTION_SHIFT);
+	zone = page_zone(first_page);
+	return sprintf(buf, "%s\n", zone->name);
+}
+
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
 static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
 static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
-
+static DEVICE_ATTR(zone_index, 0444, show_mem_zone_index, NULL);
 /*
  * Block size attribute stuff
  */
@@ -521,6 +533,7 @@ static struct attribute *memory_memblk_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
+	&dev_attr_zone_index.attr,
 	NULL
 };

-- 
1.8.1.2


.




