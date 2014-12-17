Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaLQObD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:31:03 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52207 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLQOa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:30:59 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b2-549193a0d8c9
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "nadia.derbey@bull.net" <Nadia.Derbey@bull.net>, aquini@redhat.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-mm@kvack.org
Subject: [PATCH 2/2] mm: hugetlb: fix type of hugetlb_treat_as_movable variable
Date: Wed, 17 Dec 2014 17:30:50 +0300
Message-id: <1418826650-10145-2-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418826650-10145-1-git-send-email-a.ryabinin@samsung.com>
References: <548CA6B6.3060901@colorfullife.com>
 <1418826650-10145-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7oLJk8MMdi7z8xi269HbBZz1q9h
	s+jZvZPJYsbDXywWK5ZeY7FYfXMNo8Xzhw/ZLSY8bGO3mH3/MVDi2X0mi+3P3jJZ3Hw+h8Vi
	ZecDVov+x9/ZLS7vmsNmcW/Nf1aLffensFp8WHuKxeJE31omi7YlG5kcRDxeLNzC7DHx6UxW
	j5fbN7B57Jx1l91jwaZSjz0TT7J5bPo0id3jxIzfLB7zTgZ6TDr8mcnjy6przB7v911l8+jb
	sorRY+rseo/Pm+QC+KO4bFJSczLLUov07RK4MrqPT2cs+MFVce3XNdYGxjbOLkZODgkBE4lJ
	j48xQthiEhfurWfrYuTiEBJYyijRv+oSI4TTxyRxd9pkJpAqNgE9iX+ztrOB2CICshJT/55n
	ASliFnjGKnH9SCczSEJYwF9iT+sxVhCbRUBVoqV1LVgzr4CbxJT+6ewQ6+Qkttx6BGZzCrhL
	LP3zFWyokECOxLGjG1knMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESOV92MC4+
	ZnWIUYCDUYmH98X1CSFCrIllxZW5hxglOJiVRHg/B04MEeJNSaysSi3Kjy8qzUktPsTIxMEp
	1cAYocdtPaW1Yv2XEycfF0wIYfjdYrVE8IO7rr5V9XEfeZZF8yzaO/nCuZRLFl5jT7irw3/y
	JVtNm0OJbfbbrj+b9jJmHfb/em5F6lTrEy6RYo+zd3F8ndqsIubtdWH19jMH9l/OrvN5dHLJ
	L/EHiT2Xp3yubdh/s7zC7qnFKkHDq/wrVieuXHFQiaU4I9FQi7moOBEAPbf+YXoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb_treat_as_movable declared as unsigned long, but
proc_dointvec() used for parsing it:

static struct ctl_table vm_table[] = {
...
	{
		.procname	= "hugepages_treat_as_movable",
		.data		= &hugepages_treat_as_movable,
		.maxlen		= sizeof(int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},

This seems harmless, but it's better to use int type here.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/hugetlb.h | 2 +-
 mm/hugetlb.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 431b7fc..7d78563 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -86,7 +86,7 @@ void free_huge_page(struct page *page);
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 #endif
 
-extern unsigned long hugepages_treat_as_movable;
+extern int hugepages_treat_as_movable;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 85032de..be0e5d0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -35,7 +35,7 @@
 #include <linux/node.h>
 #include "internal.h"
 
-unsigned long hugepages_treat_as_movable;
+int hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
-- 
2.2.0

