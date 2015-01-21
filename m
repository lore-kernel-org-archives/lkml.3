Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbbAUQ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:56:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42795 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbbAUQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-8b-54bfd8acf197
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
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v9 05/17] mm: slub: share object_err function
Date: Wed, 21 Jan 2015 19:51:33 +0300
Message-id: <1421859105-25253-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7prbuwPMWhexG2x7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8Xzhw/ZLSY8bGO3WNndzGax/dlbJouVnQ9YLS7vmsNm
	cW/Nf1aLts//gMSSjUwWi4/cZrZ492wys8WPDY9ZHYQ85u/8yOixc9Zddo8Fm0o9Fu95yeSx
	aVUnm8emT5PYPbreXmHyODHjN4vHkyvTmTw+Pr3F4tG3ZRWjx+dNcgE8UVw2Kak5mWWpRfp2
	CVwZFzb+Zy7o5qzYdHktUwPjBvYuRk4OCQETiY1bHrNC2GISF+6tZ+ti5OIQEljKKHHnwXxG
	CKePSWLyrV6wDjYBPYl/s7azgdgiAgoSm3ufsYIUMQt8ZpF43HUNKMHBISxgK/GrTQDEZBFQ
	lTi9KgSknFfATWLe6TVMEMvkJDbeWQG2mFPAXWLm+YlMELuaGCU+H9nONoGRdwEjwypG0dTS
	5ILipPRcQ73ixNzi0rx0veT83E2MkEj4soNx8TGrQ4wCHIxKPLwVoftDhFgTy4orcw8xSnAw
	K4nwzr8OFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC4eWNH/BW7k0fVnh/sV9deXPLc4O2MM7uF
	6nfqr1DcVnrFxyQ7RM2R6aDj8WoRiR/qt88bve/hXr322qm9RmvecWYLrL3/SHCpuYjuhZwV
	HW9y1/KdOmbCekNeUN3wgtGi/tBD89etUK/J2CKe5+nYlf9Ka06Q1PJDmULfE1jMjT54HGQ5
	M4VLiaU4I9FQi7moOBEAgQTWuGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to
linux/slub_def.h so it could be used by kernel
address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h | 3 +++
 mm/slub.c                | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c75bc1d..d7d9f26 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -115,4 +115,7 @@ static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
 	return x - ((x - slab_page) % s->size);
 }
 
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/mm/slub.c b/mm/slub.c
index fe376fe..18777c9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -629,7 +629,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);
-- 
2.2.1

