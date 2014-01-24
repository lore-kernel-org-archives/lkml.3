Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaAXTKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:10:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34875 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaAXTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:10:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/3] memblock: Don't align size silent in memblock_virt_alloc()
Date: Fri, 24 Jan 2014 11:11:09 -0800
Message-Id: <1390590670-25901-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In original __alloc_memory_core_early() for bootmem wrapper, we do not
align size silently.

We should not do that, as later free with old size will leave some
range not freed.

It's obvious that code is copied from memblock_base_nid(), and that code
is wrong for the same reason.

Also remove that in memblock_alloc_base.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -981,9 +981,6 @@ static phys_addr_t __init memblock_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
 	found = memblock_find_in_range_node(size, align, 0, max_addr, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
@@ -1077,9 +1074,6 @@ static void * __init memblock_virt_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
 					    nid);
