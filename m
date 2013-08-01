Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3HAGAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:00:04 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38695 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3HAGAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:00:01 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 8/8] prepare to remove /proc/sys/vm/hugepages_treat_as_movable
In-Reply-To: <1375302249-scfvftrh-mutt-n-horiguchi@ah.jp.nec.com>
References: <1374728103-17468-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1374728103-17468-9-git-send-email-n-horiguchi@ah.jp.nec.com> <87k3k7q4ox.fsf@linux.vnet.ibm.com> <1375302249-scfvftrh-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Thu, 01 Aug 2013 11:29:39 +0530
Message-ID: <87vc3qvtmc.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080105-5490-0000-0000-000003EB6F90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> On Wed, Jul 31, 2013 at 12:02:30AM +0530, Aneesh Kumar K.V wrote:
>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
>> 
>> > Now hugepages are definitely movable. So allocating hugepages from
>> > ZONE_MOVABLE is natural and we have no reason to keep this parameter.
>> > In order to allow userspace to prepare for the removal, let's leave
>> > this sysctl handler as noop for a while.
>> 
>> I guess you still need to handle architectures for which pmd_huge is
>> 
>> int pmd_huge(pmd_t pmd)
>> {
>> 	return 0;
>> }
>> 
>> embedded powerpc is one. They don't store pte information at the PMD
>> level. Instead pmd contains a pointer to hugepage directory which
>> contain huge pte.
>
> It seems that this comment is for the whole series, not just for this
> patch, right?
>
> Some users of hugepage migration (mbind, move_pages, migrate_pages)
> walk over page tables to collect hugepages to be migrated, where
> hugepages are just ignored in such architectures due to pmd_huge.
> So no problem for these users.
>
> But the other users (softoffline, memory hotremove) choose hugepages
> to be migrated based on pfn, where they don't check pmd_huge.
> As you wrote, this can be problematic for such architectures.
> So I think of adding pmd_huge() check somewhere (in unmap_and_move_huge_page
> for example) to make it fail for such architectures.

Considering that we have architectures that won't support migrating
explicit hugepages with this patch series, is it ok to use
GFP_HIGHUSER_MOVABLE for hugepage allocation ?

-aneesh

