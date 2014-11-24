Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaKXSEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:04:16 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28052 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaKXSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:49 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-95-547372c3da18
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
Subject: [PATCH v7 07/12] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Mon, 24 Nov 2014 21:02:20 +0300
Message-id: <1416852146-9781-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xK7qHi4pDDH7OtLTY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNatH3+BySWbGSyWHzkNrPFu2eTmS2urjrIbvFjw2NWB1GP+Ts/Mnrs
	nHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeLzfd5XNo2/L
	KkaPz5vkPE60fGEN4IvisklJzcksSy3St0vgyjj9fBlzwWn+iltvN7I3MF7m6WLk5JAQMJF4
	O2seE4QtJnHh3nq2LkYuDiGBpYwSu9tvQzl9TBLzPhxmAaliE9CT+DdrOxuILSKgK7Hq+S5m
	kCJmgQusEn1dc9hBEsICSRKzd19kBbFZBFQlzq6bxgxi8wq4SuzauR4ozgG0Tk5i6zpvEJNT
	wE3ix9MyiF2NjBI9szazTWDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJHK+7mBc
	eszqEKMAB6MSD2+FZnGIEGtiWXFl7iFGCQ5mJRHetHygEG9KYmVValF+fFFpTmrxIUYmDk6p
	Bsb0+F+fdh5JEhDMnXh23ewD5etaV5TOT3+oqrau2rP49pUVFmcuVOWozHX/73Jh98vVQUIn
	PLs2TI1d+WZ+Vx1XnBNbH/OeSefN0s/3LDD8uK/5AUfEm9LKSqm5jQkXs9apKNUunnxFxmbX
	m7kb7nZ75c/X2S91lkOzWNjhlmY1s3DW8788B2YpsRRnJBpqMRcVJwIAClKhSXoCAAA=
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

