Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbaKRXn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:43:59 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:46044 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbaKRXn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:43:58 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Dave Hansen" <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
Thread-Topic: [PATCH 06/19] mm: store mapcount for compound page separate
Thread-Index: AQHP+QfhC/Yx8W8vu0evpav335us2Zxljo2AgAAU1YCAAOYbgA==
Date: Tue, 18 Nov 2014 23:41:08 +0000
Message-ID: <20141118234145.GA4116@hori1.linux.bs1.fc.nec.co.jp>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
 <20141118084337.GA16714@hori1.linux.bs1.fc.nec.co.jp>
 <20141118095811.GA21774@node.dhcp.inet.fi>
In-Reply-To: <20141118095811.GA21774@node.dhcp.inet.fi>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.11]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <0ACED6FBA3CFB049B5DB2D7AC4EB0B4F@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:58:11AM +0200, Kirill A. Shutemov wrote:
> On Tue, Nov 18, 2014 at 08:43:00AM +0000, Naoya Horiguchi wrote:
> > > @@ -1837,6 +1839,9 @@ static void __split_huge_page_refcount(struct page *page,
> > >  	atomic_sub(tail_count, &page->_count);
> > >  	BUG_ON(atomic_read(&page->_count) <= 0);
> > >  
> > > +	page->_mapcount = *compound_mapcount_ptr(page);
> > 
> > Is atomic_set() necessary?
> 
> Do you mean
> 	atomic_set(&page->_mapcount, atomic_read(compound_mapcount_ptr(page)));
> ?
> 
> I don't see why we would need this. Simple assignment should work just
> fine. Or we have archs which will break?

Sorry, I was wrong, please ignore this comment.

> > > @@ -6632,10 +6637,12 @@ static void dump_page_flags(unsigned long flags)
> > >  void dump_page_badflags(struct page *page, const char *reason,
> > >  		unsigned long badflags)
> > >  {
> > > -	printk(KERN_ALERT
> > > -	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
> > > +	pr_alert("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
> > >  		page, atomic_read(&page->_count), page_mapcount(page),
> > >  		page->mapping, page->index);
> > > +	if (PageCompound(page))
> > 
> > > +		printk(" compound_mapcount: %d", compound_mapcount(page));
> > > +	printk("\n");
> > 
> > These two printk() should be pr_alert(), too?
> 
> No. It will split the line into several messages in dmesg.

This splitting is fine. I meant that these printk()s are for one series
of message, so setting the same log level looks reasonable to me.

> > > @@ -986,9 +986,30 @@ void page_add_anon_rmap(struct page *page,
> > >  void do_page_add_anon_rmap(struct page *page,
> > >  	struct vm_area_struct *vma, unsigned long address, int flags)
> > >  {
> > > -	int first = atomic_inc_and_test(&page->_mapcount);
> > > +	bool compound = flags & RMAP_COMPOUND;
> > > +	bool first;
> > > +
> > > +	VM_BUG_ON_PAGE(!PageLocked(compound_head(page)), page);
> > > +
> > > +	if (PageTransCompound(page)) {
> > > +		struct page *head_page = compound_head(page);
> > > +
> > > +		if (compound) {
> > > +			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
> > > +			first = atomic_inc_and_test(compound_mapcount_ptr(page));
> > 
> > Is compound_mapcount_ptr() well-defined for tail pages?
> 
> The page is head page, otherwise VM_BUG_ON on the line above would trigger.

Ah, OK.

Thanks,
Naoya Horiguchi

> > > @@ -1032,10 +1052,19 @@ void page_add_new_anon_rmap(struct page *page,
> > >  
> > >  	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
> > >  	SetPageSwapBacked(page);
> > > -	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
> > >  	if (compound) {
> > > +		atomic_t *compound_mapcount;
> > > +
> > >  		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
> > > +		compound_mapcount = (atomic_t *)&page[1].mapping;
> > 
> > You can use compound_mapcount_ptr() here.
> 
> Right, thanks.
> 
> -- 
>  Kirill A. Shutemov
> 