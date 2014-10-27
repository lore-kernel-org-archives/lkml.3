Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaJ0Qtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:49:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52388 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaJ0Qru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:50 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-f3-544e77322f66
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
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v5 07/12] mm: slub: share slab_err and object_err functions
Date: Mon, 27 Oct 2014 19:46:54 +0300
Message-id: <1414428419-17860-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7rG5X4hBvPMLLb9esRm8XvvTFaL
	OevXsFkcufad3eL6tzeMFp9ePmC02HK9icni+cOH7BYTHraxW0zbKG6xsruZzWL7s7dMFis7
	H7BaXN41h83i3pr/rBZtn/8BiSUbmSwWH7nNbPHu2WRmi6urDrJb/NjwmNVB1GP+zo+MHjtn
	3WX3WLCp1GPxnpdMHptWdbJ5bPo0id2j6+0VJo8TM36zeDy5Mp3J4+PTWywe7/ddZfPo27KK
	0ePzJjmPEy1fWAP4orhsUlJzMstSi/TtErgyzjxuYC9Yx13R+foMawPjLM4uRk4OCQETiX0N
	G5ggbDGJC/fWs3UxcnEICSxllOhc9gnK6WOSWHf3AAtIFZuAnsS/WdvZQGwRAV2JVc93MYMU
	MQtcYJXo65rD3sXIwSEs4C1x+pQ7SA2LgKrEuv0bwMK8Am4SU55oQSyTk5i+9y7YSE4Bd4me
	S9NYIHY1MUr0TVnOPIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLj5soNx8TGr
	Q4wCHIxKPLw7pvmGCLEmlhVX5h5ilOBgVhLhPZDmFyLEm5JYWZValB9fVJqTWnyIkYmDU6qB
	0eTz/po7qa3OOw2Z33Z9kXm0ZPW5n41R0V07d9ilHb78zyLWrGf2o+k+DzTO7ftoZ5h585B6
	SIWjivTmhE8u0n2bS94HHgi+1mr6Lq7sU/aMyinfs5XjGibFfKg9K17Ze7Pi9wzG9SenJEb7
	PAhxXuqmVsKy78NWgWsCvvHVFx6mxhcKqXswKrEUZyQaajEXFScCANeQjFV5AgAA
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
2.1.2

