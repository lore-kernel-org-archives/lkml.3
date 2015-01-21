Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbbAUQ4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:56:31 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37326 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAUQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:22 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-8d-54bfd8ada642
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
Subject: [PATCH v9 06/17] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Wed, 21 Jan 2015 19:51:34 +0300
Message-id: <1421859105-25253-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7prb+wPMfi+RsZi269HbBa/985k
	tZizfg2bxZFr39ktrn97w2jx6eUDRovnDx+yW0x42MZusbK7mc1i+7O3TBYrOx+wWlzeNYfN
	4t6a/6wWbZ//AYklG5ksFh+5zWzx7tlkZosfGx6zOgh5zN/5kdFj56y77B4LNpV6LN7zkslj
	06pONo9Nnyaxe3S9vcLkcWLGbxaPJ1emM3l8fHqLxaNvyypGj8+b5AJ4orhsUlJzMstSi/Tt
	ErgylpzbyVJwmr/ixotWxgbGyzxdjJwcEgImEkuefWSHsMUkLtxbz9bFyMUhJLCUUeLP5StM
	EE4fk8Tc5l42kCo2AT2Jf7O2g9kiAgoSm3ufsYIUMQt8ZpF43HUNLCEskCSxesFVFhCbRUBV
	4uWeNkYQm1fATWLa7XfMEOvkJDbeWcEKYnMKuEvMPD8RalsTo8TnI9vZJjDyLmBkWMUomlqa
	XFCclJ5rpFecmFtcmpeul5yfu4kREg1fdzAuPWZ1iFGAg1GJh1fCZ3+IEGtiWXFl7iFGCQ5m
	JRHe+deBQrwpiZVVqUX58UWlOanFhxiZODilGhgvVC9uP/95OefWhwHcTB5Hfi5/UlU1ZWbN
	btWbVpbL7vpkdb6NO9NkXylSf2zuxYDz7KfEnJzUdsi7yy990hKVEyMV+Loi63DgenuW6dnr
	LU2SL/bd23b99W/Du4ZWp/he1pRv0JrU5Blx3ON7iT3nDF61T6kPzzEXR8ve7ypbbfJyYfv7
	aXOUWIozEg21mIuKEwFVS8SZZAIAAA==
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
index 18777c9..9747976 100644
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
2.2.1

