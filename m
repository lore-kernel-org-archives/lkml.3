Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3IYBDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:03:07 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33595 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3IYBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:03:04 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v7 3/4] mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"
Date: Wed, 25 Sep 2013 09:02:43 +0800
Message-Id: <1380070964-12975-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1380070964-12975-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1380070964-12975-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-5140-0000-0000-000003E2A81D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v2 -> v3: revert commit d157a558 directly

The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00(mm: avoid
null pointer access in vm_struct via /proc/vmallocinfo) is used to avoid
accessing the pages field with unallocated page when show_numa_info() is
called. This patch move the check just before show_numa_info in order that
some messages still can be dumped via /proc/vmallocinfo. This patch revert
commit d157a558 (mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead
of show_numa_info);

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7647e69..e523a14 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2562,6 +2562,11 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 		if (!counters)
 			return;
 
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+		if (v->flags & VM_UNINITIALIZED)
+			return;
+
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2587,11 +2592,6 @@ static int s_show(struct seq_file *m, void *p)
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
-
 	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
-- 
1.7.5.4

