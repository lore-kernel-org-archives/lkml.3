Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3HTIXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:23:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3HTIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:23:12 -0400
Date: Tue, 20 Aug 2013 01:22:36 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-527bf129f9a780e11b251cf2467dc30118a57d16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, dave.hansen@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, dave.hansen@intel.com, tglx@linutronix.de
In-Reply-To: <1376351004-4015-1-git-send-email-yinghai@kernel.org>
References: <1376351004-4015-1-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=
 y and more than 512G RAM
Git-Commit-ID: 527bf129f9a780e11b251cf2467dc30118a57d16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 20 Aug 2013 01:22:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  527bf129f9a780e11b251cf2467dc30118a57d16
Gitweb:     http://git.kernel.org/tip/527bf129f9a780e11b251cf2467dc30118a57d16
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 12 Aug 2013 16:43:24 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 20 Aug 2013 10:06:50 +0200

x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=y and more than 512G RAM

Dave Hansen reported that systems between 500G and 600G RAM
crash early if DEBUG_PAGEALLOC is selected.

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

It turns out that we missed increasing needed pages in BRK to
mapping initial 2M and [0,1M) when we switched to use the #PF
handler to set memory mappings:

 > commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
 > Author: H. Peter Anvin <hpa@zytor.com>
 > Date:   Thu Jan 24 12:19:52 2013 -0800
 >
 >     x86, 64bit: Use a #PF handler to materialize early mappings on demand

Before that, we had the maping from [0,512M) in head_64.S, and we
can spare two pages [0-1M).  After that change, we can not reuse
pages anymore.

When we have more than 512M ram, we need an extra page for pgd page
with [512G, 1024g).

Increase pages in BRK for page table to solve the boot crash.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Bisected-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org> # v3.9 and later
Link: http://lkml.kernel.org/r/1376351004-4015-1-git-send-email-yinghai@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 2ec29ac..04664cd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -78,8 +78,8 @@ __ref void *alloc_low_pages(unsigned int num)
 	return __va(pfn << PAGE_SHIFT);
 }
 
-/* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
-#define INIT_PGT_BUF_SIZE	(5 * PAGE_SIZE)
+/* need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
+#define INIT_PGT_BUF_SIZE	(6 * PAGE_SIZE)
 RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
 void  __init early_alloc_pgt_buf(void)
 {
