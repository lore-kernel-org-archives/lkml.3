Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbaGSLgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:36:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50588 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760878AbaGSLgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:36:45 -0400
Date: Sat, 19 Jul 2014 17:06:37 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] x86, olpc: Eliminate BUG_ON and memset after alloc_bootmem
Message-ID: <20140719113637.GA23621@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_bootmem and related functions never return NULL and always return
a zeroed region of memory.  Thus a BUG_ON the NULL test or memset after
calls to these functions is unnecessary.

The following Coccinelle semantic patch was used for making the change:

@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- BUG_ON (E == NULL);

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 arch/x86/platform/olpc/olpc_dt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index d6ee929..280645d 100644
--- a/arch/x86/platform/olpc/olpc_dt.c
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -142,9 +142,7 @@ void * __init prom_early_alloc(unsigned long size)
 		 * wasted bootmem) and hand off chunks of it to callers.
 		 */
 		res = alloc_bootmem(chunk_size);
-		BUG_ON(!res);
 		prom_early_allocated += chunk_size;
-		memset(res, 0, chunk_size);
 		free_mem = chunk_size;
 		mem = res;
 	}
-- 
1.9.1

