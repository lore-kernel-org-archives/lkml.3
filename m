Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaJTX10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaJTX1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:27:25 -0400
From: Petr Holasek <pholasek@redhat.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Dave Hansen <dave.hansen@intel.com>,
        pholasek@redhat.com
Subject: [RFC][PATCH] add pagesize field to /proc/pid/numa_maps
Date: Tue, 21 Oct 2014 01:27:14 +0200
Message-Id: <1413847634-20039-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some similar attempts to add vma's pagesize to numa_maps in the past,
so I've distilled the most straightforward one - adding pagesize field
expressing size in kbytes to each line. Although page size can be also obtained
from smaps file, adding pagesize to numa_maps makes the interface more compact
and easier to use without need for traversing other files.

New numa_maps output looks like that:

2aaaaac00000 default file=/dev/hugepages/hugepagefile huge pagesize=2097152 dirty=1 N0=1
7f302441a000 default file=/usr/lib64/libc-2.17.so pagesize=4096 mapped=65 mapmax=38 N0=65

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 fs/proc/task_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0388c..964c4de 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1498,6 +1498,9 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	if (!md->pages)
 		goto out;
 
+	seq_puts(m, " pagesize=");
+	seq_printf(m, "%lu", vma_kernel_pagesize(vma));
+
 	if (md->anon)
 		seq_printf(m, " anon=%lu", md->anon);
 
-- 
1.9.3

