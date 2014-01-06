Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaAFMp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:45:56 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53079 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaAFMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:45:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140106112422.GA27602@dhcp22.suse.cz>
References: <20140106112422.GA27602@dhcp22.suse.cz>
Date: Mon, 6 Jan 2014 20:45:54 +0800
Message-ID: <CAA_GA1dNdrG9aQ3UKDA0O=BY721rvseORVkc2+RxUpzysp3rYw@mail.gmail.com>
Subject: Re: could you clarify mm/mempolicy: fix !vma in new_vma_page()
From: Bob Liu <lliubbo@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bob Liu <bob.liu@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, Jan 6, 2014 at 7:24 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Hi Wanpeng Li,
> I have just noticed 11c731e81bb0 (mm/mempolicy: fix !vma in
> new_vma_page()) and I am not sure I understand it. Your changelog claims
> "
>     page_address_in_vma() may still return -EFAULT because of many other
>     conditions in it.  As a result the while loop in new_vma_page() may end
>     with vma=NULL.
> "
>
> And the patch handles hugetlb case only. I was wondering what are those
> "other conditions" that failed in the BUG_ON mentioned in the changelog?
> Could you be more specific please?
>

Sorry for the confusion caused.
The code of new_vma_page() used to like this:
1193         while (vma) {
1194                 address = page_address_in_vma(page, vma);
1195                 if (address != -EFAULT)
1196                         break;
1197                 vma = vma->vm_next;
1198         }
1199         /*
1200          * queue_pages_range() confirms that @page belongs to some vma,
1201          * so vma shouldn't be NULL.
1202          */
1203         BUG_ON(!vma);
1204
1205         if (PageHuge(page))
1206                 return alloc_huge_page_noerr(vma, address, 1);
1207         return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);

The BUG_ON() was triggered and my idea was that even
queue_pages_range() confirms @page belongs to some vma,
page_address_in_vma() may still return -EFAULT because of below checks
in page_address_in_vma().

544         if (PageAnon(page)) {
 545                 struct anon_vma *page__anon_vma = page_anon_vma(page);
 546                 /*
 547                  * Note: swapoff's unuse_vma() is more efficient with this
 548                  * check, and needs it to match anon_vma when KSM
is active.
 549                  */
 550                 if (!vma->anon_vma || !page__anon_vma ||
 551                     vma->anon_vma->root != page__anon_vma->root)
 552                         return -EFAULT;
 553         } else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 554                 if (!vma->vm_file ||
 555                     vma->vm_file->f_mapping != page->mapping)
 556                         return -EFAULT;
 557         } else
 558                 return -EFAULT;

That's the "other conditions" and the reason why we can't use
BUG_ON(!vma) in new_vma_page().

-- 
Regards,
--Bob
