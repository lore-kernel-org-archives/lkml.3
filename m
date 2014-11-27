Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaK0QBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:01:39 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38635 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaK0QBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:01:36 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ad-54774adf7700
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
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v8 10/12] kmemleak: disable kasan instrumentation for kmemleak
Date: Thu, 27 Nov 2014 19:00:54 +0300
Message-id: <1417104057-20335-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xa7r3vcpDDBb8lrDY9usRm8XvvTNZ
	LeasX8NmceTad3aL98t6GC2uf3vDaPHp5QNGi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNaLD5ym9ni3bPJzBY/NjxmdRDyWDNvDaPH/J0fGT12zrrL7rFgU6nH
	4j0vmTw2repk89j0aRK7R9fbK0weJ2b8ZvF4cmU6k8fHp7dYPPq2rGL0+LxJzuNEyxfWAL4o
	LpuU1JzMstQifbsErow5E+YxF8zhqni7fRJjA+MGji5GTg4JAROJLT9msUHYYhIX7q0Hsrk4
	hASWMkrMvHyJHcLpY5J4NWslC0gVm4CexL9Z28E6RAR0JVY938UMUsQs8IJFYsOvzawgCWEB
	P4mVi9cwg9gsAqoSx6/PZwexeQXcJY7NWAJkcwCtk5PYus4bJMwJFG4//40RYlkTo0RL+zWW
	CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKERMeXHYyLj1kdYhTgYFTi4U14XBYi
	xJpYVlyZe4hRgoNZSYS3ybY8RIg3JbGyKrUoP76oNCe1+BAjEwenVAOjxtsHc42Xm5pqrJjW
	M8dLvELT1eZj6m/NewV/v+g9PDPzfePrKPWt0/UCe98z1jFn/E9yOvfSbNoxFYEPF13nPUvL
	8fjx7NKDD/IXd59yOzbxQvrb859fTntxkOPtijkMJypPB/YtM5uxVDJSVaPYVN1kz4b7Xm3y
	3deEe5RNj/Sstr6nydanpsRSnJFoqMVcVJwIAMK/pSJsAgAA
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
2.1.3

