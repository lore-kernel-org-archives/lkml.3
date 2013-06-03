Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab3FCPbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:31:50 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35735 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3FCPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:31:48 -0400
Message-ID: <51ACB6DB.6040809@gmail.com>
Date: Mon, 03 Jun 2013 23:31:39 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Joonsoo Kim <js1304@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] mm, vmalloc: Only call setup_vmalloc_vm only in __get_vm_area_node
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Now for insert_vmalloc_vm, it only calls the two functions:
- setup_vmalloc_vm: fill vm_struct and vmap_area instances
- clear_vm_unlist: clear VM_UNLIST bit in vm_struct->flags

So in function __get_vm_area_node, if VM_UNLIST bit unset
in flags, that is the else branch here, we don't need to
clear VM_UNLIST bit for vm->flags since this bit is obviously
not set. That is to say, we could only call setup_vmalloc_vm
instead of insert_vmalloc_vm here. And then we could even
remove the if test here.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d365724..6580c76 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1367,16 +1367,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 		return NULL;
 	}
 
-	/*
-	 * When this function is called from __vmalloc_node_range,
-	 * we add VM_UNLIST flag to avoid accessing uninitialized
-	 * members of vm_struct such as pages and nr_pages fields.
-	 * They will be set later.
-	 */
-	if (flags & VM_UNLIST)
-		setup_vmalloc_vm(area, va, flags, caller);
-	else
-		insert_vmalloc_vm(area, va, flags, caller);
+	setup_vmalloc_vm(area, va, flags, caller);
 
 	return area;
 }
-- 
1.7.1
