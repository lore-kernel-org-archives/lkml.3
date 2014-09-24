Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaIXMzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:55:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47921 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaIXMv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:28 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-43-5422be4e14fe
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
Subject: [PATCH v3 07/13] mm: slub: share slab_err and object_err functions
Date: Wed, 24 Sep 2014 16:44:03 +0400
Message-id: <1411562649-28231-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xy7p++5RCDH7cFbXY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNatH3+BySWbGSyWHzkNrPFu2eTmS2urjrIbvFjw2NWB1GP+Ts/Mnrs
	nHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeLzfd5XNo2/L
	KkaPz5vkPE60fGEN4IvisklJzcksSy3St0vgyri4eApTwTruihczNBoYZ3F2MXJySAiYSLzf
	s4IVwhaTuHBvPVsXIxeHkMBSRom9u5cwQzh9TBK3j79hBqliE9CT+DdrOxuILSKgILG59xkr
	SBGzwH1Wid0L3jJ1MXJwCAt4Szz4oQNSwyKgKvHqxCl2EJtXwE3i36n9UNvkJPZOXs0CYnMK
	uEsc+PGCHWJZE6PEsr2/mSYw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERI5X3Yw
	Lj5mdYhRgINRiYd3grhSiBBrYllxZe4hRgkOZiUR3rA9QCHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2MeqYHf2y7VzK/tOnw76bbF9eECMxYGXtG9YaOVO3jHxFV96Ot+7cdCtjSbfPV81l54tZv
	qdGzTrGckT7wWvL8hKdtWuqaKXpny3cqLJfcd2fq8qK2vlVWK46KTIg72dQTw8gu1dx99/D9
	z7dSWU9UPTPJbrVyS3y+XOtE7ixNQ63zodNad/w+qMRSnJFoqMVcVJwIAH8/ISh6AgAA
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
2.1.1

