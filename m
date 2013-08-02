Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3HBCnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab3HBCnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:43:50 -0400
Date: Thu, 01 Aug 2013 22:43:16 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1375411396-bw4cbhso-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <87vc3qvtmc.fsf@linux.vnet.ibm.com>
References: <1374728103-17468-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1374728103-17468-9-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87k3k7q4ox.fsf@linux.vnet.ibm.com>
 <1375302249-scfvftrh-mutt-n-horiguchi@ah.jp.nec.com>
 <87vc3qvtmc.fsf@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/8] prepare to remove
 /proc/sys/vm/hugepages_treat_as_movable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 11:29:39AM +0530, Aneesh Kumar K.V wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > On Wed, Jul 31, 2013 at 12:02:30AM +0530, Aneesh Kumar K.V wrote:
> >> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> >> 
> >> > Now hugepages are definitely movable. So allocating hugepages from
> >> > ZONE_MOVABLE is natural and we have no reason to keep this parameter.
> >> > In order to allow userspace to prepare for the removal, let's leave
> >> > this sysctl handler as noop for a while.
> >> 
> >> I guess you still need to handle architectures for which pmd_huge is
> >> 
> >> int pmd_huge(pmd_t pmd)
> >> {
> >> 	return 0;
> >> }
> >> 
> >> embedded powerpc is one. They don't store pte information at the PMD
> >> level. Instead pmd contains a pointer to hugepage directory which
> >> contain huge pte.
> >
> > It seems that this comment is for the whole series, not just for this
> > patch, right?
> >
> > Some users of hugepage migration (mbind, move_pages, migrate_pages)
> > walk over page tables to collect hugepages to be migrated, where
> > hugepages are just ignored in such architectures due to pmd_huge.
> > So no problem for these users.
> >
> > But the other users (softoffline, memory hotremove) choose hugepages
> > to be migrated based on pfn, where they don't check pmd_huge.
> > As you wrote, this can be problematic for such architectures.
> > So I think of adding pmd_huge() check somewhere (in unmap_and_move_huge_page
> > for example) to make it fail for such architectures.
> 
> Considering that we have architectures that won't support migrating
> explicit hugepages with this patch series, is it ok to use
> GFP_HIGHUSER_MOVABLE for hugepage allocation ?

Originally this parameter was introduced to make hugepage pool on ZONE_MOVABLE.
The benefit is that we can extend the hugepage pool more easily,
because external fragmentation less likely happens than other zone type
by rearranging fragmented pages with page migration/reclaim.

So I think using ZONE_MOVABLE for hugepage allocation by default makes sense
even on the architectures which don't support hugepage migration.

Thanks,
Naoya Horiguchi
