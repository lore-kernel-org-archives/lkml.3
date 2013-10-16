Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab3JPMJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:09:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:13541 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760576Ab3JPMJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:09:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,507,1378882800"; 
   d="scan'208";a="375505538"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CACz4_2fiF+vaAbFixgGF+Uxn0av4H8y-aMQdyi3yYs5pdS2WBA@mail.gmail.com>
References: <20131015001304.GH3432@hippobay.mtv.corp.google.com>
 <20131015110146.7E8BEE0090@blue.fi.intel.com>
 <CACz4_2fiF+vaAbFixgGF+Uxn0av4H8y-aMQdyi3yYs5pdS2WBA@mail.gmail.com>
Subject: Re: [PATCH 07/12] mm, thp, tmpfs: handle huge page in
 shmem_undo_range for truncate
Content-Transfer-Encoding: 7bit
Message-Id: <20131016120951.B5012E0090@blue.fi.intel.com>
Date: Wed, 16 Oct 2013 15:09:51 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> > Again. Here and below ifdef is redundant: PageTransHugeCache() is zero
> > compile-time and  thp case will be optimize out.
> 
> The problem is actually from HPAGE_CACHE_INDEX_MASK, it is marked as
> build bug when CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE is false. So we
> either wrap some logic inside a inline function, or we have to be like
> this .. Or we don't treat the HPAGE_CACHE_INDEX_MASK as a build bug?

HPAGE_CACHE_INDEX_MASK shouldn't be a problem.
If it's wrapped into 'if PageTransHugeCache(page)' or similar it will be
eliminated by compiler if thp-pc disabled and build bug will not be
triggered.

> 
> >
> > And do we really need a copy of truncate logic here? Is there a way to
> > share code?
> >
> The truncate between tmpfs and general one is similar but not exactly
> the same (no readahead), so share the whole function might not be a
> good choice from the perspective of tmpfs? Anyway, there are other
> similar functions in tmpfs, e.g. the one you mentioned for
> shmem_add_to_page_cache. It is possible to share the code, I am just
> worried it will make the logic more complicated?

I think introducing thp-pc is good opportunity to refactor all these code.

-- 
 Kirill A. Shutemov
