Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaGILkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:40:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53593 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbaGILgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:37 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e2-53bd2943596b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 11/21] mm: slub: share slab_err and object_err
 functions
Date: Wed, 09 Jul 2014 15:30:05 +0400
Message-id: <1404905415-9046-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xy7rOmnuDDS5O0bXY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroxpx6axFkzmrujYPIWtgbGV
	s4uRk0NCwETi8Jw/LBC2mMSFe+vZuhi5OIQEljJKTD38kQkkISTQxySx/EkgiM0moCfxb9Z2
	NhBbREBBYnPvM1aQBmaBZjaJ9o4PrCAJYYFoifXr9zCC2CwCqhIHNr4GGsTBwSvgJtG0zw1i
	mYLEsuUzwco5gcITpl9jBikREnCVmLBCbQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5
	uZsYIXH0ZQfj4mNWhxgFOBiVeHg1ancHC7EmlhVX5h5ilOBgVhLhtRXdGyzEm5JYWZValB9f
	VJqTWnyIkYmDU6qBsa34a/KEt4pxNQbuyRmeMmWzRVWbn38zM/NlvfziSPKk/I07227/cvD9
	5yWguseuLmtiluRbq7wjqu4mldbzyje3Hz/S8aig4o+T6ekPupx7J0dPP9IdZR7wVc70WYjC
	q5kvrm2fck71i/03r0mR8VNXy7UBA4ORc+2ylxEsq48G53g4XJ6kxFKckWioxVxUnAgAEkkI
	LoECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to mm/slab.h so they
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.h | 5 +++++
 mm/slub.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1257ade..912af7f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -339,5 +339,10 @@ static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
+void slab_err(struct kmem_cache *s, struct page *page,
+		const char *fmt, ...);
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 
 #endif /* MM_SLAB_H */
diff --git a/mm/slub.c b/mm/slub.c
index 6641a8f..3bdd9ac 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -635,14 +635,14 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
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
1.8.5.5

