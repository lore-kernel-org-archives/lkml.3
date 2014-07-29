Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaG2X0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:26:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50236 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaG2X0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:26:39 -0400
Date: Tue, 29 Jul 2014 16:26:35 -0700 (PDT)
Message-Id: <20140729.162635.638786990787878495.davem@davemloft.net>
To: mroos@linux.ee
Cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1404170119550.20193@math.ut.ee>
References: <20140414184353.GA5630@drone.musicnaut.iki.fi>
	<20140416.145822.1317931249717152474.davem@davemloft.net>
	<alpine.SOC.1.00.1404170119550.20193@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Jul 2014 16:26:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mroos@linux.ee
Date: Thu, 17 Apr 2014 01:22:17 +0300 (EEST)

>> > Just for the archives, I got one of these again with 3.14:
>> 
>> Meelis and Aaro, thanks again for all of your reports.
>> 
>> After pouring over a lot of the data and auditing some code I'm
>> suspecting it's a problem with transparent huge pages.
>> 
>> One thing you two can do to help me further confirm this is to run
>> with THP disabled for a while and see if you still get the log
>> messages.
> 
> I have snice turned off CONFIG_TRANSPARENT_HUGEPAGE on 3 of 4 servers 
> that had this problem (actually most of my sparc64 machines) and the 4th 
> has
> 
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not se
> 
> and also has not had this problem since then. All 4 machines have been 
> running through most -rc's of every kernel.

Here is something I'd like you guys to test.

Yesterday, Christopher (CC:'d), posted some fixes yesterday and one of
them is very interesting.

Basically the update_mmu_cache() methods on sparc64 can insert an
invalid PTE into the TSB hash tables, causing livelocks and other
annoying issues.

The path where this can happen is via remove_migration_pte().

I had a discussion with Johannes Weiner about this and we determined
that it would make sense to mis-diagnose THP as being the root cause
in the RSS counter et al. problems if this bug here is the real
reason those things are happening.

That's because if you're not using THP there is less compaction going
on.  Less compaction means less migration, and therefore a lower
likelyhood of this code path triggering like this.

Could you guys please try this patch below?  Thanks.

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 16b58ff..8e894e0 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -351,6 +351,10 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 
 	mm = vma->vm_mm;
 
+	/* Don't insert a non-valid PTE into the TSB, we'll deadlock.  */
+	if (!pte_accessible(mm, pte))
+		return;
+
 	spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
@@ -2617,6 +2621,10 @@ void update_mmu_cache_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (!pmd_large(entry) || !pmd_young(entry))
 		return;
 
+	/* Don't insert a non-valid PMD into the TSB, we'll deadlock.  */
+	if (!(pte & _PAGE_VALID))
+		return;
+
 	pte = pmd_val(entry);
 
 	/* We are fabricating 8MB pages using 4MB real hw pages.  */
