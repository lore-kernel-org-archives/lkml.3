Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaK0QDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:03:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60719 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaK0QBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:01:32 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-91-54774ad947e0
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
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v8 06/12] mm: slub: share slab_err and object_err functions
Date: Thu, 27 Nov 2014 19:00:50 +0300
Message-id: <1417104057-20335-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xa7o3vcpDDDruGVts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi7bP/4DEko1MFouP3Ga2ePdsMrPFjw2PWR2EPebv/MjosXPWXXaPBZtKPRbv
	ecnksWlVJ5vHpk+T2D263l5h8jgx4zeLx5Mr05k8Pj69xeLRt2UVo8fnTXIeJ1q+sAbwRnHZ
	pKTmZJalFunbJXBlXD6dUHCAu+LehibmBsaVnF2MnBwSAiYSN47OZ4SwxSQu3FvPBmILCSxl
	lNi7U6aLkQvI7mOSuNrSyQKSYBPQk/g3aztYkYiArsSq57uYQYqYBdpYJZ4+aARLCAt4S8xZ
	9xmsgUVAVeLo0p1ARRwcvAJuEj+v54CYEgJyElvXeYNUcAq4S7Sf/8YIsauJUaKl/RrLBEbe
	BYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFC4uLrDsalx6wOMQpwMCrx8DLcKgsRYk0s
	K67MPcQowcGsJMLbZFseIsSbklhZlVqUH19UmpNafIiRiYNTqoGx7Nn52DTDpdZbCgt2OHqv
	f9lTuXfikjzn377bjs9eL16ueU/cidlmbqDl2j89L+4aurx+umr2nqafVfGWRfsPBh8X+Rci
	M2OVQv4CiWZz7YtcCpUMVrMPv437vWPOjoWndCw7n/otblX/cTjohZjNudmKR13u8D3ba/hz
	ctn1KMPdE3+HnGtbosRSnJFoqMVcVJwIANJ4ymtpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to mm/slab.h so they
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h | 5 +++++
 mm/slub.c                | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c75bc1d..144b5cb 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -115,4 +115,9 @@ static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
 	return x - ((x - slab_page) % s->size);
 }
 
+__printf(3, 4)
+void slab_err(struct kmem_cache *s, struct page *page, const char *fmt, ...);
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/mm/slub.c b/mm/slub.c
index 95d2142..0c01584 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -629,14 +629,14 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
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
2.1.3

