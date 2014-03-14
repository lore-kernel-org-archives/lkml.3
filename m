Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaCNAte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 20:49:34 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45078 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaCNAtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 20:49:33 -0400
Message-ID: <53225217.3070205@gmail.com>
Date: Fri, 14 Mar 2014 08:49:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/kernel/module.c: use __vmalloc_node_range()
 instead of __vmalloc_area()
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc_area() has already been removed from upstream kernel, need
use __vmalloc_node_range() instead of.

The related commit: "d0a2126 mm: unify module_alloc code for vmalloc".

The related error (allmodconfig for unicore32):

    CC      arch/unicore32/kernel/module.o
  arch/unicore32/kernel/module.c: In function ‘module_alloc’:
  arch/unicore32/kernel/module.c:34: error: implicit declaration of function ‘__vmalloc_area’
  arch/unicore32/kernel/module.c:34: warning: return makes pointer from integer without a cast
  make[1]: *** [arch/unicore32/kernel/module.o] Error 1
  make: *** [arch/unicore32/kernel] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/module.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/unicore32/kernel/module.c b/arch/unicore32/kernel/module.c
index 16bd149..dc41f6d 100644
--- a/arch/unicore32/kernel/module.c
+++ b/arch/unicore32/kernel/module.c
@@ -24,14 +24,9 @@
 
 void *module_alloc(unsigned long size)
 {
-	struct vm_struct *area;
-
-	size = PAGE_ALIGN(size);
-	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
-	if (!area)
-		return NULL;
-
-	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
+	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				__builtin_return_address(0));
 }
 
 int
-- 
1.7.9.5
