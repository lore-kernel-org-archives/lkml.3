Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3AXDbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3AXDbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Liu <r64343@freescale.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 53/74] mm: compaction: fix echo 1 > compact_memory return error issue
Date: Thu, 24 Jan 2013 01:27:05 -0200
Message-Id: <1358998046-613-54-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Liu <r64343@freescale.com>

commit 7964c06d66c76507d8b6b662bffea770c29ef0ce upstream.

when run the folloing command under shell, it will return error

  sh/$ echo 1 > /proc/sys/vm/compact_memory
  sh/$ sh: write error: Bad address

After strace, I found the following log:

  ...
  write(1, "1\n", 2)               = 3
  write(1, "", 4294967295)         = -1 EFAULT (Bad address)
  write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
  ) = 31

This tells system return 3(COMPACT_COMPLETE) after write data to
compact_memory.

The fix is to make the system just return 0 instead 3(COMPACT_COMPLETE)
from sysctl_compaction_handler after compaction_nodes finished.

Signed-off-by: Jason Liu <r64343@freescale.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 2f42d95..cf955bb 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -843,7 +843,7 @@ static int compact_node(int nid)
 }
 
 /* Compact all nodes in the system */
-static int compact_nodes(void)
+static void compact_nodes(void)
 {
 	int nid;
 
@@ -852,8 +852,6 @@ static int compact_nodes(void)
 
 	for_each_online_node(nid)
 		compact_node(nid);
-
-	return COMPACT_COMPLETE;
 }
 
 /* The written value is actually unused, all memory is compacted */
@@ -864,7 +862,7 @@ int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos)
 {
 	if (write)
-		return compact_nodes();
+		compact_nodes();
 
 	return 0;
 }
-- 
1.7.9.5

