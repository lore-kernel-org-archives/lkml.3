Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbaH0LST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:18:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:29199 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbaH0LSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:18:18 -0400
Message-ID: <53FDBE6B.8070100@huawei.com>
Date: Wed, 27 Aug 2014 19:18:03 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>
CC: <wangnan0@huawei.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] memory-hotplug: rename zones_online_to to valid_zones
References: <1409124238-18635-1-git-send-email-zhenzhang.zhang@huawei.com> <53FDBDF0.5000200@huawei.com>
In-Reply-To: <53FDBDF0.5000200@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.53FDBE77.00D3,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 3dfce68b747046d15ca2a57da54e59df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the interface to valid_zones according to most pepole's
suggestion.

Sample output of the sysfs files:
	memory0/valid_zones: none
	memory1/valid_zones: DMA32
	memory2/valid_zones: DMA32
	memory3/valid_zones: DMA32
	memory4/valid_zones: Normal
	memory5/valid_zones: Normal
	memory6/valid_zones: Normal Movable
	memory7/valid_zones: Movable Normal
	memory8/valid_zones: Movable

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 Documentation/ABI/testing/sysfs-devices-memory |  8 ++++----
 Documentation/memory-hotplug.txt               | 13 ++++++++++---
 drivers/base/memory.c                          |  6 +++---
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index 2b2a1d7..deef3b5 100644
--- a/Documentation/ABI/testing/sysfs-devices-memory
+++ b/Documentation/ABI/testing/sysfs-devices-memory
@@ -61,13 +61,13 @@ Users:		hotplug memory remove tools
 		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils


-What:           /sys/devices/system/memory/memoryX/zones_online_to
+What:           /sys/devices/system/memory/memoryX/valid_zones
 Date:           July 2014
 Contact:	Zhang Zhen <zhenzhang.zhang@huawei.com>
 Description:
-		The file /sys/devices/system/memory/memoryX/zones_online_to
-		is read-only and is designed to show which zone this memory block can
-		be onlined to.
+		The file /sys/devices/system/memory/memoryX/valid_zones	is
+		read-only and is designed to show which zone this memory
+		block can be onlined to.

 What:		/sys/devices/system/memoryX/nodeY
 Date:		October 2009
diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 5b34e33..93a25ef 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -155,7 +155,7 @@ Under each memory block, you can see 4 files:
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
 /sys/devices/system/memory/memoryXXX/removable
-/sys/devices/system/memory/memoryXXX/zones_online_to
+/sys/devices/system/memory/memoryXXX/valid_zones

 'phys_index'      : read-only and contains memory block id, same as XXX.
 'state'           : read-write
@@ -171,8 +171,15 @@ Under each memory block, you can see 4 files:
                     block is removable and a value of 0 indicates that
                     it is not removable. A memory block is removable only if
                     every section in the block is removable.
-'zones_online_to' : read-only: designed to show which zone this memory block
-		    can be onlined to.
+'valid_zones'     : read-only: designed to show which zones this memory block
+		    can be onlined to.
+		    The first column shows it's default zone.
+		    "memory6/valid_zones: Normal Movable" shows this memoryblock
+		    can be onlined to ZONE_NORMAL by default and to ZONE_MOVABLE
+		    by online_movable.
+		    "memory7/valid_zones: Movable Normal" shows this memoryblock
+		    can be onlined to ZONE_MOVABLE by default and to ZONE_NORMAL
+		    by online_kernel.

 NOTE:
   These directories/files appear after physical memory hotplug phase.
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 0fc1d25..efd456c 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -374,7 +374,7 @@ static ssize_t show_phys_device(struct device *dev,
 }

 #ifdef CONFIG_MEMORY_HOTREMOVE
-static ssize_t show_zones_online_to(struct device *dev,
+static ssize_t show_valid_zones(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem = to_memory_block(dev);
@@ -409,7 +409,7 @@ static ssize_t show_zones_online_to(struct device *dev,

 	return sprintf(buf, "%s\n", zone->name);
 }
-static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
+static DEVICE_ATTR(valid_zones, 0444, show_valid_zones, NULL);
 #endif

 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
@@ -563,7 +563,7 @@ static struct attribute *memory_memblk_attrs[] = {
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
 #ifdef CONFIG_MEMORY_HOTREMOVE
-	&dev_attr_zones_online_to.attr,
+	&dev_attr_valid_zones.attr,
 #endif
 	NULL
 };
-- 1.8.1.4

