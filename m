Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab3JOUQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759712Ab3JOUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:16:33 -0400
Date: Tue, 15 Oct 2013 16:16:23 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1381868183-6d50s9n5-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20131015194428.GI3479@redhat.com>
References: <alpine.LNX.2.00.1310150358170.11905@eggly.anvils>
 <20131015143407.GE3479@redhat.com>
 <20131015144827.C45DDE0090@blue.fi.intel.com>
 <alpine.LNX.2.00.1310151029040.12481@eggly.anvils>
 <20131015185510.GH3479@redhat.com>
 <1381865330-8nb86ucy-mutt-n-horiguchi@ah.jp.nec.com>
 <20131015194428.GI3479@redhat.com>
Subject: Re: mm: fix BUG in __split_huge_page_pmd
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20131015194428.GI3479@redhat.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:44:28PM +0200, Andrea Arcangeli wrote:
> On Tue, Oct 15, 2013 at 03:28:50PM -0400, Naoya Horiguchi wrote:
> > On Tue, Oct 15, 2013 at 08:55:10PM +0200, Andrea Arcangeli wrote:
> > > On Tue, Oct 15, 2013 at 10:53:10AM -0700, Hugh Dickins wrote:
> > > > I'm afraid Andrea's mail about concurrent madvises gives me far more
> > > > to think about than I have time for: seems to get into problems he
> > > > knows a lot about but I'm unfamiliar with.  If this patch looks good
> > > > for now on its own, let's put it in; but no problem if you guys prefer
> > > > to wait for a fuller solution of more problems, we can ride with this
> > > > one internally for the moment.
> > > 
> > > I'm very happy with the patch and I think it's a correct fix for the
> > > COW scenario which is deterministic so the looping makes a meaningful
> > > difference for it. If we wouldn't loop, part of the copied page
> > > wouldn't be zapped after the COW.
> > 
> > I like this patch, too.
> > 
> > If we have the loop in __split_huge_page_pmd as suggested in this patch,
> > can we assume that the pmd is stable after __split_huge_page_pmd returns?
> > If it's true, we can remove pmd_none_or_trans_huge_or_clear_bad check
> > in the callers side (zap_pmd_range and some other page table walking code.)
> 
> We can assume it stable for the deterministic cases where the
> looping is useful for and split_huge_page creates non-huge pmd that points to
> a regular pte.
> 
> But we cannot remove pmd_none_or_trans_huge_or_clear_bad after if for
> the other non deterministic cases that I described in previous
> email. Looping still provides no guarantee that when the function
> returns, the pmd in not huge. So for safety we still need to handle
> the non deterministic case and just discard it through
> pmd_none_or_trans_huge_or_clear_bad.

OK, this check is necessary. But pmd_none_or_trans_huge_or_clear_bad
doesn't clear the pmd when pmd_trans_huge is true. So zap_pmd_range
seems to do nothing on such irregular pmd_trans_huge. So it looks to
me better that zap_pmd_range retries the loop on the same address
instead of 'goto next'.
The reason why I had this kind of question is that I recently study on
page table walker and some related code do retry in the similar situation.

Thanks,
Naoya Horiguchi
