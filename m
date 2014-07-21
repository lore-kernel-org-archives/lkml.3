Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaGUMA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:00:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37488 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaGUMAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:00:55 -0400
Date: Mon, 21 Jul 2014 14:00:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721120053.GA14069@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405938422-21900-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Rebased to v3.16-rc6
> * Fixed the style issues in Patch 1 mentioned by Rafael
> 
> Hi,
> 
> here is the revised patch set to improve the scalability of
> the memory bitmap implementation used for hibernation. The
> current implementation does not scale well to machines with
> several TB of memory. A resume on those machines may cause
> soft lockups to be reported.
> 
> These patches improve the data structure by adding a radix
> tree to the linked list structure to improve random access
> performance from O(n) to O(log_b(n)), where b depends on the
> architecture (b=512 on amd64, 1024 in i386).

Why are we doing random access there?

Is the improvement from fact that normally very little memory is used
on big memory machines?

> A test on a 12TB machine showed an improvement in resume
> time from 76s with the old implementation to 2.4s with the
> radix tree and the improved swsusp_free function. See below
> for details of this test.

Actually... how long does it take to hibernate 12TB machine? That
should be many hours, right? You just can't hibernate machine that
big.

> The last patch adds touching the soft lockup watchdog in
> rtree_next_node. This is necessary because the worst case
> performance (all bits set in the forbidden_pages_map and
> free_pages_map) is the same as with the old implementation
> and may still cause soft lockups. Patch 6 avoids this.

Ok, so what about simpler patch? Just touch the watchdog?

Additional 70 seconds will be lost in noise if you write 12TB of RAM
to (even quite fast) disk.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
