Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3A2Msr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:48:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:64169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3A2Mso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:48:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,559,1355126400"; 
   d="scan'208";a="249702128"
Date: Tue, 29 Jan 2013 14:48:37 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <5107c525eb8d1_f167d78c8425f9@blue.mail>
In-Reply-To: <CAJd=RBCCmDrS=866SMEezcsCCX3vrfnusUFoyaRQb+c=JCkFEg@mail.gmail.com>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com> <1359365068-10147-7-git-send-email-kirill.shutemov@linux.intel.com> <CAJd=RBCCmDrS=866SMEezcsCCX3vrfnusUFoyaRQb+c=JCkFEg@mail.gmail.com>
Subject: Re: [PATCH, RFC 06/16] thp, mm: rewrite add_to_page_cache_locked() to
 support huge pages
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Mon, Jan 28, 2013 at 5:24 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > +       page_cache_get(page);
> > +       spin_lock_irq(&mapping->tree_lock);
> > +       page->mapping = mapping;
> > +       if (PageTransHuge(page)) {
> > +               int i;
> > +               for (i = 0; i < HPAGE_CACHE_NR; i++) {
> > +                       page_cache_get(page + i);
> > +                       page[i].index = offset + i;
> > +                       error = radix_tree_insert(&mapping->page_tree,
> > +                                       offset + i, page + i);
> > +                       if (error) {
> > +                               page_cache_release(page + i);
> > +                               break;
> > +                       }
> 
> Is page count balanced with the following?

It's broken. Last minue changes are evil :(

Thanks for catching it. I'll fix it in next revision.

> @@ -168,6 +180,9 @@ void delete_from_page_cache(struct page *page)
> 
>         if (freepage)
>                 freepage(page);
> +       if (PageTransHuge(page))
> +               for (i = 1; i < HPAGE_CACHE_NR; i++)
> +                       page_cache_release(page);
>         page_cache_release(page);

-- 
 Kirill A. Shutemov
