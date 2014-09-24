Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaIXMyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:54:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47921 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIXMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:31 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-54-5422be5069a1
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
Subject: [PATCH v3 08/13] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Wed, 24 Sep 2014 16:44:04 +0400
Message-id: <1411562649-28231-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xy7oB+5RCDM58MbHY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNatH3+BySWbGSyWHzkNrPFu2eTmS2urjrIbvFjw2NWB1GP+Ts/Mnrs
	nHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeLzfd5XNo2/L
	KkaPz5vkPE60fGEN4IvisklJzcksSy3St0vgypi3bydzwWn+ig8935kaGC/zdDFycEgImEj0
	dbN3MXICmWISF+6tZ+ti5OIQEljKKPF4VzMjhNPHJHH+chcLSBWbgJ7Ev1nb2UBsEQEFic29
	z1hBipgF7rNK7F7wlgkkISyQJNG14DUjiM0ioCrRtOQPWAOvgJtE14P9LBDr5CT2Tl4NZnMK
	uEsc+PGCHWJbE6PEsr2/mSYw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERI7X3Yw
	Lj5mdYhRgINRiYd3grhSiBBrYllxZe4hRgkOZiUR3rA9QCHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2MVUptcX4pYZuPvZqxMuW7pGtOzHW/PQU7j2yU2rGhIqFMqbPpSZrARDaN6bJmsi+qzrld
	2MAZX3OU9U7tdIY0NeWIwK862+ezec1V8sld3biyY75jg8EBBlY9qfyMvwW/Gf6nT3dgWh7q
	c176rlfAZv6puy8tevS522Kq6vR9LUns21Usd81RYinOSDTUYi4qTgQA813+y3sCAAA=
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
2.1.1

