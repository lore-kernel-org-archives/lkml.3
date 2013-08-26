Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3HZKhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:37:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42783 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab3HZKhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:37:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,957,1367942400"; 
   d="scan'208";a="8305162"
Message-ID: <521B2ED2.2010501@cn.fujitsu.com>
Date: Mon, 26 Aug 2013 18:32:50 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH] drivers/base/memory.c: introduce help macro to_memory_block
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/26 18:35:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/26 18:35:13,
	Serialize complete at 2013/08/26 18:35:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce help macro to_memory_block to hide the conversion(device-->memory_block),
just clean up.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/base/memory.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2b7813e..4a874c6 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -30,6 +30,8 @@ static DEFINE_MUTEX(mem_sysfs_mutex);
 
 #define MEMORY_CLASS_NAME	"memory"
 
+#define to_memory_block(dev) container_of(dev, struct memory_block, dev)
+
 static int sections_per_block;
 
 static inline int base_memory_block_id(int section_nr)
@@ -77,7 +79,7 @@ EXPORT_SYMBOL(unregister_memory_isolate_notifier);
 
 static void memory_block_release(struct device *dev)
 {
-	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 
 	kfree(mem);
 }
@@ -110,8 +112,7 @@ static unsigned long get_memory_block_size(void)
 static ssize_t show_mem_start_phys_index(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	unsigned long phys_index;
 
 	phys_index = mem->start_section_nr / sections_per_block;
@@ -121,8 +122,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
 static ssize_t show_mem_end_phys_index(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	unsigned long phys_index;
 
 	phys_index = mem->end_section_nr / sections_per_block;
@@ -137,8 +137,7 @@ static ssize_t show_mem_removable(struct device *dev,
 {
 	unsigned long i, pfn;
 	int ret = 1;
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 
 	for (i = 0; i < sections_per_block; i++) {
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
@@ -154,8 +153,7 @@ static ssize_t show_mem_removable(struct device *dev,
 static ssize_t show_mem_state(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	ssize_t len = 0;
 
 	/*
@@ -280,7 +278,7 @@ static int __memory_block_change_state(struct memory_block *mem,
 
 static int memory_subsys_online(struct device *dev)
 {
-	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	int ret;
 
 	mutex_lock(&mem->state_mutex);
@@ -295,7 +293,7 @@ static int memory_subsys_online(struct device *dev)
 
 static int memory_subsys_offline(struct device *dev)
 {
-	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	int ret;
 
 	mutex_lock(&mem->state_mutex);
@@ -349,7 +347,7 @@ store_mem_state(struct device *dev,
 	bool offline;
 	int ret = -EINVAL;
 
-	mem = container_of(dev, struct memory_block, dev);
+	mem = to_memory_block(dev);
 
 	lock_device_hotplug();
 
@@ -392,8 +390,7 @@ store_mem_state(struct device *dev,
 static ssize_t show_phys_device(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
@@ -525,7 +522,7 @@ struct memory_block *find_memory_block_hinted(struct mem_section *section,
 		put_device(&hint->dev);
 	if (!dev)
 		return NULL;
-	return container_of(dev, struct memory_block, dev);
+	return to_memory_block(dev);
 }
 
 /*
-- 
1.7.7

