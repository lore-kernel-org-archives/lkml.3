Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaIJOkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:40:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15298 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaIJOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:35 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f9-541062682e01
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
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [RFC/PATCH v2 05/10] mm: slub: share slab_err and object_err functions
Date: Wed, 10 Sep 2014 18:31:22 +0400
Message-id: <1410359487-31938-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xq7oZSQIhBovvcVts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi7bP/4DEko1MFouP3Ga2ePdsMrPF1VUH2S1+bHjM6iDiMX/nR0aPnbPusnss
	2FTqsXjPSyaPTas62Tw2fZrE7tH19gqTx4kZv1k8nlyZzuTx8ektFo++LasYPT5vkvM40fKF
	NYA3issmJTUnsyy1SN8ugSujZ95axoIL3BXL+yczNTDu5Oxi5OSQEDCRaNq6jQXCFpO4cG89
	G4gtJLCUUeL/NZsuRi4gu49J4tXvM8wgCTYBPYl/s7aDFYkIKEhs7n3GClLELHCAVaLz8DWw
	hLCAv8SmrlVAUzk4WARUJbYvSgYJ8wq4SfQdbWCGWCYnsWH3f0YQm1PAXeLUyRVMEMuaGCWW
	XNjEPoGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkCj5soNx8TGrQ4wCHIxKPLyF
	F/lDhFgTy4orcw8xSnAwK4nwNjkIhAjxpiRWVqUW5ccXleakFh9iZOLglGpgXFlYs/Iqa6XK
	l7J2k8V1gqyCqu91n9V8Lj+oZjm54mv32RmvdvAufpSs375wwc9DwpFWf9Zces1y52iWe8CG
	L9vLeSz6pyzuUlCsfsm+r3n3hO83Oucs3OKfwHOk6+d1txcTJP7ujTS7bL4nS9xm8vF1c2d+
	EjmS+f/TziCBbVsWvp1wdBXvXC0lluKMREMt5qLiRABDOFKfcAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to mm/slab.h so they
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.h | 5 +++++
 mm/slub.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 3e3a6ae..87491dd 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -345,6 +345,11 @@ static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
+void slab_err(struct kmem_cache *s, struct page *page,
+		const char *fmt, ...);
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 
 static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
 {
diff --git a/mm/slub.c b/mm/slub.c
index fa86e58..c4158b2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -639,14 +639,14 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
 }
 
-static void slab_err(struct kmem_cache *s, struct page *page,
+void slab_err(struct kmem_cache *s, struct page *page,
 			const char *fmt, ...)
 {
 	va_list args;
-- 
1.8.5.5

