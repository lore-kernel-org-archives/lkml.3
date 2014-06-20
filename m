Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbaFTRqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:46:19 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:45919 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaFTRqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:46:14 -0400
Date: Fri, 20 Jun 2014 20:45:33 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/13] mm, THP: don't hold mmap_sem in khugepaged when
 allocating THP
Message-ID: <20140620174533.GA9635@node.dhcp.inet.fi>
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz>
 <1403279383-5862-2-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403279383-5862-2-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 05:49:31PM +0200, Vlastimil Babka wrote:
> When allocating huge page for collapsing, khugepaged currently holds mmap_sem
> for reading on the mm where collapsing occurs. Afterwards the read lock is
> dropped before write lock is taken on the same mmap_sem.
> 
> Holding mmap_sem during whole huge page allocation is therefore useless, the
> vma needs to be rechecked after taking the write lock anyway. Furthemore, huge
> page allocation might involve a rather long sync compaction, and thus block
> any mmap_sem writers and i.e. affect workloads that perform frequent m(un)map
> or mprotect oterations.
> 
> This patch simply releases the read lock before allocating a huge page. It
> also deletes an outdated comment that assumed vma must be stable, as it was
> using alloc_hugepage_vma(). This is no longer true since commit 9f1b868a13
> ("mm: thp: khugepaged: add policy for finding target node").

There is no point in touching ->mmap_sem in khugepaged_alloc_page() at
all. Please, move up_read() outside khugepaged_alloc_page().

-- 
 Kirill A. Shutemov
