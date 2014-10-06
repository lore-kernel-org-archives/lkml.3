Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaJFQBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:01:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54573 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaJFQBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:33 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e5-5432bcdb9c19
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
        x86@kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 11/13] kmemleak: disable kasan instrumentation for kmemleak
Date: Mon, 06 Oct 2014 19:54:05 +0400
Message-id: <1412610847-27671-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xy7q39xiFGNy6rWGx7dcjNovfe2ey
	WsxZv4bN4si17+wW75f1MFpc//aG0eLTyweMFluuNzFZPH/4kN1iwsM2dotpG8UtVnY3s1ls
	f/aWyWJl5wNWi8u75rBZ3Fvzn9Vi8ZHbzBbvnk1mtri66iC7xY8Nj1kdRDzWzFvD6DF/50dG
	j52z7rJ7LNhU6rF4z0smj02rOtk8Nn2axO7R9fYKk8eJGb9ZPJ5cmc7k8fHpLRaP9/uusnn0
	bVnF6PF5k5zHiZYvrAH8UVw2Kak5mWWpRfp2CVwZM5a9ZSmYw1Vx/ud9xgbGDRxdjBwcEgIm
	Er9a4roYOYFMMYkL99azdTFycQgJLGWUmPRuLzOE08ckse/dRkaQKjYBPYl/s7azgdgiAgoS
	m3ufsYIUMQscZJVY3tbDCpIQFvCT6Ho4AayIRUBVon3KBTCbV8Bd4tazR0wQ6+Qkpu+9ywJi
	cwLFp12ZyQ6xrYlR4tCXHWwTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJnS87
	GBcfszrEKMDBqMTDG7HDMESINbGsuDL3EKMEB7OSCK/5PKMQId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYxKcYsl5LMmnfIVT7U7GNJYZaRr6vw4ZIFnt9rcxIe/+lmOfbh65UhnUvHx4onuuT2z
	ls2/HmWm3/VWUjfY8ODRwDka2d+Euvy6zj5hNb2lrClXt9edbYdkhpKw24Gwh8b3j+6euVGm
	jmnHl4aS9VJuAtsuPg1L0+T67Jl5vPHu7ABtrisHlyqxFGckGmoxFxUnAgC5XXAcewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc internally round up allocation size, and kmemleak
uses rounded up size as object's size. This makes kasan
to complain while kmemleak scans memory or calculates of object's
checksum. The simplest solution here is to disable kasan.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/kmemleak.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3cda50c..9bda1b3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -98,6 +98,7 @@
 #include <asm/processor.h>
 #include <linux/atomic.h>
 
+#include <linux/kasan.h>
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
@@ -1113,7 +1114,10 @@ static bool update_checksum(struct kmemleak_object *object)
 	if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
 		return false;
 
+	kasan_disable_local();
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
+	kasan_enable_local();
+
 	return object->checksum != old_csum;
 }
 
@@ -1164,7 +1168,9 @@ static void scan_block(void *_start, void *_end,
 						  BYTES_PER_POINTER))
 			continue;
 
+		kasan_disable_local();
 		pointer = *ptr;
+		kasan_enable_local();
 
 		object = find_and_get_object(pointer, 1);
 		if (!object)
-- 
2.1.2

