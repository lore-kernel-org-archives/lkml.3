Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaKYOE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:04:56 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:38897 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaKYOEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:04:54 -0500
Date: Tue, 25 Nov 2014 16:04:28 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 01/19] mm, thp: drop FOLL_SPLIT
Message-ID: <20141125140428.GA11841@node.dhcp.inet.fi>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-2-git-send-email-kirill.shutemov@linux.intel.com>
 <20141125030109.GA21716@hori1.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125030109.GA21716@hori1.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 03:01:16AM +0000, Naoya Horiguchi wrote:
> On Wed, Nov 05, 2014 at 04:49:36PM +0200, Kirill A. Shutemov wrote:
> > FOLL_SPLIT is used only in two places: migration and s390.
> > 
> > Let's replace it with explicit split and remove FOLL_SPLIT.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> ...
> > @@ -1246,6 +1246,11 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
> >  		if (!page)
> >  			goto set_status;
> >  
> > +		if (PageTransHuge(page) && split_huge_page(page)) {
> > +			err = -EBUSY;
> > +			goto set_status;
> > +		}
> > +
> 
> This check makes split_huge_page() be called for hugetlb pages, which
> triggers BUG_ON. So could you do this after if (PageHuge) block below?
> And I think that we have "Node already in the right place" check afterward,
> so I hope that moving down this check also helps us reduce thp splitting.

It makes sense. Thanks for report.

Other problem here is that we need to goto put_and_set, not set_status :-/

-- 
 Kirill A. Shutemov
