Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaKYK6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:58:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaKYKnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 211/254] mem-hotplug: reset node present pages when hot-adding a new pgdat
Date: Tue, 25 Nov 2014 10:39:21 +0000
Message-Id: <1416912004-5928-212-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Chen <tangchen@cn.fujitsu.com>

commit 0bd854200873894a76f32603ff2c4c988ad6b5b5 upstream.

When memory is hot-added, all the memory is in offline state.  So clear
all zones' present_pages because they will be updated in online_pages()
and offline_pages().  Otherwise, /proc/zoneinfo will corrupt:

When the memory of node2 is offline:

  # cat /proc/zoneinfo
  ......
  Node 2, zone   Movable
  ......
        spanned  8388608
        present  8388608
        managed  0

When we online memory on node2:

  # cat /proc/zoneinfo
  ......
  Node 2, zone   Movable
  ......
        spanned  8388608
        present  16777216
        managed  8388608

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory_hotplug.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2fcc1a2e8ab2..845ca44ee5ab 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1064,6 +1064,16 @@ out:
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+static void reset_node_present_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		z->present_pages = 0;
+
+	pgdat->node_present_pages = 0;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
@@ -1102,6 +1112,13 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 	 */
 	reset_node_managed_pages(pgdat);
 
+	/*
+	 * When memory is hot-added, all the memory is in offline state. So
+	 * clear all zones' present_pages because they will be updated in
+	 * online_pages() and offline_pages().
+	 */
+	reset_node_present_pages(pgdat);
+
 	return pgdat;
 }
 
-- 
2.1.0

