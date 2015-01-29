Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbbA2PQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:16:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19814 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbbA2PMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:34 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f4-54ca4d4da102
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
Subject: [PATCH v10 06/17] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Thu, 29 Jan 2015 18:11:50 +0300
Message-id: <1422544321-24232-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xy7q+vqdCDBrPC1ts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtVnY3s1lsf/aWyWJl5wNWi8u75rBZ
	3Fvzn9Wi7fM/ILFkI5PF4iO3mS3ePZvMbPFjw2NWByGP+Ts/MnrsnHWX3WPBplKPxXteMnls
	WtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xePRtWcXo8XmTXABPFJdNSmpOZllqkb5d
	AldG74R7zAWn+Suu72tnb2C8zNPFyMkhIWAiMenQYTYIW0ziwr31QDYXh5DAUkaJHfeeQzl9
	TBIblrUzg1SxCehJ/Ju1HaxDREBBYnPvM1aQImaBzywSj7uugSWEBZIlfnVdYASxWQRUJdYe
	vsgKYvMKuEl8erUFyOYAWicnceFjPEiYU8Bd4t+9x0wQy5oYJTaencc2gZF3ASPDKkbR1NLk
	guKk9FxDveLE3OLSvHS95PzcTYyQWPiyg3HxMatDjAIcjEo8vDM3nQwRYk0sK67MPcQowcGs
	JMK71PJUiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG972fDy5Z08s1sc74n+YhuQ1cHUefmJ0r
	iMlb63i2rlu9Qvhht93fDwyphzr23lOLupAtvryv4eC6xc0GdrlNfOor9Lhipv1TWe59P1vk
	betn0bSeeQfmr+zwclxadipn/5J7e7Y5hlSa6LOuayu3m7k256P0/ZunVxopKP/Nu5/CEBH3
	5W2wEktxRqKhFnNRcSIAxphs22MCAAA=
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
index 3eb73f5..38d34a8 100644
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
2.2.2

