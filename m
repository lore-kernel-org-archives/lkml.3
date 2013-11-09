Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3KIHBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:01:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3KIGwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 75/94] mm: /proc/pid/pagemap: inspect _PAGE_SOFT_DIRTY only on present pages
Date: Fri,  8 Nov 2013 22:52:21 -0800
Message-Id: <20131109065209.559757151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrill Gorcunov <gorcunov@gmail.com>

commit e9cdd6e771580e6ff872e5c64e8b766972c7d1bc upstream.

If a page we are inspecting is in swap we may occasionally report it as
having soft dirty bit (even if it is clean).  The pte_soft_dirty helper
should be called on present pte only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -938,6 +938,8 @@ static void pte_to_pagemap_entry(pagemap
 		frame = pte_pfn(pte);
 		flags = PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
+		if (pte_soft_dirty(pte))
+			flags2 |= __PM_SOFT_DIRTY;
 	} else if (is_swap_pte(pte)) {
 		swp_entry_t entry;
 		if (pte_swp_soft_dirty(pte))
@@ -955,8 +957,6 @@ static void pte_to_pagemap_entry(pagemap
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (pte_soft_dirty(pte))
-		flags2 |= __PM_SOFT_DIRTY;
 
 	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, flags2) | flags);
 }


