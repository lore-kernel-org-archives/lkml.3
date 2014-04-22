Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbaDVOxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661AbaDVOxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:53:18 -0400
Date: Tue, 22 Apr 2014 11:53:01 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: commit 0bf1457f0cfca7b  " mm: vmscan: do not swap anon pages
 just because free+file is low" causes heavy performance regression on paging
Message-ID: <20140422145300.GA23630@localhost.localdomain>
References: <53564AA9.3060905@de.ibm.com>
 <53565922.1050709@de.ibm.com>
 <53567F51.8050608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53567F51.8050608@redhat.com>
X-PGP-Key: http://people.redhat.com/~raquini/gpg-pubkey.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:40:17AM -0400, Rik van Riel wrote:
> On 04/22/2014 07:57 AM, Christian Borntraeger wrote:
> > On 22/04/14 12:55, Christian Borntraeger wrote:
> >> While preparing/testing some KVM on s390 patches for the next merge window (target is kvm/next which is based on 3.15-rc1) I faced a very severe performance hickup on guest paging (all anonymous memory).
> >>
> >> All memory bound guests are in "D" state now and the system is barely unusable.
> >>
> >> Reverting commit 0bf1457f0cfca7bc026a82323ad34bcf58ad035d
> >> "mm: vmscan: do not swap anon pages just because free+file is low" makes the problem go away.
> >>
> >> According to /proc/vmstat the system is now in direct reclaim almost all the time for every page fault (more than 10x more direct reclaims than kswap reclaims)
> >> With the patch being reverted everything is fine again.
> >>
> >> Any ideas?
> > 
> > Here is an idea to tackle my problem and the original problem:
> > 
> > reverting  0bf1457f0cfca7bc026a82323ad34bcf58ad035d + checking against low, also seems to make my system usable.
> > 
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1923,7 +1923,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> >          */
> >         if (global_reclaim(sc)) {
> >                 free = zone_page_state(zone, NR_FREE_PAGES);
> > -               if (unlikely(file + free <= high_wmark_pages(zone))) {
> > +               if (unlikely(file + free <= low_wmark_pages(zone))) {
> >                         scan_balance = SCAN_ANON;
> >                         goto out;
> >                 }
> > 
> 
> Looks reasonable to me.
+1

