Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3CONV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:21:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:6237 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3CONVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:21:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="279996801"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBAH1+YaDvL9=ayx2j6b4jx0CzBZGrAL9LVwPMx4Y=s3Rg@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-9-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBAH1+YaDvL9=ayx2j6b4jx0CzBZGrAL9LVwPMx4Y=s3Rg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 08/30] thp, mm: rewrite add_to_page_cache_locked()
 to support huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132333.B8205E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:23:33 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > +       page_cache_get(page);
> > +       spin_lock_irq(&mapping->tree_lock);
> > +       page->mapping = mapping;
> > +       page->index = offset;
> > +       error = radix_tree_insert(&mapping->page_tree, offset, page);
> > +       if (unlikely(error))
> > +               goto err;
> > +       if (PageTransHuge(page)) {
> > +               int i;
> > +               for (i = 1; i < HPAGE_CACHE_NR; i++) {
> 			struct page *tail = page + i; to easy reader
> 
> > +                       page_cache_get(page + i);
> s/page_cache_get/get_page_foll/ ?

Why?

> > +                       page[i].index = offset + i;
> > +                       error = radix_tree_insert(&mapping->page_tree,
> > +                                       offset + i, page + i);
> > +                       if (error) {
> > +                               page_cache_release(page + i);
> > +                               break;
> > +                       }
> >                 }
> > -               radix_tree_preload_end();
> > -       } else
> > -               mem_cgroup_uncharge_cache_page(page);
> > -out:
> > +               if (error) {
> > +                       error = ENOSPC; /* no space for a huge page */
> s/E/-E/

Good catch! Thanks.

> > +                       for (i--; i > 0; i--) {
> > +                               radix_tree_delete(&mapping->page_tree,
> > +                                               offset + i);
> > +                               page_cache_release(page + i);
> > +                       }
> > +                       radix_tree_delete(&mapping->page_tree, offset);
> > +                       goto err;
> > +               }
> > +       }

-- 
 Kirill A. Shutemov
