Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaJ0Qtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:49:31 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56725 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaJ0Qrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:51 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-f1-544e773528cc
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
Subject: [PATCH v5 08/12] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
Date: Mon, 27 Oct 2014 19:46:55 +0300
Message-id: <1414428419-17860-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7qm5X4hBo9vslts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1kt2j7/AxJLNjJZLD5ym9ni3bPJzBZXVx1kt/ix4TGrg6jH/J0fGT12
	zrrL7rFgU6nH4j0vmTw2repk89j0aRK7R9fbK0weJ2b8ZvF4cmU6k8fHp7dYPN7vu8rm0bdl
	FaPH501yHidavrAG8EVx2aSk5mSWpRbp2yVwZRxY8Iip4DR/xdnLx1gaGC/zdDFyckgImEis
	OXWFDcIWk7hwbz2YLSSwlFHizKyCLkYuILuPSWLBpT4mkASbgJ7Ev1nbwYpEBHQlVj3fxQxS
	xCxwgVWir2sOO0hCWCBJ4uLZZ4wgNouAqsSsNU1gDbwCbhJb/i9gh9gmJzF9710WEJtTwF2i
	59I0FohtTYwSfVOWM09g5F3AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyR2vu5gXHrM
	6hCjAAejEg/vhGLfECHWxLLiytxDjBIczEoivAfS/EKEeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MEZo9oSuUfimZq8mwsGiVvbEgfXQ5lN3ZFn+dnrm3v0RsrxF4z/vY5NrBYG1BkLOAv+fS83M
	ElXOvmGsVTR7tzW74cQ1m2+2nFjq5LLecabX+tgVr36sfVgirCs36Ztd4t7qs72fn3VHLHs5
	g7mjd76n8iNvmT9KCq1Vf9X38WzMzZ9ltSD+qxJLcUaioRZzUXEiAEMtFfZ7AgAA
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
index 1458629..2116ccd 100644
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

