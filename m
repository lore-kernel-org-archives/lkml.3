Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaGKWST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:18:19 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:38312 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaGKWSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:18:18 -0400
Subject: [PATCH] MIPS: bugfix: missed cache flush of TLB refill handler
To: <linux-mips@linux-mips.org>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: <paul.gortmaker@windriver.com>, <jchandra@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <david.daney@cavium.com>
Date: Fri, 11 Jul 2014 15:18:05 -0700
Message-ID: <20140711221805.17764.743.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit

    Commit 1d40cfcd3442a53e98468cdb3e6d4d9a568d76cf
    Author: Ralf Baechle <ralf@linux-mips.org>
    Date:   Fri Jul 15 15:23:23 2005 +0000

    Avoid SMP cacheflushes.  This is a minor optimization of startup but
    will also avoid smp_call_function from doing stupid things when called
    from a CPU that is not yet marked online.

missed an appropriate cache flush of TLB refill handler because that time it was
at fixed location CAC_BASE. After years the refill handler in EBASE vector
is not at that location and can be allocated in some another memory and needs
I-cache sync as other TLB exception vectors.

Besides that, the new function - local_flash_icache_range() was introduced
to avoid SMP cacheflushes.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
---
 arch/mips/mm/tlbex.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index e80e10b..661bc3d 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -429,6 +429,7 @@ static void build_r3000_tlb_refill_handler(void)
 		 (unsigned int)(p - tlb_handler));
 
 	memcpy((void *)ebase, tlb_handler, 0x80);
+	local_flush_icache_range(ebase, ebase + 0x80);
 
 	dump_handler("r3000_tlb_refill", (u32 *)ebase, 32);
 }
@@ -1415,6 +1416,7 @@ static void build_r4000_tlb_refill_handler(void)
 		 final_len);
 
 	memcpy((void *)ebase, final_handler, 0x100);
+	local_flush_icache_range(ebase, ebase + 0x100);
 
 	dump_handler("r4000_tlb_refill", (u32 *)ebase, 64);
 }

