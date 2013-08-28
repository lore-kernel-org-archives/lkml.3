Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3H1Gmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:42:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab3H1Gms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:42:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,974,1367942400"; 
   d="scan'208";a="8328572"
Message-ID: <521D9AE3.5010808@cn.fujitsu.com>
Date: Wed, 28 Aug 2013 14:38:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH RESEND] drivers/base/memory.c: introduce help macro to_memory_block
References: <521B2ED2.2010501@cn.fujitsu.com> <20130828055253.GA22776@kroah.com>
In-Reply-To: <20130828055253.GA22776@kroah.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/28 14:40:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/28 14:40:48,
	Serialize complete at 2013/08/28 14:40:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce help macro to_memory_block to hide the conversion(device-->memory_block),
just clean up.

Reviewed-by: Yasuaki Ishimatsu  <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/base/memory.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2a38cd2..69e09a1 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -29,6 +29,8 @@ static DEFINE_MUTEX(mem_sysfs_mutex);
 
 #define MEMORY_CLASS_NAME	"memory"
 
+#define to_memory_block(dev) container_of(dev, struct memory_block, dev)
+
 static int sections_per_block;
 
 static inline int base_memory_block_id(int section_nr)
@@ -76,7 +78,7 @@ EXPORT_SYMBOL(unregister_memory_isolate_notifier);
 
 static void memory_block_release(struct device *dev)
 {
-	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 
 	kfree(mem);
 }
@@ -109,8 +111,7 @@ static unsigned long get_memory_block_size(void)
 static ssize_t show_mem_start_phys_index(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	unsigned long phys_index;
 
 	phys_index = mem->start_section_nr / sections_per_block;
@@ -120,8 +121,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
 static ssize_t show_mem_end_phys_index(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	unsigned long phys_index;
 
 	phys_index = mem->end_section_nr / sections_per_block;
@@ -136,8 +136,7 @@ static ssize_t show_mem_removable(struct device *dev,
 {
 	unsigned long i, pfn;
 	int ret = 1;
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 
 	for (i = 0; i < sections_per_block; i++) {
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
@@ -153,8 +152,7 @@ static ssize_t show_mem_removable(struct device *dev,
 static ssize_t show_mem_state(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	ssize_t len = 0;
 
 	/*
@@ -282,7 +280,7 @@ static int memory_block_change_state(struct memory_block *mem,
 /* The device lock serializes operations on memory_subsys_[online|offline] */
 static int memory_subsys_online(struct device *dev)
 {
-	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	int ret;
 
 	if (mem->state == MEM_ONLINE)
@@ -306,7 +304,7 @@ static int memory_subsys_online(struct device *dev)
 
 static int memory_subsys_offline(struct device *dev)
 {
-	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 
 	if (mem->state == MEM_OFFLINE)
 		return 0;
@@ -318,11 +316,9 @@ static ssize_t
 store_mem_state(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct memory_block *mem;
+	struct memory_block *mem = to_memory_block(dev);
 	int ret, online_type;
 
-	mem = container_of(dev, struct memory_block, dev);
-
 	lock_device_hotplug();
 
 	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
@@ -376,8 +372,7 @@ store_mem_state(struct device *dev,
 static ssize_t show_phys_device(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, dev);
+	struct memory_block *mem = to_memory_block(dev);
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
@@ -509,7 +504,7 @@ struct memory_block *find_memory_block_hinted(struct mem_section *section,
 		put_device(&hint->dev);
 	if (!dev)
 		return NULL;
-	return container_of(dev, struct memory_block, dev);
+	return to_memory_block(dev);
 }
 
 /*
-- 
1.7.7


