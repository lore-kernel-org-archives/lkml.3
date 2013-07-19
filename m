Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab3GSDUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:20:12 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56884 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759599Ab3GSDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:20:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hugepage related lockdep trace.
In-Reply-To: <CAJd=RBA0UDCJGE5ua7m44hOQp5g9EQdkeC00iWSEDkmLhc0rDw@mail.gmail.com>
References: <20130717153223.GD27731@redhat.com> <20130718000901.GA31972@blaptop> <87hafrdatb.fsf@linux.vnet.ibm.com> <CAJd=RBA0UDCJGE5ua7m44hOQp5g9EQdkeC00iWSEDkmLhc0rDw@mail.gmail.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 19 Jul 2013 08:50:02 +0530
Message-ID: <87d2qfck2l.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071903-8878-0000-0000-000008053799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton <dhillf@gmail.com> writes:

> On Fri, Jul 19, 2013 at 1:42 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> Minchan Kim <minchan@kernel.org> writes:
>>> IMHO, it's a false positive because i_mmap_mutex was held by kswapd
>>> while one in the middle of fault path could be never on kswapd context.
>>>
>>> It seems lockdep for reclaim-over-fs isn't enough smart to identify
>>> between background and direct reclaim.
>>>
>>> Wait for other's opinion.
>>
>> Is that reasoning correct ?. We may not deadlock because hugetlb pages
>> cannot be reclaimed. So the fault path in hugetlb won't end up
>> reclaiming pages from same inode. But the report is correct right ?
>>
>>
>> Looking at the hugetlb code we have in huge_pmd_share
>>
>> out:
>>         pte = (pte_t *)pmd_alloc(mm, pud, addr);
>>         mutex_unlock(&mapping->i_mmap_mutex);
>>         return pte;
>>
>> I guess we should move that pmd_alloc outside i_mmap_mutex. Otherwise
>> that pmd_alloc can result in a reclaim which can call shrink_page_list ?
>>
> Hm, can huge pages be reclaimed, say by kswapd currently?

No we don't reclaim hugetlb pages.

-aneesh

