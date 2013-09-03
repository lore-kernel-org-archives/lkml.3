Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab3ICDAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:00:44 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:42977 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3ICDAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:00:41 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/3] mm/vmalloc: move VM_UNINITIALIZED just before show_numa_info
Date: Tue,  3 Sep 2013 11:00:20 +0800
Message-Id: <1378177220-26218-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1378177220-26218-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378177220-26218-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090302-8256-0000-0000-0000090E9696
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00(mm: avoid
null pointer access in vm_struct via /proc/vmallocinfo) is used to avoid
accessing the pages field with unallocated page when show_numa_info() is
called. This patch move the check just before show_numa_info in order that
some messages still can be dumped via /proc/vmallocinfo.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e3ec8b4..c4720cd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2590,11 +2590,6 @@ static int s_show(struct seq_file *m, void *p)
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
-
 	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
@@ -2622,6 +2617,11 @@ static int s_show(struct seq_file *m, void *p)
 	if (v->flags & VM_VPAGES)
 		seq_printf(m, " vpages");
 
+	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+	smp_rmb();
+	if (v->flags & VM_UNINITIALIZED)
+		return 0;
+
 	show_numa_info(m, v);
 	seq_putc(m, '\n');
 	return 0;
-- 
1.7.5.4

