Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaIXMvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:51:44 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47941 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaIXMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:35 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-2f-5422be55d110
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
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3 10/13] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Wed, 24 Sep 2014 16:44:06 +0400
Message-id: <1411562649-28231-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xy7qh+5RCDLq7DSy2/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtNhyvYnJ4vnDh+wWEx62sVtM2yhusbK7mc1i+7O3TBYr
	Ox+wWlzeNYfN4t6a/6wWi4/cZrZ492wys8XVVQfZLc7/Pc5q8WPDY1YHEY/5Oz8yeuycdZfd
	Y8GmUo/Fe14yeWxa1cnmsenTJHaPrrdXmDxOzPjN4vHkynQmj49Pb7F4vN93lc2jb8sqRo/P
	m+Q8Nj15C1TR8oU1gD+KyyYlNSezLLVI3y6BK+PUgh2sBUe4Kib0/GBtYLzM0cXIySEhYCIx
	Y8l7JghbTOLCvfVsXYxcHEICSxklvt/sZIZw+pgkHrZtAatiE9CT+DdrOxuILSKgILG59xkr
	SBGzwAFWie5FJ9i7GDk4hAWyJQ6+TwQxWQRUJXrfWYGU8wq4Syz6dpkVYpmcxN7Jq1lAbE6g
	+IEfL9ghdjUxSizb+5tpAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghkfN1B+PS
	Y1aHGAU4GJV4eCeKK4UIsSaWFVfmHmKU4GBWEuEN2wMU4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wHjtsuZ+FsW4/X6Fear766f5aV3jtYmYvcb00HGZ7d+6lAKmHxflXmDgO/WH8VUrO78vh4wX
	R1sd/s/DJ2HIN3lF54OAq2suVUaXHL6pcZrHJ3DGc7PlJT96Fv3I/mzxtO/ttsOGjg8T4msZ
	35VyZBi2yaqft5HYHlUeOEvkxokzKbKLVM+tD1JiKc5INNRiLipOBAA2EAkkegIAAA==
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
index 8552986..7811eb2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,7 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -1395,6 +1396,10 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
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
2.1.1

