Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbbA2PMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:12:42 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13156 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbbA2PMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:37 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d8-54ca4d51c41b
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
        x86@kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v10 09/17] kmemleak: disable kasan instrumentation for kmemleak
Date: Thu, 29 Jan 2015 18:11:53 +0300
Message-id: <1422544321-24232-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xy7qBvqdCDO6c57PY9usRm8XvvTNZ
	LeasX8NmceTad3aL98t6GC2uf3vDaPHp5QNGi+cPH7JbTHjYxm6xsruZzWL7s7dMFis7H7Ba
	XN41h83i3pr/rBaLj9xmtnj3bDKzxY8Nj1kdBD3WzFvD6DF/50dGj52z7rJ7LNhU6rF4z0sm
	j02rOtk8Nn2axO7R9fYKk8eJGb9ZPJ5cmc7k8fHpLRaPvi2rGD0+b5IL4I3isklJzcksSy3S
	t0vgyjj5aQt7wUWuipX/TjI2MD7g6GLk4JAQMJGYt9eqi5ETyBSTuHBvPRuILSSwlFFizQNJ
	CLuPSeLXaR0Qm01AT+LfrO1gNSICChKbe5+xdjFycTALXGaRWPPlGztIQljAX2LS5FlgNouA
	qsTqpk9MIDavgLvEnhdLGSH2yklc+BgPEuYECv+795gJZI6QQBOjxMaz89gmMPIuYGRYxSia
	WppcUJyUnmukV5yYW1yal66XnJ+7iRESBV93MC49ZnWIUYCDUYmHd8amkyFCrIllxZW5hxgl
	OJiVRHiXWp4KEeJNSaysSi3Kjy8qzUktPsTIxMEp1cDo4iGbesT1ztS81Yl8qltqP9/64BN1
	OfHl9AtlGy/GbOm+VCoW9++v+fdJq4+2tKzIkxQ3ipsbImNUoCuma/Lw+/lSQUE5I5mymxeP
	Ca9Xc9tw0maLqsDSfXuMLq64Lnusu+6X3NbdRco7JvGVHn/fVOlw1YqxZvLR+bOvTom3cnTk
	uVe+4sVlJZbijERDLeai4kQA1IBgXGACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc internally round up allocation size, and kmemleak
uses rounded up size as object's size. This makes kasan
to complain while kmemleak scans memory or calculates of object's
checksum. The simplest solution here is to disable kasan.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
2.2.2

