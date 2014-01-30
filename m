Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaA3Nqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:46:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32704 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaA3Nqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:46:44 -0500
Message-ID: <52EA57AC.3090700@oracle.com>
Date: Thu, 30 Jan 2014 08:46:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jonathan Gonzalez <jgonzalez@linets.cl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, hugetlb: gimme back my page
References: <1391063823.2931.3.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1391063823.2931.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 01:37 AM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso<davidlohr@hp.com>
>
> While testing some changes, I noticed an issue triggered by the libhugetlbfs
> test-suite. This is caused by commit 309381fe (mm: dump page when hitting a
> VM_BUG_ON using VM_BUG_ON_PAGE), where an application can unexpectedly OOM due
> to another program that using, or reserving, pool_size-1 pages later triggers
> a VM_BUG_ON_PAGE and thus greedly leaves no memory to the rest of the hugetlb
> aware tasks. For example, in libhugetlbfs 2.14:
>
> mmap-gettest 10 32783 (2M: 64): <---- hit VM_BUG_ON_PAGE
> mmap-cow 32782 32783 (2M: 32):  FAIL    Failed to create shared mapping: Cannot allocate memory
> mmap-cow 32782 32783 (2M: 64):  FAIL    Failed to create shared mapping: Cannot allocate memory
>
> While I have not looked into why 'mmap-gettest' keeps failing, it is of no
> importance to this particular issue. This problem is similar to why we have
> the hugetlb_instantiation_mutex, hugepages are quite finite.
>
> Revert the use of VM_BUG_ON_PAGE back to just VM_BUG_ON.

VM_BUG_ON_PAGE is just a VM_BUG_ON that does dump_page before the BUG().

The only reason to use VM_BUG_ON instead of VM_BUG_ON_PAGE is if the page you're working
with doesn't make sense/isn't useful as debug output.

If doing a dump_page is causing issues somewhere then dump_pages should be fixed - instead
of hiding the problem under the rug by not using it.


Thanks,
sasha
