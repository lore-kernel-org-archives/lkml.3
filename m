Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaJFQB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:01:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51429 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaJFQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:26 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cf-5432bcd56054
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
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v4 07/13] mm: slub: share slab_err and object_err functions
Date: Mon, 06 Oct 2014 19:54:01 +0400
Message-id: <1412610847-27671-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xy7pX9xiFGCz/z2Gx7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1aPv8D0gs2chksfjIbWaLd88mM1tcXXWQ3eLHhsesDqIe83d+ZPTY
	Oesuu8eCTaUei/e8ZPLYtKqTzWPTp0nsHl1vrzB5nJjxm8XjyZXpTB4fn95i8Xi/7yqbR9+W
	VYwenzfJeZxo+cIawBfFZZOSmpNZllqkb5fAlXFp3Q3WgnXcFece7WRpYJzF2cXIySEhYCKx
	5u88FghbTOLCvfVsXYxcHEICSxkl+lYsZodw+pgk/j/8zApSxSagJ/Fv1nY2EFtEQEFic+8z
	VpAiZoH7rBK7F7xlAkkIC3hLHDn0BGgsBweLgKrE+tfSIGFeATeJEx/eMkNsk5OYvvcu2GZO
	AXeJaVdmQi1rYpQ49GUH2wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmLnyw7G
	xcesDjEKcDAq8fBG7DAMEWJNLCuuzD3EKMHBrCTCaz7PKESINyWxsiq1KD++qDQntfgQIxMH
	p1QD48Kdd1/7c7qu3nM2ZefW3695DXruX2VO9ZLnTbNJ4Pr7zHBzwCWjp+b2S4vy2jo2awox
	XJnKdbW7rCQ/paNl37nTL6srjNS2MPnaaquk3dfxk7Nfls5ieV4wpIix/Zxv9ik9mfMT/SS4
	GDp7d06o55wu5Lo93OfxWYuHk0xKL37zMDjaPYdZiaU4I9FQi7moOBEAa0gfLHsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to mm/slab.h so they
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h | 4 ++++
 mm/slub.c                | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c75bc1d..8fed60d 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -115,4 +115,8 @@ static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
 	return x - ((x - slab_page) % s->size);
 }
 
+void slab_err(struct kmem_cache *s, struct page *page, const char *fmt, ...);
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/mm/slub.c b/mm/slub.c
index ae7b9f1..82282f5 100644
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
2.1.2

