Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaFHCJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 22:09:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaFHCJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 22:09:40 -0400
Date: Sat, 7 Jun 2014 19:09:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.14 103/228] revert "mm: vmscan: do not swap anon pages
 just because free+file is low"
Message-ID: <20140608020935.GA30113@kroah.com>
References: <20140604232347.966798903@linuxfoundation.org>
 <20140604232351.347803140@linuxfoundation.org>
 <1402192995.23860.21.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402192995.23860.21.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 03:03:15AM +0100, Ben Hutchings wrote:
> On Wed, 2014-06-04 at 16:22 -0700, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > commit 623762517e2370be3b3f95f4fe08d6c063a49b06 upstream.
> > 
> > This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages
> > just because free+file is low") because it introduced a regression in
> > mostly-anonymous workloads, where reclaim would become ineffective and
> > trap every allocating task in direct reclaim.
> [...]
> 
> That commit was not included in 3.14 or in subsequent stable updates, so
> this 'revert' is not approriate.  We now have duplicate checks:
> 
> 	/*
> 	 * If it's foreseeable that reclaiming the file cache won't be
> 	 * enough to get the zone back into a desirable shape, we have
> 	 * to swap.  Better start now and leave the - probably heavily
> 	 * thrashing - remaining file pages alone.
> 	 */
> 	if (global_reclaim(sc)) {
> 		free = zone_page_state(zone, NR_FREE_PAGES);
> 		if (unlikely(file + free <= high_wmark_pages(zone))) {
> 			scan_balance = SCAN_ANON;
> 			goto out;
> 		}
> 	}
> 
> 	/*
> 	 * Prevent the reclaimer from falling into the cache trap: as
> 	 * cache pages start out inactive, every cache fault will tip
> 	 * the scan balance towards the file LRU.  And as the file LRU
> 	 * shrinks, so does the window for rotation from references.
> 	 * This means we have a runaway feedback loop where a tiny
> 	 * thrashing file LRU becomes infinitely more attractive than
> 	 * anon pages.  Try to detect this based on file LRU size.
> 	 */
> 	if (global_reclaim(sc)) {
> 		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
> 
> 		if (unlikely(file + free <= high_wmark_pages(zone))) {
> 			scan_balance = SCAN_ANON;
> 			goto out;
> 		}
> 	}
> 
> Ben.

Ugh, good catch, thanks for this.  I'll go revert it now.

greg k-h
