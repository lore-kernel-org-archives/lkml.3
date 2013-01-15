Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab3AOWyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:54:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:47613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934048Ab3AOWys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Liu <r64343@freescale.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/71] mm: compaction: fix echo 1 > compact_memory return error issue
Date: Tue, 15 Jan 2013 14:54:01 -0800
Message-Id: <20130115225340.708749536@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -714,14 +714,12 @@ static int compact_node(int nid)
 }
 
 /* Compact all nodes in the system */
-static int compact_nodes(void)
+static void compact_nodes(void)
 {
 	int nid;
 
 	for_each_online_node(nid)
 		compact_node(nid);
-
-	return COMPACT_COMPLETE;
 }
 
 /* The written value is actually unused, all memory is compacted */
@@ -732,7 +730,7 @@ int sysctl_compaction_handler(struct ctl
 			void __user *buffer, size_t *length, loff_t *ppos)
 {
 	if (write)
-		return compact_nodes();
+		compact_nodes();
 
 	return 0;
 }


