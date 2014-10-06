Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaJFQCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:02:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21586 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaJFQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:36 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fa-5432bcda9003
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
Subject: [PATCH v4 10/13] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Mon, 06 Oct 2014 19:54:04 +0400
Message-id: <1412610847-27671-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xy7q39hiFGCy/wm+x7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1WHzkNrPFu2eTmS2urjrIbnH+73FWix8bHrM6iHjM3/mR0WPnrLvs
	Hgs2lXos3vOSyWPTqk42j02fJrF7dL29wuRxYsZvFo8nV6YzeXx8eovF4/2+q2wefVtWMXp8
	3iTnsenJW6CKli+sAfxRXDYpqTmZZalF+nYJXBmzmg6zFBzhqvi8bD5rA+Nlji5GDg4JAROJ
	iScjuhg5gUwxiQv31rN1MXJxCAksZZR4PnE+E4TTxyTx+/ZuZpAqNgE9iX+ztrOB2CICChKb
	e5+xghQxCxxglehedIIdJCEskC2x/OcCFhCbRUBV4v+ntWA2r4C7xOsdS5kh1slJTN97FyzO
	CRSfdmUmO8S2JkaJQ192sE1g5F3AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyR2vu5g
	XHrM6hCjAAejEg9v5A7DECHWxLLiytxDjBIczEoivObzjEKEeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MEZqcn27k9tb6Nl08peSb+iRyyu2G/FN8nv8+mik5MzbS3tOuinLFxa5eL1OdVQplDvq
	3Pypk03nQof2lh0t+Y1qirO+m7z0ecYXcTDv/dTibXpXvOZKrlhgfWZ3sAi7kdLjC6tzkuY4
	PFbdJZ6mo3Ttt9SOl1lsL9l3ZxVteH7kSfbxfDG9T0osxRmJhlrMRcWJACBwk757AgAA
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
index 876ac08..584b283 100644
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
2.1.2

