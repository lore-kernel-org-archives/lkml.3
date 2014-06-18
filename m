Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbaFRGiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:38:12 -0400
Received: from fgwmail4.fujitsu.co.jp ([164.71.1.141]:56461 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbaFRGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:38:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53A1339E.2000000@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 15:37:18 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <akpm@linux-foundation.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
CC: <tangchen@cn.fujitsu.com>, <toshi.kani@hp.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <guz.fnst@cn.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH 1/2] x86,mem-hotplug: pass sync_global_pgds() a correct argument
 in remove_pagetable()
References: <53A132E2.9000605@jp.fujitsu.com>
In-Reply-To: <53A132E2.9000605@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove_pagetable() gets start argument and passes the argument to
sync_global_pgds(). In this case, the argument must not be modified.
If the argument is modified and passed to sync_global_pgds(),
sync_global_pgds() does not correctly synchronize PGD to PGD entries
of all processes MM since synchronized range of memory [start, end]
is wrong.

Unfortunately the start argument is modified in remove_pagetable().
So this patch fixes the issue.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/x86/mm/init_64.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df1a992..a5b245d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -975,19 +975,20 @@ static void __meminit
 remove_pagetable(unsigned long start, unsigned long end, bool direct)
 {
 	unsigned long next;
+	unsigned long addr;
 	pgd_t *pgd;
 	pud_t *pud;
 	bool pgd_changed = false;

-	for (; start < end; start = next) {
-		next = pgd_addr_end(start, end);
+	for (addr = start; addr < end; addr = next) {
+		next = pgd_addr_end(addr, end);

-		pgd = pgd_offset_k(start);
+		pgd = pgd_offset_k(addr);
 		if (!pgd_present(*pgd))
 			continue;

 		pud = (pud_t *)pgd_page_vaddr(*pgd);
-		remove_pud_table(pud, start, next, direct);
+		remove_pud_table(pud, addr, next, direct);
 		if (free_pud_table(pud, pgd))
 			pgd_changed = true;
 	}

