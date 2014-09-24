Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaIXMvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:51:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35324 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaIXMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:39 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-82-5422be5911a1
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
Subject: [PATCH v3 11/13] kmemleak: disable kasan instrumentation for kmemleak
Date: Wed, 24 Sep 2014 16:44:07 +0400
Message-id: <1411562649-28231-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xy7qR+5RCDK5dUbXY9usRm8XvvTNZ
	LeasX8NmceTad3aL98t6GC2uf3vDaPHp5QNGiy3Xm5gsnj98yG4x4WEbu8W0jeIWK7ub2Sy2
	P3vLZLGy8wGrxeVdc9gs7q35z2qx+MhtZot3zyYzW1xddZDd4seGx6wOIh5r5q1h9Ji/8yOj
	x85Zd9k9Fmwq9Vi85yWTx6ZVnWwemz5NYvfoenuFyePEjN8sHk+uTGfy+Pj0FovH+31X2Tz6
	tqxi9Pi8Sc7jRMsX1gD+KC6blNSczLLUIn27BK6Mr7va2ArmcFWsO7WfvYFxA0cXIyeHhICJ
	xPzts1khbDGJC/fWs3UxcnEICSxllHi6ooMVwuljkuhtW8AMUsUmoCfxb9Z2NhBbREBBYnPv
	M7AiZoGDrBLL23rARgkL+EkcefKMEcRmEVCV6Fu9DszmFXCX2NS5lw1inZzE3smrWUBsTqD4
	gR8v2CG2NTFKLNv7m2kCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHR82UH4+Jj
	VocYBTgYlXh4J4grhQixJpYVV+YeYpTgYFYS4Q3bAxTiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	6KScdz9grvSC8w49eifNtgj4/ZGeabncbnrGiwX3VTSZtba/+fhSicU9TnxR85VHljWbTl26
	u2H2oeXtprNkjJcsmC5d3xPcFS1wcDX/zwBmq7+1E43nPnRzKOxfbDTBt3OSpbZVXPxpqZam
	Y1kn1TMc72lFt2RNv9h2x+Xu8zVPordvz5R/oMRSnJFoqMVcVJwIAKsi43R8AgAA
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
2.1.1

