Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaKXSCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:02:50 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50068 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaKXSCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:43 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-91-547372c2cff2
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, Joe Perches <joe@perches.com>,
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
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v7 06/12] mm: slub: share slab_err and object_err functions
Date: Mon, 24 Nov 2014 21:02:19 +0300
Message-id: <1416852146-9781-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xK7qHiopDDNbMkbDY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL2fcfs1hs
	f/aWyWJl5wNWi8u75rBZ3Fvzn9Wi7fM/ILFkI5PF4iO3mS3ePZvMbHF11UF2ix8bHrM6iHnM
	3/mR0WPnrLvsHgs2lXos3vOSyWPTqk42j02fJrF7dL29wuRxYsZvFo8nV6YzeXx8eovF48uq
	a8we7/ddZfPo27KK0ePzJjmPEy1fWAP4o7hsUlJzMstSi/TtErgyLp9OKDjAXXFvQxNzA+NK
	zi5GTg4JAROJF6ceMELYYhIX7q1n62Lk4hASWMoo0dgwkwnC6WOSaG3dBlbFJqAn8W/WdjYQ
	W0RAV2LV813MIEXMAu9ZJV7em8QEkhAW8JbYOfM9M4jNIqAqcfP1YzCbV8BVYmrLQfYuRg6g
	dXISW9d5g5icAm4SP56WQexqZJTombWZbQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5
	uZsYIbH0dQfj0mNWhxgFOBiVeHgrNItDhFgTy4orcw8xSnAwK4nwpuUDhXhTEiurUovy44tK
	c1KLDzEycXBKNTCeuDIzXsV7U23yIQ/n5WmFqSsOxNkfflnU3+WQlWy07N6dMxdWJ/y4JOJ2
	+uZye6vlOYeL3CINy/+s3n3hxdwlKv8ZQo0WrT351dTlOvOs6bWSpxqulERfEj+eFDRhgva6
	uEffHI4vqM5R+qS3+sZGVYmj7hMF/fr2qa996uB8mGHhTCe/Ux1PlViKMxINtZiLihMBnypX
	5IMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to mm/slab.h so they
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h | 5 +++++
 mm/slub.c                | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c75bc1d..144b5cb 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -115,4 +115,9 @@ static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
 	return x - ((x - slab_page) % s->size);
 }
 
+__printf(3, 4)
+void slab_err(struct kmem_cache *s, struct page *page, const char *fmt, ...);
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/mm/slub.c b/mm/slub.c
index 95d2142..0c01584 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -629,14 +629,14 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
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
2.1.3

