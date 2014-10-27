Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaJ0Qsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:48:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56736 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaJ0Qrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:55 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-07-544e7739b7a5
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
Subject: [PATCH v5 11/12] kmemleak: disable kasan instrumentation for kmemleak
Date: Mon, 27 Oct 2014 19:46:58 +0300
Message-id: <1414428419-17860-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRW0iTUQDHPd/d4Ucfa+nBh0GLXiQtqewkIT4Enh60CEmQQqcuNXeRzZmX
	HmRp4RSRks9LltLKyxioy3KKMxMxQcIyL5R4mZomOKdmWQ2t1t7+N/g9/DlS+pUM5bK1eSq9
	VqlWMBJq7ODtdPj52wmJp7YmTqNXv5cY5HXW06ixw8ag4ek9FnlaKgGa+bEB0M76IkDdMyYC
	rblcLKp23WOR2BWC2ivuMqhn1U2g9vJFGn3sa2TQvO0PjSzDsyTaXH1IoinrGxb97FymY2XY
	9sQGcFPvNsC9DXMsbrYbsaV/ncB2azmD7TsPWGx2TxJ4tM5L4ZXJWgJvf/lMYc/AFIOruq0A
	f7PL8WjpLn3lULLkQoZKnZ2v0p+MSZVk1bW4qdxGScH4rwVQAjo5MwjkoHAGbjsdlF8Hw/fz
	HYwZSDip8BxA98BTwm+qCLjkbAO+FSNEwIOGHsanZUI4tK71kb4RKdhp6PhUQfqKw0ICnGyz
	sWbAcZRwHI59p30xL8TBd/MjrJ8mh7XOuf/kwH955YRI+WEmAKtqWslqwDeDACs4ojKm5xrS
	MjWREQalxmDUZkak6zR24H9n1wEsI9FDQOCAIoh3iPGJUlqZbyjUDAHIkQoZP3gzIVHKZygL
	i1R6XYreqFYZhgDBBYaWAOsd14dNUbIXIoPL4c9ObBRdW/R4Kd3BUo7+RuvjGItJrOwaLM6J
	L2wp5XXyAL5mZJa7NHdxPFVdXOZlnSmlSaago6+bY1/Kz5UsKJJtL2J57caKZrdatt+0FbWQ
	Exx1SxXWnet5lOS+fD0v7ur+sYqy+2L9uNgfnV58tkCioAxZysgwUm9Q/gWxLS2dewIAAA==
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

