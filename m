Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3GXUvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:51:45 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:44177
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3GXUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:51:43 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com, dave@sr71.net
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: base: memory: Export functionality for "in kernel" onlining of memory
Date: Wed, 24 Jul 2013 14:29:58 -0700
Message-Id: <1374701399-30842-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1374701355-30799-1-git-send-email-kys@microsoft.com>
References: <1374701355-30799-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current machinery for hot-adding memory requires having user
level to bring the memory segments online. Export the necessary functionality
to bring the memory segment online without involving user space code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/base/memory.c  |   35 +++++++++++++++++++++++++++++++++++
 include/linux/memory.h |    5 +++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2b7813e..a7140b3 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -541,6 +541,41 @@ struct memory_block *find_memory_block(struct mem_section *section)
 	return find_memory_block_hinted(section, NULL);
 }
 
+/*
+ * Given the start pfn of a memory block; bring the memory
+ * block online. This API would be useful for drivers that may
+ * want to bring "online" the memory that has been hot-added.
+ */
+
+int online_memory_block(unsigned long start_pfn)
+{
+	struct mem_section *cur_section;
+	struct memory_block *cur_memory_block;
+	int ret_val = -EINVAL;
+
+	cur_section = __pfn_to_section(start_pfn);
+
+	if (!valid_section(cur_section))
+		return ret_val;
+
+	mutex_lock(&mem_sysfs_mutex);
+	cur_memory_block = find_memory_block(cur_section);
+
+	if (!cur_memory_block) {
+		mutex_unlock(&mem_sysfs_mutex);
+		return ret_val;
+	}
+
+	lock_device_hotplug();
+	ret_val = memory_block_change_state(cur_memory_block, MEM_ONLINE,
+						MEM_OFFLINE, ONLINE_KEEP);
+	unlock_device_hotplug();
+	mutex_unlock(&mem_sysfs_mutex);
+
+	return ret_val;
+}
+EXPORT_SYMBOL_GPL(online_memory_block);
+
 static struct attribute *memory_memblk_attrs[] = {
 	&dev_attr_phys_index.attr,
 	&dev_attr_end_phys_index.attr,
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 85c31a8..7d0d2a6 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -109,12 +109,17 @@ static inline int memory_isolate_notify(unsigned long val, void *v)
 {
 	return 0;
 }
+static inline int online_memory_block(unsigned long start_pfn)
+{
+	return 0;
+}
 #else
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb);
 extern int register_new_memory(int, struct mem_section *);
+extern int online_memory_block(unsigned long start_pfn);
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern int unregister_memory_section(struct mem_section *);
 #endif
-- 
1.7.4.1

