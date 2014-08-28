Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400AbaH1I5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:57:24 -0400
Received: from fallback1.mail.ru ([94.100.181.184]:40230 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934718AbaH1I5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:57:21 -0400
Message-ID: <53FEEEC9.5090403@list.ru>
Date: Thu, 28 Aug 2014 12:56:41 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sh: get_user_pages_fast() must flush cache the way
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, could you please apply?


-=-=-=-=-=-=-=-=-=# Don't remove this line #=-=-=-=-=-=-=-=-=-
This patch avoids fuse hangs on sh4 by flushing the cache on
get_user_pages_fast(). This is not necessary a good thing to do,
but get_user_pages() does this, so get_user_pages_fast() should too.

Please note the patch for mips arch that addresses the similar problem:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/ralf/linux/+/linux-3.4.50%5E!/#F0
They basically simply disable get_user_pages_fast() at all, using a
fall-back to get_user_pages(). But my fix is different, it adds an
explicit cache flushes.

Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
---
 arch/sh/mm/gup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index bf8daf9..37458f3 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -105,6 +105,8 @@ static noinline int gup_pte_range(pmd_t pmd,
unsigned long addr,
         VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
         page = pte_page(pte);
         get_page(page);
+        __flush_anon_page(page, addr);
+        flush_dcache_page(page);
         pages[*nr] = page;
         (*nr)++;
 
-- 
1.7.11.7

