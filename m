Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaJFQD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:03:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54558 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaJFQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:28 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ee-5432bcd60dad
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
Subject: [PATCH v4 08/13] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Mon, 06 Oct 2014 19:54:02 +0400
Message-id: <1412610847-27671-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xy7rX9hiFGKx9rWex7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1aPv8D0gs2chksfjIbWaLd88mM1tcXXWQ3eLHhsesDqIe83d+ZPTY
	Oesuu8eCTaUei/e8ZPLYtKqTzWPTp0nsHl1vrzB5nJjxm8XjyZXpTB4fn95i8Xi/7yqbR9+W
	VYwenzfJeZxo+cIawBfFZZOSmpNZllqkb5fAlXF+82mWgtP8FU96f7M2MF7m6WLk5JAQMJFo
	eHWGHcIWk7hwbz1bFyMXh5DAUkaJ/wfnMEE4fUwSr6d9YgGpYhPQk/g3azsbiC0ioCCxufcZ
	K0gRs8B9VondC94CdXBwCAskSSw45gNSwyKgKnGoYQ8jiM0r4CZxpr+FEWKbnMT0vXfBZnIK
	uEtMuzKTHWJZE6PEoS872CYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERI7X3cw
	Lj1mdYhRgINRiYc3codhiBBrYllxZe4hRgkOZiURXvN5RiFCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGHtE+8J1m3xvObOmHqgvPt/Wk+Zw8GVJtnDJ8mfrngocyjswOYFn+yKlVH7J/4YBQtMS
	Du/XtvN+xrrj2/r/jnfV0x+nd13dq3qohOvI03ItKb6v+19c5PoabcWYH8BxN/1iq90hZs7m
	qr+2mv6i0ol/K+UKzvjur31wjDX+k7absPnuoJ+TlViKMxINtZiLihMBUGUWg3sCAAA=
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
index 82282f5..9b1f75c 100644
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
2.1.2

