Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaJ0Qvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:51:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52371 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaJ0Qrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:40 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-d1-544e772a2cf6
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
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/12] kasan: Add support for upcoming GCC 5.0 asan ABI
 changes
Date: Mon, 27 Oct 2014 19:46:49 +0300
Message-id: <1414428419-17860-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xa7pa5X4hBv0nDSy2/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtNhyvYnJ4vnDh+wWEx62sVtM2yhusbK7mc1i+7O3TBYr
	Ox+wWlzeNYfN4t6a/6wWi4/cZrZ492wys8XVVQfZLX5seMzqIOwxf+dHRo+ds+6yeyzYVOqx
	eM9LJo9NqzrZPDZ9msTu0fX2CpPHiRm/WTyeXJnO5PHx6S0Wj/f7rrJ59G1ZxejxeZOcx4mW
	L6wBfFFcNimpOZllqUX6dglcGbvXnGIq2CJSseHRJsYGxkVCXYycHBICJhJvPj1jhbDFJC7c
	W8/WxcjFISSwlFHi4aajLBBOH5PE+5WN7CBVbAJ6Ev9mbWcDsUUEdCVWPd/FDGIzC7SySpza
	mtTFyMEhLBACVFMJEmYRUJWYfOseWAmvgJvE6n+ToJbJSUzfe5cFxOYUcJfouTQNalcTo0Tf
	lOXMExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQIiZKvOxiXHrM6xCjAwajEwzuh
	2DdEiDWxrLgy9xCjBAezkgjvgTS/ECHelMTKqtSi/Pii0pzU4kOMTBycUg2MSrkazQn6b8/N
	VP8WFNo0bwvvca6jQmebv34rCG80zTvMzteX0h54z+nc6pfruK87Ldh5xuVuX4/sV4H/zUG2
	t+4wLXbSYY6/cGdVm+vhUps4lTs2dhxXL2owL42zs/r13aqcue/Hv4VfrO/1P4hMvH+hYGXa
	xmqxI6oZYZ83soVJyZS6MZ5RYinOSDTUYi4qTgQAF4AAxHACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC 5.0 will have some changes in asan ABI.
New function (__asan_load*_noabort()/__asan_store*_noabort)
will be introduced.
By default, for -fsanitize=kernel-address GCC 5.0 will
generate __asan_load*_noabort() functions instead of __asan_load*()

Details in this thread: https://gcc.gnu.org/ml/gcc-patches/2014-10/msg02510.html

We still need __asan_load*() for GCC 4.9.2, so this patch just adds aliases.

Note: Patch for GCC hasn't been upstreamed yet.
I'm adding this patch in advance, to avoid breaking KASan
in future GCC update.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/kasan/kasan.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 8ce738e..11fa3f8 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -334,3 +334,41 @@ EXPORT_SYMBOL(__asan_storeN);
 /* to shut up compiler complaints */
 void __asan_handle_no_return(void) {}
 EXPORT_SYMBOL(__asan_handle_no_return);
+
+
+/* GCC 5.0 has different function names by default */
+void __asan_load1_noabort(unsigned long) __attribute__((alias("__asan_load1")));
+EXPORT_SYMBOL(__asan_load1_noabort);
+
+void __asan_load2_noabort(unsigned long) __attribute__((alias("__asan_load2")));
+EXPORT_SYMBOL(__asan_load2_noabort);
+
+void __asan_load4_noabort(unsigned long) __attribute__((alias("__asan_load4")));
+EXPORT_SYMBOL(__asan_load4_noabort);
+
+void __asan_load8_noabort(unsigned long) __attribute__((alias("__asan_load8")));
+EXPORT_SYMBOL(__asan_load8_noabort);
+
+void __asan_load16_noabort(unsigned long) __attribute__((alias("__asan_load16")));
+EXPORT_SYMBOL(__asan_load16_noabort);
+
+void __asan_loadN_noabort(unsigned long) __attribute__((alias("__asan_loadN")));
+EXPORT_SYMBOL(__asan_loadN_noabort);
+
+void __asan_store1_noabort(unsigned long) __attribute__((alias("__asan_store1")));
+EXPORT_SYMBOL(__asan_store1_noabort);
+
+void __asan_store2_noabort(unsigned long) __attribute__((alias("__asan_store2")));
+EXPORT_SYMBOL(__asan_store2_noabort);
+
+void __asan_store4_noabort(unsigned long) __attribute__((alias("__asan_store4")));
+EXPORT_SYMBOL(__asan_store4_noabort);
+
+void __asan_store8_noabort(unsigned long) __attribute__((alias("__asan_store8")));
+EXPORT_SYMBOL(__asan_store8_noabort);
+
+void __asan_store16_noabort(unsigned long) __attribute__((alias("__asan_store16")));
+EXPORT_SYMBOL(__asan_store16_noabort);
+
+void __asan_storeN_noabort(unsigned long) __attribute__((alias("__asan_storeN")));
+EXPORT_SYMBOL(__asan_storeN_noabort);
-- 
2.1.2

