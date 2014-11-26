Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaKZWQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:16:49 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61557 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaKZWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:16:48 -0500
Date: Wed, 26 Nov 2014 14:16:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [patch] fs, seq_file: fallback to vmalloc instead of oom kill
 processes
Message-ID: <alpine.DEB.2.10.1411261415500.13014@chino.kir.corp.google.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 058504edd026 ("fs/seq_file: fallback to vmalloc allocation"),
seq_buf_alloc() falls back to vmalloc() when the kmalloc() for contiguous
memory fails.  This was done to address order-4 slab allocations for
reading /proc/stat on large machines and noticed because
PAGE_ALLOC_COSTLY_ORDER < 4, so there is no infinite loop in the page
allocator when allocating new slab for such high-order allocations.

Contiguous memory isn't necessary for caller of seq_buf_alloc(), however.
Other GFP_KERNEL high-order allocations that are <=
PAGE_ALLOC_COSTLY_ORDER will simply loop forever in the page allocator
and oom kill processes as a result.

We don't want to kill processes so that we can allocate contiguous memory
in situations when contiguous memory isn't necessary.

This patch does the kmalloc() allocation with __GFP_NORETRY for
high-order allocations.  This still utilizes memory compaction and direct 
reclaim in the allocation path, the only difference is that it will fail 
immediately instead of oom kill processes when out of memory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/seq_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -36,7 +36,7 @@ static void *seq_buf_alloc(unsigned long size)
 {
 	void *buf;
 
-	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);
 	return buf;
