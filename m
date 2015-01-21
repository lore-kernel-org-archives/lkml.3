Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbbAUQ4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:56:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41010 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbbAUQwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:25 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-96-54bfd8b08b95
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
        x86@kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...))
Subject: [PATCH v9 08/17] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Wed, 21 Jan 2015 19:51:36 +0300
Message-id: <1421859105-25253-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xq7obbuwPMbh73tJi269HbBa/985k
	tZizfg2bxZFr39ktrn97w2jx6eUDRovnDx+yW0x42MZusbK7mc1i+7O3TBYrOx+wWuzZe5LF
	4vKuOWwW99b8Z7VYfOQ2s8W7Z5OZLc7/Pc5q8WPDY1YHIY/5Oz8yeuycdZfdY8GmUo/Fe14y
	eWxa1cnmsenTJHaPrrdXmDxOzPjN4vHkynQmj49Pb7F49G1ZxejxeZOcx6Ynb5kCeKO4bFJS
	czLLUov07RK4MnbNuMFUcICrYvq3TtYGxnMcXYycHBICJhL3/+1jhrDFJC7cW88GYgsJLGWU
	ePcnuYuRC8juY5LYe3IfO0iCTUBP4t+s7WBFIgIKEpt7n7GCFDELTGGVOL20E2ySsEC2xP6V
	7WA2i4CqxP/d15hAbF4BN4mVj9+wQ2yTk9h4ZwUriM0p4C4x8/xEJohtTYwSn49sZ5vAyLuA
	kWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhUfN3BuPSY1SFGAQ5GJR5eCZ/9IUKsiWXF
	lbmHGCU4mJVEeOdfBwrxpiRWVqUW5ccXleakFh9iZOLglGpg5E+YKvF89+Qts568kV2+Iydq
	yYld1wye2e64XHCi2+nh93WcL5ZXGRmE/GLZ0Mi8s8c3+7XLylD78IXlJ0WT+XMOPbrbNNUm
	Qevo9BOHNi/w4FH52SuydP+ZfIHsd9FTmPpeLuZ/7DOr/l6e8pTut+4WLcKyVbs+XJt2UuXi
	r/2Hfrspz75yok2JpTgj0VCLuag4EQAXr/8LaAIAAA==
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
index e368d4f..3c097f9 100644
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
 
@@ -1430,6 +1432,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 		}
 		atomic_set(&p->u.count, 1);
 		dname = p->name;
+		if (IS_ENABLED(CONFIG_DCACHE_WORD_ACCESS))
+			kasan_unpoison_shadow(dname,
+				round_up(name->len + 1,	sizeof(unsigned long)));
 	} else  {
 		dname = dentry->d_iname;
 	}	
-- 
2.2.1

