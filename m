Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaJ0Qr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:47:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56736 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaJ0Qry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:54 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-03-544e77389b1f
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Subject: [PATCH v5 10/12] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Mon, 27 Oct 2014 19:46:57 +0300
Message-id: <1414428419-17860-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7oW5X4hBvdnSFhs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1ktFh+5zWzx7tlkZourqw6yW5z/e5zV4seGx6wOIh7zd35k9Ng56y67
	x4JNpR6L97xk8ti0qpPNY9OnSeweXW+vMHmcmPGbxePJlelMHh+f3mLxeL/vKptH35ZVjB6f
	N8l5bHryFqii5QtrAH8Ul01Kak5mWWqRvl0CV8aMlatYC/ZzVcxY2s7SwHiOo4uRk0NCwERi
	38OTTBC2mMSFe+vZQGwhgaWMEs86KroYuYDsPiaJ2c17wRJsAnoS/2ZtB7NFBHQlVj3fxQxS
	xCywkVXixofzYAlhgWyJc5tmAU3l4GARUJV4cSwVxOQVcJf4vtcMYpecxPS9d1lAbE6gcM+l
	aSwQu5oYJfqmLGeewMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI3HzZwbj4mNUh
	RgEORiUe3h3TfEOEWBPLiitzDzFKcDArifAeSPMLEeJNSaysSi3Kjy8qzUktPsTIxMEp1cDo
	sFXK6tnmlfl+upsO/nn6ib+tK9rG9Kxzo3LFvG2MV66dzHDcsH7rH85j9mXTd4ufLb4RtiRL
	a8c32XPyb5fyGH/2bmZqaFGOuHpI8XiuybRnF/IVxPfnB6gseev7pMCjvfr8zRPtJbf2JQqv
	3c/kxvRmas/HjdnFqwyOZLmJJk/afuhvyKQEJZbijERDLeai4kQA8eyHWnkCAAA=
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
2.1.2

