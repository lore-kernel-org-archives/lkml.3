Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbbA2PMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:12:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19814 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbbA2PMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:33 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ee-54ca4d4bca9f
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
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v10 05/17] mm: slub: share object_err function
Date: Thu, 29 Jan 2015 18:11:49 +0300
Message-id: <1422544321-24232-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xy7revqdCDGZ+tLTY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbrOxuZrPY/uwtk8XKzgesFpd3zWGz
	uLfmP6tF2+d/QGLJRiaLxUduM1u8ezaZ2eLHhsesDkIe83d+ZPTYOesuu8eCTaUei/e8ZPLY
	tKqTzWPTp0nsHl1vrzB5nJjxm8XjyZXpTB4fn95i8ejbsorR4/MmuQCeKC6blNSczLLUIn27
	BK6MczPusRV0c1Z0/l7N3MC4gb2LkZNDQsBE4syMbmYIW0ziwr31bF2MXBxCAksZJY7/W8AE
	4fQxSTxavI4FpIpNQE/i36ztbCC2iICCxObeZ6wgRcwCn1kkHnddA0sIC9hJrH64DmwFi4Cq
	ROv/RUA2OwevgJvE3YIuRg6gZXISFz7GgxRwCrhL/Lv3GGpVE6PExrPz2CYw8i5gZFjFKJpa
	mlxQnJSea6hXnJhbXJqXrpecn7uJERIHX3YwLj5mdYhRgINRiYd35qaTIUKsiWXFlbmHGCU4
	mJVEeJdangoR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwCjRapK7a7WD0oSvc19513x+O0l67ulD
	WdKpixa6+R4L3Nch+pG7LCD2oNzpqLX+7Q2xG26kO93+8tfh9olvN9I+nVgefrPjkwTnMi0B
	7nVBj3mVlwa9YVCXcvr6emWUWWuNzKkbciEZIqFbeLTKXy5XTCvnuvsr9W+Av/K8//J/whV+
	TIhPZlJiKc5INNRiLipOBAC3r1D8YQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to
linux/slub_def.h so it could be used by kernel
address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h | 3 +++
 mm/slub.c                | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index eca3883..93e4104 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -115,4 +115,7 @@ static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
 	return x - ((x - slab_page) % s->size);
 }
 
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/mm/slub.c b/mm/slub.c
index 1562955..3eb73f5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -629,7 +629,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);
-- 
2.2.2

