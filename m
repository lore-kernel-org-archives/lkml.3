Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3FHIpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:45:08 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54703 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3FHIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:45:05 -0400
Message-ID: <51B2EF06.3070106@gmail.com>
Date: Sat, 08 Jun 2013 16:44:54 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: [PATCH -mm 2/2] mm, vmalloc: Check VM_UNINITIALIZED flag in s_show
 instead of show_numa_info
References: <51B2EEA3.5020808@gmail.com>
In-Reply-To: <51B2EEA3.5020808@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

We should check the VM_UNITIALIZED flag in s_show(). If this
flag is set, that said, the vm_struct is not fully initialized.
So it is unnecessary to try to show the information contained
in vm_struct.

We checked this flag in show_numa_info(), but I think it's better
to check it earlier.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fe41a4f..722268b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2591,11 +2591,6 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 		if (!counters)
 			return;
 
-		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-		smp_rmb();
-		if (v->flags & VM_UNINITIALIZED)
-			return;
-
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2624,6 +2619,11 @@ static int s_show(struct seq_file *m, void *p)
 
 	v = va->vm;
 
+	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+	smp_rmb();
+	if (v->flags & VM_UNINITIALIZED)
+		return 0;
+
 	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
-- 
1.7.1

