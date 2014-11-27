Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaK0QC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:02:29 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23733 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaK0QBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:01:35 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a3-54774adeb85b
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v8 09/12] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Thu, 27 Nov 2014 19:00:53 +0300
Message-id: <1417104057-20335-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xa7r3vMpDDFY8F7LY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbTNsobrGyu5nNYvuzt0wWKzsfsFpc
	3jWHzeLemv+sFouP3Ga2ePdsMrPF+b/HWS1+bHjM6iDkMX/nR0aPnbPusnss2FTqsXjPSyaP
	Tas62Tw2fZrE7tH19gqTx4kZv1k8nlyZzuTx8ektFo++LasYPT5vkvPY9OQtULLlC2sAXxSX
	TUpqTmZZapG+XQJXxtJDc5kK9nFVtGx7ztLAeJaji5GDQ0LAROLhXccuRk4gU0ziwr31bCC2
	kMBSRon9K9S7GLmA7D4mibb2L2AJNgE9iX+ztoPZIgK6Eque72IGKWIWeM4iMeHNQlaQhLBA
	tsT1U1vBbBYBVYmb7xrBGngF3CV+Nk1ghVgsJ7F1nTdImBMo3H7+GyPEsiZGiZb2aywTGHkX
	MDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJjK87GJceszrEKMDBqMTDy3CrLESINbGs
	uDL3EKMEB7OSCG+TbXmIEG9KYmVValF+fFFpTmrxIUYmDk6pBkaBk7fW9mrd8eic+WrBrxuG
	ulV2u+/fuX307bU9M2bxfDxWvzKHf+1EOcuPnKvmWN1pfCdU5bi7/Arz/y0zTjOxdBjFzzoj
	cGxp3pyj3uwRZc0T38l6v125aLsI37GpdZsVBCQCq9epn3EW6bv14866jwtq2WsnLZY3uqYi
	Mz1T6cynf2/W/b4upcRSnJFoqMVcVJwIAMI+vF1qAgAA
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
index e368d4f..81561c8 100644
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
 
@@ -1430,6 +1432,10 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
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

