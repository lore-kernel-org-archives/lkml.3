Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936571Ab3DIWBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934324Ab3DIWB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:01:29 -0400
Date: Tue, 09 Apr 2013 18:00:34 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <1365544834-c6v2jpoo-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAHGf_=ruv9itn7fhcL=Ar7z_6wQ5Ga_4kj7Ui3EfDUe_cV7D0w@mail.gmail.com>
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1365014138-19589-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F1F1F.6060900@gmail.com>
 <1365449252-9pc7knd5-mutt-n-horiguchi@ah.jp.nec.com>
 <CAHGf_=ruv9itn7fhcL=Ar7z_6wQ5Ga_4kj7Ui3EfDUe_cV7D0w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] hugetlbfs: add swap entry check in
 follow_hugetlb_page()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <CAHGf_=ruv9itn7fhcL=Ar7z_6wQ5Ga_4kj7Ui3EfDUe_cV7D0w@mail.gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:57:44PM -0400, KOSAKI Motohiro wrote:
> > -               if (absent ||
> > +               /*
> > +                * is_swap_pte test covers both is_hugetlb_entry_hwpoisoned
> > +                * and hugepages under migration in which case
> > +                * hugetlb_fault waits for the migration and bails out
> > +                * properly for HWPosined pages.
> > +                */
> > +               if (absent || is_swap_pte(huge_ptep_get(pte)) ||
> >                     ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
> >                         int ret;
> 
> Your comment describe what the code is. However we want the comment describe
> why. In migration case, calling hugetlb_fault() is natural. but in
> hwpoison case, it is
> needed more explanation.

We should call hugetlb_fault() when we encounter any kind of swap
type entry. It's consistent with handling of normal pages.

> Why can't we call is_hugetlb_hwpoisoned() directly?

We can use it, but I like to make code simple.

I rewrite the comment here, how about this?

-		if (absent ||
+		/*
+		 * We need call hugetlb_fault for both hugepages under migration
+		 * (in which case hugetlb_fault waits for the migration,) and
+		 * hwpoisoned hugepages (in which case we need to prevent the
+		 * caller from accessing to them.) In order to do this, we use
+		 * here is_swap_pte instead of is_hugetlb_entry_migration and
+		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * both cases, and because we can't follow correct pages directly
+		 * from any kind of swap entries.
+		 */
+		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
 		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;

Thanks,
Naoya
