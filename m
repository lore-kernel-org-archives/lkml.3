Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3EWMbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:31:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:27224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099Ab3EWMbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:31:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="318352160"
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
        Dave Hansen <dave@sr71.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBAcsAk5qN1dy2OhHYqB3fuwd0RfjPK_4=E1G_k=CUwycw@mail.gmail.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-38-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBA64hW7x6u0Mou4_z_Ox3J+sC3ZL+a4h8XcTHbXZicALg@mail.gmail.com>
 <20130523120856.DD752E0090@blue.fi.intel.com>
 <CAJd=RBAcsAk5qN1dy2OhHYqB3fuwd0RfjPK_4=E1G_k=CUwycw@mail.gmail.com>
Subject: Re: [PATCHv4 37/39] thp: handle write-protect exception to
 file-backed huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130523123318.A5285E0090@blue.fi.intel.com>
Date: Thu, 23 May 2013 15:33:18 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Thu, May 23, 2013 at 8:08 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Hillf Danton wrote:
> >> On Sun, May 12, 2013 at 9:23 AM, Kirill A. Shutemov
> >> <kirill.shutemov@linux.intel.com> wrote:
> >> > @@ -1120,7 +1119,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
> >> >
> >> >         page = pmd_page(orig_pmd);
> >> >         VM_BUG_ON(!PageCompound(page) || !PageHead(page));
> >> > -       if (page_mapcount(page) == 1) {
> >> > +       if (PageAnon(page) && page_mapcount(page) == 1) {
> >>
> >> Could we avoid copying huge page if
> >> no-one else is using it, no matter anon?
> >
> > No. The page is still in page cache and can be later accessed later.
> > We could isolate the page from page cache, but I'm not sure whether it's
> > good idea.
> >
> Hugetlb tries to avoid copying pahe.
> 
> 	/* If no-one else is actually using this page, avoid the copy
> 	 * and just make the page writable */
> 	avoidcopy = (page_mapcount(old_page) == 1);

It makes sense for hugetlb, since it RAM-backed only.

Currently, the project supports only ramfs, but I hope we will bring
storage-backed filesystems later. For them it would be much cheaper to
copy the page then bring it back later from storage.

And one more point: we must not ever reuse dirty pages, since it will lead
to data lost. And ramfs pages are always dirty.

-- 
 Kirill A. Shutemov
