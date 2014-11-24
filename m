Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaKXSCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:02:53 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62399 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaKXSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:50 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-9c-547372c8a7de
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
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v7 10/12] kmemleak: disable kasan instrumentation for kmemleak
Date: Mon, 24 Nov 2014 21:02:23 +0300
Message-id: <1416852146-9781-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xK7oniopDDCb907HY9usRm8XvvTNZ
	LeasX8NmceTad3aL98t6GC2uf3vDaPHp5QNGiy3Xm5gsnj98yG4x4WEbu8W0jeIWK7ub2Sy2
	P3vLZLGy8wGrxeVdc9gs7q35z2qx+MhtZot3zyYzW1xddZDd4seGx6wOIh5r5q1h9Ji/8yOj
	x85Zd9k9Fmwq9Vi85yWTx6ZVnWwemz5NYvfoenuFyePEjN8sHk+uTGfy+Pj0FovH+31X2Tz6
	tqxi9Pi8Sc7jRMsX1gD+KC6blNSczLLUIn27BK6MORPmMRfM4ap4u30SYwPjBo4uRk4OCQET
	iSkT29ghbDGJC/fWs3UxcnEICSxllFi+/QgThNPHJLFv5XkWkCo2AT2Jf7O2s4HYIgK6Eque
	72IGKWIW2MQqseNmNzNIQljAT+Jc70ywBhYBVYnLJ04CTeLg4BVwk/j5hwXElBCQk9i6zhvE
	5ASK/nhaBrGqkVGiZ9ZmtgmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMTN1x2M
	S49ZHWIU4GBU4uGt0CwOEWJNLCuuzD3EKMHBrCTCm5YPFOJNSaysSi3Kjy8qzUktPsTIxMEp
	1cCYr6PetztbeA1HQW/zYr+zqU0SGSflixdey8if9k8oVHJN0QSdgEf8xwoeZfZO3FcSffTS
	3wTR7Ek8rO5G+74wbo2Jjdl20mNlfYOL+vtA9QX3DRZpiv7ZLdSy5JbqHJVGJ2fxz12Rl9TW
	T1GebTwl1oLPf+Hj72tyv5fl2K3fudGs5DrbGl8lluKMREMt5qLiRADHAmcjeQIAAA==
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

