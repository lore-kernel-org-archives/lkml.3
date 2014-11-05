Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaKEOyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62147 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbaKEOyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:36 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-02-545a3a299ca5
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v6 09/11] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Wed, 05 Nov 2014 17:53:59 +0300
Message-id: <1415199241-5121-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7qaVlEhBn9e21hs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1ktFh+5zWzx7tlkZourqw6yW5z/e5zV4seGx6wOIh7zd35k9Ng56y67
	x4JNpR6L97xk8ti0qpPNY9OnSeweXW+vMHmcmPGbxePJlelMHh+f3mLxeL/vKptH35ZVjB6f
	N8l5bHryFqii5QtrAH8Ul01Kak5mWWqRvl0CV8aVC53MBfu5Khb0/mFtYDzH0cXIySEhYCIx
	Ye1yRghbTOLCvfVsXYxcHEICSxklrn9sBEsICfQxSazdXA9iswnoSfybtZ0NxBYRkJWY+vc8
	C0gDs8BGVokbH86DJYQFsiUut11iArFZBFQl/k59ATaIV8BNYvuROaxdjBxA2+Qktq7zBglz
	AoWP9C9igVjcyCjx+VYnywRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQiLnyw7G
	xcesDjEKcDAq8fB6NEWGCLEmlhVX5h5ilOBgVhLhbdKOChHiTUmsrEotyo8vKs1JLT7EyMTB
	KdXA6K+geHquoOAW8+m5pdMi3xj8Ys+wN72/YtN54ZMes3Z+td69fyXzzeTZ65LU3u1dcy1R
	MFH1UMLnxzJ6J9dvv/OEc8KquutpIV+V/8z4+PNqv6fd9BdeF3VE566d7DX/O2OJ6LUnn6/u
	LJRwFN7do6Xxwih1YjHHSu98SeubU7jiGrjiso/c7lBiKc5INNRiLipOBAD0tGD2egIAAA==
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
 fs/dcache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index d5a23fd..d58ffcc6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,8 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
+
 #include "internal.h"
 #include "mount.h"
 
@@ -1429,6 +1431,10 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 		}
 		atomic_set(&p->u.count, 1);
 		dname = p->name;
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+		kasan_unpoison_shadow(dname,
+				round_up(name->len + 1,	sizeof(unsigned long)));
+#endif
 	} else  {
 		dname = dentry->d_iname;
 	}	
-- 
2.1.3

