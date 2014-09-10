Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaIJOin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:38:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34026 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaIJOik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:40 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-17-5410626ee72a
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [RFC/PATCH v2 08/10] fs: dcache: manually unpoison dname after
 allocation to shut up kasan's reports
Date: Wed, 10 Sep 2014 18:31:25 +0400
Message-id: <1410359487-31938-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xq7p5SQIhBmtmi1ts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi8VHbjNbvHs2mdni6qqD7Bbn/x5ntfix4TGrg7DH/J0fGT12zrrL7rFgU6nH
	4j0vmTw2repk89j0aRK7R9fbK0weJ2b8ZvF4cmU6k8fHp7dYPPq2rGL0+LxJzmPTk7dAyZYv
	rAF8UVw2Kak5mWWpRfp2CVwZ775+Ziw4xlUxZYZIA+NVji5GDg4JAROJ+b/Euxg5gUwxiQv3
	1rOB2EICSxklZpyt6WLkArL7mCTeLLrMDJJgE9CT+DdrO1iRiICCxObeZ6wgRcwC81kl7kxa
	wQiSEBbIl1jed4oVxGYRUJU4Me0WmM0r4CZx5U0LC8Q2OYkNu/+D1XMKuEucOrmCCWJbE6PE
	kgub2Ccw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIjX3YwLj5mdYhRgINRiYe3
	8CJ/iBBrYllxZe4hRgkOZiUR3iYHgRAh3pTEyqrUovz4otKc1OJDjEwcnFINjGFMlscO73Yt
	nnt3eqJvh9ZVbeV9xrnGKZMusqu47vVgfv7uVujrBR8ZMxql5k24ERlwW5ltefzLVVXcl2eY
	qBe5/t/7hLsnO3zp53tM1wv/B7Sp31z9y1NLad3R3JNMxzqUequ2TP+4bP46weUZbrucDn9x
	uRMuv75UI05O5v6BIwttw2RkdZVYijMSDbWYi4oTAUQYkSZvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to manually unpoison rounded up allocation size for dname
to avoid kasan's reports in dentry_string_cmp().
When CONFIG_DCACHE_WORD_ACCESS=y dentry_string_cmp may access
few bytes beyound requested in kmalloc() size.

dentry_string_cmp() relates on that fact that dentry allocated
using kmalloc and kmalloc internally round up allocation size.
So this is not a bug, but this makes kasan to complain about
such accesses.
To avoid such reports we mark rounded up allocation size in
shadow as accessible.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 fs/dcache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 35e61f6..b83dbc1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,7 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -1396,6 +1397,10 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;
 		}
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+		kasan_unpoison_shadow(dname,
+				round_up(name->len + 1,	sizeof(unsigned long)));
+#endif
 	} else  {
 		dname = dentry->d_iname;
 	}	
-- 
1.8.5.5

