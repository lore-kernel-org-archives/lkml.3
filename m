Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaFJILD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:11:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaFJIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:10:59 -0400
Message-ID: <5396BD90.4060104@suse.cz>
Date: Tue, 10 Jun 2014 10:10:56 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH, RFC 00/10] THP refcounting redesign
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 06:04 PM, Kirill A. Shutemov wrote:
> Hello everybody,
>
> We've discussed few times that is would be nice to allow huge pages to be
> mapped with 4k pages too. Here's my first attempt to actually implement
> this. It's early prototype and not stabilized yet, but I want to share it
> to discuss any potential show stoppers early.
>
> The main reason why we can't map THP with 4k is how refcounting on THP
> designed. It built around two requirements:
>
>    - split of huge page should never fail;
>    - we can't change interface of get_user_page();
>
> To be able to split huge page at any point we have to track which tail
> page was pinned. It leads to tricky and expensive get_page() on tail pages
> and also occupy tail_page->_mapcount.
>
> Most split_huge_page*() users want PMD to be split into table of PTEs and
> don't care whether compound page is going to be split or not.
>
> The plan is:
>
>   - allow split_huge_page() to fail if the page is pinned. It's trivial to
>     split non-pinned page and it doesn't require tail page refcounting, so
>     tail_page->_mapcount is free to be reused.
>
>   - introduce new routine -- split_huge_pmd() -- to split PMD into table of
>     PTEs. It splits only one PMD, not touching other PMDs the page is
>     mapped with or underlying compound page. Unlike new split_huge_page(),
>     split_huge_pmd() never fails.
>
> Fortunately, we have only few places where split_huge_page() is needed:
> swap out, memory failure, migration, KSM. And all of them can handle
> split_huge_page() fail.
>
> In new scheme we use tail_page->_mapcount is used to account how many time
> the tail page is mapped. head_page->_mapcount is used for both PMD mapping
> of whole huge page and PTE mapping of the firt 4k page of the compound
> page. It seems work fine, except the fact that we don't have a cheap way
> to check whether the page mapped with PMDs or not.
>
> Introducing split_huge_pmd() effectively allows THP to be mapped with 4k.
> It can break some kernel expectations. I.e. VMA now can start and end in
> middle of compound page. IIUC, it will break compactation and probably
> something else (any hints?).

I don't think compaction cares at all about VMA's. Unless the underlying 
page migration does. What will break is munlock due to 
VM_BUG_ON(PageTail(page)) in the PageTransHuge() check.

> Also munmap() on part of huge page will not split and free unmapped part
> immediately. We need to be careful here to keep memory footprint under
> control.

So who will take care of it, if it's not done immediately?

> As side effect we don't need to mark PMD splitting since we have
> split_huge_pmd(). get_page()/put_page() on tail of THP is cheaper (and
> cleaner) now.

But per patch 2, PageAnon() is more expensive. Also there are no side 
effects to this change?

> I will continue with stabilizing this. The patchset also available on
> git[1].
>
> Any commemnt?
>
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git thp/refcounting/v1
>
