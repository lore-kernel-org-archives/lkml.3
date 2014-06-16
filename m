Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaFPQpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbaFPQpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:45:00 -0400
Date: Mon, 16 Jun 2014 12:44:49 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 7/7] mincore: apply page table walker on do_mincore()
Message-ID: <20140616164449.GB13264@nhori.bos.redhat.com>
References: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1402095520-10109-8-git-send-email-n-horiguchi@ah.jp.nec.com>
 <539F0C20.10101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539F0C20.10101@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

Thanks for bug reporting.

On Mon, Jun 16, 2014 at 11:24:16AM -0400, Sasha Levin wrote:
> On 06/06/2014 06:58 PM, Naoya Horiguchi wrote:
> > This patch makes do_mincore() use walk_page_vma(), which reduces many lines
> > of code by using common page table walk code.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> Hi Naoya,
> 
> This patch is causing a few issues on -next:
> 
> [  367.679282] BUG: sleeping function called from invalid context at mm/mincore.c:37

cond_resched() in mincore_hugetlb() triggered this. This is done in common
pagewalk code, so I should have removed it.

...
> And:
> 
> [  391.118663] BUG: unable to handle kernel paging request at ffff880142aca000
> [  391.118663] IP: mincore_hole (mm/mincore.c:99 (discriminator 2))

walk->pte_hole cannot assume walk->vma != NULL, so I should've checked it
in mincore_hole() before using walk->vma.

Could you try the following fixes?

Thanks,
Naoya Horiguchi
---
diff --git a/mm/mincore.c b/mm/mincore.c
index d8a5e9f62268..3261788369bd 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -34,7 +34,6 @@ static int mincore_hugetlb(pte_t *pte, unsigned long addr,
 	present = pte && !huge_pte_none(huge_ptep_get(pte));
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
-	cond_resched();
 	walk->private += (end - addr) >> PAGE_SHIFT;
 #else
 	BUG();
@@ -91,7 +90,7 @@ static int mincore_hole(unsigned long addr, unsigned long end,
 	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
 
-	if (vma->vm_file) {
+	if (vma && vma->vm_file) {
 		pgoff_t pgoff;
 
 		pgoff = linear_page_index(vma, addr);
