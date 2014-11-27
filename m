Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaK0QBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:01:36 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23726 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaK0QBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:01:33 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9a-54774ada9efe
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v8 07/12] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Thu, 27 Nov 2014 19:00:51 +0300
Message-id: <1417104057-20335-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xa7q3vcpDDC74WGz79YjN4vfemawW
	c9avYbM4cu07u8X1b28YLT69fMBo8fzhQ3aLCQ/b2C2mbRS3WNndzGax/dlbJouVnQ9YLS7v
	msNmcW/Nf1aLts//gMSSjUwWi4/cZrZ492wys8WPDY9ZHYQ95u/8yOixc9Zddo8Fm0o9Fu95
	yeSxaVUnm8emT5PYPbreXmHyODHjN4vHkyvTmTw+Pr3F4tG3ZRWjx+dNch4nWr6wBvBGcdmk
	pOZklqUW6dslcGWcfr6MueA0f8WttxvZGxgv83QxcnJICJhIbJlyiA3CFpO4cG89kM3FISSw
	lFFi3eHl7BBOH5PEyu4lYFVsAnoS/2ZtB7NFBHQlVj3fxQxSxCzQxirx9EEjWEJYIEni9e8z
	YDaLgKrE/i23GEFsXgE3if7L14HiHEDr5CS2rvMGCXMKuEu0n//GCLGsiVGipf0aywRG3gWM
	DKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmLjyw7GxcesDjEKcDAq8fAmPC4LEWJNLCuu
	zD3EKMHBrCTC22RbHiLEm5JYWZValB9fVJqTWnyIkYmDU6qB0c9QTET5woeyj7fCBA4dE/oq
	PPM+x1FXf1l9i82TdJ4sfv9TsczHxHlj9OfLk698i3Pnas79kDBJmj/wrG7kueRXD++rmxky
	f9dRiTzA+ytSUq4hRrV9B9f1ptoPB3syjCYckZuQ8iH2/723tx7YcZp/eVjpqnPV/DzL5S+8
	JWI7XY6tCjnvqMRSnJFoqMVcVJwIAGaekQ9rAgAA
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
index 0c01584..88ad8b8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -467,13 +467,23 @@ static int slub_debug;
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
@@ -503,7 +513,9 @@ static void set_track(struct kmem_cache *s, void *object,
 		trace.max_entries = TRACK_ADDRS_COUNT;
 		trace.entries = p->addrs;
 		trace.skip = 3;
+		metadata_access_enable();
 		save_stack_trace(&trace);
+		metadata_access_disable();
 
 		/* See rant in lockdep.c */
 		if (trace.nr_entries != 0 &&
@@ -677,7 +689,9 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 	u8 *fault;
 	u8 *end;
 
+	metadata_access_enable();
 	fault = memchr_inv(start, value, bytes);
+	metadata_access_disable();
 	if (!fault)
 		return 1;
 
@@ -770,7 +784,9 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
 	if (!remainder)
 		return 1;
 
+	metadata_access_enable();
 	fault = memchr_inv(end - remainder, POISON_INUSE, remainder);
+	metadata_access_disable();
 	if (!fault)
 		return 1;
 	while (end > fault && end[-1] == POISON_INUSE)
-- 
2.1.3

