Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaKUGmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:42:15 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35841 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKUGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:42:14 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
In-Reply-To: <20141118095811.GA21774@node.dhcp.inet.fi>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com> <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com> <20141118084337.GA16714@hori1.linux.bs1.fc.nec.co.jp> <20141118095811.GA21774@node.dhcp.inet.fi>
User-Agent: Notmuch/0.18.2+162~g34d2c62 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Fri, 21 Nov 2014 12:11:34 +0530
Message-ID: <87egsx6oo1.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112106-0033-0000-0000-000000901A1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> On Tue, Nov 18, 2014 at 08:43:00AM +0000, Naoya Horiguchi wrote:
>> > @@ -1837,6 +1839,9 @@ static void __split_huge_page_refcount(struct page *page,
>> >  	atomic_sub(tail_count, &page->_count);
>> >  	BUG_ON(atomic_read(&page->_count) <= 0);
>> >  
>> > +	page->_mapcount = *compound_mapcount_ptr(page);
>> 
>> Is atomic_set() necessary?
>
> Do you mean
> 	atomic_set(&page->_mapcount, atomic_read(compound_mapcount_ptr(page)));
> ?
>
> I don't see why we would need this. Simple assignment should work just
> fine. Or we have archs which will break?

Are you looking at architecture related atomic_set issues, or the fact
that we cannot have parallel _mapcount update and hence the above
assignment should be ok ? If the former, current thp code
use atomic_add instead of even using atomic_set when
updatinge page_tail->_count.  

		 * from under us on the tail_page. If we used
		 * atomic_set() below instead of atomic_add(), we
		 * would then run atomic_set() concurrently with
		 * get_page_unless_zero(), and atomic_set() is
		 * implemented in C not using locked ops. spin_unlock
		 * on x86 sometime uses locked ops because of PPro
		 * errata 66, 92, so unless somebody can guarantee
		 * atomic_set() here would be safe on all archs (and
		 * not only on x86), it's safer to use atomic_add().
		 */
		atomic_add(page_mapcount(page) + page_mapcount(page_tail) + 1,
			   &page_tail->_count);



-aneesh

