Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaFWFjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 01:39:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21622 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbaFWFjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 01:39:41 -0400
X-IronPort-AV: E=Sophos;i="5.00,758,1396972800"; 
   d="scan'208";a="32269592"
Message-ID: <53A7BD91.8020802@cn.fujitsu.com>
Date: Mon, 23 Jun 2014 13:39:29 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Vlastimil Babka <vbabka@suse.cz>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/13] mm, THP: don't hold mmap_sem in khugepaged when
 allocating THP
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz> <1403279383-5862-2-git-send-email-vbabka@suse.cz> <20140620174533.GA9635@node.dhcp.inet.fi>
In-Reply-To: <20140620174533.GA9635@node.dhcp.inet.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On 06/21/2014 01:45 AM, Kirill A. Shutemov wrote:
> On Fri, Jun 20, 2014 at 05:49:31PM +0200, Vlastimil Babka wrote:
>> When allocating huge page for collapsing, khugepaged currently holds mmap_sem
>> for reading on the mm where collapsing occurs. Afterwards the read lock is
>> dropped before write lock is taken on the same mmap_sem.
>>
>> Holding mmap_sem during whole huge page allocation is therefore useless, the
>> vma needs to be rechecked after taking the write lock anyway. Furthemore, huge
>> page allocation might involve a rather long sync compaction, and thus block
>> any mmap_sem writers and i.e. affect workloads that perform frequent m(un)map
>> or mprotect oterations.
>>
>> This patch simply releases the read lock before allocating a huge page. It
>> also deletes an outdated comment that assumed vma must be stable, as it was
>> using alloc_hugepage_vma(). This is no longer true since commit 9f1b868a13
>> ("mm: thp: khugepaged: add policy for finding target node").
> 
> There is no point in touching ->mmap_sem in khugepaged_alloc_page() at
> all. Please, move up_read() outside khugepaged_alloc_page().
> 

I might be wrong. If we up_read in khugepaged_scan_pmd(), then if we round again
do the for loop to get the next vma and handle it. Does we do this without holding
the mmap_sem in any mode?

And if the loop end, we have another up_read in breakouterloop. What if we have
released the mmap_sem in collapse_huge_page()?

-- 
Thanks.
Zhang Yanfei
