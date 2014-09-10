Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaIJOkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:40:05 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28224 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaIJOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:35 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-03-5410626a710e
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
Subject: [RFC/PATCH v2 06/10] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Wed, 10 Sep 2014 18:31:23 +0400
Message-id: <1410359487-31938-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xq7pZSQIhBluOcVhs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi7bP/4DEko1MFouP3Ga2ePdsMrPF1VUH2S1+bHjM6iDiMX/nR0aPnbPusnss
	2FTqsXjPSyaPTas62Tw2fZrE7tH19gqTx4kZv1k8nlyZzuTx8ektFo++LasYPT5vkvM40fKF
	NYA3issmJTUnsyy1SN8ugSuj8fsZtoKz/BVHFuc2MF7l6WLk5JAQMJHYvuoAM4QtJnHh3nq2
	LkYuDiGBpYwSj178YoZw+pgkdjx5ww5SxSagJ/Fv1nY2EFtEQEFic+8zVpAiZoEDrBKdh68B
	JTg4hAXSJB5+LQepYRFQlXixox+snlfATeLmxz1sENvkJDbs/s8IYnMKuEucOrmCCWJZE6PE
	kgub2Ccw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIlX3YwLj5mdYhRgINRiYe3
	8CJ/iBBrYllxZe4hRgkOZiUR3iYHgRAh3pTEyqrUovz4otKc1OJDjEwcnFINjLEr5mxI/X5P
	2aDnWejRm9dCWOuT20y+qyhMO27eNnmLmFF8vW9Gt1Gsw6JdYRaKXFt0Nz3/nvPjyIZWFuvD
	cxbqbXjGyPOo5N0+47yWtP973q/bZ5r+m49nW0yaLcvXcGaZ9k1b1BfNlT19l8XV1aj2c/pr
	ieXsLM3vN/mFzP+8eoPKc6OWX0osxRmJhlrMRcWJAHkUKqdwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to object's metadata in external functions with
metadata_access_enable()/metadata_access_disable() function calls.

This hooks separates payload accesses from metadata accesses
which might be useful for different checkers (e.g. KASan).

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slub.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index c4158b2..f3603d2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -477,13 +477,23 @@ static int slub_debug;
 static char *slub_debug_slabs;
 static int disable_higher_order_debug;
 
+static inline void metadata_access_enable(void)
+{
+}
+
+static inline void metadata_access_disable(void)
+{
+}
+
 /*
  * Object debugging
  */
 static void print_section(char *text, u8 *addr, unsigned int length)
 {
+	metadata_access_enable();
 	print_hex_dump(KERN_ERR, text, DUMP_PREFIX_ADDRESS, 16, 1, addr,
 			length, 1);
+	metadata_access_disable();
 }
 
 static struct track *get_track(struct kmem_cache *s, void *object,
@@ -513,7 +523,9 @@ static void set_track(struct kmem_cache *s, void *object,
 		trace.max_entries = TRACK_ADDRS_COUNT;
 		trace.entries = p->addrs;
 		trace.skip = 3;
+		metadata_access_enable();
 		save_stack_trace(&trace);
+		metadata_access_disable();
 
 		/* See rant in lockdep.c */
 		if (trace.nr_entries != 0 &&
@@ -687,7 +699,9 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 	u8 *fault;
 	u8 *end;
 
+	metadata_access_enable();
 	fault = memchr_inv(start, value, bytes);
+	metadata_access_disable();
 	if (!fault)
 		return 1;
 
@@ -780,7 +794,9 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
 	if (!remainder)
 		return 1;
 
+	metadata_access_enable();
 	fault = memchr_inv(end - remainder, POISON_INUSE, remainder);
+	metadata_access_disable();
 	if (!fault)
 		return 1;
 	while (end > fault && end[-1] == POISON_INUSE)
-- 
1.8.5.5

