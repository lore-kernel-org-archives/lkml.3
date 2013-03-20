Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3CTHlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:41:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab3CTHlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:41:22 -0400
Date: Wed, 20 Mar 2013 08:41:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] migrate: enable migrate_pages() to migrate hugepage
Message-ID: <20130320074118.GB20045@dhcp22.suse.cz>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130318154057.GS10192@dhcp22.suse.cz>
 <1363651636-3lsf20se-mutt-n-horiguchi@ah.jp.nec.com>
 <20130319071113.GD5112@dhcp22.suse.cz>
 <1363759974-38t0k25g-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363759974-38t0k25g-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-03-13 02:12:54, Naoya Horiguchi wrote:
> On Tue, Mar 19, 2013 at 08:11:13AM +0100, Michal Hocko wrote:
> > On Mon 18-03-13 20:07:16, Naoya Horiguchi wrote:
> > > On Mon, Mar 18, 2013 at 04:40:57PM +0100, Michal Hocko wrote:
> > > > On Thu 21-02-13 14:41:44, Naoya Horiguchi wrote:
> ...
> > > > > @@ -536,6 +557,11 @@ static inline int check_pmd_range(struct vm_area_struct *vma, pud_t *pud,
> > > > >  	pmd = pmd_offset(pud, addr);
> > > > >  	do {
> > > > >  		next = pmd_addr_end(addr, end);
> > > > > +		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
> > > > 
> > > > Why an explicit check for is_vm_hugetlb_page here? Isn't pmd_huge()
> > > > sufficient?
> > > 
> > > I think we need both check here because if we use only pmd_huge(),
> > > pmd for thp goes into this branch wrongly. 
> > 
> > Bahh. You are right. I thought that pmd_huge is hugetlb thingy but it
> > obviously checks only _PAGE_PSE same as pmd_large() which is really
> > unfortunate and confusing. Can we make it hugetlb specific?
> 
> I agree that we had better fix this confusion.
> 
> What pmd_huge() (or pmd_large() in some architectures) does is just
> checking whether a given pmd is pointing to huge/large page or not.
> It does not say which type of hugepage it is.
> So it shouldn't be used to decide whether the hugepage are hugetlbfs or not.
> I think it would be better to introduce pmd_hugetlb() which has pmd and vma
> as arguments and returns true only for hugetlbfs pmd.
> Checking pmd_hugetlb() should come before checking pmd_trans_huge() because
> pmd_trans_huge() implicitly assumes that the vma which covers the virtual
> address of a given pmd is not hugetlbfs vma.
> 
> I'm interested in this cleanup, so will work on it after this patchset.

pnd_huge is used only at few places so it shouldn't be very big. On the
other hand you do not have vma always available so it is getting tricky.

Thanks
-- 
Michal Hocko
SUSE Labs
