Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3AOKzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:55:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab3AOKzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:55:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6591339"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, jiang.liu@huawei.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: [BUG Fix Patch 1/6] Bug fix: Hold spinlock across find|remove /sys/firmware/memmap/X operation.
Date: Tue, 15 Jan 2013 18:54:22 +0800
Message-Id: <1358247267-18089-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1358247267-18089-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358247267-18089-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:54:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:54:29,
	Serialize complete at 2013/01/15 18:54:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unsafe to return an entry pointer and release the map_entries_lock. So we should
not hold the map_entries_lock separately in firmware_map_find_entry() and
firmware_map_remove_entry(). Hold the map_entries_lock across find and remove
/sys/firmware/memmap/X operation.

And also, users of these two functions need to be careful to hold the lock when using
these two functions.

The suggestion is from Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/firmware/memmap.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 4211da5..940c4e9 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -150,12 +150,12 @@ static int firmware_map_add_entry(u64 start, u64 end,
  * firmware_map_remove_entry() - Does the real work to remove a firmware
  * memmap entry.
  * @entry: removed entry.
+ *
+ * The caller must hold map_entries_lock, and release it properly.
  **/
 static inline void firmware_map_remove_entry(struct firmware_map_entry *entry)
 {
-	spin_lock(&map_entries_lock);
 	list_del(&entry->list);
-	spin_unlock(&map_entries_lock);
 }
 
 /*
@@ -188,23 +188,28 @@ static inline void remove_sysfs_fw_map_entry(struct firmware_map_entry *entry)
 }
 
 /*
- * Search memmap entry
+ * firmware_map_find_entry: Search memmap entry.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function is to find the memmap entey of a given memory range.
+ * The caller must hold map_entries_lock, and must not release the lock
+ * until the processing of the returned entry has completed.
+ *
+ * Return pointer to the entry to be found on success, or NULL on failure.
  */
-
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
-	spin_lock(&map_entries_lock);
 	list_for_each_entry(entry, &map_entries, list)
 		if ((entry->start == start) && (entry->end == end) &&
 		    (!strcmp(entry->type, type))) {
-			spin_unlock(&map_entries_lock);
 			return entry;
 		}
 
-	spin_unlock(&map_entries_lock);
 	return NULL;
 }
 
@@ -274,11 +279,15 @@ int __meminit firmware_map_remove(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
+	spin_lock(&map_entries_lock);
 	entry = firmware_map_find_entry(start, end - 1, type);
-	if (!entry)
+	if (!entry) {
+		spin_unlock(&map_entries_lock);
 		return -EINVAL;
+	}
 
 	firmware_map_remove_entry(entry);
+	spin_unlock(&map_entries_lock);
 
 	/* remove the memmap entry */
 	remove_sysfs_fw_map_entry(entry);
-- 
1.7.1

