Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3IQO5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:57:44 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:33760 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IQO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:57:43 -0400
Date: Tue, 17 Sep 2013 16:57:34 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix bootmem error handling in pcpu_page_first_chunk()
Message-ID: <20130917165734.16aa0226@holzheu>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091714-1948-0000-0000-00000655733A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory allocation of in pcpu_embed_first_chunk() fails, the
allocated memory is not released correctly. In the release loop also
the non-allocated elements are released which leads to the following
kernel BUG on systems with very little memory:

[    0.000000] kernel BUG at mm/bootmem.c:307!
[    0.000000] illegal operation: 0001 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0 #22
[    0.000000] task: 0000000000a20ae0 ti: 0000000000a08000 task.ti: 0000000000a08000
[    0.000000] Krnl PSW : 0400000180000000 0000000000abda7a (__free+0x116/0x154)
[    0.000000]            R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:0 CC:0 PM:0 EA:3
...
[    0.000000]  [<0000000000abdce2>] mark_bootmem_node+0xde/0xf0
[    0.000000]  [<0000000000abdd9c>] mark_bootmem+0xa8/0x118
[    0.000000]  [<0000000000abcbba>] pcpu_embed_first_chunk+0xe7a/0xf0c
[    0.000000]  [<0000000000abcc96>] setup_per_cpu_areas+0x4a/0x28c

To fix the problem now only allocated elements are released. This then
leads to the correct kernel panic:

[    0.000000] Kernel panic - not syncing: Failed to initialize percpu areas.
...
[    0.000000] Call Trace:
[    0.000000] ([<000000000011307e>] show_trace+0x132/0x150)
[    0.000000]  [<0000000000113160>] show_stack+0xc4/0xd4
[    0.000000]  [<00000000007127dc>] dump_stack+0x74/0xd8
[    0.000000]  [<00000000007123fe>] panic+0xea/0x264
[    0.000000]  [<0000000000b14814>] setup_per_cpu_areas+0x5c/0x28c

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 mm/percpu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1705,9 +1705,12 @@ int __init pcpu_embed_first_chunk(size_t
 	goto out_free;
 
 out_free_areas:
-	for (group = 0; group < ai->nr_groups; group++)
+	for (group = 0; group < ai->nr_groups; group++) {
+		if (!areas[group])
+			continue;
 		free_fn(areas[group],
 			ai->groups[group].nr_units * ai->unit_size);
+	}
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)

