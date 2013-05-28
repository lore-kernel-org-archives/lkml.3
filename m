Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab3E1MvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:51:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:25090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab3E1Mu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="344349854"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
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
In-Reply-To: <519BD65C.1050709@sr71.net>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-16-git-send-email-kirill.shutemov@linux.intel.com>
 <519BD65C.1050709@sr71.net>
Subject: Re: [PATCHv4 15/39] thp, mm: trigger bug in replace_page_cache_page()
 on THP
Content-Transfer-Encoding: 7bit
Message-Id: <20130528125328.5385CE0090@blue.fi.intel.com>
Date: Tue, 28 May 2013 15:53:28 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > replace_page_cache_page() is only used by FUSE. It's unlikely that we
> > will support THP in FUSE page cache any soon.
> > 
> > Let's pospone implemetation of THP handling in replace_page_cache_page()
> > until any will use it.
> ...
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 657ce82..3a03426 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -428,6 +428,8 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> >  {
> >  	int error;
> >  
> > +	VM_BUG_ON(PageTransHuge(old));
> > +	VM_BUG_ON(PageTransHuge(new));
> >  	VM_BUG_ON(!PageLocked(old));
> >  	VM_BUG_ON(!PageLocked(new));
> >  	VM_BUG_ON(new->mapping);
> 
> The code calling replace_page_cache_page() has a bunch of fallback and
> error returning code.  It seems a little bit silly to bring the whole
> machine down when you could just WARN_ONCE() and return an error code
> like fuse already does:

What about:

	if (WARN_ONCE(PageTransHuge(old) || PageTransHuge(new),
		     "%s: unexpected huge page\n", __func__))
		return -EINVAL;

?

-- 
 Kirill A. Shutemov
