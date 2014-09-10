Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaIJOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:38:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11158 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaIJOil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:41 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1d-54106270556d
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC/PATCH v2 09/10] kmemleak: disable kasan instrumentation for
 kmemleak
Date: Wed, 10 Sep 2014 18:31:26 +0400
Message-id: <1410359487-31938-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xq7oFSQIhBh+PClts+/WIzeL33pms
	FnPWr2GzOHLtO7vF+2U9jBbXv71htPj08gGjxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1ktFh+5zWzx7tlkZourqw6yW/zY8JjVQdhjzbw1jB7zd35k9Ng56y67
	x4JNpR6L97xk8ti0qpPNY9OnSeweXW+vMHmcmPGbxePJlelMHh+f3mLx6NuyitHj8yY5jxMt
	X1gD+KK4bFJSczLLUov07RK4Mo6eW8xesIm74snbr+wNjGs4uxg5OSQETCT+L37HAmGLSVy4
	t56ti5GLQ0hgKaPEogl/mSCcPiaJzqPfGUGq2AT0JP7N2s4GYosIKEhs7n3GClLELLCAVeL2
	88VARRwcwgIhEh9uZ4HUsAioSrz5vpEJxOYVcJc4d3U6G8Q2OYkNu/+DzeQEip86uQJqWROj
	xJILm9gnMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESJ192MC4+ZnWIUYCDUYmH
	t/Aif4gQa2JZcWXuIUYJDmYlEd4mB4EQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzeE4ODyuZm
	R33beN3g+vYLH8W/uLxw/LBx4Wobsc+frZRWfwoNUbvtyfQ28vjkLS5XXWwY5qZP1f6aJyd9
	emLo53l3jNweb6h9ZH1E74TwJ7/o8447gl+embv5tdyx+VebS3bUiyzj9z4+4diTxKwT+/0/
	XPlmazRHMrv9muV+Tb5r0mJzju/YpsRSnJFoqMVcVJwIAIGPVu5xAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak scans all memory while searching for pointers to
objects. So function scan_block could access
kasan's shadow memory region while searching for pointer.

Also kmalloc internally round up allocation size, and kmemleak
uses rounded up size as size of object. This makes kasan
to complain while calculation of object's checksum. The
simplest solution here is to disable kasan.

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
1.8.5.5

