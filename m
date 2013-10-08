Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3JHHvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:51:17 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42519 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3JHHvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:51:16 -0400
Date: Tue, 8 Oct 2013 09:51:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: fix __get_user_pages_fast() irq handling
Message-ID: <20131008075111.GB4252@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100807-8372-0000-0000-00000765D462
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1454d5ca6209926a52c2fdea9ba41a41a33e4046 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 8 Oct 2013 09:46:00 +0200
Subject: [PATCH] powerpc: fix __get_user_pages_fast() irq handling

__get_user_pages_fast() may be called with interrupts disabled (see e.g.
get_futex_key() in kernel/futex.c) and therefore should use local_irq_save()
and local_irq_restore() instead of local_irq_disable()/enable().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Please note that this patch is completely untested; not even compile
tested. I just realized that there seems to be a bug when looking at
the powerpc code ;)

 arch/powerpc/mm/gup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index 6936547..c5f734e 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -123,6 +123,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	struct mm_struct *mm = current->mm;
 	unsigned long addr, len, end;
 	unsigned long next;
+	unsigned long flags;
 	pgd_t *pgdp;
 	int nr = 0;
 
@@ -156,7 +157,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * So long as we atomically load page table pointers versus teardown,
 	 * we can follow the address down to the the page and take a ref on it.
 	 */
-	local_irq_disable();
+	local_irq_save(flags);
 
 	pgdp = pgd_offset(mm, addr);
 	do {
@@ -179,7 +180,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			break;
 	} while (pgdp++, addr = next, addr != end);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 
 	return nr;
 }
-- 
1.8.3.4

