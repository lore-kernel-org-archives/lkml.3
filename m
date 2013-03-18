Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3CRLkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:40:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:56086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3CRLkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:40:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,863,1355126400"; 
   d="scan'208";a="303773630"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <5146FA90.6070906@gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <514691F5.2040204@gmail.com>
 <5146A4CC.3060306@gmail.com>
 <20130318111939.C8206E0085@blue.fi.intel.com>
 <5146FA90.6070906@gmail.com>
Subject: Re: [PATCHv2, RFC 00/30] Transparent huge page cache
Content-Transfer-Encoding: 7bit
Message-Id: <20130318114221.5C5A3E0085@blue.fi.intel.com>
Date: Mon, 18 Mar 2013 13:42:21 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Jeons wrote:
> Hi Kirill,
> On 03/18/2013 07:19 PM, Kirill A. Shutemov wrote:
> > Simon Jeons wrote:
> >> On 03/18/2013 12:03 PM, Simon Jeons wrote:
> >>> Hi Kirill,
> >>> On 03/15/2013 01:50 AM, Kirill A. Shutemov wrote:
> >>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >>>>
> >>>> Here's the second version of the patchset.
> >>>>
> >>>> The intend of the work is get code ready to enable transparent huge page
> >>>> cache for the most simple fs -- ramfs.
> >>>>
> >>>> We have read()/write()/mmap() functionality now. Still plenty work
> >>>> ahead.
> >>> One offline question.
> >>>
> >>> Why set PG_mlocked to page_tail which be splited in function
> >>> __split_huge_page_refcount?
> > Not set, but copied from head page. Head page represents up-to-date sate
> > of compound page, we need to copy it to all tail pages on split.
> 
> I always see up-to-date state, could you conclude to me which state can 
> be treated as up-to-date? :-)

While we work with huge page we only alter flags (like mlocked or
uptodate) of head page, but not tail, so we have to copy flags to all tail
pages on split. We also need to distribute _count and _mapcount properly.
Just read the code.

> 
> >   
> >> Also why can't find where _PAGE_SPLITTING and _PAGE_PSE flags are
> >> cleared in split_huge_page path?
> >   
> > The pmd is invalidated and replaced with reference to page table at the end
> > of __split_huge_page_map.
> 
> Since pmd is populated by page table and new flag why need 
> invalidated(clear present flag) before it?

Comment just before pmdp_invalidate() in __split_huge_page_map() is fairly
informative.

-- 
 Kirill A. Shutemov
