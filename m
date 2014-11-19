Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaKSUyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:54:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbaKSUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 040/141] mem-hotplug: reset node present pages when hot-adding a new pgdat
Date: Wed, 19 Nov 2014 12:51:03 -0800
Message-Id: <20141119205151.986681196@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1067,6 +1067,16 @@ out:
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
@@ -1105,6 +1115,13 @@ static pg_data_t __ref *hotadd_new_pgdat
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
 


