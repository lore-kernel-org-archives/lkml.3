Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3HLXn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:43:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3HLXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:43:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86: Fix booting with DEBUG_PAGE_ALLOC with more than 512G RAM
Date: Mon, 12 Aug 2013 16:43:24 -0700
Message-Id: <1376351004-4015-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <52090CF2.3040505@sr71.net>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave reported that system have early crash if DEBUG_PAGEALLOC is selected,
when system have between 500G and 600G.

> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02086000, 0x02086fff] PGTABLE
> [    0.000000] BRK [0x02087000, 0x02087fff] PGTABLE
> [    0.000000] BRK [0x02088000, 0x02088fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xe80ee00000-0xe80effffff]
> [    0.000000]  [mem 0xe80ee00000-0xe80effffff] page 4k
> [    0.000000] BRK [0x02089000, 0x02089fff] PGTABLE
> [    0.000000] BRK [0x0208a000, 0x0208afff] PGTABLE
> [    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory

It turns out that we missed increasing needed pages in BRK to mapping
initial 2M and [0,1M) when we switch to use #PF handler set mem mapping.

> commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Thu Jan 24 12:19:52 2013 -0800
>
>     x86, 64bit: Use a #PF handler to materialize early mappings on demand

Before that, we have maping from [0,512M) in head_64.S, and we can
spare two pages [0-1M).  After that change, we can not reuse pages anymore.

When we have more than 512M ram, we need extra page for pgd page with
[512G, 1024g).

Increase pages in BRK for page table to solve the booting problem.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Bisected-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org> 3.9+

---
 arch/x86/mm/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -78,8 +78,8 @@ __ref void *alloc_low_pages(unsigned int
 	return __va(pfn << PAGE_SHIFT);
 }
 
-/* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
-#define INIT_PGT_BUF_SIZE	(5 * PAGE_SIZE)
+/* need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
+#define INIT_PGT_BUF_SIZE	(6 * PAGE_SIZE)
 RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
 void  __init early_alloc_pgt_buf(void)
 {
