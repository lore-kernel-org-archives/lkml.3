Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaKEOye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:34 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25026 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaKEOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:30 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-49-545a3a25e46a
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
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
Subject: [PATCH v6 06/11] mm: slub: share slab_err and object_err functions
Date: Wed, 05 Nov 2014 17:53:56 +0300
Message-id: <1415199241-5121-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xq7qqVlEhBpOPMVts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF7PuPWSy2
	P3vLZLGy8wGrxeVdc9gs7q35z2rR9vkfkFiykcli8ZHbzBbvnk1mtri66iC7xY8Nj1kdxDzm
	7/zI6LFz1l12jwWbSj0W73nJ5LFpVSebx6ZPk9g9ut5eYfI4MeM3i8eTK9OZPD4+vcXi8WXV
	NWaP9/uusnn0bVnF6PF5k5zHiZYvrAH8UVw2Kak5mWWpRfp2CVwZi76sYSw4wF1xd8YJxgbG
	lZxdjJwcEgImEre2TWaCsMUkLtxbzwZiCwksZZToXZrVxcgFZPcxSfye0gZWxCagJ/Fv1naw
	IhEBWYmpf8+zgBQxC7xnlXh5bxJYkbCAt8TvmfvBilgEVCVOLu9gBrF5BVwlrj9ayt7FyAG0
	TU5i6zpvkDCngJvEkf5FLBDLGhklPt/qZJnAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5y
	fu4mRkg0fd3BuPSY1SFGAQ5GJR5ej6bIECHWxLLiytxDjBIczEoivE3aUSFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGMXPXdwlGhL/o31Gp0pZhKuy2VqBoKNJnz2vzmidI25cabc36Ij380mh
	8xWfvG07z8RX8K5j9Ts7H1vrlz8c50/NqjWWlPctURSZcuRCtHlcy8IfPNYrCrMWS9TtLfGW
	kfdZs+Pik60m7EevZWea7bsRtfCmr5fTsqe8b8ouXxTNnjd75UO1dCWW4oxEQy3mouJEAFOV
	w8uEAgAA
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
index 80c170e..1458629 100644
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

