Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3HFVzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:55:42 -0400
Received: from www.sr71.net ([198.145.64.142]:57029 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab3HFVzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:55:41 -0400
Message-ID: <520170CA.4040409@sr71.net>
Date: Tue, 06 Aug 2013 14:55:22 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Ning Qu <quning@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/23] truncate: support huge pages
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com> <1375582645-29274-20-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1375582645-29274-20-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 07:17 PM, Kirill A. Shutemov wrote:
> If a huge page is only partly in the range we zero out the part,
> exactly like we do for partial small pages.

What's the logic behind this behaviour?  Seems like the kind of place
that we would really want to be splitting pages.

> +	if (partial_thp_start || lstart & ~PAGE_CACHE_MASK) {
> +		pgoff_t off;
> +		struct page *page;
> +		unsigned pstart, pend;
> +		void (*zero_segment)(struct page *page,
> +				unsigned start, unsigned len);
> +retry_partial_start:
> +		if (partial_thp_start) {
> +			zero_segment = zero_huge_user_segment;

That's a pretty hackish way to conditionally call a function, especially
since its done twice in one function. :)

I seem to recall zero_user_segment() vs. zero_huge_user_segment() being
something that caused some ugliness in the previous versions too.
What's the barrier to just having a smart zero_..._user_segment()
function that can conditionally perform huge or base page-zeroing?

> +		if (partial_thp_end) {
> +			zero_segment = zero_huge_user_segment;
> +			off = end & ~HPAGE_CACHE_INDEX_MASK;
> +			pend = (lend - 1) & ~HPAGE_PMD_MASK;
> +		} else {
> +			zero_segment = zero_user_segment;
> +			off = end;
> +			pend = (lend - 1) & ~PAGE_CACHE_MASK;
> +		}

We went though a similar exercise for the fault code (I think), but I
really think you need to refactor this.  Way too much of the code is in
the style:

	if (thp) {
		// new behavior
	} else {
		// old behavior
	}

To me, that's just a recipe that makes it hard to review, and I also bet
it'll make the thp much more prone to bitrot.  Maybe something like this?

	size_t page_cache_mask = PAGE_CACHE_MASK;
	unsigned long end_mask = 0UL;
	
	if (partial_thp_end) {
		page_cache_mask = HPAGE_PMD_MASK;
		end_mask = HPAGE_CACHE_INDEX_MASK;
	}
	...
	magic_zero_user_segment(...);
	off = end & ~end_mask;
	pend = (lend - 1) & ~page_cache_mask;

Like I said before, I somehow like to rewrite your code. :)
