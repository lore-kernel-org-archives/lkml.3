Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3BCPQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:16:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34281 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929Ab3BCO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:05 -0500
Message-Id: <20130203144647.784936223@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jason Liu <r64343@freescale.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 042/128] mm: compaction: fix echo 1 > compact_memory return error issue
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6b807e4..f8f5c11 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1210,7 +1210,7 @@ static int compact_node(int nid)
 }
 
 /* Compact all nodes in the system */
-static int compact_nodes(void)
+static void compact_nodes(void)
 {
 	int nid;
 
@@ -1219,8 +1219,6 @@ static int compact_nodes(void)
 
 	for_each_online_node(nid)
 		compact_node(nid);
-
-	return COMPACT_COMPLETE;
 }
 
 /* The written value is actually unused, all memory is compacted */
@@ -1231,7 +1229,7 @@ int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos)
 {
 	if (write)
-		return compact_nodes();
+		compact_nodes();
 
 	return 0;
 }


