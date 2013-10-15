Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769Ab3JOToz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:44:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab3JOToy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:44:54 -0400
Date: Tue, 15 Oct 2013 21:44:28 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: mm: fix BUG in __split_huge_page_pmd
Message-ID: <20131015194428.GI3479@redhat.com>
References: <alpine.LNX.2.00.1310150358170.11905@eggly.anvils>
 <20131015143407.GE3479@redhat.com>
 <20131015144827.C45DDE0090@blue.fi.intel.com>
 <alpine.LNX.2.00.1310151029040.12481@eggly.anvils>
 <20131015185510.GH3479@redhat.com>
 <1381865330-8nb86ucy-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381865330-8nb86ucy-mutt-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 03:28:50PM -0400, Naoya Horiguchi wrote:
> On Tue, Oct 15, 2013 at 08:55:10PM +0200, Andrea Arcangeli wrote:
> > On Tue, Oct 15, 2013 at 10:53:10AM -0700, Hugh Dickins wrote:
> > > I'm afraid Andrea's mail about concurrent madvises gives me far more
> > > to think about than I have time for: seems to get into problems he
> > > knows a lot about but I'm unfamiliar with.  If this patch looks good
> > > for now on its own, let's put it in; but no problem if you guys prefer
> > > to wait for a fuller solution of more problems, we can ride with this
> > > one internally for the moment.
> > 
> > I'm very happy with the patch and I think it's a correct fix for the
> > COW scenario which is deterministic so the looping makes a meaningful
> > difference for it. If we wouldn't loop, part of the copied page
> > wouldn't be zapped after the COW.
> 
> I like this patch, too.
> 
> If we have the loop in __split_huge_page_pmd as suggested in this patch,
> can we assume that the pmd is stable after __split_huge_page_pmd returns?
> If it's true, we can remove pmd_none_or_trans_huge_or_clear_bad check
> in the callers side (zap_pmd_range and some other page table walking code.)

We can assume it stable for the deterministic cases where the
looping is useful for and split_huge_page creates non-huge pmd that points to
a regular pte.

But we cannot remove pmd_none_or_trans_huge_or_clear_bad after if for
the other non deterministic cases that I described in previous
email. Looping still provides no guarantee that when the function
returns, the pmd in not huge. So for safety we still need to handle
the non deterministic case and just discard it through
pmd_none_or_trans_huge_or_clear_bad.
