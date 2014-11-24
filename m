Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaKXSEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:04:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47677 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaKXSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:49 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-99-547372c7ca2d
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
Subject: [PATCH v7 09/12] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Mon, 24 Nov 2014 21:02:22 +0300
Message-id: <1416852146-9781-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xK7rHi4pDDLZNELLY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNaLD5ym9ni3bPJzBZXVx1ktzj/9zirxY8Nj1kdRDzm7/zI6LFz1l12
	jwWbSj0W73nJ5LFpVSebx6ZPk9g9ut5eYfI4MeM3i8eTK9OZPD4+vcXi8X7fVTaPvi2rGD0+
	b5Lz2PTkLVBFyxfWAP4oLpuU1JzMstQifbsEroyl7zYyFuzjqvh4/CV7A+NZji5GTg4JAROJ
	LZsOM0PYYhIX7q1n62Lk4hASWMoocezdE1YIp49J4ueB/WwgVWwCehL/Zm0Hs0UEdCVWPd/F
	DFLELLCRVeLGh/NACQ4OYYFsiRP9BiAmi4CqxL/TUiDlvAJuEnsuTWQGCUsIyElsXecNYnIC
	hX88LYPY1Mgo0TNrM9sERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUKi5usOxqXH
	rA4xCnAwKvHwVmgWhwixJpYVV+YeYpTgYFYS4U3LBwrxpiRWVqUW5ccXleakFh9iZOLglGpg
	zGp51tU1P/JIuLvwW+0TSmfZOawXTVy5YumCH0zZzdNKz/JYrH/ddj/l3mINk1uc++b1zd18
	eaaYrevZVYf384nuX8t/bQVvQ42zHOehhJexM/7H77vayBI2u23G8tYtDf9WrFNgDlmZMUFx
	+7XUNv3/duols7K0v4pNqH506tetFUm2ZSFGbkosxRmJhlrMRcWJANOEncN4AgAA
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
index a6c5d7e..3914e56 100644
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

