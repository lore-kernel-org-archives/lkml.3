Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaKEOzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:55:41 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42616 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaKEOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:37 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-69-545a3a2b409e
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
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
Subject: [PATCH v6 10/11] kmemleak: disable kasan instrumentation for kmemleak
Date: Wed, 05 Nov 2014 17:54:00 +0300
Message-id: <1415199241-5121-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7raVlEhBkcOyFhs+/WIzeL33pms
	FnPWr2GzOHLtO7vF+2U9jBbXv71htPj08gGjxZbrTUwWzx8+ZLeY8LCN3WLaRnGLld3NbBbb
	n71lsljZ+YDV4vKuOWwW99b8Z7VYfOQ2s8W7Z5OZLa6uOshu8WPDY1YHEY8189Yweszf+ZHR
	Y+esu+weCzaVeize85LJY9OqTjaPTZ8msXt0vb3C5HFixm8WjydXpjN5fHx6i8Xj/b6rbB59
	W1YxenzeJOdxouULawB/FJdNSmpOZllqkb5dAlfGnAnzmAvmcFW83T6JsYFxA0cXIyeHhICJ
	xMIv21ggbDGJC/fWs3UxcnEICSxllDgy7xCU08cksWjzdHaQKjYBPYl/s7azgdgiArISU/+e
	ZwEpYhbYxCqx42Y3M0hCWMBP4uaWuWANLAKqEtf+HgRbwSvgJrH+31WmLkYOoHVyElvXeYOE
	OYHCR/oXsUAsa2SU+Hyrk2UCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx83UH
	49JjVocYBTgYlXh4PZoiQ4RYE8uKK3MPMUpwMCuJ8DZpR4UI8aYkVlalFuXHF5XmpBYfYmTi
	4JRqYDx7TIThalCqoUmpk/KfLVeb+KJS87tj/vkZ7O7Otp39YKpM8iLxbyuaZZm1by//xbjx
	4/u3NeaOT7dITfwg7PK5YM2+hX6/Z0SU9XGk7w+RSPZSedA7KeJ1z+pNt5ftEL3CHtz8Tv6j
	HWd6oILet6WSBbsMKyb7PsjPb1nMU7Njwcvwtg8bZZVYijMSDbWYi4oTASRRY7x7AgAA
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

