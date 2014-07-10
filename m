Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaGJN2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaGJN2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:28:15 -0400
Date: Thu, 10 Jul 2014 09:27:17 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v4 05/13] clear_refs: remove clear_refs_private->vma and
 introduce clear_refs_test_walk()
Message-ID: <20140710132717.GA12391@nhori>
References: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404234451-21695-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140710113219.GA30954@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710113219.GA30954@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 02:32:19PM +0300, Kirill A. Shutemov wrote:
> On Tue, Jul 01, 2014 at 01:07:23PM -0400, Naoya Horiguchi wrote:
> > @@ -822,38 +844,14 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> >  		};
> >  		struct mm_walk clear_refs_walk = {
> >  			.pmd_entry = clear_refs_pte_range,
> > +			.test_walk = clear_refs_test_walk,
> >  			.mm = mm,
> >  			.private = &cp,
> >  		};
> >  		down_read(&mm->mmap_sem);
> >  		if (type == CLEAR_REFS_SOFT_DIRTY)
> >  			mmu_notifier_invalidate_range_start(mm, 0, -1);
> > -		for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > -			cp.vma = vma;
> > -			if (is_vm_hugetlb_page(vma))
> > -				continue;
> > -			/*
> > -			 * Writing 1 to /proc/pid/clear_refs affects all pages.
> > -			 *
> > -			 * Writing 2 to /proc/pid/clear_refs only affects
> > -			 * Anonymous pages.
> > -			 *
> > -			 * Writing 3 to /proc/pid/clear_refs only affects file
> > -			 * mapped pages.
> > -			 *
> > -			 * Writing 4 to /proc/pid/clear_refs affects all pages.
> > -			 */
> > -			if (type == CLEAR_REFS_ANON && vma->vm_file)
> > -				continue;
> > -			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
> > -				continue;
> > -			if (type == CLEAR_REFS_SOFT_DIRTY) {
> > -				if (vma->vm_flags & VM_SOFTDIRTY)
> > -					vma->vm_flags &= ~VM_SOFTDIRTY;
> > -			}
> > -			walk_page_range(vma->vm_start, vma->vm_end,
> > -					&clear_refs_walk);
> > -		}
> > +		walk_page_range(0, ~0UL, &clear_refs_walk);
> 
> 'vma' variable is now unused in the clear_refs_write().

Yes, will remove it.

Naoya
