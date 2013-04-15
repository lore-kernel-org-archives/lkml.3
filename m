Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3DOFsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:48:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52805 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3DOFsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:48:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516B94A1.4040603@jp.fujitsu.com>
Date: Mon, 15 Apr 2013 14:48:17 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <wency@cn.fujitsu.co>, <tangchen@cn.fujitsu.com>, <toshi.kani@hp.com>
Subject: [PATCH] firmware, memmap: fix firmware_map_entry leak
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot removing a memory, a firmware_map_entry which has memory range
of the memory is released by release_firmware_map_entry(). If the entry
is allocated by bootmem, release_firmware_map_entry() adds the entry to
map_entires_bootmem list when firmware_map_find_entry() finds the entry
from map_entries list. But firmware_map_find_entry never find the entry
sicne map_entires list does not have the entry. So the entry just leaks.

Here are steps of leaking firmware_map_entry:
firmware_map_remove()
-> firmware_map_find_entry()
   Find released entry from map_entries list
-> firmware_map_remove_entry()
   Delete the entry from map_entries list
-> remove_sysfs_fw_map_entry()
   ...
   -> release_firmware_map_entry()
      -> firmware_map_find_entry()
         Find the entry from map_entries list but the entry has been
         deleted from map_entries list. So the entry is not added
         to map_entries_bootmem. Thus the entry leaks

release_firmware_map_entry() should not call firmware_map_find_entry()
since releaed entry has been deleted from map_entries list.
So the patch delete firmware_map_find_entry() from releae_firmware_map_entry()

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/firmware/memmap.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 0b5b5f6..e2e04b0 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -114,12 +114,9 @@ static void __meminit release_firmware_map_entry(struct kobject *kobj)
 		 * map_entries_bootmem here, and deleted from &map_entries in
 		 * firmware_map_remove_entry().
 		 */
-		if (firmware_map_find_entry(entry->start, entry->end,
-		    entry->type)) {
-			spin_lock(&map_entries_bootmem_lock);
-			list_add(&entry->list, &map_entries_bootmem);
-			spin_unlock(&map_entries_bootmem_lock);
-		}
+		spin_lock(&map_entries_bootmem_lock);
+		list_add(&entry->list, &map_entries_bootmem);
+		spin_unlock(&map_entries_bootmem_lock);
 
 		return;
 	}

